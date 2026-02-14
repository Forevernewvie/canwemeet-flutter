import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../ui_components/sentence_card.dart';

class TodayView extends StatelessWidget {
  const TodayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('우리 제법 잘 어울려'),
        actions: [
          IconButton(
            onPressed: () {
              // Placeholder refresh.
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '오늘 바로 써먹는 문장과 패턴으로\n영작 없이 “바로 튀어나오게” 만들기',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          _FocusChips(
            onSelected: (tag) {
              // Will be wired to data layer in the next step.
            },
          ),
          const SizedBox(height: 16),
          Text('오늘의 큐레이토 1개', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          SentenceCard(
            english: "When you said 'later', were you talking about the location?",
            korean: '네가 “나중에”라고 했을 때, 장소 말한 거야?',
            onTap: () => context.push('/sentence/s0001'),
          ),
          const SizedBox(height: 16),
          Text('추가 추천 2개', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          SentenceCard(
            english: 'Did you drink enough water on your way home?',
            korean: '집에 가는 길에 물 충분히 마셨어?',
            onTap: () => context.push('/sentence/s0002'),
          ),
          SentenceCard(
            english: 'Do you want to watch a movie on your day off?',
            korean: '쉬는 날에 영화 볼래?',
            onTap: () => context.push('/sentence/s0003'),
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: () => context.push('/pattern'),
            child: const Text('패턴 연습 (Pattern Practice)'),
          ),
        ],
      ),
    );
  }
}

class _FocusChips extends StatefulWidget {
  const _FocusChips({required this.onSelected});

  final ValueChanged<String> onSelected;

  @override
  State<_FocusChips> createState() => _FocusChipsState();
}

class _FocusChipsState extends State<_FocusChips> {
  String _selected = 'date';

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
          final selected = it.$1 == _selected;

          return ChoiceChip(
            selected: selected,
            onSelected: (_) {
              setState(() => _selected = it.$1);
              widget.onSelected(it.$1);
            },
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
