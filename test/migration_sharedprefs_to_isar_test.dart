import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ourmatchwell_flutter/core/persistence/isar/isar_persistence_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('migrates shared_preferences data into Isar snapshot', () async {
    final dir = await Directory.systemTemp.createTemp('omw_isar_mig_prefs_');
    final engine = IsarPersistenceEngine(
      forceEnabled: true,
      instanceName: 'prefs_migration_test',
      directoryProvider: () async => dir,
    );

    final installDateIso = DateTime(2026, 2, 14).toIso8601String();
    final nowEpochMs = DateTime(2026, 2, 15, 10).millisecondsSinceEpoch;

    SharedPreferences.setMockInitialValues(<String, Object>{
      'onboarding_completed': true,
      'install_date_iso': installDateIso,
      'favorite_ids': <String>['s1', 's2'],
      'studied_day_keys': <String>['2026-02-14', '2026-02-15'],
      'review_state_json': jsonEncode(<String, Object>{
        's1': <String, Object>{'dueAtEpochMs': nowEpochMs, 'intervalDays': 1},
      }),
    });
    final prefs = await SharedPreferences.getInstance();

    final migrated = await engine.migrateFromLegacy(
      prefs: prefs,
      cacheByKey: const <String, String>{},
    );
    expect(migrated, isTrue);

    final snapshot = await engine.loadStateSnapshot();
    expect(snapshot, isNotNull);
    expect(snapshot!.meta.onboardingCompleted, isTrue);
    expect(snapshot.meta.installDateIso, installDateIso);
    expect(snapshot.meta.migrationVersion, greaterThanOrEqualTo(1));
    expect(snapshot.favoriteIds, equals(<String>{'s1', 's2'}));
    expect(
      snapshot.studiedDayKeys,
      equals(<String>{'2026-02-14', '2026-02-15'}),
    );
    expect(snapshot.reviewMap['s1']?.dueAtEpochMs, nowEpochMs);
    expect(snapshot.reviewMap['s1']?.intervalDays, 1);

    await engine.close();
    await dir.delete(recursive: true);
  });
}
