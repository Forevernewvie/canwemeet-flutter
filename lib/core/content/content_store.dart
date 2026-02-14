import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/pattern.dart';
import '../../domain/models/sentence.dart';
import '../persistence/file_cache.dart';
import 'manifest_client.dart';

final contentStoreProvider = Provider<ContentStore>((ref) {
  final cache = ref.watch(fileCacheProvider);
  final manifest = ref.watch(manifestClientProvider);
  return ContentStore(fileCache: cache, manifestClient: manifest);
});

class ContentStore {
  ContentStore({required this.fileCache, required this.manifestClient});

  static const _sentencesAsset = 'assets/data/sentences_v1.json';
  static const _curatedAsset = 'assets/data/curated_sentences_200_v1.json';
  static const _patternsAsset = 'assets/data/patterns_v1.json';

  static const _sentencesCacheKey = 'sentences_v1.json';
  static const _curatedCacheKey = 'curated_sentences_200_v1.json';
  static const _patternsCacheKey = 'patterns_v1.json';

  final FileCache fileCache;
  final ManifestClient manifestClient;

  List<Sentence>? _sentences;
  List<Sentence>? _curated;
  List<Pattern>? _patterns;

  Future<List<Sentence>> getSentences() async {
    _sentences ??= await _loadSentences(
      assetPath: _sentencesAsset,
      cacheKey: _sentencesCacheKey,
      minCount: 100,
    );
    return _sentences!;
  }

  Future<List<Sentence>> getCuratedSentences() async {
    _curated ??= await _loadSentences(
      assetPath: _curatedAsset,
      cacheKey: _curatedCacheKey,
      minCount: 50,
    );
    return _curated!;
  }

  Future<List<Pattern>> getPatterns() async {
    _patterns ??= await _loadPatterns(
      assetPath: _patternsAsset,
      cacheKey: _patternsCacheKey,
      minCount: 10,
    );
    return _patterns!;
  }

  Future<void> refresh() async {
    // Remote updates are currently stubbed. This still clears memory so a future
    // manifest implementation can plug-in without UI refactors.
    _sentences = null;
    _curated = null;
    _patterns = null;

    await fileCache.delete(_sentencesCacheKey);
    await fileCache.delete(_curatedCacheKey);
    await fileCache.delete(_patternsCacheKey);
  }

  Future<List<Sentence>> _loadSentences({
    required String assetPath,
    required String cacheKey,
    required int minCount,
  }) async {
    final cached = await fileCache.readString(cacheKey);
    final fromCache = _tryDecodeSentences(cached);
    if (fromCache != null && fromCache.length >= minCount) {
      return fromCache;
    }

    final raw = await rootBundle.loadString(assetPath);
    final decoded = _tryDecodeSentences(raw);
    if (decoded == null || decoded.length < minCount) {
      throw StateError('Broken dataset: $assetPath');
    }

    // Only cache validated data.
    await fileCache.writeString(cacheKey, raw);
    return decoded;
  }

  Future<List<Pattern>> _loadPatterns({
    required String assetPath,
    required String cacheKey,
    required int minCount,
  }) async {
    final cached = await fileCache.readString(cacheKey);
    final fromCache = _tryDecodePatterns(cached);
    if (fromCache != null && fromCache.length >= minCount) {
      return fromCache;
    }

    final raw = await rootBundle.loadString(assetPath);
    final decoded = _tryDecodePatterns(raw);
    if (decoded == null || decoded.length < minCount) {
      throw StateError('Broken dataset: $assetPath');
    }

    await fileCache.writeString(cacheKey, raw);
    return decoded;
  }

  List<Sentence>? _tryDecodeSentences(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final list = (jsonDecode(raw) as List<dynamic>);
      return list.map((e) => Sentence.fromJson(e as Map<String, dynamic>)).toList(growable: false);
    } catch (_) {
      return null;
    }
  }

  List<Pattern>? _tryDecodePatterns(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final list = (jsonDecode(raw) as List<dynamic>);
      return list.map((e) => Pattern.fromJson(e as Map<String, dynamic>)).toList(growable: false);
    } catch (_) {
      return null;
    }
  }
}
