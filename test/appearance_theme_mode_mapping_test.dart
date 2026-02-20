import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ourmatchwell_flutter/app/app.dart';
import 'package:ourmatchwell_flutter/core/persistence/preferences_store.dart';

void main() {
  test('appearance mode maps to expected theme mode', () {
    expect(
      mapAppearanceModeToThemeMode(AppearanceMode.system),
      ThemeMode.system,
    );
    expect(mapAppearanceModeToThemeMode(AppearanceMode.light), ThemeMode.light);
    expect(mapAppearanceModeToThemeMode(AppearanceMode.dark), ThemeMode.dark);
  });
}
