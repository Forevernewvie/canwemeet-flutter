import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/pattern.dart';
import '../../domain/models/sentence.dart';
import 'content_store.dart';

final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  final store = ref.watch(contentStoreProvider);
  return ContentRepository(store);
});

class ContentRepository {
  ContentRepository(this._store);

  final ContentStore _store;
  static const int _seedMask31Bits = 0x7fffffff;

  /// Loads all content datasets into one immutable snapshot.
  Future<ContentSnapshot> loadAll() async {
    final sentences = await _store.getSentences();
    final curated = await _store.getCuratedSentences();
    final patterns = await _store.getPatterns();
    return ContentSnapshot(
      sentences: sentences,
      curated: curated,
      patterns: patterns,
    );
  }

  /// Filters sentences by scenario tag and falls back to full list if empty.
  List<Sentence> filterSentencesByTag(List<Sentence> list, String tag) {
    return _filterByTag(list, tag, (sentence) => sentence.tags);
  }

  /// Filters patterns by scenario tag and falls back to full list if empty.
  List<Pattern> filterPatternsByTag(List<Pattern> list, String tag) {
    return _filterByTag(list, tag, (pattern) => pattern.tags);
  }

  /// Picks one value deterministically from a non-empty list.
  Sentence pickOneDeterministic(List<Sentence> list, String seedKey) {
    if (list.isEmpty) {
      throw StateError('Cannot pick from empty list');
    }
    final shuffled = _shuffled(list, seedKey);
    return shuffled.first;
  }

  /// Picks up to `count` values deterministically from a list.
  List<T> pickManyDeterministic<T>(List<T> list, int count, String seedKey) {
    if (list.isEmpty) return const [];
    final shuffled = _shuffled(list, seedKey);
    return shuffled.take(count).toList(growable: false);
  }

  /// Filters generic tagged data with fallback to full list on empty match.
  List<T> _filterByTag<T>(
    List<T> list,
    String tag,
    List<String> Function(T item) tagsReader,
  ) {
    final filtered = list
        .where((item) => tagsReader(item).contains(tag))
        .toList(growable: false);
    return filtered.isEmpty ? list : filtered;
  }

  /// Creates a deterministic shuffled copy based on a stable seed key.
  List<T> _shuffled<T>(List<T> list, String seedKey) {
    final seed = _seed32(seedKey);
    final copy = List<T>.of(list);
    copy.shuffle(Random(seed));
    return copy;
  }

  /// Converts an arbitrary string to a positive deterministic 31-bit seed.
  int _seed32(String input) {
    final digest = sha256.convert(utf8.encode(input)).bytes;
    final v =
        (digest[0] << 24) | (digest[1] << 16) | (digest[2] << 8) | digest[3];
    return v & _seedMask31Bits;
  }
}

class ContentSnapshot {
  const ContentSnapshot({
    required this.sentences,
    required this.curated,
    required this.patterns,
  });

  final List<Sentence> sentences;
  final List<Sentence> curated;
  final List<Pattern> patterns;
}
