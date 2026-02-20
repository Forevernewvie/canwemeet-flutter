import 'dart:io';
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'isar/isar_persistence_engine.dart';

final fileCacheProvider = Provider<StringCache>((ref) {
  final engine = ref.watch(isarPersistenceEngineProvider);
  return IsarBackedStringCache(engine: engine, legacy: FileCache());
});

abstract class StringCache {
  Future<String?> readString(String key);
  Future<void> writeString(String key, String value);
  Future<void> delete(String key);
}

class FileCache implements StringCache {
  FileCache({Directory? directory}) : _directory = directory;

  Directory? _directory;

  Future<Directory> _getDirectory() async {
    if (_directory != null) return _directory!;
    _directory = await getApplicationSupportDirectory();
    return _directory!;
  }

  Future<File> _fileForKey(String key) async {
    final dir = await _getDirectory();
    return File('${dir.path}/$key');
  }

  @override
  Future<String?> readString(String key) async {
    try {
      final file = await _fileForKey(key);
      if (!await file.exists()) return null;
      return await file.readAsString();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> writeString(String key, String value) async {
    final file = await _fileForKey(key);
    await file.parent.create(recursive: true);
    await file.writeAsString(value, flush: true);
  }

  @override
  Future<void> delete(String key) async {
    try {
      final file = await _fileForKey(key);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // ignore
    }
  }
}

class IsarBackedStringCache implements StringCache {
  IsarBackedStringCache({
    required IsarPersistenceEngine engine,
    required StringCache legacy,
  }) : _engine = engine,
       _legacy = legacy;

  final IsarPersistenceEngine _engine;
  final StringCache _legacy;

  @override
  Future<String?> readString(String key) async {
    if (!_engine.isEnabled) {
      return _legacy.readString(key);
    }

    final fromIsar = await _engine.readCache(key);
    if (fromIsar != null) {
      return fromIsar;
    }

    final fromLegacy = await _legacy.readString(key);
    if (fromLegacy != null) {
      unawaited(_engine.writeCache(key, fromLegacy));
    }
    return fromLegacy;
  }

  @override
  Future<void> writeString(String key, String value) async {
    if (_engine.isEnabled) {
      await _engine.writeCache(key, value);
    }
    await _legacy.writeString(key, value);
  }

  @override
  Future<void> delete(String key) async {
    if (_engine.isEnabled) {
      await _engine.deleteCache(key);
    }
    await _legacy.delete(key);
  }
}

class MemoryCache implements StringCache {
  final Map<String, String> _store = <String, String>{};

  @override
  Future<String?> readString(String key) async {
    return _store[key];
  }

  @override
  Future<void> writeString(String key, String value) async {
    _store[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _store.remove(key);
  }
}
