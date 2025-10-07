import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_xo_royale/features/achievements/achievements.dart';
import 'package:tictactoe_xo_royale/features/game/game.dart';
import 'package:tictactoe_xo_royale/features/home/home.dart';
import 'package:tictactoe_xo_royale/features/loading/loading.dart';
import 'package:tictactoe_xo_royale/features/profile/profile.dart';
import 'package:tictactoe_xo_royale/features/settings/settings.dart';
import 'package:tictactoe_xo_royale/features/setup/setup.dart';
import 'package:tictactoe_xo_royale/features/store/store.dart';

/// Simple router configuration for TicTacToe XO Royale
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/loading',
    debugLogDiagnostics: true, // Enable debug logging
    redirect: (context, state) {
      // Handle global redirects and navigation state
      final location = state.uri.path;

      // If we're at loading and it's completed, redirect to home
      if (location == '/loading') {
        return null; // Let loading screen handle its own navigation
      }

      // For all other routes, ensure proper navigation context
      return null;
    },
    routes: [
      // Loading screen
      GoRoute(
        path: '/loading',
        name: 'loading',
        builder: (context, state) => const LoadingScreen(),
      ),

      // Main app with bottom navigation
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

      // Setup screen (outside shell)
      GoRoute(
        path: '/setup',
        name: 'setup',
        builder: (context, state) {
          // Parse query parameters
          final gameMode = state.uri.queryParameters['gameMode'];
          final boardSize = state.uri.queryParameters['boardSize'];
          final winCondition = state.uri.queryParameters['winCondition'];
          final difficulty = state.uri.queryParameters['difficulty'];
          final player1 = state.uri.queryParameters['player1'];
          final player2 = state.uri.queryParameters['player2'];
          final firstMove = state.uri.queryParameters['firstMove'];

          return SetupScreen(
            gameMode: gameMode,
            boardSize: boardSize != null ? int.tryParse(boardSize) : null,
            winCondition: winCondition != null
                ? int.tryParse(winCondition)
                : null,
            difficulty: difficulty,
            player1: player1,
            player2: player2,
            firstMove: firstMove,
          );
        },
      ),

      // Game screen (outside shell)
      GoRoute(
        path: '/game',
        name: 'game',
        builder: (context, state) {
          // Parse query parameters
          final boardSize =
              int.tryParse(state.uri.queryParameters['boardSize'] ?? '3') ?? 3;
          final winCondition =
              int.tryParse(state.uri.queryParameters['winCondition'] ?? '3') ??
              3;
          final gameMode = state.uri.queryParameters['gameMode'] ?? 'local';
          final difficulty =
              state.uri.queryParameters['difficulty'] ?? 'medium';
          final player1 = state.uri.queryParameters['player1'] ?? 'Player 1';
          final player2 = state.uri.queryParameters['player2'] ?? 'Player 2';
          final firstMove = state.uri.queryParameters['firstMove'] ?? 'player1';

          return GameScreen(
            boardSize: boardSize,
            winCondition: winCondition,
            isRobotMode: gameMode == 'robot',
            difficulty: difficulty,
            player1Name: player1,
            player2Name: player2,
            firstMove: firstMove,
          );
        },
      ),

      // Achievements screen (outside shell)
      GoRoute(
        path: '/achievements',
        name: 'achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
    ],
    errorBuilder: (context, state) => ErrorScreen(
      error: state.error?.toString() ?? 'Unknown error',
      location: state.matchedLocation,
    ),
  );
});

/// Main app shell with bottom navigation
class MainAppShell extends ConsumerStatefulWidget {
  final Widget child;

  const MainAppShell({super.key, required this.child});

  @override
  ConsumerState<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends ConsumerState<MainAppShell> {
  int _currentIndex = 0;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCurrentIndex();
  }

  void _updateCurrentIndex() {
    final location = GoRouterState.of(context).uri.path;
    int newIndex;

    switch (location) {
      case '/home':
        newIndex = 0;
        break;
      case '/store':
        newIndex = 1;
        break;
      case '/profile':
        newIndex = 2;
        break;
      case '/settings':
        newIndex = 3;
        break;
      default:
        newIndex = 0;
    }

    if (_currentIndex != newIndex) {
      setState(() {
        _currentIndex = newIndex;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    final routes = ['/home', '/store', '/profile', '/settings'];
    context.go(routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onItemTapped,
        destinations: _navigationItems,
      ),
    );
  }
}

/// Simple error screen
class ErrorScreen extends StatelessWidget {
  final String error;
  final String location;

  const ErrorScreen({super.key, required this.error, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Route: $location',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(error, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
