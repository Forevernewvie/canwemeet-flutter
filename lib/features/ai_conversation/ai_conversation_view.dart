import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/premium/entitlement_manager.dart';

class AIConversationView extends ConsumerWidget {
  const AIConversationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entitlements = ref.watch(entitlementManagerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Conversation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: entitlements.isPremium
            ? const Center(child: Text('AI chat placeholder (premium)'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '프리미엄 기능',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('추천 문장으로 말했을 때 상대의 답변 + 후속 질문을 시뮬레이션해요.'),
                  const Spacer(),
                  FilledButton(
                    onPressed: () => entitlements.purchasePremium(),
                    child: const Text('프리미엄 시작하기 (stub)'),
                  ),
                ],
              ),
      ),
    );
  }
}
