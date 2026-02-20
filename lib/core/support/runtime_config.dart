import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Keys supported in dart-define runtime configuration.
enum RuntimeConfigKey {
  adMobUseTestAds,
  adMobBannerIdAndroid,
  adMobBannerIdIos,
}

/// Immutable configuration values consumed by runtime services.
@immutable
class RuntimeConfigValues {
  const RuntimeConfigValues({
    required this.adMobUseTestAds,
    required this.adMobBannerIdAndroid,
    required this.adMobBannerIdIos,
  });

  final bool adMobUseTestAds;
  final String adMobBannerIdAndroid;
  final String adMobBannerIdIos;
}

/// Configuration source abstraction to separate environment access from logic.
abstract interface class RuntimeConfigReader {
  /// Reads all supported configuration values.
  RuntimeConfigValues read();
}

/// Production reader backed by dart-define compile-time environment values.
final class DartDefineRuntimeConfigReader implements RuntimeConfigReader {
  const DartDefineRuntimeConfigReader();

  static const bool _defaultUseTestAds = kDebugMode || kProfileMode;

  @override
  RuntimeConfigValues read() {
    return RuntimeConfigValues(
      adMobUseTestAds: const bool.fromEnvironment(
        'ADMOB_USE_TEST_ADS',
        defaultValue: _defaultUseTestAds,
      ),
      adMobBannerIdAndroid: const String.fromEnvironment(
        'ADMOB_BANNER_ID_ANDROID',
        defaultValue: '',
      ),
      adMobBannerIdIos: const String.fromEnvironment(
        'ADMOB_BANNER_ID_IOS',
        defaultValue: '',
      ),
    );
  }
}

/// Provides runtime config reader dependency.
final runtimeConfigReaderProvider = Provider<RuntimeConfigReader>((ref) {
  return const DartDefineRuntimeConfigReader();
});

/// Provides runtime config values as a simple immutable object.
final runtimeConfigValuesProvider = Provider<RuntimeConfigValues>((ref) {
  final reader = ref.watch(runtimeConfigReaderProvider);
  return reader.read();
});
