import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_xo_royale/app/routing/app_routes.dart';

/// Navigation performance optimization utilities
///
/// Provides performance monitoring, caching, and optimization
/// for navigation operations throughout the application.
class NavigationPerformance {
  // Private constructor for utility class
  NavigationPerformance._();

  static final Map<String, Widget> _widgetCache = {};
  static final Map<String, DateTime> _lastAccessTime = {};
  static const int _maxCacheSize = 10;
  static const Duration _cacheExpiration = Duration(minutes: 5);

  /// Preloads critical routes for better performance
  static void preloadCriticalRoutes(BuildContext context) {
    if (!context.mounted) return;

    // Preload main navigation routes
    for (final route in AppRoutes.mainNavRoutes) {
      _preloadRoute(context, route);
    }

    // Preload setup route (frequently accessed)
    _preloadRoute(context, AppRoutes.setup);
  }

  /// Preloads a specific route
  static void _preloadRoute(BuildContext context, String route) {
    // This is a placeholder for route preloading logic
    // In a real implementation, you might:
    // - Pre-build route widgets
    // - Cache route configurations
    // - Preload data for routes

    debugPrint('Preloading route: $route');
  }

  /// Gets a cached widget for the given route
  static Widget? getCachedWidget(String route) {
    final lastAccess = _lastAccessTime[route];

    if (lastAccess != null) {
      if (DateTime.now().difference(lastAccess) > _cacheExpiration) {
        _widgetCache.remove(route);
        _lastAccessTime.remove(route);
        return null;
      }
    }

    return _widgetCache[route];
  }

  /// Caches a widget for the given route
  static void cacheWidget(String route, Widget widget) {
    if (_widgetCache.length >= _maxCacheSize) {
      _evictOldestCache();
    }

    _widgetCache[route] = widget;
    _lastAccessTime[route] = DateTime.now();
  }

  /// Evicts the oldest cached widget
  static void _evictOldestCache() {
    String? oldestKey;
    DateTime? oldestTime;

    for (final entry in _lastAccessTime.entries) {
      if (oldestTime == null || entry.value.isBefore(oldestTime)) {
        oldestTime = entry.value;
        oldestKey = entry.key;
      }
    }

    if (oldestKey != null) {
      _widgetCache.remove(oldestKey);
      _lastAccessTime.remove(oldestKey);
    }
  }

  /// Clears the widget cache
  static void clearCache() {
    _widgetCache.clear();
    _lastAccessTime.clear();
  }

  /// Optimizes navigation by checking if we can reuse cached widgets
  static Widget optimizeNavigation(
    BuildContext context,
    String route,
    Widget Function() builder,
  ) {
    // Check if we have a cached widget
    final cachedWidget = getCachedWidget(route);
    if (cachedWidget != null) {
      return cachedWidget;
    }

    // Build the widget and cache it for future use
    final widget = builder();
    cacheWidget(route, widget);
    return widget;
  }

  /// Measures navigation performance
  static Future<T> measureNavigation<T>(
    String operation,
    Future<T> Function() navigationOperation,
  ) async {
    final stopwatch = Stopwatch()..start();

    try {
      final result = await navigationOperation();
      stopwatch.stop();

      final duration = stopwatch.elapsedMilliseconds;
      debugPrint('Navigation "$operation" took ${duration}ms');

      // Log performance warnings
      if (duration > 100) {
        debugPrint('WARNING: Navigation "$operation" is slow (${duration}ms)');
      }

      return result;
    } catch (e) {
      stopwatch.stop();
      debugPrint(
        'Navigation "$operation" failed after ${stopwatch.elapsedMilliseconds}ms: $e',
      );
      rethrow;
    }
  }

  /// Checks if navigation should be optimized based on route patterns
  static bool shouldOptimizeNavigation(String fromRoute, String toRoute) {
    // Optimize navigation between main nav routes
    if (AppRoutes.isMainNavRoute(fromRoute) &&
        AppRoutes.isMainNavRoute(toRoute)) {
      return true;
    }

    // Don't optimize navigation to/from game (state preservation is important)
    if (fromRoute == AppRoutes.game || toRoute == AppRoutes.game) {
      return false;
    }

    // Optimize navigation to setup (frequently used)
    if (toRoute == AppRoutes.setup) {
      return true;
    }

    return false;
  }

  /// Gets performance metrics for monitoring
  static Map<String, dynamic> getPerformanceMetrics() {
    return {
      'cacheSize': _widgetCache.length,
      'maxCacheSize': _maxCacheSize,
      'cacheHitRatio': _widgetCache.isNotEmpty
          ? (_widgetCache.length /
                (_widgetCache.length + _lastAccessTime.length))
          : 0.0,
      'lastCleanup': _lastAccessTime.isNotEmpty
          ? _lastAccessTime.values
                .reduce((a, b) => a.isBefore(b) ? a : b)
                .toIso8601String()
          : null,
      'cachedRoutes': _widgetCache.keys.toList(),
    };
  }

  /// Provides navigation performance recommendations
  static List<String> getPerformanceRecommendations() {
    final recommendations = <String>[];
    final metrics = getPerformanceMetrics();

    if (metrics['cacheSize'] == 0) {
      recommendations.add(
        'Consider enabling widget caching for better performance',
      );
    }

    if (metrics['cacheHitRatio'] != null && metrics['cacheHitRatio'] < 0.5) {
      recommendations.add(
        'Cache hit ratio is low, consider adjusting cache strategy',
      );
    }

    if (metrics['cacheSize'] >= metrics['maxCacheSize']) {
      recommendations.add('Cache is at maximum capacity, monitor memory usage');
    }

    return recommendations;
  }

  /// Warms up the navigation system
  static Future<void> warmUpNavigation(BuildContext context) async {
    if (!context.mounted) return;

    debugPrint('Warming up navigation system...');

    // Preload critical routes
    await measureNavigation('Warmup', () async {
      preloadCriticalRoutes(context);

      // Note: Skip GoRouter validation during warmup as it may not be available yet
      // This will be handled naturally when routes are actually navigated to
    });

    debugPrint('Navigation system warmup complete');
  }

  /// Monitors navigation health
  static NavigationHealthReport checkNavigationHealth(BuildContext context) {
    if (!context.mounted) {
      return NavigationHealthReport(
        isHealthy: false,
        issues: ['Context is not mounted'],
        recommendations: [
          'Ensure navigation operations are performed with valid context',
        ],
      );
    }

    final issues = <String>[];
    final recommendations = <String>[];

    try {
      // Check router state
      final router = GoRouter.of(context);
      final currentLocation = router.routeInformationProvider.value.uri.path;

      // Check if current route is valid
      if (currentLocation.isEmpty) {
        issues.add('Current route is empty');
        recommendations.add('Ensure initial route is properly set');
      }

      // Check cache health
      final metrics = getPerformanceMetrics();
      if (metrics['cacheSize'] > metrics['maxCacheSize'] * 0.8) {
        recommendations.add(
          'Consider clearing navigation cache to free memory',
        );
      }

      // Add performance recommendations
      recommendations.addAll(getPerformanceRecommendations());

      return NavigationHealthReport(
        isHealthy: issues.isEmpty,
        currentRoute: currentLocation,
        issues: issues,
        recommendations: recommendations,
        metrics: metrics,
      );
    } catch (e) {
      return NavigationHealthReport(
        isHealthy: false,
        issues: ['Router access failed: $e'],
        recommendations: ['Check router configuration and context validity'],
      );
    }
  }
}

/// Navigation health report data class
class NavigationHealthReport {
  final bool isHealthy;
  final String? currentRoute;
  final List<String> issues;
  final List<String> recommendations;
  final Map<String, dynamic>? metrics;

  NavigationHealthReport({
    required this.isHealthy,
    this.currentRoute,
    required this.issues,
    required this.recommendations,
    this.metrics,
  });

  @override
  String toString() {
    return 'NavigationHealthReport(healthy: $isHealthy, route: $currentRoute, issues: ${issues.length})';
  }
}

/// Navigation performance observer
class NavigationPerformanceObserver extends NavigatorObserver {
  final List<NavigationEvent> _events = [];
  static const int _maxEvents = 50;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _recordEvent('push', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _recordEvent('pop', route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _recordEvent('replace', newRoute, oldRoute);
  }

  void _recordEvent(
    String action,
    Route<dynamic>? route,
    Route<dynamic>? previousRoute,
  ) {
    final event = NavigationEvent(
      action: action,
      route: route?.settings.name,
      previousRoute: previousRoute?.settings.name,
      timestamp: DateTime.now(),
    );

    _events.add(event);

    // Keep only recent events
    if (_events.length > _maxEvents) {
      _events.removeAt(0);
    }

    // Log performance warnings
    if (route is PageRoute) {
      final transitionDuration = route.transitionDuration;
      if (transitionDuration.inMilliseconds > 300) {
        debugPrint(
          'WARNING: Slow transition detected (${transitionDuration.inMilliseconds}ms) for route: ${route.settings.name}',
        );
      }
    }
  }

  /// Gets recent navigation events
  List<NavigationEvent> getRecentEvents({int limit = 10}) {
    return _events.reversed.take(limit).toList();
  }

  /// Gets navigation analytics
  NavigationAnalytics getAnalytics() {
    final pushCount = _events.where((e) => e.action == 'push').length;
    final popCount = _events.where((e) => e.action == 'pop').length;
    final replaceCount = _events.where((e) => e.action == 'replace').length;

    final routeCounts = <String, int>{};
    for (final event in _events) {
      if (event.route != null) {
        routeCounts[event.route!] = (routeCounts[event.route] ?? 0) + 1;
      }
    }

    return NavigationAnalytics(
      totalEvents: _events.length,
      pushCount: pushCount,
      popCount: popCount,
      replaceCount: replaceCount,
      routeCounts: routeCounts,
      mostRecentEvent: _events.isNotEmpty ? _events.last : null,
    );
  }

  /// Clears all events
  void clearEvents() {
    _events.clear();
  }
}

/// Navigation event data class
class NavigationEvent {
  final String action;
  final String? route;
  final String? previousRoute;
  final DateTime timestamp;

  NavigationEvent({
    required this.action,
    this.route,
    this.previousRoute,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'NavigationEvent(action: $action, route: $route, previous: $previousRoute, time: $timestamp)';
  }
}

/// Navigation analytics data class
class NavigationAnalytics {
  final int totalEvents;
  final int pushCount;
  final int popCount;
  final int replaceCount;
  final Map<String, int> routeCounts;
  final NavigationEvent? mostRecentEvent;

  NavigationAnalytics({
    required this.totalEvents,
    required this.pushCount,
    required this.popCount,
    required this.replaceCount,
    required this.routeCounts,
    this.mostRecentEvent,
  });

  /// Gets the most visited routes
  List<MapEntry<String, int>> getMostVisitedRoutes({int limit = 5}) {
    return routeCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
  }

  @override
  String toString() {
    return 'NavigationAnalytics(total: $totalEvents, pushes: $pushCount, pops: $popCount, replaces: $replaceCount)';
  }
}
