import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ourmatchwell_flutter/core/persistence/file_cache.dart';
import 'package:ourmatchwell_flutter/core/persistence/isar/isar_persistence_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'cache data is migrated and supports legacy fallback backfill',
    () async {
      final dir = await Directory.systemTemp.createTemp('omw_isar_mig_cache_');
      final engine = IsarPersistenceEngine(
        forceEnabled: true,
        instanceName: 'cache_migration_test',
        directoryProvider: () async => dir,
      );

      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();

      final migrated = await engine.migrateFromLegacy(
        prefs: prefs,
        cacheByKey: const <String, String>{
          'sentences_v1.json': '{"source":"isar"}',
          'curated_sentences_200_v1.json': '{"curated":true}',
          'patterns_v1.json': '{"patterns":3}',
        },
      );
      expect(migrated, isTrue);

      final legacy = MemoryCache();
      final cache = IsarBackedStringCache(engine: engine, legacy: legacy);

      expect(await cache.readString('sentences_v1.json'), '{"source":"isar"}');
      expect(
        await cache.readString('curated_sentences_200_v1.json'),
        '{"curated":true}',
      );

      await cache.delete('patterns_v1.json');
      await legacy.writeString('patterns_v1.json', '{"source":"legacy"}');

      // First read falls back to legacy and asynchronously backfills Isar.
      expect(await cache.readString('patterns_v1.json'), '{"source":"legacy"}');
      await Future<void>.delayed(const Duration(milliseconds: 30));

      await legacy.delete('patterns_v1.json');
      // Second read comes from Isar even after legacy value is gone.
      expect(await cache.readString('patterns_v1.json'), '{"source":"legacy"}');

      await engine.close();
      await dir.delete(recursive: true);
    },
  );
}
