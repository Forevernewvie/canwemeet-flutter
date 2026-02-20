import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
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
        emoji: '💬',
        title: '우리 제법 잘 어울려',
        subtitle: '연인과의 영어 대화를\n매일 3문장 + 3패턴으로\n자연스럽게 이어가요.',
        bullets: [
          '• 오늘 바로 쓰는 문장 추천',
          '• 발음/저장/복습 루프',
          '• 스트릭으로 습관 만들기',
        ],
      ),
      const _OnboardingPageData(
        emoji: '🗓️',
        title: '매일 3문장 + 3패턴',
        subtitle: '상황 포커스를 고르면\n대화 맥락에 맞는 추천을\n빠르게 확인할 수 있어요.',
        bullets: [
          '• Today에서 바로 추천 확인',
          '• Explore에서 태그+검색 탐색',
          '• My Library에서 복습 이어가기',
        ],
      ),
      const _OnboardingPageData(
        emoji: '🤝',
        title: '실전 전송 모드 지원',
        subtitle: '문장 상세에서 톤을 바꾸고\n복사/공유로 바로 전송해\n실전 대화를 이어가요.',
        bullets: [
          '• Natural / Softer / More direct',
          '• 복사 / 공유 원탭 동작',
          '• 리마인더로 학습 루틴 유지',
        ],
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  const Spacer(),
                  TextButton(onPressed: _complete, child: const Text('건너뛰기')),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (v) => setState(() => _index = v),
                itemCount: pages.length,
                itemBuilder: (context, i) => _OnboardingPage(page: pages[i]),
              ),
            ),
            _Dots(count: pages.length, index: _index),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Text(
                '시작 후에도 설정에서 알림 시간을 바꿀 수 있어요.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
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
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.bullets,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final List<String> bullets;
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.page});

  final _OnboardingPageData page;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.elevatedSurface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 170,
                    child: Center(
                      child: Text(page.emoji, style: const TextStyle(fontSize: 48)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(page.title, style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 8),
                Text(
                  page.subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppColors.chipText),
                ),
                const SizedBox(height: 12),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderSoft),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final bullet in page.bullets)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Text(
                              bullet,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.chipText,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: i == index ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: i == index ? on : const Color(0xFFD6C8B3),
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ),
    );
  }
}
