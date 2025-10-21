import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_xo_royale/app/routing/app_routes.dart';

/// Route guard service for handling navigation rules and authentication
///
/// This service provides centralized logic for route protection,
/// redirection, and navigation flow control.
class RouteGuard {
  // Private constructor for singleton pattern
  RouteGuard._();

  /// Global redirect logic for the application
  ///
  /// Handles authentication state, app initialization, and navigation flow.
  /// Returns null if no redirect is needed, otherwise returns the target path.
  static String? redirect(BuildContext context, GoRouterState state) {
    final location = state.uri.path;

    // Skip redirect logic for loading screen - let it handle its own navigation
    if (location == AppRoutes.loading) {
      return null;
    }

    // Example: Check if app is initialized
    // In a real app, you might check for user authentication,
    // app initialization state, onboarding completion, etc.

    // For now, we'll implement basic navigation flow protection
    return _validateNavigationFlow(state);
  }

  /// Validates the navigation flow and redirects if necessary
  static String? _validateNavigationFlow(GoRouterState state) {
    final location = state.uri.path;

    // Prevent direct access to setup without proper game mode
    if (location == AppRoutes.setup) {
      // This would normally check if user came from home with valid game mode
      // For now, allow access but this could be enhanced
      return null;
    }

    // Prevent direct access to game without proper setup
    if (location == AppRoutes.game) {
      // Check if game parameters are present
      if (state.uri.queryParameters.isEmpty) {
        return AppRoutes.setup;
      }

      // Validate the game parameters
      final validatedParams = validateGameParams(state.uri.queryParameters);
      if (validatedParams == null) {
        return AppRoutes.setup;
      }

      return null;
    }

    // Allow access to all other routes
    return null;
  }

  /// Validates that a route transition is allowed
  static bool canTransitionTo(String fromRoute, String toRoute) {
    // Prevent navigation from game back to setup (would lose game state)
    if (fromRoute == AppRoutes.game && toRoute == AppRoutes.setup) {
      return false;
    }

    // Allow all other transitions
    return true;
  }

  /// Gets the appropriate fallback route for navigation errors
  static String getFallbackRoute(String attemptedRoute) {
    // If user was trying to access a main nav route, go to home
    if (AppRoutes.isMainNavRoute(attemptedRoute)) {
      return AppRoutes.home;
    }

    // If user was trying to access game-related routes, go to home
    // (Setup screen should navigate back to home when back button is pressed)
    if (attemptedRoute == AppRoutes.game || attemptedRoute == AppRoutes.setup) {
      return AppRoutes.home; // Changed from setup to home
    }

    // Default fallback
    return AppRoutes.home;
  }

  /// Determines if a route requires special handling
  static bool requiresSpecialHandling(String route) {
    return AppRoutes.isExternalRoute(route);
  }

  /// Validates query parameters for game setup
  static GameSetupParams? validateGameSetupParams(Map<String, String> params) {
    try {
      final setupParams = GameSetupParams.fromQueryParams(params);

      // Validate required parameters
      if (setupParams.gameMode == null || setupParams.gameMode!.isEmpty) {
        return null;
      }

      // Validate numeric parameters
      if (setupParams.boardSize != null &&
          (setupParams.boardSize! < 3 || setupParams.boardSize! > 10)) {
        return null;
      }

      if (setupParams.winCondition != null &&
          (setupParams.winCondition! < 3 || setupParams.winCondition! > 10)) {
        return null;
      }

      return setupParams;
    } catch (e) {
      return null;
    }
  }

  /// Validates query parameters for game screen
  static GameSetupParams? validateGameParams(Map<String, String> params) {
    try {
      final gameParams = GameSetupParams.fromQueryParams(params);

      // Game screen requires boardSize, winCondition, and gameMode
      if (gameParams.boardSize == null ||
          gameParams.winCondition == null ||
          gameParams.gameMode == null) {
        return null;
      }

      // Validate numeric ranges
      if (gameParams.boardSize! < 3 || gameParams.boardSize! > 10) {
        return null;
      }

      if (gameParams.winCondition! < 3 || gameParams.winCondition! > 10) {
        return null;
      }

      // Validate game mode
      if (gameParams.gameMode != 'local' && gameParams.gameMode != 'robot') {
        return null;
      }

      // Apply defaults for missing optional parameters
      return GameSetupParams(
        gameMode: gameParams.gameMode!,
        boardSize: gameParams.boardSize!,
        winCondition: gameParams.winCondition!,
        difficulty: gameParams.difficulty ?? AppRoutes.defaultDifficulty,
        player1: gameParams.player1 ?? AppRoutes.defaultPlayer1,
        player2: gameParams.player2 ?? AppRoutes.defaultPlayer2,
        firstMove: gameParams.firstMove ?? AppRoutes.defaultFirstMove,
      );
    } catch (e) {
      return null;
    }
  }

  /// Creates a redirect response with query parameters
  static String createRedirectWithParams(
    String basePath,
    Map<String, String> parameters,
  ) {
    if (parameters.isEmpty) return basePath;

    final queryString = parameters.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '$basePath?$queryString';
  }

  /// Handles deep linking validation
  static String? handleDeepLink(String deepLink) {
    try {
      final uri = Uri.parse(deepLink);

      // Validate the deep link path
      switch (uri.path) {
        case AppRoutes.game:
          // Validate game parameters from deep link
          final validatedParams = validateGameParams(uri.queryParameters);
          if (validatedParams != null) {
            return deepLink;
          }
          return AppRoutes.setup;

        case AppRoutes.setup:
        case AppRoutes.achievements:
        case AppRoutes.home:
        case AppRoutes.store:
        case AppRoutes.profile:
        case AppRoutes.settings:
          return deepLink;

        default:
          // Invalid deep link, redirect to home
          return AppRoutes.home;
      }
    } catch (e) {
      // Invalid deep link format
      return AppRoutes.home;
    }
  }

  /// Checks if navigation should preserve state
  static bool shouldPreserveState(String fromRoute, String toRoute) {
    // Preserve state when navigating between main nav routes
    if (AppRoutes.isMainNavRoute(fromRoute) &&
        AppRoutes.isMainNavRoute(toRoute)) {
      return true;
    }

    // Don't preserve state when navigating to/from game
    if (fromRoute == AppRoutes.game || toRoute == AppRoutes.game) {
      return false;
    }

    // Default to preserving state
    return true;
  }

  /// Determines the transition type for navigation
  static PageTransition getTransitionType(String fromRoute, String toRoute) {
    // Use slide transition for main navigation
    if (AppRoutes.isMainNavRoute(fromRoute) &&
        AppRoutes.isMainNavRoute(toRoute)) {
      return PageTransition.slide;
    }

    // Use dialog transition for achievements
    if (toRoute == AppRoutes.achievements) {
      return PageTransition.dialog;
    }

    // Use default transition for other cases
    return PageTransition.normal;
  }
}

/// Enumeration of page transition types
enum PageTransition { normal, slide, dialog, fade }
