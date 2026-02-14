import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/persistence/preferences_store.dart';
import '../../ui_components/primary_button.dart';

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _complete() {
    ref.read(preferencesStoreProvider).completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final pages = <_OnboardingPageData>[
      const _OnboardingPageData(
        title: '우리 제법 잘 어울려',
        subtitle: '영어권 연인과 대화가 막힐 때,\n오늘 바로 쓰는 문장 3개 + 패턴 3개',
        icon: Icons.chat_bubble_outline,
      ),
      const _OnboardingPageData(
        title: '매일 3문장 + 3패턴',
        subtitle: '상황을 고르면 그 대화에\n가까운 문장을 추천해요.',
        icon: Icons.calendar_today_outlined,
      ),
      const _OnboardingPageData(
        title: '프리미엄: AI 대화',
        subtitle: '추천 문장으로 말했을 때\n상대의 답변과 후속 질문을 시뮬레이션.',
        icon: Icons.auto_awesome_outlined,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: _complete,
            child: const Text('건너뛰기'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (v) => setState(() => _index = v),
                itemCount: pages.length,
                itemBuilder: (context, i) => _OnboardingPage(page: pages[i]),
              ),
            ),
            _Dots(count: pages.length, index: _index),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: PrimaryButton(
                label: _index == pages.length - 1 ? '시작하기' : '다음',
                onPressed: () {
                  if (_index == pages.length - 1) {
                    _complete();
                    return;
                  }
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.page});

  final _OnboardingPageData page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(page.icon, size: 72),
          const SizedBox(height: 24),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final on = Theme.of(context).colorScheme.primary;
    final off = Theme.of(context).colorScheme.outlineVariant;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: i == index ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: i == index ? on : off,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ),
    );
  }
}
