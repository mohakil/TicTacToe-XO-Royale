import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';
import 'route_transitions.dart';
import '../../features/loading/loading.dart';
import '../../features/home/home.dart';
import '../../features/setup/setup.dart';
import '../../features/game/game.dart';
import '../../features/store/store.dart';
import '../../features/profile/profile.dart';
import '../../features/settings/settings.dart';

/// Advanced GoRouter configuration with ShellRoute and nested navigation
class AdvancedRouter {
  /// Global navigator key for the root navigator
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  /// Shell navigator key for nested navigation
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  /// Getter for root navigator key
  static GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;

  /// Getter for shell navigator key
  static GlobalKey<NavigatorState> get shellNavigatorKey => _shellNavigatorKey;

  /// Advanced router configuration with ShellRoute
  static GoRouter createAdvancedRouter() {
    return GoRouter(
      initialLocation: AppRoutes.loading,
      navigatorKey: _rootNavigatorKey,
      debugLogDiagnostics: true,
      routes: _buildAdvancedRoutes(),
      redirect: _handleRedirects,
      errorBuilder: _buildErrorScreen,
      redirectLimit: 5,
    );
  }

  /// Build advanced routes with ShellRoute structure
  static List<RouteBase> _buildAdvancedRoutes() {
    return [
      // Loading route (outside shell)
      GoRoute(
        path: AppRoutes.loading,
        name: AppRoutes.loadingName,
        parentNavigatorKey: _rootNavigatorKey,
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
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          // Home route
          GoRoute(
            path: AppRoutes.home,
            name: AppRoutes.homeName,
            parentNavigatorKey: _shellNavigatorKey,
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
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) => const SetupScreen(),
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const SetupScreen(),
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
            ),
          ),

          // Game route with parameters
          GoRoute(
            path: AppRoutes.game,
            name: AppRoutes.gameName,
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) => GameScreen(),
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: GameScreen(),
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
            ),
          ),

          // Store route
          GoRoute(
            path: AppRoutes.store,
            name: AppRoutes.storeName,
            parentNavigatorKey: _shellNavigatorKey,
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
            parentNavigatorKey: _shellNavigatorKey,
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
            parentNavigatorKey: _shellNavigatorKey,
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
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => GameScreen(),
        redirect: (context, state) {
          // Handle deep link redirects
          final gameId = state.pathParameters['gameId'];
          if (gameId != null) {
            // Redirect to game screen with proper parameters
            return AppRoutes.game;
          }
          return null;
        },
      ),

      // Store item deep link
      GoRoute(
        path: '/store/:category/:itemId',
        name: 'store-item-deep-link',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Store Item Detail - Coming Soon')),
        ),
        redirect: (context, state) {
          // Handle store deep link redirects
          return AppRoutes.store;
        },
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
}

/// App shell widget that wraps the main navigation
class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  /// Build bottom navigation bar for main routes
  Widget _buildBottomNavigation(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _getCurrentIndex(currentLocation),
      onTap: (index) => _onNavigationTap(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Store'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }

  /// Get current navigation index based on route
  int _getCurrentIndex(String location) {
    switch (location) {
      case AppRoutes.home:
        return 0;
      case AppRoutes.store:
        return 1;
      case AppRoutes.profile:
        return 2;
      case AppRoutes.settings:
        return 3;
      default:
        return 0;
    }
  }

  /// Handle navigation tap events
  void _onNavigationTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.store);
        break;
      case 2:
        context.go(AppRoutes.profile);
        break;
      case 3:
        context.go(AppRoutes.settings);
        break;
    }
  }
}

/// Enhanced provider for the advanced router
final advancedRouterProvider = Provider<GoRouter>((ref) {
  return AdvancedRouter.createAdvancedRouter();
});

/// Provider for router state management
final routerStateProvider =
    StateNotifierProvider<RouterStateNotifier, RouterState>((ref) {
      return RouterStateNotifier();
    });

/// Router state notifier for managing navigation state
class RouterStateNotifier extends StateNotifier<RouterState> {
  RouterStateNotifier() : super(RouterState.initial());

  void setCurrentRoute(String route) {
    state = state.copyWith(currentRoute: route);
  }

  void setPreviousRoute(String route) {
    state = state.copyWith(previousRoute: route);
  }

  void addToHistory(String route) {
    final newHistory = List<String>.from(state.routeHistory)..add(route);
    if (newHistory.length > 10) {
      newHistory.removeAt(0); // Keep only last 10 routes
    }
    state = state.copyWith(routeHistory: newHistory);
  }

  void clearHistory() {
    state = state.copyWith(routeHistory: []);
  }
}

/// Router state data class
class RouterState {
  final String currentRoute;
  final String? previousRoute;
  final List<String> routeHistory;
  final DateTime lastNavigation;

  const RouterState({
    required this.currentRoute,
    this.previousRoute,
    required this.routeHistory,
    required this.lastNavigation,
  });

  factory RouterState.initial() {
    return RouterState(
      currentRoute: AppRoutes.loading,
      routeHistory: [AppRoutes.loading],
      lastNavigation: DateTime.now(),
    );
  }

  RouterState copyWith({
    String? currentRoute,
    String? previousRoute,
    List<String>? routeHistory,
    DateTime? lastNavigation,
  }) {
    return RouterState(
      currentRoute: currentRoute ?? this.currentRoute,
      previousRoute: previousRoute ?? this.previousRoute,
      routeHistory: routeHistory ?? this.routeHistory,
      lastNavigation: lastNavigation ?? this.lastNavigation,
    );
  }
}

// Forward declarations for screen widgets (defined in router_config.dart)
