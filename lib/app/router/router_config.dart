import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'advanced_router.dart';
import 'deep_linking.dart';
import 'navigation_service.dart';
import 'routes.dart';
import 'route_transitions.dart';
import '../../features/loading/loading.dart';
import '../../features/home/home.dart';
import '../../features/setup/setup.dart';
import '../../features/game/game.dart';
import '../../features/store/store.dart';
import '../../features/profile/profile.dart';
import '../../features/settings/settings.dart';

/// Comprehensive router configuration for the Tic Tac Toe XO Royale app
/// Integrates all advanced features: ShellRoute, deep linking, navigation state, etc.
class RouterConfig {
  /// Create the main router configuration
  static GoRouter createRouter(Ref ref) {
    return GoRouter(
      initialLocation: AppRoutes.loading,
      navigatorKey: AdvancedRouter.rootNavigatorKey,
      debugLogDiagnostics: true,
      routes: _buildMainRoutes(),
      redirect: _handleRedirects,
      errorBuilder: _buildErrorScreen,
      redirectLimit: 5,
      refreshListenable: _RouterRefreshStream(ref),
    );
  }

  /// Build main routes with ShellRoute structure
  static List<RouteBase> _buildMainRoutes() {
    return [
      // Loading route (outside shell)
      GoRoute(
        path: AppRoutes.loading,
        name: AppRoutes.loadingName,
        parentNavigatorKey: AdvancedRouter.rootNavigatorKey,
        builder: (context, state) => const LoadingScreen(),
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoadingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return AppRouteTransitions.fade(
              child: child,
            ).transitionsBuilder(context, animation, secondaryAnimation, child);
          },
        ),
      ),

      // Shell route for main app navigation
      ShellRoute(
        navigatorKey: AdvancedRouter.shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          // Home route
          GoRoute(
            path: AppRoutes.home,
            name: AppRoutes.homeName,
            parentNavigatorKey: AdvancedRouter.shellNavigatorKey,
            builder: (context, state) => const HomeScreen(),
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return AppRouteTransitions.fade(
                      child: child,
                    ).transitionsBuilder(
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    );
                  },
            ),
          ),

          // Game setup route
          GoRoute(
            path: AppRoutes.setup,
            name: AppRoutes.setupName,
            parentNavigatorKey: AdvancedRouter.shellNavigatorKey,
            builder: (context, state) {
              final queryParams = state.uri.queryParameters;
              return SetupScreen(
                challengeId: queryParams['challengeId'],
                tournamentId: queryParams['tournamentId'],
                boardSize: int.tryParse(
                  queryParams[AppRoutes.boardSizeParam] ?? '',
                ),
                winCondition: int.tryParse(
                  queryParams[AppRoutes.winConditionParam] ?? '',
                ),
                gameMode: queryParams[AppRoutes.gameModeParam],
                difficulty: queryParams[AppRoutes.difficultyParam],
                player1: queryParams[AppRoutes.player1Param],
                player2: queryParams[AppRoutes.player2Param],
                firstMove: queryParams[AppRoutes.firstMoveParam],
              );
            },
            pageBuilder: (context, state) {
              final queryParams = state.uri.queryParameters;
              return CustomTransitionPage(
                key: state.pageKey,
                child: SetupScreen(
                  challengeId: queryParams['challengeId'],
                  tournamentId: queryParams['tournamentId'],
                  boardSize: int.tryParse(
                    queryParams[AppRoutes.boardSizeParam] ?? '',
                  ),
                  winCondition: int.tryParse(
                    queryParams[AppRoutes.winConditionParam] ?? '',
                  ),
                  gameMode: queryParams[AppRoutes.gameModeParam],
                  difficulty: queryParams[AppRoutes.difficultyParam],
                  player1: queryParams[AppRoutes.player1Param],
                  player2: queryParams[AppRoutes.player2Param],
                  firstMove: queryParams[AppRoutes.firstMoveParam],
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return AppRouteTransitions.sharedAxisVertical(
                        child: child,
                      ).transitionsBuilder(
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      );
                    },
              );
            },
          ),

          // Game route with parameters
          GoRoute(
            path: AppRoutes.game,
            name: AppRoutes.gameName,
            parentNavigatorKey: AdvancedRouter.shellNavigatorKey,
            builder: (context, state) {
              final queryParams = state.uri.queryParameters;
              return GameScreen(
                boardSize:
                    int.tryParse(
                      queryParams[AppRoutes.boardSizeParam] ?? '3',
                    ) ??
                    3,
                winCondition:
                    int.tryParse(
                      queryParams[AppRoutes.winConditionParam] ?? '3',
                    ) ??
                    3,
                player1Name: queryParams[AppRoutes.player1Param] ?? 'Player 1',
                player2Name: queryParams[AppRoutes.player2Param] ?? 'Player 2',
                isRobotMode: queryParams[AppRoutes.gameModeParam] == 'robot',
                difficulty: queryParams[AppRoutes.difficultyParam] ?? 'medium',
              );
            },
            pageBuilder: (context, state) {
              final queryParams = state.uri.queryParameters;
              return CustomTransitionPage(
                key: state.pageKey,
                child: GameScreen(
                  boardSize:
                      int.tryParse(
                        queryParams[AppRoutes.boardSizeParam] ?? '3',
                      ) ??
                      3,
                  winCondition:
                      int.tryParse(
                        queryParams[AppRoutes.winConditionParam] ?? '3',
                      ) ??
                      3,
                  player1Name:
                      queryParams[AppRoutes.player1Param] ?? 'Player 1',
                  player2Name:
                      queryParams[AppRoutes.player2Param] ?? 'Player 2',
                  isRobotMode: queryParams[AppRoutes.gameModeParam] == 'robot',
                  difficulty:
                      queryParams[AppRoutes.difficultyParam] ?? 'medium',
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return AppRouteTransitions.sharedAxisVertical(
                        child: child,
                      ).transitionsBuilder(
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      );
                    },
              );
            },
          ),

          // Store route
          GoRoute(
            path: AppRoutes.store,
            name: AppRoutes.storeName,
            parentNavigatorKey: AdvancedRouter.shellNavigatorKey,
            builder: (context, state) => const StoreScreen(),
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const StoreScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return AppRouteTransitions.sharedAxisHorizontal(
                      child: child,
                    ).transitionsBuilder(
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    );
                  },
            ),
          ),

          // Profile route
          GoRoute(
            path: AppRoutes.profile,
            name: AppRoutes.profileName,
            parentNavigatorKey: AdvancedRouter.shellNavigatorKey,
            builder: (context, state) => const ProfileScreen(),
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ProfileScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return AppRouteTransitions.sharedAxisHorizontal(
                      child: child,
                    ).transitionsBuilder(
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    );
                  },
            ),
          ),

          // Settings route
          GoRoute(
            path: AppRoutes.settings,
            name: AppRoutes.settingsName,
            parentNavigatorKey: AdvancedRouter.shellNavigatorKey,
            builder: (context, state) => const SettingsScreen(),
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const SettingsScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return AppRouteTransitions.sharedAxisHorizontal(
                      child: child,
                    ).transitionsBuilder(
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    );
                  },
            ),
          ),
        ],
      ),

      // Deep link routes (outside shell)
      GoRoute(
        path: '/game/:gameId',
        name: 'game-deep-link',
        parentNavigatorKey: AdvancedRouter.rootNavigatorKey,
        builder: (context, state) => const GameScreen(),
        redirect: (context, state) => AppRoutes.game,
      ),

      // Store item deep link
      GoRoute(
        path: '/store/:category/:itemId',
        name: 'store-item-deep-link',
        parentNavigatorKey: AdvancedRouter.rootNavigatorKey,
        builder: (context, state) => const StoreScreen(),
        redirect: (context, state) => AppRoutes.store,
      ),

      // Challenge deep link
      GoRoute(
        path: '/challenge/:challengeId',
        name: 'challenge-deep-link',
        parentNavigatorKey: AdvancedRouter.rootNavigatorKey,
        builder: (context, state) => const SetupScreen(),
        redirect: (context, state) => AppRoutes.setup,
      ),

      // Tournament deep link
      GoRoute(
        path: '/tournament/:tournamentId',
        name: 'tournament-deep-link',
        parentNavigatorKey: AdvancedRouter.rootNavigatorKey,
        builder: (context, state) => const SetupScreen(),
        redirect: (context, state) => AppRoutes.setup,
      ),

      // Profile deep link
      GoRoute(
        path: '/profile/:userId',
        name: 'profile-deep-link',
        parentNavigatorKey: AdvancedRouter.rootNavigatorKey,
        builder: (context, state) => const ProfileScreen(),
        redirect: (context, state) => AppRoutes.profile,
      ),

      // Leaderboard deep link
      GoRoute(
        path: '/leaderboard/:boardId',
        name: 'leaderboard-deep-link',
        parentNavigatorKey: AdvancedRouter.rootNavigatorKey,
        builder: (context, state) => const ProfileScreen(),
        redirect: (context, state) => AppRoutes.profile,
      ),

      // Share deep link
      GoRoute(
        path: '/share',
        name: 'share-deep-link',
        parentNavigatorKey: AdvancedRouter.rootNavigatorKey,
        builder: (context, state) {
          final queryParams = state.uri.queryParameters;
          return _buildShareScreen(queryParams);
        },
        redirect: (context, state) =>
            DeepLinkingConfig.handleDeepLink(state.uri),
      ),
    ];
  }

  /// Handle route redirects for authentication and navigation logic
  static String? _handleRedirects(BuildContext context, GoRouterState state) {
    try {
      // Check if user needs to complete onboarding
      // if (state.matchedLocation == AppRoutes.home && !_isOnboardingComplete()) {
      //   return AppRoutes.onboarding;
      // }

      // Check authentication for protected routes
      if (_requiresAuth(state.matchedLocation) && !_isAuthenticated()) {
        // Redirect to login or show auth dialog
        return AppRoutes.home; // For now, redirect to home
      }

      // Check if route is accessible
      if (!_isRouteAccessible(state.matchedLocation)) {
        return AppRoutes.home;
      }

      return null; // No redirect needed
    } catch (e) {
      debugPrint('Redirect error: $e');
      return AppRoutes.home; // Fallback to home on error
    }
  }

  /// Check if route requires authentication
  static bool _requiresAuth(String route) {
    final protectedRoutes = [AppRoutes.profile, AppRoutes.settings];

    return protectedRoutes.contains(route);
  }

  /// Check if user is authenticated
  static bool _isAuthenticated() {
    // Add your authentication check logic here
    // return AuthService.instance.isAuthenticated;
    return true; // For now, assume authenticated
  }

  /// Check if route is accessible
  static bool _isRouteAccessible(String route) {
    // Add your route accessibility logic here
    // For example, check if user has required permissions
    return true; // For now, assume all routes are accessible
  }

  /// Build error screen for invalid routes
  static Widget _buildErrorScreen(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page "${state.matchedLocation}" does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }

  /// Build share screen for deep links
  static Widget _buildShareScreen(Map<String, String> queryParams) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Processing share link...'),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
            if (queryParams.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Parameters: $queryParams'),
            ],
          ],
        ),
      ),
    );
  }
}

/// Router refresh stream for reactive navigation
class _RouterRefreshStream extends ChangeNotifier {
  _RouterRefreshStream(this._ref) {
    _ref.listen<NavigationState>(
      navigationStateProvider,
      (_, __) => notifyListeners(),
    );
  }

  final Ref _ref;
}

/// Enhanced provider for the comprehensive router
final comprehensiveRouterProvider = Provider<GoRouter>((ref) {
  return RouterConfig.createRouter(ref);
});
