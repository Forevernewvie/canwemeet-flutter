import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ourmatchwell_flutter/core/persistence/isar/isar_persistence_engine.dart';
import 'package:ourmatchwell_flutter/core/persistence/preferences_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'preferences behavior is equivalent between legacy and Isar paths',
    () async {
      final legacy = await _runScenario(
        engine: IsarPersistenceEngine(forceEnabled: false),
      );

      final dir = await Directory.systemTemp.createTemp('omw_isar_equiv_');
      final isarEngine = IsarPersistenceEngine(
        forceEnabled: true,
        instanceName: 'prefs_equivalence_test',
        directoryProvider: () async => dir,
      );
      final isar = await _runScenario(engine: isarEngine);

      expect(isar, equals(legacy));

      await isarEngine.close();
      await dir.delete(recursive: true);
    },
  );
}

Future<_Snapshot> _runScenario({required IsarPersistenceEngine engine}) async {
  final installDate = DateTime(2026, 2, 14);
  final now = DateTime(2026, 2, 15, 10);
  final plusThreeDays = now.add(const Duration(days: 3));

  SharedPreferences.setMockInitialValues(<String, Object>{
    'onboarding_completed': false,
    'install_date_iso': installDate.toIso8601String(),
    'favorite_ids': <String>['legacy-1'],
    'studied_day_keys': <String>['2026-02-14'],
    'review_state_json': jsonEncode(<String, Object>{
      'legacy-1': <String, Object>{
        'dueAtEpochMs': DateTime(2026, 2, 14, 11).millisecondsSinceEpoch,
        'intervalDays': 1,
      },
    }),
  });
  final prefs = await SharedPreferences.getInstance();
  await engine.migrateFromLegacy(
    prefs: prefs,
    cacheByKey: const <String, String>{},
  );

  final store = PreferencesStore(prefs, isarEngine: engine);
  await Future<void>.delayed(const Duration(milliseconds: 50));

  store.completeOnboarding();
  store.toggleFavorite('s-new', now: now);
  store.recordStudyEvent(now: now);
  store.submitReviewResult('s-new', ReviewResult.easy, now: now);
  store.refreshReviewNow('legacy-1', now: now.add(const Duration(hours: 1)));
  await Future<void>.delayed(const Duration(milliseconds: 80));

  return _Snapshot(
    onboardingCompleted: store.onboardingCompleted,
    favoriteIds: store.favoriteIds.toSet(),
    hasStudiedToday: store.hasStudiedToday(today: now),
    studiedDayCountInMonth: store.studiedDayCountInMonth(date: now),
    currentStreak: store.currentStreak(asOf: now),
    reviewQueueNow: store.reviewQueueCount(now: now),
    reviewDueIdsFuture: store.dueReviewSentenceIds(now: plusThreeDays)..sort(),
    dayIndex: store.dayIndexFor(DateTime(2026, 2, 16)),
  );
}

class _Snapshot {
  const _Snapshot({
    required this.onboardingCompleted,
    required this.favoriteIds,
    required this.hasStudiedToday,
    required this.studiedDayCountInMonth,
    required this.currentStreak,
    required this.reviewQueueNow,
    required this.reviewDueIdsFuture,
    required this.dayIndex,
  });

  final bool onboardingCompleted;
  final Set<String> favoriteIds;
  final bool hasStudiedToday;
  final int studiedDayCountInMonth;
  final int currentStreak;
  final int reviewQueueNow;
  final List<String> reviewDueIdsFuture;
  final int dayIndex;

  @override
  bool operator ==(Object other) {
    if (other is! _Snapshot) return false;
    return onboardingCompleted == other.onboardingCompleted &&
        _setEquals(favoriteIds, other.favoriteIds) &&
        hasStudiedToday == other.hasStudiedToday &&
        studiedDayCountInMonth == other.studiedDayCountInMonth &&
        currentStreak == other.currentStreak &&
        reviewQueueNow == other.reviewQueueNow &&
        _listEquals(reviewDueIdsFuture, other.reviewDueIdsFuture) &&
        dayIndex == other.dayIndex;
  }

  @override
  int get hashCode => Object.hash(
    onboardingCompleted,
    favoriteIds.length,
    hasStudiedToday,
    studiedDayCountInMonth,
    currentStreak,
    reviewQueueNow,
    reviewDueIdsFuture.length,
    dayIndex,
  );

  static bool _setEquals(Set<String> a, Set<String> b) {
    if (a.length != b.length) return false;
    return a.containsAll(b);
  }

  static bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
