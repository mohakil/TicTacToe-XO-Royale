import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_xo_royale/app/router/route_transitions.dart';
import 'package:tictactoe_xo_royale/app/router/routes.dart';

/// Navigation helper for the TicTacToe XO Royale app
/// Provides methods to navigate between screens with custom transitions
class NavigationHelper {
  /// Navigate to a route with custom transition
  static void navigateWithTransition(
    BuildContext context,
    String route, {
    Object? extra,
    PageTransitionType transitionType = PageTransitionType.fade,
    Duration? duration,
  }) {
    final pageBuilder = _createPageBuilder(
      route,
      extra,
      transitionType,
      duration,
    );
    Navigator.of(context).push(pageBuilder);
  }

  /// Replace current route with custom transition
  static void replaceWithTransition(
    BuildContext context,
    String route, {
    Object? extra,
    PageTransitionType transitionType = PageTransitionType.fade,
    Duration? duration,
  }) {
    final pageBuilder = _createPageBuilder(
      route,
      extra,
      transitionType,
      duration,
    );
    Navigator.of(context).pushReplacement(pageBuilder);
  }

  /// Navigate to home screen with combined transition
  static void goToHome(BuildContext context) {
    context.go(AppRoutes.home);
  }

  /// Navigate to setup screen with vertical transition
  static void goToSetup(BuildContext context) {
    context.go(AppRoutes.setup);
  }

  /// Navigate to game screen with hero transition
  static void goToGame(
    BuildContext context, {
    int? boardSize,
    int? winCondition,
    String? gameMode,
    String? difficulty,
    String? player1,
    String? player2,
    String? firstMove,
  }) {
    final route = AppRoutes.buildGameRoute(
      boardSize: boardSize,
      winCondition: winCondition,
      gameMode: gameMode,
      difficulty: difficulty,
      player1: player1,
      player2: player2,
      firstMove: firstMove,
    );
    context.go(route);
  }

  /// Navigate to store screen with horizontal transition
  static void goToStore(BuildContext context) {
    context.go(AppRoutes.store);
  }

  /// Navigate to profile screen with horizontal transition
  static void goToProfile(BuildContext context) {
    context.go(AppRoutes.profile);
  }

  /// Navigate to settings screen with horizontal transition
  static void goToSettings(BuildContext context) {
    context.go(AppRoutes.settings);
  }

  /// Go back with custom transition
  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  /// Create a page builder with custom transition
  static PageRouteBuilder<dynamic> _createPageBuilder(
    String route,
    Object? extra,
    PageTransitionType transitionType,
    Duration? duration,
  ) {
    final child = _buildChild(route, extra);

    switch (transitionType) {
      case PageTransitionType.sharedAxisHorizontal:
        return AppRouteTransitions.sharedAxisHorizontal(child: child);
      case PageTransitionType.sharedAxisVertical:
        return AppRouteTransitions.sharedAxisVertical(child: child);
      case PageTransitionType.fade:
        return AppRouteTransitions.fade(child: child, duration: duration);
      case PageTransitionType.scale:
        return AppRouteTransitions.scale(child: child, duration: duration);
      case PageTransitionType.hero:
        return AppRouteTransitions.hero(
          child: child,
          tag: route,
          duration: duration,
        );
      case PageTransitionType.combined:
        return AppRouteTransitions.combined(child: child, duration: duration);
    }
  }

  /// Build child widget for the route
  /// This is a simplified implementation - in a real app, you'd resolve the actual route
  // ignore: prefer_expression_function_bodies
  static Widget _buildChild(String route, Object? extra) {
    // This would typically resolve to the actual screen widget
    // For now, return a placeholder
    return Scaffold(
      appBar: AppBar(title: Text('Route: $route'), leading: const BackButton()),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Route: $route'),
            if (extra != null) Text('Extra: $extra'),
            const SizedBox(height: 16),
            const Text('This is a placeholder screen'),
          ],
        ),
      ),
    );
  }

  /// Get the appropriate transition type for a route
  static PageTransitionType getTransitionTypeForRoute(String route) =>
      RouteTransitionConfig.getForRoute(route).type;

  /// Get the appropriate duration for a route
  static Duration getDurationForRoute(String route) =>
      RouteTransitionConfig.getForRoute(route).duration ??
      const Duration(milliseconds: 300);
}

/// Extension methods for easier navigation
extension NavigationExtension on BuildContext {
  /// Navigate to home with custom transition
  void goToHome() => NavigationHelper.goToHome(this);

  /// Navigate to setup with custom transition
  void goToSetup() => NavigationHelper.goToSetup(this);

  /// Navigate to game with custom transition
  void goToGame({
    int? boardSize,
    int? winCondition,
    String? gameMode,
    String? difficulty,
    String? player1,
    String? player2,
    String? firstMove,
  }) => NavigationHelper.goToGame(
    this,
    boardSize: boardSize,
    winCondition: winCondition,
    gameMode: gameMode,
    difficulty: difficulty,
    player1: player1,
    player2: player2,
    firstMove: firstMove,
  );

  /// Navigate to store with custom transition
  void goToStore() => NavigationHelper.goToStore(this);

  /// Navigate to profile with custom transition
  void goToProfile() => NavigationHelper.goToProfile(this);

  /// Navigate to settings with custom transition
  void goToSettings() => NavigationHelper.goToSettings(this);

  /// Go back with custom transition
  void goBack() => NavigationHelper.goBack(this);
}
