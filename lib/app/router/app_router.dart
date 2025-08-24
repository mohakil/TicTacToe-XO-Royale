import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/loading/loading.dart';
import '../../features/home/home.dart';

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

// App routes configuration
final List<RouteBase> appRoutes = [
  GoRoute(
    path: '/loading',
    name: 'loading',
    builder: (context, state) => const LoadingScreen(),
  ),
  GoRoute(
    path: '/home',
    name: 'home',
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    path: '/setup',
    name: 'setup',
    builder: (context, state) => const SetupScreen(),
  ),
  GoRoute(
    path: '/game',
    name: 'game',
    builder: (context, state) => const GameScreen(),
  ),
  GoRoute(
    path: '/store',
    name: 'store',
    builder: (context, state) => const StoreScreen(),
  ),
  GoRoute(
    path: '/profile',
    name: 'profile',
    builder: (context, state) => const ProfileScreen(),
  ),
  GoRoute(
    path: '/settings',
    name: 'settings',
    builder: (context, state) => const SettingsScreen(),
  ),
];

// HomeScreen is now imported from the home feature

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          label: 'Game Setup Screen',
          child: const Text('Game Setup'),
        ),
        leading: Semantics(
          label: 'Back to home button',
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/home'),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Semantics(
              label: 'Game setup instructions',
              child: Text(
                'Configure your game settings',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            Semantics(
              label: 'Start game button',
              child: ElevatedButton(
                onPressed: () => context.go('/game'),
                child: const Text('Start Game'),
              ),
            ),
            const SizedBox(height: 16),
            Semantics(
              label: 'Return to home button',
              child: TextButton(
                onPressed: () => context.go('/home'),
                child: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Semantics(label: 'Game Screen', child: const Text('Game')),
      ),
      body: Center(
        child: Semantics(
          label: 'Game content - Coming Soon',
          child: const Text('Game Screen - Coming Soon!'),
        ),
      ),
    );
  }
}

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Semantics(label: 'Store Screen', child: const Text('Store')),
      ),
      body: Center(
        child: Semantics(
          label: 'Store content - Coming Soon',
          child: const Text('Store Screen - Coming Soon!'),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          label: 'User Profile Screen',
          child: const Text('Profile'),
        ),
      ),
      body: Center(
        child: Semantics(
          label: 'Profile content - Coming Soon',
          child: const Text('Profile Screen - Coming Soon!'),
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
      appBar: AppBar(
        title: Semantics(
          label: 'Settings Screen',
          child: const Text('Settings'),
        ),
      ),
      body: Center(
        child: Semantics(
          label: 'Settings content - Coming Soon',
          child: const Text('Settings Screen - Coming Soon!'),
        ),
      ),
    );
  }
}
