import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final fileCacheProvider = Provider<FileCache>((ref) {
  return FileCache();
});

class FileCache {
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

  Future<String?> readString(String key) async {
    try {
      final file = await _fileForKey(key);
      if (!await file.exists()) return null;
      return await file.readAsString();
    } catch (_) {
      return null;
    }
  }

  Future<void> writeString(String key, String value) async {
    final file = await _fileForKey(key);
    await file.parent.create(recursive: true);
    await file.writeAsString(value, flush: true);
  }

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
