import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/persistence/preferences_store.dart';
import '../../domain/models/scenario_tag.dart';
import '../../domain/models/sentence.dart';
import '../../domain/usecases/today_pack_usecase.dart';
import '../../ui_components/app_surfaces.dart';
import 'today_controller.dart';

class TodayView extends ConsumerWidget {
  const TodayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.appPalette;
    final focus = ref.watch(todayFocusProvider);
    final packAsync = ref.watch(todayPackProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
          children: [
            const AppTopBarCard(title: '우리 제법 잘 어울려'),
            const SizedBox(height: 12),
            Text(
              '오늘 바로 써먹는 문장과 패턴으로\n영작 없이 ‘바로 튀어나오게’ 만들기',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              '상황을 선택하면 그 대화에 더 가까운 문장을 추천해요.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: palette.subText),
            ),
            const SizedBox(height: 18),
            Text('오늘의 포커스', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 10),
            _FocusChips(
              selected: focus,
              onSelected: (tag) =>
                  ref.read(todayFocusProvider.notifier).state = tag,
            ),
            const SizedBox(height: 16),
            packAsync.when(
              loading: () =>
                  const AppLoadingStateCard(message: '문장과 패턴을 불러오고 있어요...'),
              error: (error, _) => _ErrorState(
                error: error.toString(),
                onRetry: () => ref.invalidate(todayPackProvider),
              ),
              data: (pack) => _TodayContent(pack: pack),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error, required this.onRetry});

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return AppErrorStateCard(title: '오류가 발생했어요', body: error, onRetry: onRetry);
  }
}

class _TodayContent extends ConsumerWidget {
  const _TodayContent({required this.pack});

  final TodayPack pack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferencesStoreProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('오늘의 큐레이션 1개', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 10),
        if (pack.curatedSentence != null)
          _SentenceCardBlock(
            sentence: pack.curatedSentence!,
            badges: [
              '큐레이션',
              if (pack.curatedSentence!.usageLabel.isNotEmpty)
                pack.curatedSentence!.usageLabel,
              '톤: ${pack.curatedSentence!.tone}',
            ],
          )
        else
          const AppEmptyStateCard(
            title: '큐레이션 문장을 준비 중이에요.',
            body: '지금은 추가 추천 문장으로 학습을 이어갈 수 있어요.',
          ),
        const SizedBox(height: 18),
        Text(
          '추가 추천 ${pack.extraSentences.length}개',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 10),
        for (final sentence in pack.extraSentences) ...[
          _SentenceCardBlock(
            sentence: sentence,
            badges: [sentence.usageLabel, '톤: ${sentence.tone}'],
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 8),
        Text('오늘의 패턴 3개', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 10),
        if (pack.patterns.isEmpty)
          const AppEmptyStateCard(
            title: '추천 패턴이 없어요.',
            body: '상황 포커스를 바꿔 다시 확인해 보세요.',
          )
        else
          for (final pattern in pack.patterns) ...[
            AppCard(
              title: pattern.title,
              subtitle:
                  '${pattern.exampleEnglish}\n${pattern.exampleKorean}\n\n팁: ${pattern.tip}',
              badges: pattern.tags
                  .map((tag) => '#$tag')
                  .toList(growable: false),
              onTap: () => context.push('/pattern'),
            ),
            const SizedBox(height: 10),
          ],
        const SizedBox(height: 8),
        Text('빠른 실행', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            _QuickChip(label: '🔊 발음 듣기'),
            _QuickChip(label: '⭐ 오늘팩 저장'),
          ],
        ),
        const SizedBox(height: 10),
        AppStatusBanner(
          title: '오늘 추천 저장 ${prefs.favoriteIds.isEmpty ? 0 : 1}개',
          body: prefs.hasStudiedToday()
              ? '좋았던 문장을 저장하면 복습 큐가 자동 생성돼요.'
              : '지금 문장 1개를 저장하면 복습 루프가 시작돼요.',
        ),
      ],
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.chip,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(label, style: Theme.of(context).textTheme.labelMedium),
      ),
    );
  }
}

class _SentenceCardBlock extends ConsumerWidget {
  const _SentenceCardBlock({required this.sentence, required this.badges});

  final Sentence sentence;
  final List<String> badges;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferencesStoreProvider);
    final isFavorite = prefs.isFavorite(sentence.id);

    return AppCard(
      title: sentence.english,
      subtitle: sentence.korean,
      badges: badges,
      trailing: Column(
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () {
              ref.read(preferencesStoreProvider).recordStudyEvent();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('발음 재생 기능은 곧 제공됩니다.')),
              );
            },
            icon: const Icon(Icons.volume_up_outlined),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () =>
                ref.read(preferencesStoreProvider).toggleFavorite(sentence.id),
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          ),
        ],
      ),
      onTap: () => context.push('/sentence/${sentence.id}'),
    );
  }
}

class _FocusChips extends StatelessWidget {
  const _FocusChips({required this.selected, required this.onSelected});

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tag = ScenarioTag.values[index];
          final isSelected = selected == tag.key;
          return ChoiceChip(
            selected: isSelected,
            onSelected: (_) => onSelected(tag.key),
            label: Text('${tag.emoji} ${tag.titleKr}'),
            labelStyle: TextStyle(
              color: isSelected ? palette.onAccent : palette.chipText,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            backgroundColor: palette.chip,
            selectedColor: palette.accent,
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            showCheckmark: false,
          );
        },
        separatorBuilder: (context, _) => const SizedBox(width: 8),
        itemCount: ScenarioTag.values.length,
      ),
    );
  }
}
