import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/notifications/review_reminder_controller.dart';
import '../core/persistence/preferences_store.dart';

/// Keeps local reminder schedule synchronized with app lifecycle and settings.
class ReviewReminderBootstrapper extends ConsumerStatefulWidget {
  const ReviewReminderBootstrapper({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<ReviewReminderBootstrapper> createState() =>
      _ReviewReminderBootstrapperState();
}

class _ReviewReminderBootstrapperState
    extends ConsumerState<ReviewReminderBootstrapper>
    with WidgetsBindingObserver {
  ProviderSubscription<PreferencesStore>? _prefsSub;
  String _lastSignature = '';

  @override
  /// Starts lifecycle observation and initial reminder synchronization.
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncReminder();
    });

    _prefsSub = ref.listenManual<PreferencesStore>(preferencesStoreProvider, (
      previous,
      next,
    ) {
      final nextSignature = _signatureFor(next);
      if (nextSignature == _lastSignature) {
        return;
      }
      _lastSignature = nextSignature;
      unawaited(_syncReminder());
    });
  }

  @override
  /// Releases observers/subscriptions created by this bootstrapper.
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _prefsSub?.close();
    super.dispose();
  }

  @override
  /// Triggers sync when the app returns to foreground.
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_syncReminder());
    }
  }

  @override
  /// Returns child unchanged; this widget is a side-effect coordinator.
  Widget build(BuildContext context) => widget.child;

  /// Synchronizes persisted reminder settings with platform schedule.
  Future<void> _syncReminder() async {
    final prefs = ref.read(preferencesStoreProvider);
    _lastSignature = _signatureFor(prefs);
    await ref.read(reviewReminderControllerProvider).syncCurrentSettings();
  }

  /// Creates a compact signature used to avoid redundant rescheduling.
  String _signatureFor(PreferencesStore prefs) {
    return '${prefs.reviewReminderEnabled}|'
        '${prefs.reviewReminderHour}|'
        '${prefs.reviewReminderMinute}|'
        '${prefs.reviewQueueCount()}';
  }
}
