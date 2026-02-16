import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'consent/consent_controller.dart';

final adsServiceProvider = Provider<AdsService>((ref) => AdsService(ref));

final adsEnabledProvider = Provider<bool>((ref) {
  final consent = ref.watch(consentControllerProvider);
  return consent.canRequestAds;
});

class AdsService {
  AdsService(this._ref);

  final Ref _ref;

  bool _sdkInitialized = false;
  Future<void>? _initFuture;

  bool get isSdkInitialized => _sdkInitialized;

  Future<void> ensureInitialized() {
    if (_sdkInitialized) return Future.value();

    _initFuture ??= _doInit();
    // If consent blocks initialization, allow future retries.
    return _initFuture!.whenComplete(() {
      if (!_sdkInitialized) _initFuture = null;
    });
  }

  Future<void> _doInit() async {
    // 1) Gather consent first (required for policy compliance).
    await _ref.read(consentControllerProvider.notifier).gatherConsent();
    final consent = _ref.read(consentControllerProvider);
    if (!consent.canRequestAds) {
      if (kDebugMode) {
        debugPrint(
          '[ads] Consent not granted or not ready. Skip MobileAds init.',
        );
      }
      return;
    }

    // 2) Initialize Mobile Ads SDK after consent is granted / not required.
    await MobileAds.instance.initialize();

    _sdkInitialized = true;
  }
}
