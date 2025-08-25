import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/loading/loading.dart';
import '../../features/home/home.dart';
import '../../features/settings/settings.dart';
import '../../features/store/store.dart';
import '../../features/profile/profile.dart';
import '../../features/setup/setup.dart';
import '../../features/game/game.dart';

// Theme mode provider
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

// Provider for the router
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/loading',
    routes: appRoutes,
    debugLogDiagnostics: true,
  );
});

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
    builder: (context, state) => const SetupScreen(),
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
      );
    },
  ),
];

// Main app shell with bottom navigation (4 items as per PRD)
class MainAppShell extends StatefulWidget {
  final Widget child;

  const MainAppShell({super.key, required this.child});

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
