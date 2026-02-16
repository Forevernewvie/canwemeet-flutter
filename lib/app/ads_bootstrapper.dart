import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/ads/ads_service.dart';
import '../core/ads/consent/consent_controller.dart';

class AdsBootstrapper extends ConsumerStatefulWidget {
  const AdsBootstrapper({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<AdsBootstrapper> createState() => _AdsBootstrapperState();
}

class _AdsBootstrapperState extends ConsumerState<AdsBootstrapper> {
  ProviderSubscription<ConsentState>? _consentSub;

  @override
  void initState() {
    super.initState();

    // Ensure the activity is ready before UMP tries to present UI on Android.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adsServiceProvider).ensureInitialized();
    });

    _consentSub = ref.listenManual<ConsentState>(consentControllerProvider, (
      prev,
      next,
    ) {
      final prevCanRequestAds = prev?.canRequestAds ?? false;
      if (!prevCanRequestAds && next.canRequestAds) {
        ref.read(adsServiceProvider).ensureInitialized();
      }
    });
  }

  @override
  void dispose() {
    _consentSub?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
