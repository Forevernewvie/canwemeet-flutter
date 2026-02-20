import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/content/content_providers.dart';
import '../../domain/models/pattern.dart';
import '../../domain/models/scenario_tag.dart';
import '../../domain/models/sentence.dart';
import '../../ui_components/app_surfaces.dart';

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

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              children: [
                _TopBarCard(title: 'Explore'),
                const SizedBox(height: 12),
                Text('상황 탐색', style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 6),
                Text(
                  '상황별 문장을 빠르게 찾으세요',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _queryController,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: '검색 (영문/한글)',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 12),
                Text('상황 필터', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final tag = ScenarioTag.values[index];
                      final selected = _selectedTag == tag;
                      return ChoiceChip(
                        selected: selected,
                        onSelected: (_) => setState(() => _selectedTag = tag),
                        label: Text('${tag.emoji} ${tag.titleKr}'),
                        labelStyle: TextStyle(
                          color: selected
                              ? AppColors.onAccent
                              : AppColors.chipText,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        backgroundColor: AppColors.chip,
                        selectedColor: AppColors.accent,
                        side: BorderSide.none,
                        showCheckmark: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      );
                    },
                    separatorBuilder: (context, _) => const SizedBox(width: 8),
                    itemCount: ScenarioTag.values.length,
                  ),
                ),
                const SizedBox(height: 12),
                Text('추천 문장', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 10),
                if (sentences.isEmpty)
                  const AppCard(
                    title: '해당 상황의 문장을 찾지 못했어요.',
                    subtitle: '태그나 검색어를 바꿔 다시 확인해 보세요.',
                  )
                else
                  for (final sentence in sentences.take(8)) ...[
                    AppCard(
                      title: sentence.english,
                      subtitle: sentence.korean,
                      badges: [sentence.usageLabel, '톤: ${sentence.tone}'],
                      onTap: () => context.push('/sentence/${sentence.id}'),
                    ),
                    const SizedBox(height: 10),
                  ],
                const SizedBox(height: 6),
                Text('추천 패턴', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 10),
                if (patterns.isEmpty)
                  const AppCard(
                    title: '해당 상황의 패턴을 찾지 못했어요.',
                    subtitle: '다른 상황 태그를 선택해 보세요.',
                  )
                else
                  for (final pattern in patterns.take(4)) ...[
                    AppCard(
                      title: pattern.title,
                      subtitle:
                          '${pattern.exampleEnglish}\n${pattern.exampleKorean}\n\nTip: ${pattern.tip}',
                    ),
                    const SizedBox(height: 10),
                  ],
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

class _TopBarCard extends StatelessWidget {
  const _TopBarCard({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            const CircleAvatar(
              radius: 17,
              backgroundColor: AppColors.surfaceMuted,
              child: Icon(Icons.notifications_none_rounded, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
