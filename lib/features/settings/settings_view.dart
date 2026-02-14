import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/premium/entitlement_manager.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entitlements = ref.watch(entitlementManagerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('설정/구독')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('프리미엄 상태'),
            subtitle: Text(entitlements.isPremium ? 'Premium 활성화됨' : 'Premium 비활성화'),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () => entitlements.purchasePremium(),
            child: const Text('프리미엄 구매 (stub)'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => entitlements.restore(),
            child: const Text('구매 복구 (stub)'),
          ),
        ],
      ),
    );
  }
}
