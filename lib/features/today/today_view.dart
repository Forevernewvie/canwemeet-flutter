import 'dart:async';

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

class TodayView extends ConsumerStatefulWidget {
  const TodayView({super.key});

  @override
  ConsumerState<TodayView> createState() => _TodayViewState();
}

class _TodayViewState extends ConsumerState<TodayView> {
  bool _showGreeting = true;
  Timer? _toastTimer;

  @override
  void initState() {
    super.initState();
    _toastTimer = Timer(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() => _showGreeting = false);
    });
  }

  @override
  void dispose() {
    _toastTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focus = ref.watch(todayFocusProvider);
    final packAsync = ref.watch(todayPackProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: !_showGreeting
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 2),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.card.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          child: Text(
                            '오늘도 연인과 즐겁게 대화할 준비가 되었나요? 🙂',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
                children: [
                  const _TopBarCard(title: 'Today'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Spacer(),
                      CircleToolbarButton(
                        icon: Icons.refresh,
                        onPressed: () => ref.invalidate(todayPackProvider),
                      ),
                    ],
                  ),
                  Text(
                    '우리 제법 잘 어울려',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '오늘 바로 써먹는 문장과 패턴으로\n영작 없이 ‘바로 튀어나오게’ 만들기',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '상황을 선택하면 그 대화에 더 가까운 문장을 추천해요.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.subText),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '오늘의 포커스',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  _FocusChips(
                    selected: focus,
                    onSelected: (tag) =>
                        ref.read(todayFocusProvider.notifier).state = tag,
                  ),
                  const SizedBox(height: 16),
                  packAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 28),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, _) => _ErrorState(
                      error: error.toString(),
                      onRetry: () => ref.invalidate(todayPackProvider),
                    ),
                    data: (pack) => _TodayContent(pack: pack),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error, required this.onRetry});

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '데이터 로딩 실패',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(error, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 12),
        FilledButton(onPressed: onRetry, child: const Text('다시 시도')),
      ],
    );
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
          const AppCard(
            title: '큐레이션 문장을 준비 중이에요.',
            subtitle: '지금은 추가 추천 문장으로 학습을 이어갈 수 있어요.',
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
        for (final pattern in pack.patterns) ...[
          AppCard(
            title: pattern.title,
            subtitle:
                '${pattern.exampleEnglish}\n${pattern.exampleKorean}\n\n팁: ${pattern.tip}',
            badges: pattern.tags.map((tag) => '#$tag').toList(growable: false),
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
        if (prefs.hasStudiedToday())
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '오늘 학습이 기록되었어요.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.accent),
            ),
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.chip,
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
              color: isSelected ? AppColors.onAccent : AppColors.chipText,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            backgroundColor: AppColors.chip,
            selectedColor: AppColors.accent,
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
