import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Centralized navigation service for consistent navigation handling
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  /// Navigate to home screen with proper state management
  static void goHome(BuildContext context) {
    // Use go instead of push to reset the navigation stack
    context.go('/home');
  }

  /// Navigate to setup screen
  static void goSetup(BuildContext context, {Map<String, String>? params}) {
    String path = '/setup';
    if (params != null && params.isNotEmpty) {
      final queryParams = params.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
      path = '$path?$queryParams';
    }
    context.go(path);
  }

  /// Navigate to game screen
  static void goGame(BuildContext context, {Map<String, String>? params}) {
    String path = '/game';
    if (params != null && params.isNotEmpty) {
      final queryParams = params.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
      path = '$path?$queryParams';
    }
    context.go(path);
  }

  /// Navigate to settings screen
  static void goSettings(BuildContext context) {
    context.go('/settings');
  }

  /// Navigate to store screen
  static void goStore(BuildContext context) {
    context.go('/store');
  }

  /// Navigate to profile screen
  static void goProfile(BuildContext context) {
    context.go('/profile');
  }

  /// Handle back navigation with proper context
  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      // If we can't pop, go to home
      goHome(context);
    }
  }

  /// Check if we can navigate back
  static bool canGoBack(BuildContext context) {
    return context.canPop();
  }

  /// Get current route path
  static String getCurrentPath(BuildContext context) {
    return GoRouterState.of(context).uri.path;
  }

  /// Check if we're on a specific route
  static bool isOnRoute(BuildContext context, String route) {
    return getCurrentPath(context) == route;
  }

  /// Check if we're on the home route
  static bool isOnHome(BuildContext context) {
    return isOnRoute(context, '/home');
  }

  /// Check if we're on a game-related route
  static bool isOnGameRoute(BuildContext context) {
    final path = getCurrentPath(context);
    return path.startsWith('/game') || path.startsWith('/setup');
  }
}
