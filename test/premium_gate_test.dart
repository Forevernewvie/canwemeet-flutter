import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ourmatchwell_flutter/core/premium/entitlement_manager.dart';
import 'package:ourmatchwell_flutter/features/ai_conversation/ai_conversation_view.dart';

void main() {
  testWidgets('AIConversation shows paywall content when not premium', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Default is non-premium.
    container.read(entitlementManagerProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: AIConversationView()),
      ),
    );

    expect(find.text('프리미엄 기능'), findsOneWidget);
  });

  testWidgets('AIConversation shows chat placeholder when premium', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(entitlementManagerProvider).setPremiumForDebug(true);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: AIConversationView()),
      ),
    );

    expect(find.textContaining('AI chat placeholder'), findsOneWidget);
  });
}
