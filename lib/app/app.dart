import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ads_bootstrapper.dart';
import 'review_reminder_bootstrapper.dart';
import 'router.dart';
import 'theme.dart';

/// Application root that wires routing, theme, and bootstrap side effects.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  /// Builds `MaterialApp.router` and attaches runtime bootstrappers.
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: '우리 제법 잘 어울려',
      theme: buildAppTheme(),
      routerConfig: router,
      builder: (context, child) {
        final content = child ?? const SizedBox.shrink();
        return ReviewReminderBootstrapper(
          child: AdsBootstrapper(child: content),
        );
      },
    );
  }
}
