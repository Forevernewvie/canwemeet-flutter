import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/persistence/file_cache.dart';
import '../core/persistence/isar/isar_persistence_engine.dart';

Future<SharedPreferences> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  // Best-effort one-time migration to Isar. On failure, app continues
  // with legacy storage paths.
  final legacyCache = FileCache();
  final cacheByKey = <String, String>{};
  for (final key in legacyCacheKeys) {
    final value = await legacyCache.readString(key);
    if (value != null) {
      cacheByKey[key] = value;
    }
  }
  await defaultIsarPersistenceEngine.migrateFromLegacy(
    prefs: prefs,
    cacheByKey: cacheByKey,
  );

  return prefs;
}
