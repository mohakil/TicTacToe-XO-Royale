import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_xo_royale/app/routing/app_routes.dart';
import 'package:tictactoe_xo_royale/app/routing/route_guard.dart';
import 'package:tictactoe_xo_royale/app/routing/navigation_performance.dart';

/// Enhanced centralized navigation service for consistent navigation handling
///
/// This service provides type-safe navigation methods, proper state management,
/// and integrates with the route guard system for optimal navigation flow.
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  /// Navigate to home screen with proper state management
  static void goHome(BuildContext context) {
    if (!context.mounted) return;

    // Use go instead of push to reset the navigation stack
    context.go(AppRoutes.home);
  }

  /// Navigate to loading screen
  static void goLoading(BuildContext context) {
    if (!context.mounted) return;
    context.go(AppRoutes.loading);
  }

  /// Navigate to setup screen with type-safe parameters
  static Future<void> goSetup(
    BuildContext context, {
    GameSetupParams? params,
  }) async {
    if (!context.mounted) return;

    String path;
    if (params != null) {
      path = AppRoutes.buildSetupUrl(
        gameMode: params.gameMode,
        boardSize: params.boardSize,
        winCondition: params.winCondition,
        difficulty: params.difficulty,
        player1: params.player1,
        player2: params.player2,
        firstMove: params.firstMove,
      );
    } else {
      path = AppRoutes.setup;
    }

    // Measure navigation performance
    await NavigationPerformance.measureNavigation(
      'Navigate to Setup',
      () async {
        context.go(path);
        await Future.delayed(Duration.zero);
      },
    );
  }

  /// Navigate to game screen with type-safe parameters
  static Future<void> goGame(
    BuildContext context, {
    required GameSetupParams params,
  }) async {
    if (!context.mounted) return;

    final path = AppRoutes.buildGameUrl(
      boardSize: params.boardSize,
      winCondition: params.winCondition,
      gameMode: params.gameMode,
      difficulty: params.difficulty,
      player1: params.player1,
      player2: params.player2,
      firstMove: params.firstMove,
    );

    // Measure navigation performance
    await NavigationPerformance.measureNavigation('Navigate to Game', () async {
      context.go(path);
      // Wait a frame to ensure navigation completes
      await Future.delayed(Duration.zero);
    });
  }

  /// Navigate to achievements screen
  static void goAchievements(BuildContext context) {
    if (!context.mounted) return;
    context.go(AppRoutes.achievements);
  }

  /// Navigate to settings screen
  static void goSettings(BuildContext context) {
    if (!context.mounted) return;
    context.go(AppRoutes.settings);
  }

  /// Navigate to store screen
  static void goStore(BuildContext context) {
    if (!context.mounted) return;
    context.go(AppRoutes.store);
  }

  /// Navigate to profile screen
  static void goProfile(BuildContext context) {
    if (!context.mounted) return;
    context.go(AppRoutes.profile);
  }

  /// Push a route onto the navigation stack (for modal/temporary screens)
  static void pushRoute(BuildContext context, String route) {
    if (!context.mounted) return;
    context.push(route);
  }

  /// Push achievements screen as a modal
  static void pushAchievements(BuildContext context) {
    if (!context.mounted) return;
    context.push(AppRoutes.achievements);
  }

  /// Handle back navigation with proper context and state preservation
  static void goBack<T>(BuildContext context, [T? result]) {
    if (!context.mounted) return;

    if (context.canPop()) {
      context.pop(result);
    } else {
      // If we can't pop, determine best fallback route
      final currentPath = getCurrentPath(context);
      final fallbackRoute = RouteGuard.getFallbackRoute(currentPath);
      context.go(fallbackRoute);
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

  /// Get current route name
  static String getCurrentRouteName(BuildContext context) {
    return GoRouterState.of(context).name ?? '';
  }

  /// Get all query parameters for current route
  static Map<String, String> getCurrentQueryParams(BuildContext context) {
    return GoRouterState.of(context).uri.queryParameters;
  }

  /// Check if we're on a specific route
  static bool isOnRoute(BuildContext context, String route) {
    return getCurrentPath(context) == route;
  }

  /// Check if we're on the home route
  static bool isOnHome(BuildContext context) {
    return isOnRoute(context, AppRoutes.home);
  }

  /// Check if we're on a game-related route
  static bool isOnGameRoute(BuildContext context) {
    final path = getCurrentPath(context);
    return path.startsWith(AppRoutes.game) || path.startsWith(AppRoutes.setup);
  }

  /// Check if we're on a main navigation route
  static bool isOnMainNavRoute(BuildContext context) {
    return AppRoutes.isMainNavRoute(getCurrentPath(context));
  }

  /// Navigate to a specific tab in the main navigation
  static void goToTab(BuildContext context, int index) {
    if (!context.mounted) return;

    if (index >= 0 && index < AppRoutes.mainNavRoutes.length) {
      final route = AppRoutes.mainNavRoutes[index];

      // Check if transition is allowed
      final currentPath = getCurrentPath(context);
      if (RouteGuard.canTransitionTo(currentPath, route)) {
        context.go(route);
      }
    }
  }

  /// Get the index of the current tab
  static int getCurrentTabIndex(BuildContext context) {
    final currentPath = getCurrentPath(context);
    return AppRoutes.mainNavRoutes.indexOf(currentPath);
  }

  /// Navigate to a route with validation
  static bool navigateWithValidation(
    BuildContext context,
    String route, {
    Map<String, String>? params,
  }) {
    if (!context.mounted) return false;

    final currentPath = getCurrentPath(context);

    // Check if transition is allowed
    if (!RouteGuard.canTransitionTo(currentPath, route)) {
      return false;
    }

    // Handle special routes
    if (route == AppRoutes.setup && params != null) {
      final validatedParams = RouteGuard.validateGameSetupParams(params);
      if (validatedParams == null) {
        return false;
      }
      goSetup(context, params: validatedParams);
      return true;
    }

    if (route == AppRoutes.game && params != null) {
      final validatedParams = RouteGuard.validateGameParams(params);
      if (validatedParams == null) {
        return false;
      }
      goGame(context, params: validatedParams);
      return true;
    }

    // Standard navigation
    String fullPath = route;
    if (params != null && params.isNotEmpty) {
      fullPath = RouteGuard.createRedirectWithParams(route, params);
    }

    context.go(fullPath);
    return true;
  }

  /// Handle deep linking
  static bool handleDeepLink(BuildContext context, String deepLink) {
    if (!context.mounted) return false;

    final validatedRoute = RouteGuard.handleDeepLink(deepLink);
    if (validatedRoute != null) {
      context.go(validatedRoute);
      return true;
    }
    return false;
  }

  /// Refresh current route
  static void refreshRoute(BuildContext context) {
    if (!context.mounted) return;

    final currentPath = getCurrentPath(context);

    context.go(currentPath);
  }

  /// Replace current route with new one
  static void replaceRoute(BuildContext context, String route) {
    if (!context.mounted) return;

    context.go(route);
  }

  /// Clear navigation stack and go to specific route
  static void clearAndGo(BuildContext context, String route) {
    if (!context.mounted) return;

    context.go(route);
  }

  /// Navigate with custom transition
  static void navigateWithTransition(
    BuildContext context,
    String route, {
    PageTransition transition = PageTransition.normal,
  }) {
    if (!context.mounted) return;

    // This would require custom page builders for different transitions
    // For now, use standard navigation
    context.go(route);
  }

  /// Get navigation state information for debugging
  static Map<String, dynamic> getNavigationState(BuildContext context) {
    return {
      'currentPath': getCurrentPath(context),
      'currentName': getCurrentRouteName(context),
      'queryParams': getCurrentQueryParams(context),
      'canGoBack': canGoBack(context),
      'isOnHome': isOnHome(context),
      'isOnGameRoute': isOnGameRoute(context),
      'isOnMainNav': isOnMainNavRoute(context),
      'currentTabIndex': getCurrentTabIndex(context),
    };
  }

  /// Get navigation performance analytics
  static NavigationAnalytics? getNavigationAnalytics(BuildContext context) {
    try {
      // Access the performance observer from the router provider
      // Note: In a real implementation, you would access this via Riverpod
      // For now, return null as this is a demo feature
      return null;
    } catch (e) {
      debugPrint('Error getting navigation analytics: $e');
      return null;
    }
  }

  /// Get recent navigation events
  static List<NavigationEvent> getRecentNavigationEvents(
    BuildContext context, {
    int limit = 10,
  }) {
    try {
      // Access the performance observer from the router provider
      // Note: In a real implementation, you would access this via Riverpod
      // For now, return empty list as this is a demo feature
      return [];
    } catch (e) {
      debugPrint('Error getting recent navigation events: $e');
      return [];
    }
  }

  /// Check navigation system health
  static NavigationHealthReport checkNavigationHealth(BuildContext context) {
    return NavigationPerformance.checkNavigationHealth(context);
  }

  /// Warm up navigation system (call during app initialization)
  static Future<void> warmUpNavigation(BuildContext context) async {
    await NavigationPerformance.warmUpNavigation(context);
  }

  /// Get performance metrics
  static Map<String, dynamic> getPerformanceMetrics() {
    return NavigationPerformance.getPerformanceMetrics();
  }

  /// Clear navigation cache
  static void clearNavigationCache() {
    NavigationPerformance.clearCache();
  }

  /// Get performance recommendations
  static List<String> getPerformanceRecommendations() {
    return NavigationPerformance.getPerformanceRecommendations();
  }
}
