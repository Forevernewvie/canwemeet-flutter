import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ourmatchwell_flutter/app/app.dart';
import 'package:ourmatchwell_flutter/core/persistence/file_cache.dart';
import 'package:ourmatchwell_flutter/core/persistence/preferences_store.dart';

void main() {
  testWidgets('Onboarding skip completes onboarding and routes to Today', (
    tester,
  ) async {
    TestWidgetsFlutterBinding.ensureInitialized();

    SharedPreferences.setMockInitialValues({'onboarding_completed': false});
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
      if (find.text('건너뛰기').evaluate().isNotEmpty) {
        break;
      }
    }

    expect(find.text('건너뛰기'), findsOneWidget);

    await tester.tap(find.text('건너뛰기'));
    for (var i = 0; i < 50; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (find
          .textContaining('오늘 바로 써먹는 문장과 패턴으로')
          .evaluate()
          .isNotEmpty) {
        break;
      }
    }

    expect(prefs.getBool('onboarding_completed'), true);
    expect(find.textContaining('오늘 바로 써먹는 문장과 패턴으로'), findsOneWidget);
  });
}
