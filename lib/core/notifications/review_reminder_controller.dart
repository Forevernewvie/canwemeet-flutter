import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../config/review_reminder_config.dart';
import '../persistence/preferences_store.dart';
import '../support/app_logger.dart';

/// Result states for reminder toggle requests.
enum ReminderToggleResult { enabled, disabled, permissionDenied }

/// Platform-notification abstraction for testable scheduling behavior.
abstract class ReviewReminderNotificationClient {
  /// Prepares platform notification resources.
  Future<void> initialize();

  /// Requests user notification permission on supported platforms.
  Future<bool> requestPermission();

  /// Schedules one recurring daily reminder.
  Future<void> scheduleDaily({
    required int notificationId,
    required int hour,
    required int minute,
    required String title,
    required String body,
  });

  /// Cancels a scheduled notification by identifier.
  Future<void> cancel(int notificationId);
}

/// Provides a notification client with platform-aware no-op fallbacks.
final reviewReminderNotificationClientProvider =
    Provider<ReviewReminderNotificationClient>((ref) {
      if (kIsWeb || Platform.environment.containsKey('FLUTTER_TEST')) {
        return const NoopReviewReminderNotificationClient();
      }
      if (!(Platform.isAndroid || Platform.isIOS)) {
        return const NoopReviewReminderNotificationClient();
      }
      return FlutterReviewReminderNotificationClient();
    });

/// Provides reminder orchestration logic to UI layers.
final reviewReminderControllerProvider = Provider<ReviewReminderController>((
  ref,
) {
  return ReviewReminderController(
    prefs: ref.watch(preferencesStoreProvider),
    notifications: ref.watch(reviewReminderNotificationClientProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

/// Coordinates reminder preferences, permissions, and scheduling actions.
class ReviewReminderController {
  ReviewReminderController({
    required PreferencesStore prefs,
    required ReviewReminderNotificationClient notifications,
    required AppLogger logger,
  }) : _prefs = prefs,
       _notifications = notifications,
       _logger = logger;

  final PreferencesStore _prefs;
  final ReviewReminderNotificationClient _notifications;
  final AppLogger _logger;

  /// Applies enable/disable request and keeps schedule state consistent.
  Future<ReminderToggleResult> updateEnabled(bool enabled) async {
    if (!enabled) {
      _prefs.setReviewReminderEnabled(false);
      await _notifications.cancel(reviewReminderNotificationId);
      return ReminderToggleResult.disabled;
    }

    final granted = await _requestPermissionSafely();
    if (!granted) {
      _prefs.setReviewReminderEnabled(false);
      await _notifications.cancel(reviewReminderNotificationId);
      return ReminderToggleResult.permissionDenied;
    }

    _prefs.setReviewReminderEnabled(true);
    await syncCurrentSettings();
    return ReminderToggleResult.enabled;
  }

  /// Persists reminder time and reschedules when reminders are active.
  Future<void> updateTime({required int hour, required int minute}) async {
    _prefs.setReviewReminderTime(hour: hour, minute: minute);
    if (!_prefs.reviewReminderEnabled) {
      return;
    }
    await syncCurrentSettings();
  }

  /// Reconciles persisted settings with platform reminder schedule.
  Future<void> syncCurrentSettings() async {
    if (!_prefs.reviewReminderEnabled) {
      await _notifications.cancel(reviewReminderNotificationId);
      return;
    }

    final dueCount = _prefs.reviewQueueCount();

    try {
      await _notifications.scheduleDaily(
        notificationId: reviewReminderNotificationId,
        hour: _prefs.reviewReminderHour,
        minute: _prefs.reviewReminderMinute,
        title: reviewReminderNotificationTitle,
        body: reminderBodyForDueCount(dueCount),
      );
    } catch (error, stackTrace) {
      _logger.error(
        AppLogCategory.app,
        'Failed to schedule daily review reminder.',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @visibleForTesting
  /// Returns due-count body when available, otherwise a safe fallback.
  String reminderBodyForDueCount(int dueCount) {
    if (dueCount > 0) {
      return '$reviewReminderDueBodyPrefix$dueCount$reviewReminderDueBodySuffix';
    }
    return reviewReminderFallbackBody;
  }

  /// Requests permission with defensive error handling and logging.
  Future<bool> _requestPermissionSafely() async {
    try {
      return await _notifications.requestPermission();
    } catch (error, stackTrace) {
      _logger.error(
        AppLogCategory.app,
        'Failed to request notification permission.',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }
}

/// Production notification client backed by flutter_local_notifications.
class FlutterReviewReminderNotificationClient
    implements ReviewReminderNotificationClient {
  FlutterReviewReminderNotificationClient();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  bool _timeZoneInitialized = false;

  @override
  /// Initializes plugin and timezone data once per process.
  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(initSettings);
    await _configureLocalTimezone();
    _initialized = true;
  }

  @override
  /// Requests iOS/Android notification permission when available.
  Future<bool> requestPermission() async {
    await initialize();

    var granted = true;
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      final iosGranted = await ios.requestPermissions(
        alert: true,
        badge: false,
        sound: true,
      );
      granted = granted && (iosGranted ?? false);
    }

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      final androidGranted = await android.requestNotificationsPermission();
      granted = granted && (androidGranted ?? true);
    }

    return granted;
  }

  @override
  /// Schedules a recurring local notification at the requested local time.
  Future<void> scheduleDaily({
    required int notificationId,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    await initialize();

    final details = NotificationDetails(
      android: const AndroidNotificationDetails(
        reviewReminderChannelId,
        reviewReminderChannelName,
        channelDescription: reviewReminderChannelDescription,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      notificationId,
      title,
      body,
      _nextTrigger(hour: hour, minute: minute),
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: reviewReminderPayload,
    );
  }

  @override
  /// Cancels any scheduled reminder for the provided notification id.
  Future<void> cancel(int notificationId) async {
    await _plugin.cancel(notificationId);
  }

  /// Computes the next future trigger for a given hour/minute pair.
  tz.TZDateTime _nextTrigger({required int hour, required int minute}) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  /// Resolves and sets local timezone used by zoned scheduling.
  Future<void> _configureLocalTimezone() async {
    if (_timeZoneInitialized) return;

    tz_data.initializeTimeZones();
    try {
      final localName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localName));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation(reviewReminderFallbackTimezone));
    }

    _timeZoneInitialized = true;
  }
}

/// No-op notification client used in tests and unsupported platforms.
class NoopReviewReminderNotificationClient
    implements ReviewReminderNotificationClient {
  const NoopReviewReminderNotificationClient();

  @override
  /// No-op cancel for non-notification environments.
  Future<void> cancel(int notificationId) async {}

  @override
  /// No-op initialize for non-notification environments.
  Future<void> initialize() async {}

  @override
  /// Returns granted to keep non-device tests deterministic.
  Future<bool> requestPermission() async => true;

  @override
  /// No-op schedule for non-notification environments.
  Future<void> scheduleDaily({
    required int notificationId,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {}
}
