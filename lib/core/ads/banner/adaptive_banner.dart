import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../ad_unit_ids.dart';
import '../ads_service.dart';
import '../../support/app_logger.dart';

class AdaptiveBannerAd extends ConsumerStatefulWidget {
  const AdaptiveBannerAd({super.key});

  @override
  ConsumerState<AdaptiveBannerAd> createState() => _AdaptiveBannerAdState();
}

class _AdaptiveBannerAdState extends ConsumerState<AdaptiveBannerAd> {
  BannerAd? _ad;
  AdSize? _adSize;
  bool _isLoading = false;

  @override
  void dispose() {
    _disposeAd();
    super.dispose();
  }

  void _disposeAd() {
    _ad?.dispose();
    _ad = null;
    _adSize = null;
    _isLoading = false;
  }

  Future<void> _loadIfNeeded() async {
    if (_isLoading) return;
    if (_ad != null) return;

    final adUnitId = ref.read(adUnitIdResolverProvider).banner();
    if (adUnitId.isEmpty) return;

    _isLoading = true;
    final logger = ref.read(appLoggerProvider);

    await ref.read(adsServiceProvider).ensureInitialized();
    if (!mounted) return;

    final width = MediaQuery.sizeOf(context).width.truncate();
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      width,
    );
    if (!mounted) return;
    if (size == null) {
      _isLoading = false;
      logger.warning(
        AppLogCategory.ads,
        'Adaptive banner size is unavailable for current orientation.',
      );
      return;
    }

    final banner = BannerAd(
      adUnitId: adUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _ad = ad as BannerAd;
            _adSize = size;
            _isLoading = false;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          logger.error(
            AppLogCategory.ads,
            'Banner load failed (${error.code}): ${error.message}',
          );
          if (!mounted) return;
          setState(() {
            _ad = null;
            _adSize = null;
            _isLoading = false;
          });
        },
      ),
    );

    await banner.load();
  }

  @override
  Widget build(BuildContext context) {
    final adsEnabled = ref.watch(adsEnabledProvider);
    if (!adsEnabled) {
      _disposeAd();
      return const SizedBox.shrink();
    }

    // Defer loading so we don't call async work during build.
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadIfNeeded());

    final ad = _ad;
    final size = _adSize;
    if (ad == null || size == null) {
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      width: size.width.toDouble(),
      height: size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }
}
