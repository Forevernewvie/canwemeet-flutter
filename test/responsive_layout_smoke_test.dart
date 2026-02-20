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

Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  int maxTries = 120,
  Duration step = const Duration(milliseconds: 100),
}) async {
  for (var i = 0; i < maxTries; i++) {
    await tester.pump(step);
    if (finder.evaluate().isNotEmpty) return;
  }
  throw TestFailure('Timeout waiting for: $finder');
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

Future<void> _runScenario({
  required WidgetTester tester,
  required Size logicalSize,
}) async {
  tester.view.devicePixelRatio = 3.0;
  tester.view.physicalSize = logicalSize * 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  SharedPreferences.setMockInitialValues({
    'onboarding_completed': true,
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

  // Initial route is onboarding; if it appears, skip and continue to Today.
  await tester.pump(const Duration(milliseconds: 300));
  final skipFinder = find.text('건너뛰기');
  if (skipFinder.evaluate().isNotEmpty) {
    await tester.tap(skipFinder);
    await tester.pump(const Duration(milliseconds: 250));
  }

  await _pumpUntilFound(tester, find.text('우리 제법 잘 어울려'));
  expect(tester.takeException(), isNull);

  final context = tester.element(find.byType(Scaffold).first);
  GoRouter.of(context).go('/explore');
  await _pumpUntilFound(tester, find.text('상황 탐색'));
  expect(tester.takeException(), isNull);

  GoRouter.of(context).go('/my');
  await _pumpUntilFound(tester, find.text('내 라이브러리'));
  expect(tester.takeException(), isNull);

  await tester.tap(find.byIcon(Icons.settings).first);
  await _pumpUntilFound(tester, find.text('설정'));
  expect(tester.takeException(), isNull);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('responsive smoke on galaxy-like sizes', (tester) async {
    await _runScenario(tester: tester, logicalSize: const Size(412, 915));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));

    await _runScenario(tester: tester, logicalSize: const Size(360, 800));
  });
}
