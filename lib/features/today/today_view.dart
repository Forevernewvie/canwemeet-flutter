import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/usecases/today_pack_usecase.dart';
import '../../ui_components/sentence_card.dart';
import 'today_controller.dart';

class TodayView extends ConsumerWidget {
  const TodayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focus = ref.watch(todayFocusProvider);
    final packAsync = ref.watch(todayPackProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('우리 제법 잘 어울려'),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(todayPackProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '오늘 바로 써먹는 문장과 패턴으로\n영작 없이 “바로 튀어나오게” 만들기',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          _FocusChips(
            selected: focus,
            onSelected: (tag) =>
                ref.read(todayFocusProvider.notifier).state = tag,
          ),
          const SizedBox(height: 16),
          packAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, st) => _ErrorState(
              error: e.toString(),
              onRetry: () => ref.invalidate(todayPackProvider),
            ),
            data: (pack) => _TodayContent(pack: pack),
          ),
        ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
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
      ),
    );
  }
}

class _TodayContent extends StatelessWidget {
  const _TodayContent({required this.pack});

  final TodayPack pack;

  @override
  Widget build(BuildContext context) {
    final curatedTitle = pack.isPremium
        ? '오늘의 큐레이토 1개'
        : (pack.isCuratedLocked ? '오늘의 큐레이토 (잠김)' : '오늘의 큐레이토 1개');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          curatedTitle,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        if (pack.isCuratedLocked)
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => context.push('/ai'),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.lock_outline),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '큐레이토 문장은 프리미엄에서 제공돼요.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          )
        else if (pack.curatedSentence != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SentenceCard(
                english: pack.curatedSentence!.english,
                korean: pack.curatedSentence!.korean,
                onTap: () =>
                    context.push('/sentence/${pack.curatedSentence!.id}'),
              ),
              if (!pack.isPremium)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '무료 체험 ${pack.curatedTrialDaysRemaining}일 남음',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
        const SizedBox(height: 16),
        Text(
          '추가 추천 2개',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        for (final s in pack.extraSentences)
          SentenceCard(
            english: s.english,
            korean: s.korean,
            onTap: () => context.push('/sentence/${s.id}'),
          ),
        const SizedBox(height: 16),
        Text(
          '오늘의 패턴 3개',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        for (final p in pack.patterns)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              p.title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(p.exampleEnglish),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/pattern'),
          ),
      ],
    );
  }
}

class _FocusChips extends StatelessWidget {
  const _FocusChips({required this.selected, required this.onSelected});

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final items = const <(String tag, String label, IconData icon)>[
      ('date', '데이트', Icons.favorite_border),
      ('conflict', '갈등', Icons.bolt_outlined),
      ('compliment', '칭찬', Icons.auto_awesome_outlined),
      ('sorry', '미안', Icons.volunteer_activism_outlined),
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final it = items[i];
          final isSelected = it.$1 == selected;

          return ChoiceChip(
            selected: isSelected,
            onSelected: (_) => onSelected(it.$1),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(it.$3, size: 18),
                const SizedBox(width: 6),
                Text(it.$2),
              ],
            ),
          );
        },
      ),
    );
  }
}
