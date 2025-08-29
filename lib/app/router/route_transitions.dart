import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ignore: avoid_classes_with_only_static_members
/// Custom route transitions for the TicTacToe XO Royale app
/// Implements shared axis and fade transitions as specified in the PRD
class AppRouteTransitions {
  // Transition durations based on Material 3 specifications
  static const Duration _shortDuration = Duration(milliseconds: 200);
  static const Duration _mediumDuration = Duration(milliseconds: 300);
  static const Duration _longDuration = Duration(milliseconds: 400);

  // Transition curves for smooth animations
  static const Curve _easeInOut = Curves.easeInOut;
  static const Curve _easeOut = Curves.easeOutCubic;

  /// Shared axis transition for horizontal navigation
  /// Used for main navigation between tabs (home, store, profile, settings)
  static PageRouteBuilder<T> sharedAxisHorizontal<T>({
    required Widget child,
    bool reverse = false,
  }) => PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1, 0);
      const end = Offset.zero;
      const curve = _easeInOut;

      var tween = Tween(begin: begin, end: end);
      if (reverse) {
        tween = Tween(begin: -begin, end: end);
      }

      final offsetAnimation = animation.drive(
        tween.chain(CurveTween(curve: curve)),
      );

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );

  /// Shared axis transition for vertical navigation
  /// Used for game-related navigation (setup -> game, home -> setup)
  static PageRouteBuilder<T> sharedAxisVertical<T>({
    required Widget child,
    bool reverse = false,
  }) => PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0, 1);
      const end = Offset.zero;
      const curve = _easeInOut;

      var tween = Tween(begin: begin, end: end);
      if (reverse) {
        tween = Tween(begin: -begin, end: end);
      }

      final offsetAnimation = animation.drive(
        tween.chain(CurveTween(curve: curve)),
      );

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );

  /// Fade transition for loading and utility screens
  /// Used for loading screen and modal overlays
  static PageRouteBuilder<T> fade<T>({
    required Widget child,
    Duration? duration,
  }) => PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(
          opacity: animation.drive(
            Tween<double>(
              begin: 0,
              end: 1,
            ).chain(CurveTween(curve: _easeInOut)),
          ),
          child: child,
        ),
    transitionDuration: duration ?? _shortDuration,
    reverseTransitionDuration: duration ?? _shortDuration,
  );

  /// Scale transition for game setup and store items
  /// Used for interactive elements and detailed views
  static PageRouteBuilder<T> scale<T>({
    required Widget child,
    Duration? duration,
  }) => PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        ScaleTransition(
          scale: animation.drive(
            Tween<double>(
              begin: 0.8,
              end: 1,
            ).chain(CurveTween(curve: _easeOut)),
          ),
          child: FadeTransition(
            opacity: animation.drive(
              Tween<double>(
                begin: 0,
                end: 1,
              ).chain(CurveTween(curve: _easeInOut)),
            ),
            child: child,
          ),
        ),
    transitionDuration: duration ?? _mediumDuration,
    reverseTransitionDuration: duration ?? _mediumDuration,
  );

  /// Hero transition for game board and profile elements
  /// Used for seamless transitions between related screens
  static PageRouteBuilder<T> hero<T>({
    required Widget child,
    required String tag,
    Duration? duration,
  }) => PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) =>
        Hero(tag: tag, child: child),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(
          opacity: animation.drive(
            Tween<double>(
              begin: 0,
              end: 1,
            ).chain(CurveTween(curve: _easeInOut)),
          ),
          child: child,
        ),
    transitionDuration: duration ?? _longDuration,
    reverseTransitionDuration: duration ?? _longDuration,
  );

  /// Combined transition for complex navigation
  /// Combines multiple transition effects for premium feel
  static PageRouteBuilder<T> combined<T>({
    required Widget child,
    Duration? duration,
  }) => PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
          position: animation.drive(
            Tween(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).chain(CurveTween(curve: _easeOut)),
          ),
          child: FadeTransition(
            opacity: animation.drive(
              Tween<double>(
                begin: 0,
                end: 1,
              ).chain(CurveTween(curve: _easeInOut)),
            ),
            child: ScaleTransition(
              scale: animation.drive(
                Tween<double>(
                  begin: 0.95,
                  end: 1,
                ).chain(CurveTween(curve: _easeOut)),
              ),
              child: child,
            ),
          ),
        ),
    transitionDuration: duration ?? _longDuration,
    reverseTransitionDuration: duration ?? _longDuration,
  );
}

/// Extension methods for GoRouter to use custom transitions
extension GoRouterTransitionExtension on GoRouter {
  /// Navigate with custom transition
  void pushWithTransition(
    BuildContext context,
    String location, {
    Object? extra,
    PageTransitionType transitionType = PageTransitionType.fade,
    Duration? duration,
  }) {
    final pageBuilder = _getPageBuilder(
      location,
      extra,
      transitionType,
      duration,
    );
    Navigator.of(context).push(pageBuilder);
  }

  /// Replace with custom transition
  void replaceWithTransition(
    BuildContext context,
    String location, {
    Object? extra,
    PageTransitionType transitionType = PageTransitionType.fade,
    Duration? duration,
  }) {
    final pageBuilder = _getPageBuilder(
      location,
      extra,
      transitionType,
      duration,
    );
    Navigator.of(context).pushReplacement(pageBuilder);
  }

  PageRouteBuilder<dynamic> _getPageBuilder(
    String location,
    Object? extra,
    PageTransitionType transitionType,
    Duration? duration,
  ) {
    final child = _buildChild(location, extra);

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
          tag: location,
          duration: duration,
        );
      case PageTransitionType.combined:
        return AppRouteTransitions.combined(child: child, duration: duration);
    }
  }

  // ignore: prefer_expression_function_bodies
  Widget _buildChild(String location, Object? extra) {
    // This is a simplified implementation
    // In a real app, you'd want to properly resolve the route
    return const Scaffold(body: Center(child: Text('Transition Screen')));
  }
}

/// Enum for different transition types
enum PageTransitionType {
  sharedAxisHorizontal,
  sharedAxisVertical,
  fade,
  scale,
  hero,
  combined,
}

/// Transition configuration for specific routes
class RouteTransitionConfig {
  final PageTransitionType type;
  final Duration? duration;
  final Curve? curve;
  final bool reverse;

  const RouteTransitionConfig({
    required this.type,
    this.duration,
    this.curve,
    this.reverse = false,
  });

  /// Default transitions for different route types
  static const Map<String, RouteTransitionConfig> defaults = {
    '/loading': RouteTransitionConfig(
      type: PageTransitionType.fade,
      duration: Duration(milliseconds: 200),
    ),
    '/home': RouteTransitionConfig(
      type: PageTransitionType.combined,
      duration: Duration(milliseconds: 400),
    ),
    '/setup': RouteTransitionConfig(
      type: PageTransitionType.sharedAxisVertical,
      duration: Duration(milliseconds: 300),
    ),
    '/game': RouteTransitionConfig(
      type: PageTransitionType.hero,
      duration: Duration(milliseconds: 500),
    ),
    '/store': RouteTransitionConfig(
      type: PageTransitionType.sharedAxisHorizontal,
      duration: Duration(milliseconds: 300),
    ),
    '/profile': RouteTransitionConfig(
      type: PageTransitionType.sharedAxisHorizontal,
      duration: Duration(milliseconds: 300),
    ),
    '/settings': RouteTransitionConfig(
      type: PageTransitionType.sharedAxisHorizontal,
      duration: Duration(milliseconds: 300),
    ),
  };

  /// Get transition config for a specific route
  static RouteTransitionConfig getForRoute(String route) =>
      defaults[route] ??
      const RouteTransitionConfig(type: PageTransitionType.fade);
}
