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
                gameId: queryParams['gameId'],
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
                child: GameScreen(
                  gameId: queryParams['gameId'],
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

          // Store route
          GoRoute(
            path: AppRoutes.store,
            name: AppRoutes.storeName,
            parentNavigatorKey: AdvancedRouter.shellNavigatorKey,
            builder: (context, state) {
              final queryParams = state.uri.queryParameters;
              return StoreScreen(
                category: queryParams['category'],
                itemId: queryParams['itemId'],
              );
            },
            pageBuilder: (context, state) {
              final queryParams = state.uri.queryParameters;
              return CustomTransitionPage(
                key: state.pageKey,
                child: StoreScreen(
                  category: queryParams['category'],
                  itemId: queryParams['itemId'],
                ),
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
              );
            },
          ),

          // Profile route
          GoRoute(
            path: AppRoutes.profile,
            name: AppRoutes.profileName,
            parentNavigatorKey: AdvancedRouter.shellNavigatorKey,
            builder: (context, state) {
              final queryParams = state.uri.queryParameters;
              return ProfileScreen(
                userId: queryParams['userId'],
                leaderboardId: queryParams['leaderboardId'],
              );
            },
            pageBuilder: (context, state) {
              final queryParams = state.uri.queryParameters;
              return CustomTransitionPage(
                key: state.pageKey,
                child: ProfileScreen(
                  userId: queryParams['userId'],
                  leaderboardId: queryParams['leaderboardId'],
                ),
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
              );
            },
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
        builder: (context, state) {
          final gameId = state.pathParameters['gameId'];
          return GameScreen(gameId: gameId);
        },
        redirect: (context, state) {
          // Handle deep link redirects
          final gameId = state.pathParameters['gameId'];
          if (gameId != null) {
            // Redirect to game screen with proper parameters
            return '${AppRoutes.game}?gameId=$gameId';
          }
          return null;
        },
      ),

      // Store item deep link
      GoRoute(
        path: '/store/:category/:itemId',
        name: 'store-item-deep-link',
        parentNavigatorKey: AdvancedRouter.rootNavigatorKey,
        builder: (context, state) {
          final category = state.pathParameters['category'];
          final itemId = state.pathParameters['itemId'];
          return StoreItemDetailScreen(category: category, itemId: itemId);
        },
        redirect: (context, state) {
          // Handle store deep link redirects
          final category = state.pathParameters['category'];
          final itemId = state.pathParameters['itemId'];
          if (category != null && itemId != null) {
            return '${AppRoutes.store}?category=$category&itemId=$itemId';
          }
          return AppRoutes.store;
        },
      ),

      // Challenge deep link
      GoRoute(
        path: '/challenge/:challengeId',
        name: 'challenge-deep-link',
        parentNavigatorKey: AdvancedRouter.rootNavigatorKey,
        builder: (context, state) {
          final challengeId = state.pathParameters['challengeId'];
          return SetupScreen(challengeId: challengeId);
        },
        redirect: (context, state) {
          final challengeId = state.pathParameters['challengeId'];
          if (challengeId != null) {
            return '${AppRoutes.setup}?challengeId=$challengeId';
          }
          return AppRoutes.setup;
        },
      ),

      // Tournament deep link
      GoRoute(
        path: '/tournament/:tournamentId',
        name: 'tournament-deep-link',
        parentNavigatorKey: AdvancedRouter.rootNavigatorKey,
        builder: (context, state) {
          final tournamentId = state.pathParameters['tournamentId'];
          return SetupScreen(tournamentId: tournamentId);
        },
        redirect: (context, state) {
          final tournamentId = state.pathParameters['tournamentId'];
          if (tournamentId != null) {
            return '${AppRoutes.setup}?tournamentId=$tournamentId';
          }
          return AppRoutes.setup;
        },
      ),

      // Profile deep link
      GoRoute(
        path: '/profile/:userId',
        name: 'profile-deep-link',
        parentNavigatorKey: AdvancedRouter.rootNavigatorKey,
        builder: (context, state) {
          final userId = state.pathParameters['userId'];
          return ProfileScreen(userId: userId);
        },
        redirect: (context, state) {
          final userId = state.pathParameters['userId'];
          if (userId != null) {
            return '${AppRoutes.profile}?userId=$userId';
          }
          return AppRoutes.profile;
        },
      ),

      // Leaderboard deep link
      GoRoute(
        path: '/leaderboard/:boardId',
        name: 'leaderboard-deep-link',
        parentNavigatorKey: AdvancedRouter.rootNavigatorKey,
        builder: (context, state) {
          final boardId = state.pathParameters['boardId'];
          return ProfileScreen(leaderboardId: boardId);
        },
        redirect: (context, state) {
          final boardId = state.pathParameters['boardId'];
          if (boardId != null) {
            return '${AppRoutes.profile}?leaderboardId=$boardId';
          }
          return AppRoutes.profile;
        },
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

// Placeholder screen widgets with enhanced parameters

class SetupScreen extends StatelessWidget {
  final String? challengeId;
  final String? tournamentId;
  final int? boardSize;
  final int? winCondition;
  final String? gameMode;
  final String? difficulty;
  final String? player1;
  final String? player2;
  final String? firstMove;

  const SetupScreen({
    super.key,
    this.challengeId,
    this.tournamentId,
    this.boardSize,
    this.winCondition,
    this.gameMode,
    this.difficulty,
    this.player1,
    this.player2,
    this.firstMove,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Setup'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationService.navigateBack(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Setup Screen'),
            if (challengeId != null) Text('Challenge ID: $challengeId'),
            if (tournamentId != null) Text('Tournament ID: $tournamentId'),
            if (boardSize != null) Text('Board Size: $boardSize'),
            if (winCondition != null) Text('Win Condition: $winCondition'),
            if (gameMode != null) Text('Game Mode: $gameMode'),
            if (difficulty != null) Text('Difficulty: $difficulty'),
            if (player1 != null) Text('Player 1: $player1'),
            if (player2 != null) Text('Player 2: $player2'),
            if (firstMove != null) Text('First Move: $firstMove'),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  final String? gameId;
  final int? boardSize;
  final int? winCondition;
  final String? gameMode;
  final String? difficulty;
  final String? player1;
  final String? player2;
  final String? firstMove;

  const GameScreen({
    super.key,
    this.gameId,
    this.boardSize,
    this.winCondition,
    this.gameMode,
    this.difficulty,
    this.player1,
    this.player2,
    this.firstMove,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationService.navigateBack(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Game Screen'),
            if (gameId != null) Text('Game ID: $gameId'),
            if (boardSize != null) Text('Board Size: $boardSize'),
            if (winCondition != null) Text('Win Condition: $winCondition'),
            if (gameMode != null) Text('Game Mode: $gameMode'),
            if (difficulty != null) Text('Difficulty: $difficulty'),
            if (player1 != null) Text('Player 1: $player1'),
            if (player2 != null) Text('Player 2: $player2'),
            if (firstMove != null) Text('First Move: $firstMove'),
          ],
        ),
      ),
    );
  }
}

class StoreScreen extends StatelessWidget {
  final String? category;
  final String? itemId;

  const StoreScreen({super.key, this.category, this.itemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Store Screen'),
            if (category != null) Text('Category: $category'),
            if (itemId != null) Text('Item ID: $itemId'),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String? userId;
  final String? leaderboardId;

  const ProfileScreen({super.key, this.userId, this.leaderboardId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Profile Screen'),
            if (userId != null) Text('User ID: $userId'),
            if (leaderboardId != null) Text('Leaderboard ID: $leaderboardId'),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Screen')),
    );
  }
}

class StoreItemDetailScreen extends StatelessWidget {
  final String? category;
  final String? itemId;

  const StoreItemDetailScreen({super.key, this.category, this.itemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store Item - ${category ?? 'Unknown'}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationService.navigateToStore(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Store Item Detail'),
            if (category != null) Text('Category: $category'),
            if (itemId != null) Text('Item ID: $itemId'),
          ],
        ),
      ),
    );
  }
}
