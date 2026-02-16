import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/content/content_providers.dart';
import '../../domain/models/pattern.dart';
import '../../domain/models/scenario_tag.dart';
import '../../domain/models/sentence.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  ScenarioTag _selectedTag = ScenarioTag.date;
  final TextEditingController _queryController = TextEditingController();

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(contentSnapshotProvider);

    return Scaffold(
      body: SafeArea(
        child: snapshotAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('데이터 로딩 실패: $error')),
          data: (snapshot) {
            final sentences = _filterSentences(snapshot.sentences);
            final patterns = _filterPatterns(snapshot.patterns);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '상황 탐색',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final tag = ScenarioTag.values[index];
                      final selected = _selectedTag == tag;
                      return ChoiceChip(
                        selected: selected,
                        onSelected: (_) {
                          setState(() => _selectedTag = tag);
                        },
                        label: Text('${tag.emoji} ${tag.titleKr}'),
                        labelStyle: TextStyle(
                          color: selected
                              ? AppColors.onAccent
                              : AppColors.chipText,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                        backgroundColor: AppColors.chip,
                        selectedColor: AppColors.accent,
                        side: BorderSide.none,
                        showCheckmark: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                      );
                    },
                    separatorBuilder: (context, _) => const SizedBox(width: 8),
                    itemCount: ScenarioTag.values.length,
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _queryController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(hintText: '검색 (영문/한글)'),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '문장',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      _SentenceListCard(sentences: sentences),
                      const SizedBox(height: 16),
                      _PatternListCard(patterns: patterns),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Sentence> _filterSentences(List<Sentence> all) {
    final query = _queryController.text.trim();

    final tagged = all
        .where((sentence) => sentence.tags.contains(_selectedTag.key))
        .toList(growable: false);

    if (query.isEmpty) return tagged.take(60).toList(growable: false);

    return tagged
        .where(
          (sentence) =>
              sentence.english.toLowerCase().contains(query.toLowerCase()) ||
              sentence.korean.contains(query),
        )
        .take(60)
        .toList(growable: false);
  }

  List<Pattern> _filterPatterns(List<Pattern> all) {
    return all
        .where((pattern) => pattern.tags.contains(_selectedTag.key))
        .take(30)
        .toList(growable: false);
  }
}

class _SentenceListCard extends StatelessWidget {
  const _SentenceListCard({required this.sentences});

  final List<Sentence> sentences;

  @override
  Widget build(BuildContext context) {
    if (sentences.isEmpty) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Text(
            '해당 상황의 문장을 찾지 못했어요.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.subText),
          ),
        ),
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
          return InkWell(
            onTap: () => context.push('/sentence/${sentence.id}'),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sentence.english,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontSize: 19, height: 1.28),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          sentence.korean,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.subText),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textTertiary,
                    size: 30,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PatternListCard extends StatelessWidget {
  const _PatternListCard({required this.patterns});

  final List<Pattern> patterns;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          '패턴 ${patterns.length}개',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        subtitle: Text(
          '해당 상황에서 자주 쓰는 패턴',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.subText),
        ),
        children: [
          if (patterns.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '해당 상황의 패턴을 찾지 못했어요.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          else
            for (final pattern in patterns)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  '- ${pattern.title}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
        ],
      ),
    );
  }
}
