import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_xo_royale/app/router/route_transitions.dart';
import 'package:tictactoe_xo_royale/app/router/routes.dart';

/// Enhanced navigation service for the Tic Tac Toe XO Royale app
/// Provides advanced navigation capabilities, route guards, and analytics
class NavigationService {
  static final NavigationService _instance = NavigationService._();
  static NavigationService get instance => _instance;

  NavigationService._();

  /// Navigate to a route with custom transition and parameters
  static Future<void> navigateTo(
    BuildContext context,
    String route, {
    Map<String, String>? queryParameters,
    Object? extra,
    PageTransitionType transitionType = PageTransitionType.fade,
    Duration? duration,
    bool replace = false,
  }) async {
    try {
      final uri = Uri.parse(route);
      final finalUri = queryParameters != null
          ? uri.replace(queryParameters: queryParameters)
          : uri;

      if (replace) {
        context.go(finalUri.toString());
      } else {
        unawaited(context.push(finalUri.toString(), extra: extra));
      }

      // Log navigation for analytics
      _logNavigation(route, queryParameters, transitionType);
    } on Exception catch (e) {
      debugPrint('Navigation error: $e');
      // Fallback to basic navigation
      if (replace) {
        context.go(route);
      } else {
        unawaited(context.push(route));
      }
    }
  }

  /// Navigate to a named route with parameters
  static Future<void> navigateToNamed(
    BuildContext context,
    String routeName, {
    Map<String, String>? pathParameters,
    Map<String, String>? queryParameters,
    Object? extra,
  }) async {
    try {
      final route = _getRouteByName(routeName);
      if (route != null) {
        final uri = Uri.parse(route);
        final finalUri = uri.replace(
          pathSegments: _buildPathSegments(route, pathParameters),
          queryParameters: queryParameters,
        );

        context.go(finalUri.toString(), extra: extra);
        _logNavigation(route, queryParameters, PageTransitionType.fade);
      } else {
        debugPrint('Route name not found: $routeName');
        context.go(AppRoutes.home);
      }
    } on Exception catch (e) {
      debugPrint('Named navigation error: $e');
      context.go(AppRoutes.home);
    }
  }

  /// Navigate with custom transition
  static Future<void> navigateWithTransition(
    BuildContext context,
    String route, {
    Map<String, String>? queryParameters,
    Object? extra,
    PageTransitionType transitionType = PageTransitionType.fade,
    Duration? duration,
  }) async {
    await navigateTo(
      context,
      route,
      queryParameters: queryParameters,
      extra: extra,
      transitionType: transitionType,
      duration: duration,
    );
  }

  /// Navigate to game setup with parameters
  static Future<void> navigateToGameSetup(
    BuildContext context, {
    int? boardSize,
    int? winCondition,
    String? gameMode,
    String? difficulty,
    String? player1,
    String? player2,
    String? firstMove,
    String? challengeId,
    String? tournamentId,
  }) async {
    final queryParams = <String, String>{};

    if (boardSize != null) {
      queryParams[AppRoutes.boardSizeParam] = boardSize.toString();
    }
    if (winCondition != null) {
      queryParams[AppRoutes.winConditionParam] = winCondition.toString();
    }
    if (gameMode != null) {
      queryParams[AppRoutes.gameModeParam] = gameMode;
    }
    if (difficulty != null) {
      queryParams[AppRoutes.difficultyParam] = difficulty;
    }
    if (player1 != null) {
      queryParams[AppRoutes.player1Param] = player1;
    }
    if (player2 != null) {
      queryParams[AppRoutes.player2Param] = player2;
    }
    if (firstMove != null) {
      queryParams[AppRoutes.firstMoveParam] = firstMove;
    }
    if (challengeId != null) {
      queryParams['challengeId'] = challengeId;
    }
    if (tournamentId != null) {
      queryParams['tournamentId'] = tournamentId;
    }

    await navigateTo(
      context,
      AppRoutes.setup,
      queryParameters: queryParams,
      transitionType: PageTransitionType.sharedAxisVertical,
    );
  }

  /// Navigate to game with parameters
  static Future<void> navigateToGame(
    BuildContext context, {
    int? boardSize,
    int? winCondition,
    String? gameMode,
    String? difficulty,
    String? player1,
    String? player2,
    String? firstMove,
    String? gameId,
  }) async {
    final queryParams = <String, String>{};

    if (boardSize != null) {
      queryParams[AppRoutes.boardSizeParam] = boardSize.toString();
    }
    if (winCondition != null) {
      queryParams[AppRoutes.winConditionParam] = winCondition.toString();
    }
    if (gameMode != null) {
      queryParams[AppRoutes.gameModeParam] = gameMode;
    }
    if (difficulty != null) {
      queryParams[AppRoutes.difficultyParam] = difficulty;
    }
    if (player1 != null) {
      queryParams[AppRoutes.player1Param] = player1;
    }
    if (player2 != null) {
      queryParams[AppRoutes.player2Param] = player2;
    }
    if (firstMove != null) {
      queryParams[AppRoutes.firstMoveParam] = firstMove;
    }
    if (gameId != null) {
      queryParams['gameId'] = gameId;
    }

    await navigateTo(
      context,
      AppRoutes.game,
      queryParameters: queryParams,
      transitionType: PageTransitionType.sharedAxisVertical,
    );
  }

  /// Navigate to store with category filter
  static Future<void> navigateToStore(
    BuildContext context, {
    String? category,
    String? itemId,
  }) async {
    final queryParams = <String, String>{};

    if (category != null) {
      queryParams['category'] = category;
    }
    if (itemId != null) {
      queryParams['itemId'] = itemId;
    }

    await navigateTo(
      context,
      AppRoutes.store,
      queryParameters: queryParams,
      transitionType: PageTransitionType.sharedAxisHorizontal,
    );
  }

  /// Navigate to profile with user ID
  static Future<void> navigateToProfile(
    BuildContext context, {
    String? userId,
    String? leaderboardId,
  }) async {
    final queryParams = <String, String>{};

    if (userId != null) {
      queryParams['userId'] = userId;
    }
    if (leaderboardId != null) {
      queryParams['leaderboardId'] = leaderboardId;
    }

    await navigateTo(
      context,
      AppRoutes.profile,
      queryParameters: queryParams,
      transitionType: PageTransitionType.sharedAxisHorizontal,
    );
  }

  /// Navigate back with custom transition
  static Future<void> navigateBack(
    BuildContext context, {
    Object? result,
    PageTransitionType transitionType = PageTransitionType.fade,
  }) async {
    try {
      if (context.canPop()) {
        context.pop(result);
      } else {
        // Fallback to home if can't pop
        context.go(AppRoutes.home);
      }
    } on Exception catch (e) {
      debugPrint('Navigation back error: $e');
      context.go(AppRoutes.home);
    }
  }

  /// Navigate to home with transition
  static Future<void> navigateToHome(
    BuildContext context, {
    PageTransitionType transitionType = PageTransitionType.fade,
  }) async {
    await navigateTo(
      context,
      AppRoutes.home,
      transitionType: transitionType,
      replace: true,
    );
  }

  /// Navigate to settings
  static Future<void> navigateToSettings(
    BuildContext context, {
    PageTransitionType transitionType = PageTransitionType.sharedAxisHorizontal,
  }) async {
    await navigateTo(
      context,
      AppRoutes.settings,
      transitionType: transitionType,
    );
  }

  /// Generate shareable link for current content
  static String generateShareLink({
    required String type,
    required String id,
    Map<String, String>? additionalParams,
  }) {
    // Simplified share link generation without deep linking
    const baseUrl = 'https://xotictactoe.com/share';
    final params = <String, String>{
      'type': type,
      'id': id,
      ...?additionalParams,
    };

    final queryString = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '$baseUrl?$queryString';
  }

  /// Generate web share link for current content
  static String generateWebShareLink({
    required String type,
    required String id,
    Map<String, String>? additionalParams,
  }) =>
      // Same as regular share link for web
      generateShareLink(type: type, id: id, additionalParams: additionalParams);

  /// Check if route requires authentication
  static bool requiresAuth(String route) {
    // Add authentication logic here
    final protectedRoutes = [AppRoutes.profile, AppRoutes.settings];

    return protectedRoutes.contains(route);
  }

  /// Check if user can access route
  static Future<bool> canAccessRoute(
    BuildContext context,
    String route, {
    bool checkAuth = true,
    bool checkPermissions = true,
  }) async {
    try {
      // Check authentication if required
      if (checkAuth && requiresAuth(route)) {
        // Add your authentication check logic here
        // final isAuthenticated = await AuthService.instance.isAuthenticated();
        // if (!isAuthenticated) return false;
      }

      // Check permissions if required
      if (checkPermissions) {
        // Add your permission check logic here
        // final hasPermission = await PermissionService.instance.hasPermission(route);
        // if (!hasPermission) return false;
      }

      return true;
    } on Exception catch (e) {
      debugPrint('Route access check error: $e');
      return false;
    }
  }

  /// Get route by name
  static String? _getRouteByName(String routeName) {
    switch (routeName) {
      case AppRoutes.loadingName:
        return AppRoutes.loading;
      case AppRoutes.homeName:
        return AppRoutes.home;
      case AppRoutes.setupName:
        return AppRoutes.setup;
      case AppRoutes.gameName:
        return AppRoutes.game;
      case AppRoutes.storeName:
        return AppRoutes.store;
      case AppRoutes.profileName:
        return AppRoutes.profile;
      case AppRoutes.settingsName:
        return AppRoutes.settings;
      default:
        return null;
    }
  }

  /// Build path segments with parameters
  static List<String> _buildPathSegments(
    String route,
    Map<String, String>? pathParameters,
  ) {
    if (pathParameters == null) {
      return route.split('/').where((s) => s.isNotEmpty).toList();
    }

    final segments = route.split('/').where((s) => s.isNotEmpty).toList();
    final result = <String>[];

    for (final segment in segments) {
      if (segment.startsWith(':') && segment.length > 1) {
        final paramName = segment.substring(1);
        final paramValue = pathParameters[paramName];
        if (paramValue != null) {
          result.add(paramValue);
        } else {
          result.add(segment);
        }
      } else {
        result.add(segment);
      }
    }

    return result;
  }

  /// Log navigation for analytics
  static void _logNavigation(
    String route,
    Map<String, String>? queryParameters,
    PageTransitionType transitionType,
  ) {
    debugPrint('Navigation: $route');
    if (queryParameters != null) {
      debugPrint('Parameters: $queryParameters');
    }
    debugPrint('Transition: $transitionType');

    // Add your analytics logging here
    // AnalyticsService.instance.logNavigation(route, queryParameters, transitionType);
  }
}

/// Navigation analytics service
class NavigationAnalyticsService {
  static final NavigationAnalyticsService _instance =
      NavigationAnalyticsService._();
  static NavigationAnalyticsService get instance => _instance;

  NavigationAnalyticsService._();

  /// Log navigation event
  void logNavigation({
    required String route,
    required PageTransitionType transitionType,
    Map<String, String>? parameters,
    Duration? duration,
  }) {
    // Add your analytics implementation here
    debugPrint('Navigation Analytics: $route, $transitionType, $duration');
  }

  /// Log route error
  void logRouteError({
    required String route,
    required String error,
    StackTrace? stackTrace,
  }) {
    // Add your error logging implementation here
    debugPrint('Route Error: $route - $error');
    if (stackTrace != null) {
      debugPrint('Stack Trace: $stackTrace');
    }
  }

  /// Log deep link usage
  void logDeepLink({
    required Uri uri,
    required String resolvedRoute,
    Duration? resolutionTime,
  }) {
    // Add your deep link analytics implementation here
    debugPrint(
      'Deep Link: $uri -> $resolvedRoute (${resolutionTime?.inMilliseconds}ms)',
    );
  }
}

/// Navigation state provider
final navigationStateProvider =
    StateNotifierProvider<NavigationStateNotifier, NavigationState>(
      (ref) => NavigationStateNotifier(),
    );

/// Navigation state notifier
class NavigationStateNotifier extends StateNotifier<NavigationState> {
  NavigationStateNotifier() : super(NavigationState.initial());

  void setCurrentRoute(String route) {
    state = state.copyWith(
      currentRoute: route,
      previousRoute: state.currentRoute,
      lastNavigationTime: DateTime.now(),
    );
  }

  void addToHistory(String route) {
    final newHistory = List<String>.from(state.navigationHistory)..add(route);
    if (newHistory.length > 20) {
      newHistory.removeAt(0); // Keep only last 20 routes
    }
    state = state.copyWith(navigationHistory: newHistory);
  }

  void setNavigationError(String error) {
    state = state.copyWith(lastError: error, lastErrorTime: DateTime.now());
  }

  void clearNavigationError() {
    state = state.copyWith();
  }

  void incrementNavigationCount() {
    state = state.copyWith(totalNavigations: state.totalNavigations + 1);
  }
}

/// Navigation state data class
class NavigationState {
  final String currentRoute;
  final String? previousRoute;
  final List<String> navigationHistory;
  final DateTime lastNavigationTime;
  final String? lastError;
  final DateTime? lastErrorTime;
  final int totalNavigations;

  const NavigationState({
    required this.currentRoute,
    required this.navigationHistory,
    required this.lastNavigationTime,
    required this.totalNavigations,
    this.previousRoute,
    this.lastError,
    this.lastErrorTime,
  });

  factory NavigationState.initial() => NavigationState(
    currentRoute: AppRoutes.loading,
    navigationHistory: [AppRoutes.loading],
    lastNavigationTime: DateTime.now(),
    totalNavigations: 0,
  );

  NavigationState copyWith({
    String? currentRoute,
    String? previousRoute,
    List<String>? navigationHistory,
    DateTime? lastNavigationTime,
    String? lastError,
    DateTime? lastErrorTime,
    int? totalNavigations,
  }) => NavigationState(
    currentRoute: currentRoute ?? this.currentRoute,
    previousRoute: previousRoute ?? this.previousRoute,
    navigationHistory: navigationHistory ?? this.navigationHistory,
    lastNavigationTime: lastNavigationTime ?? this.lastNavigationTime,
    lastError: lastError ?? this.lastError,
    lastErrorTime: lastErrorTime ?? this.lastErrorTime,
    totalNavigations: totalNavigations ?? this.totalNavigations,
  );
}
