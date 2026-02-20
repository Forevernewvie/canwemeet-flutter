import 'dart:io' show Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../support/app_logger.dart';
import '../support/runtime_config.dart';

/// Supported ad-serving platforms.
enum AppAdPlatform { android, ios, unsupported }

/// Abstraction for platform detection to keep resolver unit-testable.
abstract interface class AppPlatformDetector {
  /// Returns the currently running platform.
  AppAdPlatform current();
}

/// Default platform detector backed by `dart:io` platform flags.
final class IoAppPlatformDetector implements AppPlatformDetector {
  const IoAppPlatformDetector();

  @override
  AppAdPlatform current() {
    if (Platform.isAndroid) return AppAdPlatform.android;
    if (Platform.isIOS) return AppAdPlatform.ios;
    return AppAdPlatform.unsupported;
  }
}

/// Ad unit ID resolver contract.
abstract interface class AdUnitIdResolver {
  /// Resolves a banner ad unit ID for the current platform.
  String banner();
}

/// Production resolver combining runtime config, platform, and safety checks.
final class DefaultAdUnitIdResolver implements AdUnitIdResolver {
  const DefaultAdUnitIdResolver({
    required RuntimeConfigValues config,
    required AppPlatformDetector platformDetector,
    required AppLogger logger,
  }) : _config = config,
       _platformDetector = platformDetector,
       _logger = logger;

  static const String _testBannerAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _testBannerIos = 'ca-app-pub-3940256099942544/2934735716';

  final RuntimeConfigValues _config;
  final AppPlatformDetector _platformDetector;
  final AppLogger _logger;

  @override
  String banner() {
    final platform = _platformDetector.current();
    if (_config.adMobUseTestAds) {
      return switch (platform) {
        AppAdPlatform.android => _testBannerAndroid,
        AppAdPlatform.ios => _testBannerIos,
        AppAdPlatform.unsupported => '',
      };
    }

    return switch (platform) {
      AppAdPlatform.android => _resolveProduction(
        configured: _config.adMobBannerIdAndroid,
        fallback: '',
        platformName: 'android',
      ),
      AppAdPlatform.ios => _resolveProduction(
        configured: _config.adMobBannerIdIos,
        fallback: '',
        platformName: 'ios',
      ),
      AppAdPlatform.unsupported => '',
    };
  }

  /// Resolves production ad unit safely; empty string disables ad loading.
  String _resolveProduction({
    required String configured,
    required String fallback,
    required String platformName,
  }) {
    final value = configured.trim().isNotEmpty ? configured.trim() : fallback;
    if (value.isNotEmpty) {
      return value;
    }

    _logger.warning(
      AppLogCategory.ads,
      'Missing production banner ID for $platformName; banner ad is disabled.',
    );
    return '';
  }
}

/// Provider for the application platform detector.
final appPlatformDetectorProvider = Provider<AppPlatformDetector>((ref) {
  return const IoAppPlatformDetector();
});

/// Provider for banner ad unit resolution.
final adUnitIdResolverProvider = Provider<AdUnitIdResolver>((ref) {
  final config = ref.watch(runtimeConfigValuesProvider);
  final platformDetector = ref.watch(appPlatformDetectorProvider);
  final logger = ref.watch(appLoggerProvider);
  return DefaultAdUnitIdResolver(
    config: config,
    platformDetector: platformDetector,
    logger: logger,
  );
});
