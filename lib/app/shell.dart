import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RootShell extends StatelessWidget {
  const RootShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.wb_sunny_outlined), label: 'Today'),
          NavigationDestination(icon: Icon(Icons.search_outlined), label: 'Explore'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'My'),
        ],
      ),
    );
  }
}
