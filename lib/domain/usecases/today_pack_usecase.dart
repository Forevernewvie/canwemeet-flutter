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

  static const int curatedTrialDays = 7;

  Future<TodayPack> getTodayPack({
    required DateTime date,
    required String scenarioTag,
  }) async {
    final snapshot = await _repo.loadAll();

    final dayIndex = _prefs.dayIndexFor(date);
    final trialDaysRemaining = (curatedTrialDays - dayIndex).clamp(
      0,
      curatedTrialDays,
    );

    final curatedUnlocked = dayIndex < curatedTrialDays;

    final dateIso = _isoDate(date);

    Sentence? curated;
    if (curatedUnlocked) {
      final curatedPool = _repo.filterSentencesByTag(
        snapshot.curated,
        scenarioTag,
      );
      curated = _repo.pickOneDeterministic(
        curatedPool,
        '$dateIso|$scenarioTag|curated',
      );
    }

    final fullPool = _repo.filterSentencesByTag(
      snapshot.sentences,
      scenarioTag,
    );
    final extrasPool = curated == null
        ? fullPool
        : fullPool.where((s) => s.id != curated!.id).toList(growable: false);

    final extras = _repo.pickManyDeterministic(
      extrasPool,
      2,
      '$dateIso|$scenarioTag|extras',
    );

    final patternsPool = _repo.filterPatternsByTag(
      snapshot.patterns,
      scenarioTag,
    );
    final patterns = _repo.pickManyDeterministic(
      patternsPool,
      3,
      '$dateIso|$scenarioTag|patterns',
    );

    return TodayPack(
      scenarioTag: scenarioTag,
      date: DateTime(date.year, date.month, date.day),
      dayIndex: dayIndex,
      curatedTrialDaysRemaining: trialDaysRemaining,
      curatedSentence: curated,
      extraSentences: extras,
      patterns: patterns,
      isCuratedLocked: !curatedUnlocked,
    );
  }

  String _isoDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
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
  final int curatedTrialDaysRemaining;
  final Sentence? curatedSentence;
  final List<Sentence> extraSentences;
  final List<Pattern> patterns;
  final bool isCuratedLocked;
}
