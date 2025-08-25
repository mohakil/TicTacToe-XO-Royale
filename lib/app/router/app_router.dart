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

// All screens are now imported from their respective features
