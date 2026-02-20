import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ourmatchwell_flutter/core/persistence/isar/isar_persistence_engine.dart';
import 'package:ourmatchwell_flutter/core/persistence/preferences_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('appearance mode defaults to system', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'onboarding_completed': true,
      'install_date_iso': DateTime(2026, 2, 14).toIso8601String(),
    });
    final prefs = await SharedPreferences.getInstance();
    final store = PreferencesStore(
      prefs,
      isarEngine: IsarPersistenceEngine(forceEnabled: false),
    );

    expect(store.appearanceMode, AppearanceMode.system);
  });

  test('appearance mode persists across store recreation', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'onboarding_completed': true,
      'install_date_iso': DateTime(2026, 2, 14).toIso8601String(),
    });
    final prefs = await SharedPreferences.getInstance();

    final first = PreferencesStore(
      prefs,
      isarEngine: IsarPersistenceEngine(forceEnabled: false),
    );
    first.setAppearanceMode(AppearanceMode.dark);

    final second = PreferencesStore(
      prefs,
      isarEngine: IsarPersistenceEngine(forceEnabled: false),
    );

    expect(second.appearanceMode, AppearanceMode.dark);
  });
}
