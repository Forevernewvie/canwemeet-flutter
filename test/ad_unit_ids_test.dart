import 'package:flutter_test/flutter_test.dart';

import 'package:ourmatchwell_flutter/core/ads/ad_unit_ids.dart';
import 'package:ourmatchwell_flutter/core/support/app_logger.dart';
import 'package:ourmatchwell_flutter/core/support/runtime_config.dart';

void main() {
  group('DefaultAdUnitIdResolver', () {
    test('returns official test banner for Android when test ads enabled', () {
      final resolver = DefaultAdUnitIdResolver(
        config: const RuntimeConfigValues(
          adMobUseTestAds: true,
          adMobBannerIdAndroid: '',
          adMobBannerIdIos: '',
        ),
        platformDetector: const _FixedPlatformDetector(AppAdPlatform.android),
        logger: _FakeLogger(),
      );

      expect(
        resolver.banner(),
        equals('ca-app-pub-3940256099942544/6300978111'),
      );
    });

    test('returns configured production banner for Android', () {
      final resolver = DefaultAdUnitIdResolver(
        config: const RuntimeConfigValues(
          adMobUseTestAds: false,
          adMobBannerIdAndroid: 'ca-app-pub-prod/android',
          adMobBannerIdIos: '',
        ),
        platformDetector: const _FixedPlatformDetector(AppAdPlatform.android),
        logger: _FakeLogger(),
      );

      expect(resolver.banner(), equals('ca-app-pub-prod/android'));
    });

    test('returns empty ID when Android production config is empty', () {
      final resolver = DefaultAdUnitIdResolver(
        config: const RuntimeConfigValues(
          adMobUseTestAds: false,
          adMobBannerIdAndroid: '',
          adMobBannerIdIos: '',
        ),
        platformDetector: const _FixedPlatformDetector(AppAdPlatform.android),
        logger: _FakeLogger(),
      );

      expect(resolver.banner(), isEmpty);
    });

    test('returns empty ID for iOS production when ID is missing', () {
      final resolver = DefaultAdUnitIdResolver(
        config: const RuntimeConfigValues(
          adMobUseTestAds: false,
          adMobBannerIdAndroid: '',
          adMobBannerIdIos: '',
        ),
        platformDetector: const _FixedPlatformDetector(AppAdPlatform.ios),
        logger: _FakeLogger(),
      );

      expect(resolver.banner(), isEmpty);
    });

    test('returns empty ID for unsupported platform', () {
      final resolver = DefaultAdUnitIdResolver(
        config: const RuntimeConfigValues(
          adMobUseTestAds: false,
          adMobBannerIdAndroid: 'ca-app-pub-prod/android',
          adMobBannerIdIos: 'ca-app-pub-prod/ios',
        ),
        platformDetector: const _FixedPlatformDetector(
          AppAdPlatform.unsupported,
        ),
        logger: _FakeLogger(),
      );

      expect(resolver.banner(), isEmpty);
    });
  });
}

class _FixedPlatformDetector implements AppPlatformDetector {
  const _FixedPlatformDetector(this._platform);

  final AppAdPlatform _platform;

  @override
  AppAdPlatform current() => _platform;
}

class _FakeLogger extends AppLogger {
  @override
  void log({
    required AppLogLevel level,
    required AppLogCategory category,
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) {}
}
