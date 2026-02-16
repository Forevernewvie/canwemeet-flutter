import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

import 'ad_env.dart';

class AdUnitIds {
  const AdUnitIds._();

  // Official Google-provided test ad units.
  static const String _testBannerAndroid =
      'ca-app-pub-3940256099942544/6300978111';

  static const String _testBannerIos = 'ca-app-pub-3940256099942544/2934735716';

  // Production ad unit IDs are not secrets. Keeping them as defaults prevents
  // accidental "no-ads" releases when dart-define is missing.
  static const String _prodBannerAndroid =
      'ca-app-pub-9780094598585299/6706144880';

  static String banner() => Platform.isAndroid ? bannerAndroid() : bannerIos();

  static String bannerAndroid() => _resolve(
    prodKey: 'ADMOB_BANNER_ID_ANDROID',
    testId: _testBannerAndroid,
    defaultProd: _prodBannerAndroid,
  );

  static String bannerIos() => _resolve(
    prodKey: 'ADMOB_BANNER_ID_IOS',
    testId: _testBannerIos,
    defaultProd: '',
  );

  static String _resolve({
    required String prodKey,
    required String testId,
    required String defaultProd,
  }) {
    if (AdEnv.useTestAds) return testId;

    final prod = String.fromEnvironment(
      prodKey,
      defaultValue: defaultProd,
    ).trim();
    if (prod.isNotEmpty) return prod;

    // Fail-safe: do not show ads if prod IDs are missing. (Better than shipping
    // test ads or crashing on load in release builds.)
    if (kDebugMode) {
      debugPrint(
        '[ads] Missing $prodKey. Provide it via --dart-define or enable test ads '
        '(--dart-define=ADMOB_USE_TEST_ADS=true).',
      );
    }
    return '';
  }
}
