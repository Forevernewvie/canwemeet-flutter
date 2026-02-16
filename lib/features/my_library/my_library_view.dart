import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/content/content_providers.dart';
import '../../core/persistence/preferences_store.dart';
import '../../domain/models/sentence.dart';
import '../../ui_components/app_surfaces.dart';

enum _MySegment { favorites, review, stats }

class MyLibraryView extends ConsumerStatefulWidget {
  const MyLibraryView({super.key});

  @override
  ConsumerState<MyLibraryView> createState() => _MyLibraryViewState();
}

class _MyLibraryViewState extends ConsumerState<MyLibraryView> {
  _MySegment _segment = _MySegment.favorites;
  final TextEditingController _queryController = TextEditingController();

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(preferencesStoreProvider);
    final contentSnapshot = ref.watch(contentSnapshotProvider);

    return Scaffold(
      body: SafeArea(
        child: contentSnapshot.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('데이터 로딩 실패: $error')),
          data: (snapshot) {
            final allSentences = snapshot.sentences;
            final favorites = _favoriteSentences(allSentences, prefs);
            final dueReviews = _reviewSentences(allSentences, prefs);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Row(
                    children: [
                      CircleToolbarButton(
                        icon: Icons.refresh,
                        onPressed: () {
                          ref.invalidate(contentSnapshotProvider);
                          setState(() {});
                        },
                      ),
                      const Spacer(),
                      CircleToolbarButton(
                        icon: Icons.settings,
                        onPressed: () => context.push('/my/settings'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '내 라이브러리',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: AppCard(
                    title: '연속 학습',
                    subtitle: prefs.hasStudiedToday()
                        ? '오늘 학습 완료'
                        : '오늘 🔊 발음 1번이면 학습으로 기록돼요.',
                    badges: ['이번 달 ${prefs.studiedDayCountInMonth()}일'],
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${prefs.currentStreak()}일',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          '자세히',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _Segmented(
                    value: _segment,
                    onChanged: (v) => setState(() => _segment = v),
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(color: AppColors.bg),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                      children: [
                        TextField(
                          controller: _queryController,
                          decoration: const InputDecoration(
                            hintText: '검색 (영문/한글)',
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 14),
                        if (_segment == _MySegment.favorites)
                          _FavoritesPane(
                            sentences: _applyQuery(favorites),
                            onSpeak: (sentence) {
                              ref
                                  .read(preferencesStoreProvider)
                                  .recordStudyEvent();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('발음 연습 기록: ${sentence.id}'),
                                ),
                              );
                            },
                            onRemove: (sentence) => ref
                                .read(preferencesStoreProvider)
                                .toggleFavorite(sentence.id),
                          ),
                        if (_segment == _MySegment.review)
                          _ReviewPane(sentences: _applyQuery(dueReviews)),
                        if (_segment == _MySegment.stats)
                          _StatsPane(
                            favoriteCount: favorites.length,
                            reviewCount: prefs.reviewQueueCount(),
                            streak: prefs.currentStreak(),
                            monthlyDays: prefs.studiedDayCountInMonth(),
                            daysSinceInstall: DateTime.now()
                                .difference(prefs.installDate)
                                .inDays,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Sentence> _favoriteSentences(
    List<Sentence> all,
    PreferencesStore prefs,
  ) {
    final ids = prefs.favoriteIds;
    return all
        .where((sentence) => ids.contains(sentence.id))
        .toList(growable: false);
  }

  List<Sentence> _reviewSentences(List<Sentence> all, PreferencesStore prefs) {
    final dueIds = prefs.dueReviewSentenceIds();
    final byId = <String, Sentence>{
      for (final sentence in all) sentence.id: sentence,
    };
    return dueIds
        .map((id) => byId[id])
        .whereType<Sentence>()
        .toList(growable: false);
  }

  List<Sentence> _applyQuery(List<Sentence> list) {
    final query = _queryController.text.trim();
    if (query.isEmpty) return list;
    return list
        .where(
          (sentence) =>
              sentence.english.toLowerCase().contains(query.toLowerCase()) ||
              sentence.korean.contains(query),
        )
        .toList(growable: false);
  }
}

class _Segmented extends StatelessWidget {
  const _Segmented({required this.value, required this.onChanged});

  final _MySegment value;
  final ValueChanged<_MySegment> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget item(_MySegment segment, String label) {
      final selected = segment == value;
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => onChanged(segment),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selected ? AppColors.card : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                color: selected ? AppColors.accent : AppColors.subText,
              ),
            ),
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          item(_MySegment.favorites, '저장'),
          item(_MySegment.review, '복습'),
          item(_MySegment.stats, '통계'),
        ],
      ),
    );
  }
}

class _FavoritesPane extends StatelessWidget {
  const _FavoritesPane({
    required this.sentences,
    required this.onSpeak,
    required this.onRemove,
  });

  final List<Sentence> sentences;
  final ValueChanged<Sentence> onSpeak;
  final ValueChanged<Sentence> onRemove;

  @override
  Widget build(BuildContext context) {
    if (sentences.isEmpty) {
      return const AppCard(
        title: '저장된 문장이 없어요.',
        subtitle: '오늘 탭에서 ♥로 저장해보세요.',
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sentences.length,
        separatorBuilder: (context, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final sentence = sentences[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sentence.english,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 6),
                Text(
                  sentence.korean,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.subText),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => onSpeak(sentence),
                      icon: const Icon(Icons.volume_up_outlined),
                      label: const Text('발음'),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => onRemove(sentence),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('삭제'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ReviewPane extends ConsumerWidget {
  const _ReviewPane({required this.sentences});

  final List<Sentence> sentences;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (sentences.isEmpty) {
      return const AppCard(
        title: '복습할 문장이 없어요.',
        subtitle: '저장한 문장을 기준으로 복습 큐가 자동 생성됩니다.',
      );
    }

    final sentence = sentences.first;

    return AppCard(
      title: sentence.english,
      subtitle: sentence.korean,
      badges: [sentence.usageLabel, '톤: ${sentence.tone}'],
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () =>
                ref.read(preferencesStoreProvider).recordStudyEvent(),
            icon: const Icon(Icons.volume_up_outlined),
          ),
          IconButton(
            onPressed: () => ref
                .read(preferencesStoreProvider)
                .refreshReviewNow(sentence.id),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          backgroundColor: AppColors.card,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '난이도 선택',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () {
                      ref
                          .read(preferencesStoreProvider)
                          .submitReviewResult(sentence.id, ReviewResult.easy);
                      Navigator.pop(context);
                    },
                    child: const Text('쉬움'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () {
                      ref
                          .read(preferencesStoreProvider)
                          .submitReviewResult(sentence.id, ReviewResult.hard);
                      Navigator.pop(context);
                    },
                    child: const Text('어려움'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () {
                      ref
                          .read(preferencesStoreProvider)
                          .submitReviewResult(sentence.id, ReviewResult.again);
                      Navigator.pop(context);
                    },
                    child: const Text('다시'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _StatsPane extends StatelessWidget {
  const _StatsPane({
    required this.favoriteCount,
    required this.reviewCount,
    required this.streak,
    required this.monthlyDays,
    required this.daysSinceInstall,
  });

  final int favoriteCount;
  final int reviewCount;
  final int streak;
  final int monthlyDays;
  final int daysSinceInstall;

  @override
  Widget build(BuildContext context) {
    Widget row(String title, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(child: Text(title)),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.subText),
            ),
          ],
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('요약 통계', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(
              '사용 패턴이 쌓이면 더 상세한 지표를 제공합니다.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.subText),
            ),
            const SizedBox(height: 10),
            row('연속 학습', '$streak일'),
            row('이번 달 학습', '$monthlyDays일'),
            row('저장한 문장', '$favoriteCount개'),
            row('복습 큐', '$reviewCount개'),
            row('설치 후 경과', '$daysSinceInstall일'),
          ],
        ),
      ),
    );
  }
}
