import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/content/content_repository.dart';
import '../../core/persistence/preferences_store.dart';
import '../models/pattern.dart';
import '../models/sentence.dart';

final todayPackUseCaseProvider = Provider<TodayPackUseCase>((ref) {
  final repo = ref.watch(contentRepositoryProvider);
  final prefs = ref.watch(preferencesStoreProvider);
  return TodayPackUseCase(repo: repo, prefs: prefs);
});

class TodayPackUseCase {
  TodayPackUseCase({
    required ContentRepository repo,
    required PreferencesStore prefs,
  }) : _repo = repo,
       _prefs = prefs;

  final ContentRepository _repo;
  final PreferencesStore _prefs;

  // Keep existing pack structure but no lock behavior in MVP.
  static const int _extraSentenceCount = 2;
  static const int _patternCount = 3;

  /// Builds the deterministic sentence/pattern set for the requested date.
  Future<TodayPack> getTodayPack({
    required DateTime date,
    required String scenarioTag,
  }) async {
    final snapshot = await _repo.loadAll();

    final dayIndex = _prefs.dayIndexFor(date);
    final dateIso = _isoDate(date);

    final curatedPool = _repo.filterSentencesByTag(
      snapshot.curated,
      scenarioTag,
    );
    final Sentence? curated = curatedPool.isEmpty
        ? null
        : _repo.pickOneDeterministic(
            curatedPool,
            _seed(dateIso, scenarioTag, 'curated'),
          );

    final fullPool = _repo.filterSentencesByTag(
      snapshot.sentences,
      scenarioTag,
    );
    final extrasPool = curated == null
        ? fullPool
        : fullPool.where((s) => s.id != curated.id).toList(growable: false);

    final extras = _repo.pickManyDeterministic(
      extrasPool,
      _extraSentenceCount,
      _seed(dateIso, scenarioTag, 'extras'),
    );

    final patternsPool = _repo.filterPatternsByTag(
      snapshot.patterns,
      scenarioTag,
    );
    final patterns = _repo.pickManyDeterministic(
      patternsPool,
      _patternCount,
      _seed(dateIso, scenarioTag, 'patterns'),
    );

    return TodayPack(
      scenarioTag: scenarioTag,
      date: DateTime(date.year, date.month, date.day),
      dayIndex: dayIndex,
      curatedTrialDaysRemaining: 0,
      curatedSentence: curated,
      extraSentences: extras,
      patterns: patterns,
      isCuratedLocked: false,
    );
  }

  String _isoDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Creates a stable seed key so daily selection remains deterministic.
  String _seed(String dateIso, String scenarioTag, String bucket) {
    return '$dateIso|$scenarioTag|$bucket';
  }
}

class TodayPack {
  const TodayPack({
    required this.scenarioTag,
    required this.date,
    required this.dayIndex,
    required this.curatedTrialDaysRemaining,
    required this.curatedSentence,
    required this.extraSentences,
    required this.patterns,
    required this.isCuratedLocked,
  });

  final String scenarioTag;
  final DateTime date;
  final int dayIndex;

  // Retained for compatibility with existing UI/tests.
  final int curatedTrialDaysRemaining;
  final Sentence? curatedSentence;
  final List<Sentence> extraSentences;
  final List<Pattern> patterns;
  final bool isCuratedLocked;
}
