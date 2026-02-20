import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/persistence/preferences_store.dart';
import 'ads_bootstrapper.dart';
import 'review_reminder_bootstrapper.dart';
import 'router.dart';
import 'theme.dart';

/// Maps persisted appearance preference to Flutter ThemeMode.
ThemeMode mapAppearanceModeToThemeMode(AppearanceMode mode) {
  return switch (mode) {
    AppearanceMode.light => ThemeMode.light,
    AppearanceMode.dark => ThemeMode.dark,
    AppearanceMode.system => ThemeMode.system,
  };
}

/// Application root that wires routing, theme, and bootstrap side effects.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  /// Builds `MaterialApp.router` and attaches runtime bootstrappers.
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final prefs = ref.watch(preferencesStoreProvider);

    return MaterialApp.router(
      title: '우리 제법 잘 어울려',
      theme: buildAppTheme(),
      darkTheme: buildAppDarkTheme(),
      themeMode: mapAppearanceModeToThemeMode(prefs.appearanceMode),
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
