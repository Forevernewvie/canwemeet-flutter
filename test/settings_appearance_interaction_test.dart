import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ourmatchwell_flutter/app/app.dart';
import 'package:ourmatchwell_flutter/core/persistence/file_cache.dart';
import 'package:ourmatchwell_flutter/core/persistence/preferences_store.dart';

Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  int maxTries = 120,
  Duration step = const Duration(milliseconds: 100),
}) async {
  for (var i = 0; i < maxTries; i++) {
    await tester.pump(step);
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }
  throw TestFailure('Timeout waiting for: $finder');
}

ThemeMode? _currentThemeMode(WidgetTester tester) {
  final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
  return app.themeMode;
}

void main() {
  testWidgets('settings appearance selection updates app theme mode', (
    tester,
  ) async {
    TestWidgetsFlutterBinding.ensureInitialized();

    SharedPreferences.setMockInitialValues(<String, Object>{
      'onboarding_completed': true,
      'install_date_iso': DateTime(2026, 2, 14).toIso8601String(),
      'appearance_mode': 'system',
    });

    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        fileCacheProvider.overrideWithValue(MemoryCache()),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );

    await _pumpUntilFound(tester, find.byType(Scaffold));

    final context = tester.element(find.byType(Scaffold).first);
    GoRouter.of(context).go('/my/settings');
    await tester.pump(const Duration(milliseconds: 250));

    await _pumpUntilFound(tester, find.text('Appearance'));
    expect(_currentThemeMode(tester), ThemeMode.system);

    final segmented = find.byWidgetPredicate(
      (widget) => widget is SegmentedButton<AppearanceMode>,
    );
    expect(segmented, findsOneWidget);

    await tester.tap(
      find.descendant(of: segmented, matching: find.text('Dark')).last,
    );
    await tester.pumpAndSettle();

    expect(
      container.read(preferencesStoreProvider).appearanceMode,
      AppearanceMode.dark,
    );
    expect(_currentThemeMode(tester), ThemeMode.dark);

    await tester.tap(
      find.descendant(of: segmented, matching: find.text('Light')).last,
    );
    await tester.pumpAndSettle();

    expect(
      container.read(preferencesStoreProvider).appearanceMode,
      AppearanceMode.light,
    );
    expect(_currentThemeMode(tester), ThemeMode.light);
  });
}
