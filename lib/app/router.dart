import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/persistence/preferences_store.dart';
import '../core/premium/entitlement_manager.dart';
import '../features/ai_conversation/ai_conversation_view.dart';
import '../features/explore/explore_view.dart';
import '../features/my_library/my_library_view.dart';
import '../features/onboarding/onboarding_view.dart';
import '../features/pattern_practice/pattern_practice_view.dart';
import '../features/sentence_detail/sentence_detail_view.dart';
import '../features/settings/settings_view.dart';
import '../features/today/today_view.dart';
import 'shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final prefs = ref.read(preferencesStoreProvider);
  final entitlements = ref.read(entitlementManagerProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/today',
    refreshListenable: Listenable.merge([prefs, entitlements]),
    redirect: (context, state) {
      final onboardingCompleted = prefs.onboardingCompleted;
      final isOnboarding = state.matchedLocation == '/onboarding';

      if (!onboardingCompleted && !isOnboarding) {
        return '/onboarding';
      }
      if (onboardingCompleted && isOnboarding) {
        return '/today';
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingView(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            RootShell(navigationShell: navigationShell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/today',
                builder: (context, state) => const TodayView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/explore',
                builder: (context, state) => const ExploreView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/my',
                builder: (context, state) => const MyLibraryView(),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const SettingsView(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/sentence/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return SentenceDetailView(sentenceId: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/pattern',
        builder: (context, state) => const PatternPracticeView(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/ai',
        pageBuilder: (context, state) {
          return const MaterialPage<void>(
            fullscreenDialog: true,
            child: AIConversationView(),
          );
        },
      ),
    ],
  );
});
