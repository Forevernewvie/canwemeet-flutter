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

  List<Sentence> filterSentencesByTag(List<Sentence> list, String tag) {
    final filtered = list
        .where((s) => s.tags.contains(tag))
        .toList(growable: false);
    return filtered.isEmpty ? list : filtered;
  }

  List<Pattern> filterPatternsByTag(List<Pattern> list, String tag) {
    final filtered = list
        .where((p) => p.tags.contains(tag))
        .toList(growable: false);
    return filtered.isEmpty ? list : filtered;
  }

  Sentence pickOneDeterministic(List<Sentence> list, String seedKey) {
    if (list.isEmpty) {
      throw StateError('Cannot pick from empty list');
    }
    final shuffled = _shuffled(list, seedKey);
    return shuffled.first;
  }

  List<T> pickManyDeterministic<T>(List<T> list, int count, String seedKey) {
    if (list.isEmpty) return const [];
    final shuffled = _shuffled(list, seedKey);
    return shuffled.take(count).toList(growable: false);
  }

  List<T> _shuffled<T>(List<T> list, String seedKey) {
    final seed = _seed32(seedKey);
    final copy = List<T>.of(list);
    copy.shuffle(Random(seed));
    return copy;
  }

  int _seed32(String input) {
    final digest = sha256.convert(utf8.encode(input)).bytes;
    final v =
        (digest[0] << 24) | (digest[1] << 16) | (digest[2] << 8) | digest[3];
    return v & 0x7fffffff;
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
