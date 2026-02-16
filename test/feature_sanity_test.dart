import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ourmatchwell_flutter/app/app.dart';
import 'package:ourmatchwell_flutter/core/content/content_repository.dart';
import 'package:ourmatchwell_flutter/core/content/content_store.dart';
import 'package:ourmatchwell_flutter/core/content/manifest_client.dart';
import 'package:ourmatchwell_flutter/core/persistence/file_cache.dart';
import 'package:ourmatchwell_flutter/core/persistence/preferences_store.dart';
import 'package:ourmatchwell_flutter/domain/models/pattern.dart';
import 'package:ourmatchwell_flutter/domain/models/sentence.dart';
import 'package:ourmatchwell_flutter/ui_components/app_surfaces.dart';

Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Finder? failFastFinder,
  String? failFastMessage,
  int maxTries = 120,
  Duration step = const Duration(milliseconds: 100),
}) async {
  for (var i = 0; i < maxTries; i++) {
    await tester.pump(step);
    if (failFastFinder != null && failFastFinder.evaluate().isNotEmpty) {
      throw TestFailure(
        failFastMessage ?? 'Fail-fast condition met: $failFastFinder',
      );
    }
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }
  throw TestFailure('Timeout waiting for: $finder');
}

Future<void> _popRoute(WidgetTester tester) async {
  await tester.binding.handlePopRoute();
  await tester.pump(const Duration(milliseconds: 200));
}

class _FakeContentStore extends ContentStore {
  _FakeContentStore()
    : super(fileCache: MemoryCache(), manifestClient: const ManifestClient());

  static const _tags = <String>['date', 'conflict', 'compliment', 'sorry'];

  static final _curated = <Sentence>[
    const Sentence(
      id: 'c1',
      english: "When you said 'later', were you talking about the location?",
      korean: "네가 '나중에'라고 했을 때, 장소 말한 거야?",
      tags: _tags,
      tone: 'gentle',
      usageLabel: '확인/오해풀기',
      patternHint: null,
    ),
  ];

  static final _sentences = <Sentence>[
    const Sentence(
      id: 's1',
      english: 'Do you want to watch a movie on your day off?',
      korean: '쉬는 날에 영화 볼래?',
      tags: _tags,
      tone: 'playful',
      usageLabel: '일상',
      patternHint: null,
    ),
    const Sentence(
      id: 's2',
      english: 'Did you drink enough water on your way home?',
      korean: '집에 가는 길에 물 충분히 마셨어?',
      tags: _tags,
      tone: 'gentle',
      usageLabel: '일상',
      patternHint: null,
    ),
    const Sentence(
      id: 's3',
      english: "When you said 'maybe', were you talking about the location?",
      korean: "네가 '아마'라고 했을 때, 장소 말한 거야?",
      tags: _tags,
      tone: 'gentle',
      usageLabel: '확인/오해풀기',
      patternHint: null,
    ),
  ];

  static final _patterns = <Pattern>[
    const Pattern(
      id: 'p1',
      title: 'Do you want to __?',
      exampleEnglish: 'Do you want to get coffee?',
      exampleKorean: '커피 마시고 싶어?',
      tip: 'Offer a simple option.',
      tags: _tags,
      slotTemplate: 'Do you want to {verbPhrase}?',
      slots: [
        PatternSlot(key: 'verbPhrase', hint: 'get coffee / go for a walk'),
      ],
    ),
    const Pattern(
      id: 'p2',
      title: 'Can we talk about __?',
      exampleEnglish: 'Can we talk about what happened earlier?',
      exampleKorean: '아까 있었던 일 얘기해도 될까?',
      tip: 'Use when you want a calm discussion.',
      tags: _tags,
      slotTemplate: 'Can we talk about {topic}?',
      slots: [PatternSlot(key: 'topic', hint: 'what happened earlier')],
    ),
    const Pattern(
      id: 'p3',
      title: 'I feel __ when __.',
      exampleEnglish: 'I feel anxious when we don’t reply for hours.',
      exampleKorean: '몇 시간씩 답이 없으면 불안해.',
      tip: 'Describe emotion + trigger.',
      tags: _tags,
      slotTemplate: 'I feel {emotion} when {situation}.',
      slots: [
        PatternSlot(key: 'emotion', hint: 'anxious / upset'),
        PatternSlot(key: 'situation', hint: 'we don’t reply for hours'),
      ],
    ),
  ];

  @override
  Future<List<Sentence>> getSentences() async => _sentences;

  @override
  Future<List<Sentence>> getCuratedSentences() async => _curated;

  @override
  Future<List<Pattern>> getPatterns() async => _patterns;
}

void main() {
  testWidgets(
    'Feature sanity: onboarding -> today -> detail -> tabs -> settings',
    (tester) async {
      TestWidgetsFlutterBinding.ensureInitialized();

      SharedPreferences.setMockInitialValues({
        'onboarding_completed': false,
        'install_date_iso': DateTime.now().toIso8601String(),
      });

      final prefs = await SharedPreferences.getInstance();
      final cache = MemoryCache();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            fileCacheProvider.overrideWithValue(cache),
            contentRepositoryProvider.overrideWithValue(
              ContentRepository(_FakeContentStore()),
            ),
          ],
          child: const App(),
        ),
      );

      await _pumpUntilFound(tester, find.text('건너뛰기'));
      await tester.tap(find.text('건너뛰기'));
      await _pumpUntilFound(tester, find.textContaining('오늘 바로 써먹는 문장과 패턴으로'));

      await _pumpUntilFound(
        tester,
        find.text('추가 추천 2개'),
        maxTries: 300,
        failFastFinder: find.text('데이터 로딩 실패'),
      );
      expect(find.text('오늘의 패턴 3개'), findsOneWidget);

      final conflictChip = find.widgetWithText(ChoiceChip, '🧩 갈등');
      expect(conflictChip, findsOneWidget);
      await tester.tap(conflictChip);
      await tester.pump(const Duration(milliseconds: 200));

      await _pumpUntilFound(tester, find.byType(AppCard));
      await tester.tap(find.byType(AppCard).first);
      await _pumpUntilFound(tester, find.text('문장'));
      expect(find.textContaining('Do you want to'), findsWidgets);

      await _popRoute(tester);
      await _pumpUntilFound(tester, find.textContaining('오늘 바로 써먹는 문장과 패턴으로'));

      final todayContext = tester.element(find.byType(Scaffold).first);
      GoRouter.of(todayContext).push('/pattern');
      await tester.pump(const Duration(milliseconds: 250));
      await _pumpUntilFound(tester, find.text('패턴 연습'));
      await _popRoute(tester);
      await _pumpUntilFound(tester, find.text('추가 추천 2개'));

      final appContext = tester.element(find.byType(Scaffold).first);
      GoRouter.of(appContext).go('/explore');
      await tester.pump(const Duration(milliseconds: 200));
      await _pumpUntilFound(tester, find.text('상황 탐색'));

      GoRouter.of(appContext).go('/my');
      await tester.pump(const Duration(milliseconds: 200));
      await _pumpUntilFound(tester, find.text('내 라이브러리'));

      await tester.tap(find.byIcon(Icons.settings).first);
      await _pumpUntilFound(tester, find.text('설정'));
      expect(find.text('광고/개인정보(UMP)'), findsOneWidget);
    },
  );
}
