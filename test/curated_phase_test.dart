import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ourmatchwell_flutter/core/content/content_repository.dart';
import 'package:ourmatchwell_flutter/core/content/content_store.dart';
import 'package:ourmatchwell_flutter/core/content/manifest_client.dart';
import 'package:ourmatchwell_flutter/core/persistence/file_cache.dart';
import 'package:ourmatchwell_flutter/core/persistence/preferences_store.dart';
import 'package:ourmatchwell_flutter/domain/usecases/today_pack_usecase.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test('Curated is unlocked for first 7 days, then locks', () async {
    final install = DateTime(2026, 1, 1);
    final day6 = DateTime(2026, 1, 7);
    final day7 = DateTime(2026, 1, 8);

    SharedPreferences.setMockInitialValues({
      'install_date_iso': install.toIso8601String(),
      'onboarding_completed': true,
    });
    final prefs = await SharedPreferences.getInstance();

    final store = ContentStore(
      fileCache: MemoryCache(),
      manifestClient: const ManifestClient(),
    );
    final repo = ContentRepository(store);

    final prefsStore = PreferencesStore(prefs);
    final usecase = TodayPackUseCase(repo: repo, prefs: prefsStore);

    final inTrial = await usecase.getTodayPack(date: day6, scenarioTag: 'date');
    expect(inTrial.isCuratedLocked, isFalse);
    expect(inTrial.curatedSentence, isNotNull);

    final afterTrial = await usecase.getTodayPack(
      date: day7,
      scenarioTag: 'date',
    );
    expect(afterTrial.isCuratedLocked, isTrue);
    expect(afterTrial.curatedSentence, isNull);
  });
}
