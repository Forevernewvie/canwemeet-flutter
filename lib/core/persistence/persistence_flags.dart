import 'dart:io';

/// Global feature flag for Isar persistence.
///
/// Set `--dart-define=USE_ISAR_PERSISTENCE=false` to force legacy mode.
bool get useIsarPersistence {
  const enabled = bool.fromEnvironment(
    'USE_ISAR_PERSISTENCE',
    defaultValue: true,
  );
  if (!enabled) return false;
  // Keep tests deterministic and independent from local Isar runtime setup.
  return !Platform.environment.containsKey('FLUTTER_TEST');
}
