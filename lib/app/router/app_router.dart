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

/// Simple router provider for the app
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/loading',
    routes: appRoutes,
    debugLogDiagnostics: kDebugMode,
    errorBuilder: (context, state) =>
        ErrorPage(error: state.error, location: state.matchedLocation),
  );
});

// App routes configuration with shell route for bottom navigation
final List<RouteBase> appRoutes = [
  // Loading screen (separate route) - Fade transition
  GoRoute(
    path: '/loading',
    name: 'loading',
    pageBuilder: (context, state) => CustomTransitionPage<void>(
      key: state.pageKey,
      child: const LoadingScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  ),

  // Main app shell route with bottom navigation (4 items as per PRD)
  ShellRoute(
    builder: (context, state, child) => MainAppShell(child: child),
    routes: [
      // Home tab - Slide transition
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          },
        ),
      ),

      // Store tab - Slide transition
      GoRoute(
        path: '/store',
        name: 'store',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const StoreScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          },
        ),
      ),

      // Profile tab - Slide transition
      GoRoute(
        path: '/profile',
        name: 'profile',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ProfileScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          },
        ),
      ),

      // Settings tab - Slide transition
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const SettingsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          },
        ),
      ),
    ],
  ),

  // Game flow routes (separate from bottom navigation)
  GoRoute(
    path: '/setup',
    name: 'setup',
    pageBuilder: (context, state) {
      // Extract query parameters from the URL
      final queryParams = state.uri.queryParameters;

      final setupScreen = SetupScreen(
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

      // Vertical slide transition for setup screen
      return CustomTransitionPage<void>(
        key: state.pageKey,
        child: setupScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      );
    },
  ),

  GoRoute(
    path: '/game',
    name: 'game',
    pageBuilder: (context, state) {
      // Extract query parameters from the URL
      final queryParams = state.uri.queryParameters;

      final gameScreen = GameScreen(
        boardSize: int.tryParse(queryParams['boardSize'] ?? '3') ?? 3,
        winCondition: int.tryParse(queryParams['winCondition'] ?? '3') ?? 3,
        player1Name: queryParams['player1'] ?? 'Player 1',
        player2Name: queryParams['player2'] ?? 'Player 2',
        isRobotMode: queryParams['gameMode'] == 'robot',
        difficulty: queryParams['difficulty'] ?? 'medium',
        firstMove: queryParams['firstMove'] ?? 'random',
      );

      // Scale transition for game screen
      return CustomTransitionPage<void>(
        key: state.pageKey,
        child: gameScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: animation.drive(
              Tween(
                begin: 0.0,
                end: 1.0,
              ).chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
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

/// Simple error page widget for router errors
class ErrorPage extends StatelessWidget {
  final Exception? error;
  final String location;

  const ErrorPage({super.key, this.error, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80),
              const SizedBox(height: 24),
              const Text(
                'Page Not Found',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'The page you\'re looking for doesn\'t exist.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.go('/home'),
                icon: const Icon(Icons.home),
                label: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
