import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/pattern.dart';
import '../../domain/models/sentence.dart';
import 'content_repository.dart';

final contentSnapshotProvider = FutureProvider<ContentSnapshot>((ref) async {
  final repository = ref.watch(contentRepositoryProvider);
  return repository.loadAll();
});

final sentenceByIdProvider = FutureProvider.family<Sentence?, String>((
  ref,
  sentenceId,
) async {
  final snapshot = await ref.watch(contentSnapshotProvider.future);
  for (final sentence in <Sentence>[
    ...snapshot.sentences,
    ...snapshot.curated,
  ]) {
    if (sentence.id == sentenceId) return sentence;
  }
  return null;
});

final patternByIdProvider = FutureProvider.family<Pattern?, String>((
  ref,
  patternId,
) async {
  final snapshot = await ref.watch(contentSnapshotProvider.future);
  for (final pattern in snapshot.patterns) {
    if (pattern.id == patternId) return pattern;
  }
  return null;
});
