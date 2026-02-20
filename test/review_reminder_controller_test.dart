import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ourmatchwell_flutter/core/config/review_reminder_config.dart';
import 'package:ourmatchwell_flutter/core/notifications/review_reminder_controller.dart';
import 'package:ourmatchwell_flutter/core/persistence/isar/isar_persistence_engine.dart';
import 'package:ourmatchwell_flutter/core/persistence/preferences_store.dart';
import 'package:ourmatchwell_flutter/core/support/app_logger.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('enable reminder returns denied when permission is rejected', () async {
    final store = await _newStore();
    final notifications = _FakeNotificationClient(permissionGranted: false);
    final controller = ReviewReminderController(
      prefs: store,
      notifications: notifications,
      logger: const _NoopLogger(),
    );

    final result = await controller.updateEnabled(true);

    expect(result, ReminderToggleResult.permissionDenied);
    expect(store.reviewReminderEnabled, isFalse);
    expect(notifications.scheduleCount, 0);
  });

  test(
    'enable reminder schedules a daily notification with due count',
    () async {
      final store = await _newStore();
      store.toggleFavorite('s1', now: DateTime(2026, 2, 20, 10));

      final notifications = _FakeNotificationClient(permissionGranted: true);
      final controller = ReviewReminderController(
        prefs: store,
        notifications: notifications,
        logger: const _NoopLogger(),
      );

      final result = await controller.updateEnabled(true);

      expect(result, ReminderToggleResult.enabled);
      expect(store.reviewReminderEnabled, isTrue);
      expect(notifications.scheduleCount, 1);
      expect(notifications.lastHour, reviewReminderDefaultHour);
      expect(notifications.lastMinute, reviewReminderDefaultMinute);
      expect(
        notifications.lastBody,
        '$reviewReminderDueBodyPrefix'
        '1'
        '$reviewReminderDueBodySuffix',
      );
    },
  );

  test('changing reminder time reschedules when reminder is enabled', () async {
    final store = await _newStore();
    final notifications = _FakeNotificationClient(permissionGranted: true);
    final controller = ReviewReminderController(
      prefs: store,
      notifications: notifications,
      logger: const _NoopLogger(),
    );

    await controller.updateEnabled(true);
    await controller.updateTime(hour: 8, minute: 30);

    expect(store.reviewReminderHour, 8);
    expect(store.reviewReminderMinute, 30);
    expect(notifications.scheduleCount, 2);
    expect(notifications.lastHour, 8);
    expect(notifications.lastMinute, 30);
  });

  test('sync cancels reminder when disabled', () async {
    final store = await _newStore();
    final notifications = _FakeNotificationClient(permissionGranted: true);
    final controller = ReviewReminderController(
      prefs: store,
      notifications: notifications,
      logger: const _NoopLogger(),
    );

    await controller.syncCurrentSettings();

    expect(notifications.cancelCount, 1);
    expect(notifications.scheduleCount, 0);
  });
}

Future<PreferencesStore> _newStore() async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    'onboarding_completed': true,
    'install_date_iso': DateTime(2026, 2, 14).toIso8601String(),
  });
  final prefs = await SharedPreferences.getInstance();
  return PreferencesStore(
    prefs,
    isarEngine: IsarPersistenceEngine(forceEnabled: false),
  );
}

class _FakeNotificationClient implements ReviewReminderNotificationClient {
  _FakeNotificationClient({required this.permissionGranted});

  final bool permissionGranted;
  int scheduleCount = 0;
  int cancelCount = 0;
  int? lastNotificationId;
  int? lastHour;
  int? lastMinute;
  String? lastTitle;
  String? lastBody;

  @override
  Future<void> cancel(int notificationId) async {
    cancelCount += 1;
    lastNotificationId = notificationId;
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermission() async => permissionGranted;

  @override
  Future<void> scheduleDaily({
    required int notificationId,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    scheduleCount += 1;
    lastNotificationId = notificationId;
    lastHour = hour;
    lastMinute = minute;
    lastTitle = title;
    lastBody = body;
  }
}

class _NoopLogger extends AppLogger {
  const _NoopLogger();

  @override
  void log({
    required AppLogLevel level,
    required AppLogCategory category,
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) {}
}
