import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_xo_royale/app/routing/app_routes.dart';
import 'package:tictactoe_xo_royale/app/routing/route_guard.dart';
import 'package:tictactoe_xo_royale/app/routing/navigation_performance.dart';
import 'package:tictactoe_xo_royale/features/achievements/achievements.dart';
import 'package:tictactoe_xo_royale/features/game/game.dart';
import 'package:tictactoe_xo_royale/features/home/home.dart';
import 'package:tictactoe_xo_royale/features/loading/loading.dart';
import 'package:tictactoe_xo_royale/features/profile/profile.dart';
import 'package:tictactoe_xo_royale/features/settings/settings.dart';
import 'package:tictactoe_xo_royale/features/setup/setup.dart';
import 'package:tictactoe_xo_royale/features/store/store.dart';

/// Optimized router configuration for TicTacToe XO Royale
///
/// Features:
/// - Type-safe navigation with route constants
/// - Comprehensive route guards and validation
/// - Enhanced error handling and fallbacks
/// - Advanced performance monitoring and optimization
/// - Deep linking support
/// - Proper state management
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.loading,
    debugLogDiagnostics: true,

    // Global redirect logic with route guard integration
    redirect: RouteGuard.redirect,

    // Enable advanced navigation performance observer
    observers: [NavigationPerformanceObserver()],

    routes: [
      // Loading screen - standalone route
      GoRoute(
        path: AppRoutes.loading,
        name: AppRoutes.loadingName,
        builder: (context, state) => const LoadingScreen(),
      ),

      // Main app shell with bottom navigation
      ShellRoute(
        builder: (context, state, child) =>
            MainAppShell(state: state, child: child),
        routes: [
          // Home tab
          GoRoute(
            path: AppRoutes.home,
            name: AppRoutes.homeName,
            builder: (context, state) => const HomeScreen(),
          ),

          // Store tab
          GoRoute(
            path: AppRoutes.store,
            name: AppRoutes.storeName,
            builder: (context, state) => const StoreScreen(),
          ),

          // Profile tab
          GoRoute(
            path: AppRoutes.profile,
            name: AppRoutes.profileName,
            builder: (context, state) => const ProfileScreen(),
          ),

          // Settings tab
          GoRoute(
            path: AppRoutes.settings,
            name: AppRoutes.settingsName,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),

      // Setup screen - outside shell with parameter validation
      GoRoute(
        path: AppRoutes.setup,
        name: AppRoutes.setupName,
        builder: (context, state) {
          // Validate query parameters using route guard
          final validatedParams = RouteGuard.validateGameSetupParams(
            state.uri.queryParameters,
          );

          if (validatedParams == null) {
            // If parameters are invalid, redirect to home
            return ErrorScreen(
              error: 'Invalid game setup parameters',
              location: state.matchedLocation,
              fallbackRoute: AppRoutes.home,
            );
          }

          return SetupScreen(
            gameMode: validatedParams.gameMode,
            boardSize: validatedParams.boardSize,
            winCondition: validatedParams.winCondition,
            difficulty: validatedParams.difficulty,
            player1: validatedParams.player1,
            player2: validatedParams.player2,
            firstMove: validatedParams.firstMove,
          );
        },
      ),

      // Game screen - outside shell with strict parameter validation
      GoRoute(
        path: AppRoutes.game,
        name: AppRoutes.gameName,
        builder: (context, state) {
          // Validate query parameters using route guard
          final validatedParams = RouteGuard.validateGameParams(
            state.uri.queryParameters,
          );

          if (validatedParams == null) {
            // If parameters are invalid, redirect to setup
            return ErrorScreen(
              error: 'Invalid or missing game parameters',
              location: state.matchedLocation,
              fallbackRoute: AppRoutes.setup,
            );
          }

          return GameScreen(
            boardSize: validatedParams.boardSize!,
            winCondition: validatedParams.winCondition!,
            isRobotMode: validatedParams.gameMode == 'robot',
            difficulty:
                validatedParams.difficulty ?? AppRoutes.defaultDifficulty,
            player1Name: validatedParams.player1 ?? AppRoutes.defaultPlayer1,
            player2Name: validatedParams.player2 ?? AppRoutes.defaultPlayer2,
            firstMove: validatedParams.firstMove ?? AppRoutes.defaultFirstMove,
          );
        },
      ),

      // Achievements screen - modal-style route
      GoRoute(
        path: AppRoutes.achievements,
        name: AppRoutes.achievementsName,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const AchievementsScreen(),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            );
          },
        ),
      ),
    ],

    // Enhanced error builder with fallback routes
    errorBuilder: (context, state) => ErrorScreen(
      error: state.error?.toString() ?? 'Unknown error',
      location: state.matchedLocation,
      fallbackRoute: RouteGuard.getFallbackRoute(state.matchedLocation),
    ),
  );
});

/// Enhanced main app shell with optimized navigation
class MainAppShell extends ConsumerStatefulWidget {
  final Widget child;
  final GoRouterState state;

  const MainAppShell({super.key, required this.child, required this.state});

  @override
  ConsumerState<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends ConsumerState<MainAppShell> {
  int _currentIndex = 0;
  late final GoRouter _router;
  late final VoidCallback _routerListener;

  static const List<NavigationDestination> _navigationItems = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.storefront_outlined),
      selectedIcon: Icon(Icons.storefront),
      label: 'Store',
    ),
    NavigationDestination(
      icon: Icon(Icons.account_circle_outlined),
      selectedIcon: Icon(Icons.account_circle),
      label: 'Profile',
    ),
    NavigationDestination(
      icon: Icon(Icons.tune_outlined),
      selectedIcon: Icon(Icons.tune),
      label: 'Settings',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _router = GoRouter.of(context);

    // Create a stable listener callback
    _routerListener = () {
      if (mounted) {
        _updateCurrentIndex();
      }
    };

    // Listen to route changes to update the current index
    _router.routerDelegate.addListener(_routerListener);
    // Initial update
    _updateCurrentIndex();
  }

  @override
  void dispose() {
    _router.routerDelegate.removeListener(_routerListener);
    super.dispose();
  }

  void _updateCurrentIndex() {
    final uri = _router.routeInformationProvider.value.uri;
    final path = uri.path;
    final newIndex = AppRoutes.mainNavRoutes.indexOf(path);

    if (newIndex != -1 && _currentIndex != newIndex) {
      setState(() {
        _currentIndex = newIndex;
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == _currentIndex) return; // Don't navigate to same tab

    final route = AppRoutes.mainNavRoutes[index];

    // Validate navigation before proceeding
    final currentPath = _router.routeInformationProvider.value.uri.path;
    if (RouteGuard.canTransitionTo(currentPath, route)) {
      _router.go(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: widget.child,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onItemTapped,
        destinations: _navigationItems,
        elevation: 8,
      ),
    );
  }
}

/// Enhanced error screen with better UX and fallback handling
class ErrorScreen extends StatelessWidget {
  final String error;
  final String location;
  final String? fallbackRoute;

  const ErrorScreen({
    super.key,
    required this.error,
    required this.location,
    this.fallbackRoute,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Error'),
        backgroundColor: colorScheme.errorContainer,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: colorScheme.error),
              const SizedBox(height: 16),
              Text(
                'Oops! Something went wrong',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Route: $location',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  error,
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => context.go(AppRoutes.home),
                    icon: const Icon(Icons.home),
                    label: const Text('Go Home'),
                  ),
                  if (fallbackRoute != null && fallbackRoute != AppRoutes.home)
                    OutlinedButton.icon(
                      onPressed: () => context.go(fallbackRoute!),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Navigation performance provider for accessing analytics
final navigationPerformanceObserverProvider =
    Provider<NavigationPerformanceObserver>((ref) {
      return NavigationPerformanceObserver();
    });

/// Performance-optimized route builder wrapper
Widget buildOptimizedRoute(
  BuildContext context,
  GoRouterState state,
  Widget Function() builder, {
  String? routeName,
}) {
  final route = routeName ?? state.matchedLocation;

  // Check if navigation should be optimized
  final currentRoute = GoRouterState.of(context).matchedLocation;
  if (NavigationPerformance.shouldOptimizeNavigation(currentRoute, route)) {
    return NavigationPerformance.optimizeNavigation(context, route, builder);
  }

  return builder();
}
