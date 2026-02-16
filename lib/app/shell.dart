import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/ads/ads_service.dart';
import '../core/ads/banner/adaptive_banner.dart';

class RootShell extends ConsumerWidget {
  const RootShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adsEnabled = ref.watch(adsEnabledProvider);
    final showBanner = adsEnabled && navigationShell.currentIndex != 2;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showBanner) const AdaptiveBannerAd(),
            NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.wb_sunny_outlined),
                  label: '오늘',
                ),
                NavigationDestination(
                  icon: Icon(Icons.travel_explore_outlined),
                  label: '탐색',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  label: '라이브러리',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
