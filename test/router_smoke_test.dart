import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ourmatchwell_flutter/app/app.dart';
import 'package:ourmatchwell_flutter/core/persistence/file_cache.dart';
import 'package:ourmatchwell_flutter/core/persistence/preferences_store.dart';

void main() {
  testWidgets('Deep-link to sentence detail works', (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();

    SharedPreferences.setMockInitialValues({
      'onboarding_completed': true,
    });
    final prefs = await SharedPreferences.getInstance();
    final cache = MemoryCache();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          fileCacheProvider.overrideWithValue(cache),
        ],
        child: const App(),
      ),
    );

    // Avoid pumpAndSettle: TodayView shows an indeterminate progress indicator.
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (find.byType(Scaffold).evaluate().isNotEmpty) break;
    }

    // Navigate using GoRouter from an element inside the app tree.
    final ctx = tester.element(find.byType(Scaffold).first);
    GoRouter.of(ctx).go('/sentence/s0001');

    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (find.textContaining('Sentence ID: s0001').evaluate().isNotEmpty) break;
    }

    expect(find.textContaining('Sentence ID: s0001'), findsOneWidget);
  });
}
