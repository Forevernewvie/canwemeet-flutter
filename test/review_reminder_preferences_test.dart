import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ourmatchwell_flutter/core/config/review_reminder_config.dart';
import 'package:ourmatchwell_flutter/core/persistence/isar/isar_persistence_engine.dart';
import 'package:ourmatchwell_flutter/core/persistence/preferences_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('reminder settings use expected defaults', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'onboarding_completed': true,
      'install_date_iso': DateTime(2026, 2, 14).toIso8601String(),
    });
    final prefs = await SharedPreferences.getInstance();
    final store = PreferencesStore(
      prefs,
      isarEngine: IsarPersistenceEngine(forceEnabled: false),
    );

    expect(store.reviewReminderEnabled, isFalse);
    expect(store.reviewReminderHour, reviewReminderDefaultHour);
    expect(store.reviewReminderMinute, reviewReminderDefaultMinute);
  });

  test('reminder settings persist across store recreation', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'onboarding_completed': true,
      'install_date_iso': DateTime(2026, 2, 14).toIso8601String(),
    });
    final prefs = await SharedPreferences.getInstance();

    final first = PreferencesStore(
      prefs,
      isarEngine: IsarPersistenceEngine(forceEnabled: false),
    );
    first.setReviewReminderEnabled(true);
    first.setReviewReminderTime(hour: 8, minute: 45);

    final second = PreferencesStore(
      prefs,
      isarEngine: IsarPersistenceEngine(forceEnabled: false),
    );

    expect(second.reviewReminderEnabled, isTrue);
    expect(second.reviewReminderHour, 8);
    expect(second.reviewReminderMinute, 45);
  });
}
