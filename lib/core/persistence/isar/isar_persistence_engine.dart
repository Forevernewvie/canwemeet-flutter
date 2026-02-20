import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../persistence_flags.dart';
import 'isar_entities.dart';

const legacyCacheKeys = <String>[
  'sentences_v1.json',
  'curated_sentences_200_v1.json',
  'patterns_v1.json',
];

const _kOnboardingCompleted = 'onboarding_completed';
const _kInstallDateIso = 'install_date_iso';
const _kFavoriteIds = 'favorite_ids';
const _kStudiedDayKeys = 'studied_day_keys';
const _kReviewStateJson = 'review_state_json';

const _migrationVersion = 1;
final _isFlutterTestProcess = Platform.environment.containsKey('FLUTTER_TEST');
Future<void>? _isarCoreInitFuture;

/// Shared singleton so startup migration and providers reuse the same engine.
final defaultIsarPersistenceEngine = IsarPersistenceEngine();

final isarPersistenceEngineProvider = Provider<IsarPersistenceEngine>((ref) {
  return defaultIsarPersistenceEngine;
});

@immutable
class PersistedReviewState {
  const PersistedReviewState({
    required this.dueAtEpochMs,
    required this.intervalDays,
  });

  final int dueAtEpochMs;
  final int intervalDays;

  factory PersistedReviewState.fromJson(Map<String, dynamic> json) {
    return PersistedReviewState(
      dueAtEpochMs: json['dueAtEpochMs'] is int
          ? json['dueAtEpochMs'] as int
          : 0,
      intervalDays: json['intervalDays'] is int
          ? json['intervalDays'] as int
          : 0,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'dueAtEpochMs': dueAtEpochMs,
    'intervalDays': intervalDays,
  };
}

@immutable
class LegacyPrefsSnapshot {
  const LegacyPrefsSnapshot({
    required this.onboardingCompleted,
    required this.installDateIso,
    required this.favoriteIds,
    required this.studiedDayKeys,
    required this.reviewMap,
  });

  final bool onboardingCompleted;
  final String installDateIso;
  final Set<String> favoriteIds;
  final Set<String> studiedDayKeys;
  final Map<String, PersistedReviewState> reviewMap;
}

@immutable
class PersistedSnapshot {
  const PersistedSnapshot({
    required this.meta,
    required this.favoriteIds,
    required this.studiedDayKeys,
    required this.reviewMap,
  });

  final AppMetaEntity meta;
  final Set<String> favoriteIds;
  final Set<String> studiedDayKeys;
  final Map<String, PersistedReviewState> reviewMap;
}

/// Isar-backed persistence engine with legacy fallback migration support.
class IsarPersistenceEngine {
  IsarPersistenceEngine({
    Future<Directory> Function()? directoryProvider,
    bool? forceEnabled,
    Isar? providedIsar,
    String instanceName = 'ourmatchwell',
  }) : _directoryProvider = directoryProvider ?? getApplicationSupportDirectory,
       _forceEnabled = forceEnabled,
       _providedIsar = providedIsar,
       _instanceName = instanceName;

  final Future<Directory> Function() _directoryProvider;
  final bool? _forceEnabled;
  final Isar? _providedIsar;
  final String _instanceName;

  Future<Isar?>? _isarFuture;
  Future<void> _writeQueue = Future<void>.value();

  bool get isEnabled => _forceEnabled ?? useIsarPersistence;

  /// Runs one-time migration from shared_preferences and legacy file cache.
  Future<bool> migrateFromLegacy({
    required SharedPreferences prefs,
    required Map<String, String> cacheByKey,
  }) async {
    final isar = await _getIsarOrNull();
    if (isar == null) return false;

    try {
      final existingMeta = await isar.appMetaEntitys.get(0);
      if (existingMeta != null &&
          existingMeta.migrationVersion >= _migrationVersion) {
        return true;
      }

      final snapshot = _readLegacyPrefsSnapshot(prefs);
      final nowEpochMs = DateTime.now().millisecondsSinceEpoch;

      await isar.writeTxn(() async {
        final meta = AppMetaEntity()
          ..id = 0
          ..onboardingCompleted = snapshot.onboardingCompleted
          ..installDateIso = snapshot.installDateIso
          ..migrationVersion = _migrationVersion
          ..migratedAtEpochMs = nowEpochMs;
        await isar.appMetaEntitys.put(meta);

        await isar.favoriteEntitys.clear();
        await isar.favoriteEntitys.putAll(
          snapshot.favoriteIds
              .map(
                (sentenceId) => FavoriteEntity()
                  ..sentenceId = sentenceId
                  ..createdAtEpochMs = nowEpochMs,
              )
              .toList(growable: false),
        );

        await isar.studyDayEntitys.clear();
        await isar.studyDayEntitys.putAll(
          snapshot.studiedDayKeys
              .map((dayKey) => StudyDayEntity()..dayKey = dayKey)
              .toList(growable: false),
        );

        await isar.reviewStateEntitys.clear();
        await isar.reviewStateEntitys.putAll(
          snapshot.reviewMap.entries
              .map(
                (entry) => ReviewStateEntity()
                  ..sentenceId = entry.key
                  ..dueAtEpochMs = entry.value.dueAtEpochMs
                  ..intervalDays = entry.value.intervalDays,
              )
              .toList(growable: false),
        );

        await isar.cacheBlobEntitys.clear();
        await isar.cacheBlobEntitys.putAll(
          cacheByKey.entries
              .map(
                (entry) => CacheBlobEntity()
                  ..key = entry.key
                  ..value = entry.value
                  ..updatedAtEpochMs = nowEpochMs,
              )
              .toList(growable: false),
        );
      });
      return true;
    } catch (error, stackTrace) {
      debugPrint('[isar] Legacy migration failed: $error');
      debugPrint(stackTrace.toString());
      return false;
    }
  }

  /// Reads full logical state snapshot from Isar.
  Future<PersistedSnapshot?> loadStateSnapshot() async {
    final isar = await _getIsarOrNull();
    if (isar == null) return null;
    try {
      final meta = await isar.appMetaEntitys.get(0);
      if (meta == null) return null;

      final favorites = await isar.favoriteEntitys.where().findAll();
      final studiedDays = await isar.studyDayEntitys.where().findAll();
      final reviews = await isar.reviewStateEntitys.where().findAll();

      return PersistedSnapshot(
        meta: meta,
        favoriteIds: favorites.map((item) => item.sentenceId).toSet(),
        studiedDayKeys: studiedDays.map((item) => item.dayKey).toSet(),
        reviewMap: <String, PersistedReviewState>{
          for (final item in reviews)
            item.sentenceId: PersistedReviewState(
              dueAtEpochMs: item.dueAtEpochMs,
              intervalDays: item.intervalDays,
            ),
        },
      );
    } catch (error, stackTrace) {
      debugPrint('[isar] Failed to load state snapshot: $error');
      debugPrint(stackTrace.toString());
      return null;
    }
  }

  Future<void> persistMeta({
    required bool onboardingCompleted,
    required String installDateIso,
  }) async {
    await _enqueueWrite((isar) async {
      await isar.writeTxn(() async {
        final existing = await isar.appMetaEntitys.get(0);
        final meta = AppMetaEntity()
          ..id = 0
          ..onboardingCompleted = onboardingCompleted
          ..installDateIso = installDateIso
          ..migrationVersion = existing?.migrationVersion ?? _migrationVersion
          ..migratedAtEpochMs = existing?.migratedAtEpochMs;
        await isar.appMetaEntitys.put(meta);
      });
    });
  }

  Future<void> replaceFavorites(Set<String> sentenceIds) async {
    await _enqueueWrite((isar) async {
      final nowEpochMs = DateTime.now().millisecondsSinceEpoch;
      await isar.writeTxn(() async {
        await isar.favoriteEntitys.clear();
        await isar.favoriteEntitys.putAll(
          sentenceIds
              .map(
                (sentenceId) => FavoriteEntity()
                  ..sentenceId = sentenceId
                  ..createdAtEpochMs = nowEpochMs,
              )
              .toList(growable: false),
        );
      });
    });
  }

  Future<void> replaceStudiedDays(Set<String> dayKeys) async {
    await _enqueueWrite((isar) async {
      await isar.writeTxn(() async {
        await isar.studyDayEntitys.clear();
        await isar.studyDayEntitys.putAll(
          dayKeys
              .map((dayKey) => StudyDayEntity()..dayKey = dayKey)
              .toList(growable: false),
        );
      });
    });
  }

  Future<void> replaceReviewMap(
    Map<String, PersistedReviewState> reviewMap,
  ) async {
    await _enqueueWrite((isar) async {
      await isar.writeTxn(() async {
        await isar.reviewStateEntitys.clear();
        await isar.reviewStateEntitys.putAll(
          reviewMap.entries
              .map(
                (entry) => ReviewStateEntity()
                  ..sentenceId = entry.key
                  ..dueAtEpochMs = entry.value.dueAtEpochMs
                  ..intervalDays = entry.value.intervalDays,
              )
              .toList(growable: false),
        );
      });
    });
  }

  Future<String?> readCache(String key) async {
    final isar = await _getIsarOrNull();
    if (isar == null) return null;
    try {
      final blob = await isar.cacheBlobEntitys
          .filter()
          .keyEqualTo(key)
          .findFirst();
      return blob?.value;
    } catch (error, stackTrace) {
      debugPrint('[isar] Failed to read cache key=$key: $error');
      debugPrint(stackTrace.toString());
      return null;
    }
  }

  Future<void> writeCache(String key, String value) async {
    await _enqueueWrite((isar) async {
      final nowEpochMs = DateTime.now().millisecondsSinceEpoch;
      await isar.writeTxn(() async {
        await isar.cacheBlobEntitys.put(
          CacheBlobEntity()
            ..key = key
            ..value = value
            ..updatedAtEpochMs = nowEpochMs,
        );
      });
    });
  }

  Future<void> deleteCache(String key) async {
    await _enqueueWrite((isar) async {
      await isar.writeTxn(() async {
        final blob = await isar.cacheBlobEntitys
            .filter()
            .keyEqualTo(key)
            .findFirst();
        if (blob != null) {
          await isar.cacheBlobEntitys.delete(blob.id);
        }
      });
    });
  }

  Future<void> close() async {
    if (_providedIsar != null) return;
    final isar = await _isarFuture;
    if (isar != null && isar.isOpen) {
      await isar.close();
    }
    _isarFuture = null;
    _writeQueue = Future<void>.value();
  }

  Future<void> _enqueueWrite(Future<void> Function(Isar isar) action) {
    _writeQueue = _writeQueue.then((_) async {
      final isar = await _getIsarOrNull();
      if (isar == null) return;
      try {
        await action(isar);
      } catch (error, stackTrace) {
        debugPrint('[isar] Write operation failed: $error');
        debugPrint(stackTrace.toString());
      }
    });
    return _writeQueue;
  }

  LegacyPrefsSnapshot _readLegacyPrefsSnapshot(SharedPreferences prefs) {
    final installDateIso =
        prefs.getString(_kInstallDateIso) ?? DateTime.now().toIso8601String();
    final onboardingCompleted = prefs.getBool(_kOnboardingCompleted) ?? false;
    final favoriteIds = (prefs.getStringList(_kFavoriteIds) ?? const <String>[])
        .toSet();
    final studiedDayKeys =
        (prefs.getStringList(_kStudiedDayKeys) ?? const <String>[]).toSet();
    final reviewRaw = prefs.getString(_kReviewStateJson);
    return LegacyPrefsSnapshot(
      onboardingCompleted: onboardingCompleted,
      installDateIso: installDateIso,
      favoriteIds: favoriteIds,
      studiedDayKeys: studiedDayKeys,
      reviewMap: _decodeReviewMap(reviewRaw),
    );
  }

  Map<String, PersistedReviewState> _decodeReviewMap(String? raw) {
    if (raw == null || raw.isEmpty) return <String, PersistedReviewState>{};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return <String, PersistedReviewState>{};
      }
      final out = <String, PersistedReviewState>{};
      for (final entry in decoded.entries) {
        final value = entry.value;
        if (value is! Map<String, dynamic>) continue;
        out[entry.key] = PersistedReviewState.fromJson(value);
      }
      return out;
    } catch (_) {
      return <String, PersistedReviewState>{};
    }
  }

  Future<Isar?> _getIsarOrNull() {
    _isarFuture ??= _openOrNull();
    return _isarFuture!;
  }

  Future<Isar?> _openOrNull() async {
    if (!isEnabled) return null;
    if (_providedIsar != null) return _providedIsar;

    try {
      if (_isFlutterTestProcess) {
        await _ensureIsarCoreForTests();
      }
      final directory = await _directoryProvider();
      return Isar.open(
        <CollectionSchema>[
          AppMetaEntitySchema,
          FavoriteEntitySchema,
          StudyDayEntitySchema,
          ReviewStateEntitySchema,
          CacheBlobEntitySchema,
        ],
        name: _instanceName,
        directory: directory.path,
      );
    } catch (error, stackTrace) {
      debugPrint('[isar] Failed to open database: $error');
      debugPrint(stackTrace.toString());
      return null;
    }
  }

  Future<void> _ensureIsarCoreForTests() {
    _isarCoreInitFuture ??= _initializeIsarCoreForTests();
    return _isarCoreInitFuture!;
  }

  Future<void> _initializeIsarCoreForTests() async {
    final libraries = await _resolveBundledIsarCoreLibraries();
    if (libraries.isNotEmpty) {
      await Isar.initializeIsarCore(libraries: libraries);
      return;
    }
    await Isar.initializeIsarCore(download: true);
  }

  Future<Map<Abi, String>> _resolveBundledIsarCoreLibraries() async {
    final packageRoot = _resolveIsarFlutterLibsRootFromPackageConfig();
    if (packageRoot == null) {
      return const <Abi, String>{};
    }

    final libraries = <Abi, String>{};

    if (Platform.isMacOS) {
      final dylib = File('${packageRoot.path}/macos/libisar.dylib');
      if (dylib.existsSync()) {
        libraries[Abi.macosArm64] = dylib.path;
        libraries[Abi.macosX64] = dylib.path;
      }
    } else if (Platform.isLinux) {
      final so = File('${packageRoot.path}/linux/libisar.so');
      if (so.existsSync()) {
        libraries[Abi.linuxX64] = so.path;
      }
    } else if (Platform.isWindows) {
      final dll = File('${packageRoot.path}/windows/libisar.dll');
      if (dll.existsSync()) {
        libraries[Abi.windowsX64] = dll.path;
      }
    }

    return libraries;
  }

  Directory? _resolveIsarFlutterLibsRootFromPackageConfig() {
    try {
      final configFile = File(
        '${Directory.current.path}/.dart_tool/package_config.json',
      );
      if (!configFile.existsSync()) return null;

      final decoded = jsonDecode(configFile.readAsStringSync());
      if (decoded is! Map<String, dynamic>) return null;
      final packages = decoded['packages'];
      if (packages is! List<dynamic>) return null;

      for (final item in packages) {
        if (item is! Map<String, dynamic>) continue;
        if (item['name'] != 'isar_community_flutter_libs') continue;
        final rootUriRaw = item['rootUri'];
        if (rootUriRaw is! String || rootUriRaw.isEmpty) return null;
        final rootUri = Uri.parse(rootUriRaw);
        if (rootUri.scheme == 'file') {
          return Directory.fromUri(rootUri);
        }
        final resolved = configFile.parent.uri.resolveUri(rootUri);
        return Directory.fromUri(resolved);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
