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

  test(
    'Curated recommendation stays available as a free MVP feature',
    () async {
      final install = DateTime(2026, 1, 1);
      final day6 = DateTime(2026, 1, 7);
      final day30 = DateTime(2026, 1, 31);

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

      final early = await usecase.getTodayPack(date: day6, scenarioTag: 'date');
      expect(early.isCuratedLocked, isFalse);
      expect(early.curatedSentence, isNotNull);

      final later = await usecase.getTodayPack(
        date: day30,
        scenarioTag: 'date',
      );
      expect(later.isCuratedLocked, isFalse);
      expect(later.curatedSentence, isNotNull);
    },
  );
}
