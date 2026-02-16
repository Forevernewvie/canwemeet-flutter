import 'package:flutter/foundation.dart';

class AdEnv {
  const AdEnv._();

  /// Prefer test ads in debug/profile unless explicitly overridden.
  static const bool useTestAds = bool.fromEnvironment(
    'ADMOB_USE_TEST_ADS',
    defaultValue: kDebugMode || kProfileMode,
  );
}
