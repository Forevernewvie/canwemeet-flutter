import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ourmatchwell_flutter/core/content/content_repository.dart';
import 'package:ourmatchwell_flutter/core/content/content_store.dart';
import 'package:ourmatchwell_flutter/core/content/manifest_client.dart';
import 'package:ourmatchwell_flutter/core/persistence/file_cache.dart';
import 'package:ourmatchwell_flutter/core/persistence/preferences_store.dart';
import 'package:ourmatchwell_flutter/core/premium/entitlement_manager.dart';
import 'package:ourmatchwell_flutter/core/premium/iap_service.dart';
import 'package:ourmatchwell_flutter/domain/usecases/today_pack_usecase.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test('Today selection is deterministic for date+scenario', () async {
    final install = DateTime(2026, 2, 14);
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
    final entitlements = EntitlementManager(const IapService());

    final usecase = TodayPackUseCase(repo: repo, prefs: prefsStore, entitlements: entitlements);

    final a = await usecase.getTodayPack(date: install, scenarioTag: 'date');
    final b = await usecase.getTodayPack(date: install, scenarioTag: 'date');

    expect(a.curatedSentence?.id, b.curatedSentence?.id);
    expect(a.extraSentences.map((e) => e.id).toList(), b.extraSentences.map((e) => e.id).toList());
    expect(a.patterns.map((e) => e.id).toList(), b.patterns.map((e) => e.id).toList());
  });
}
