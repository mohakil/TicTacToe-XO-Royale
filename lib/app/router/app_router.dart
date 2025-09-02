import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_xo_royale/features/game/game.dart';
import 'package:tictactoe_xo_royale/features/home/home.dart';
import 'package:tictactoe_xo_royale/features/loading/loading.dart';
import 'package:tictactoe_xo_royale/features/profile/profile.dart';
import 'package:tictactoe_xo_royale/features/settings/settings.dart';
import 'package:tictactoe_xo_royale/features/setup/setup.dart';
import 'package:tictactoe_xo_royale/features/store/store.dart';
import 'package:tictactoe_xo_royale/core/widgets/error_boundary.dart';

// Provider for the router
final routerProvider = Provider<GoRouter>((ref) {
  final errorLoggingService = ref.watch(errorLoggingProvider);

  return GoRouter(
    initialLocation: '/loading',
    routes: appRoutes,
    debugLogDiagnostics: kDebugMode,
    errorBuilder: (context, state) => _ErrorPage(
      error: state.error,
      location: state.matchedLocation,
      onRetry: () => context.go('/home'),
    ),
    redirect: (context, state) {
      // Global redirect logic with error handling
      try {
        return _handleRedirect(context, state, errorLoggingService);
      } catch (error, stackTrace) {
        errorLoggingService.logError(
          error,
          stackTrace,
          context: 'RouterRedirect',
          additionalData: {
            'location': state.matchedLocation,
            'uri': state.uri.toString(),
          },
        );
        // Fallback to home on redirect error
        return '/home';
      }
    },
  );
});

/// Handle router redirects with error recovery
String? _handleRedirect(
  BuildContext context,
  GoRouterState state,
  ErrorLoggingService errorLoggingService,
) {
  // Add any global redirect logic here
  // For example: authentication checks, maintenance mode, etc.

  // Example: Redirect to maintenance page if needed
  // if (isMaintenanceMode) {
  //   return '/maintenance';
  // }

  // Example: Redirect to login if not authenticated
  // if (requiresAuth(state.matchedLocation) && !isAuthenticated) {
  //   return '/login';
  // }

  return null; // No redirect needed
}

// App routes configuration with shell route for bottom navigation
final List<RouteBase> appRoutes = [
  // Loading screen (separate route)
  GoRoute(
    path: '/loading',
    name: 'loading',
    builder: (context, state) => const LoadingScreen(),
  ),

  // Main app shell route with bottom navigation (4 items as per PRD)
  ShellRoute(
    builder: (context, state, child) => MainAppShell(child: child),
    routes: [
      // Home tab
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Store tab
      GoRoute(
        path: '/store',
        name: 'store',
        builder: (context, state) => const StoreScreen(),
      ),

      // Profile tab
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      // Settings tab
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  ),

  // Game flow routes (separate from bottom navigation)
  GoRoute(
    path: '/setup',
    name: 'setup',
    builder: (context, state) {
      // Extract query parameters from the URL
      final queryParams = state.uri.queryParameters;

      return SetupScreen(
        challengeId: queryParams['challengeId'],
        tournamentId: queryParams['tournamentId'],
        boardSize: int.tryParse(queryParams['boardSize'] ?? '3') == 3
            ? BoardSize.threeByThree
            : int.tryParse(queryParams['boardSize'] ?? '4') == 4
            ? BoardSize.fourByFour
            : BoardSize.fiveByFive,
        winCondition: int.tryParse(queryParams['winCondition'] ?? '3') == 3
            ? WinCondition.threeInRow
            : int.tryParse(queryParams['winCondition'] ?? '4') == 4
            ? WinCondition.fourInRow
            : WinCondition.fiveInRow,
        gameMode: queryParams['gameMode'],
        difficulty: queryParams['difficulty'],
        player1: queryParams['player1'],
        player2: queryParams['player2'],
        firstMove: queryParams['firstMove'],
      );
    },
  ),

  GoRoute(
    path: '/game',
    name: 'game',
    builder: (context, state) {
      // Extract query parameters from the URL
      final queryParams = state.uri.queryParameters;

      return GameScreen(
        boardSize: int.tryParse(queryParams['boardSize'] ?? '3') ?? 3,
        winCondition: int.tryParse(queryParams['winCondition'] ?? '3') ?? 3,
        player1Name: queryParams['player1'] ?? 'Player 1',
        player2Name: queryParams['player2'] ?? 'Player 2',
        isRobotMode: queryParams['gameMode'] == 'robot',
        difficulty: queryParams['difficulty'] ?? 'medium',
        firstMove: queryParams['firstMove'] ?? 'random',
      );
    },
  ),
];

// Main app shell with bottom navigation (4 items as per PRD)
class MainAppShell extends StatefulWidget {
  final Widget child;

  const MainAppShell({required this.child, super.key});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  int _currentIndex = 0;

  // Navigation items for bottom navigation bar (4 items as per PRD)
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
    // Set initial tab based on current route
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateCurrentIndex();
    });
  }

  void _updateCurrentIndex() {
    final location = GoRouterState.of(context).uri.path;
    setState(() {
      switch (location) {
        case '/home':
          _currentIndex = 0;
          break;
        case '/store':
          _currentIndex = 1;
          break;
        case '/profile':
          _currentIndex = 2;
          break;
        case '/settings':
          _currentIndex = 3;
          break;
        default:
          _currentIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Navigate to the selected tab
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/store');
              break;
            case 2:
              context.go('/profile');
              break;
            case 3:
              context.go('/settings');
              break;
          }
        },
        destinations: _navigationItems,
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}

/// Error page widget for router errors
class _ErrorPage extends StatelessWidget {
  final Exception? error;
  final String location;
  final VoidCallback? onRetry;

  const _ErrorPage({this.error, required this.location, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error icon
              Icon(Icons.route_outlined, size: 80, color: colorScheme.error),

              const SizedBox(height: 24),

              // Error title
              Text(
                'Page Not Found',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Error message
              Text(
                'The page you\'re looking for doesn\'t exist or has been moved.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Location info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Location: $location',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Go back button
                  OutlinedButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Go Back'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      side: BorderSide(color: colorScheme.primary),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Go home button
                  ElevatedButton.icon(
                    onPressed: () => context.go('/home'),
                    icon: const Icon(Icons.home),
                    label: const Text('Go Home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),

              // Retry button (if provided)
              if (onRetry != null) ...[
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.secondary,
                  ),
                ),
              ],

              // Error details (debug mode only)
              if (kDebugMode && error != null) ...[
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),

                Text(
                  'Error Details (Debug Mode)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colorScheme.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      error.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
