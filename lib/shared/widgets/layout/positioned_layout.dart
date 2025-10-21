import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';

/// A reusable widget for responsive positioning with safe area support.
///
/// Abstracts complex responsive positioning logic used throughout the app,
/// particularly in the game screen for HUD elements and overlays.
///
/// **Usage:**
/// ```dart
/// PositionedLayout(
///   position: LayoutPosition.top,
///   spacing: ResponsiveSpacing(phoneSpacing: 16.0, tabletSpacing: 20.0),
///   child: GameHeader(...),
/// )
/// ```
class PositionedLayout extends StatelessWidget {
  /// The child widget to position.
  final Widget child;

  /// The preset position for the layout.
  final LayoutPosition position;

  /// Custom top offset (used when position is LayoutPosition.custom).
  final double? top;

  /// Custom bottom offset (used when position is LayoutPosition.custom).
  final double? bottom;

  /// Custom left offset (used when position is LayoutPosition.custom).
  final double? left;

  /// Custom right offset (used when position is LayoutPosition.custom).
  final double? right;

  /// Responsive spacing configuration.
  final LayoutSpacing? spacing;

  /// Whether to use safe area for positioning.
  final bool useSafeArea;

  /// Custom width for the positioned widget.
  final double? width;

  /// Custom height for the positioned widget.
  final double? height;

  /// Whether to use RepaintBoundary for performance optimization.
  final bool useRepaintBoundary;

  const PositionedLayout({
    required this.child,
    this.position = LayoutPosition.custom,
    this.top,
    this.bottom,
    this.left,
    this.right,
    LayoutSpacing? spacing,
    this.useSafeArea = true,
    this.width,
    this.height,
    this.useRepaintBoundary = false,
    super.key,
  }) : spacing = spacing ?? const LayoutSpacing();

  @override
  Widget build(BuildContext context) {
    final positionedChild = _buildPositionedChild(context);

    // Apply RepaintBoundary if requested
    if (useRepaintBoundary) {
      return RepaintBoundary(child: positionedChild);
    }

    return positionedChild;
  }

  Widget _buildPositionedChild(BuildContext context) {
    final positionData = _calculatePosition(context);

    return Positioned(
      top: positionData.top,
      bottom: positionData.bottom,
      left: positionData.left,
      right: positionData.right,
      width: width,
      height: height,
      child: child,
    );
  }

  _PositionData _calculatePosition(BuildContext context) {
    switch (position) {
      case LayoutPosition.top:
        final phoneSpacing = spacing?.phoneSpacing ?? 16.0;
        return _PositionData(
          top: useSafeArea
              ? context.topSafeArea + context.scale(phoneSpacing)
              : context.scale(phoneSpacing),
        );

      case LayoutPosition.bottom:
        final phoneSpacing = spacing?.phoneSpacing ?? 16.0;
        return _PositionData(
          bottom: useSafeArea
              ? context.bottomSafeArea + context.scale(phoneSpacing)
              : context.scale(phoneSpacing),
        );

      case LayoutPosition.center:
        return _PositionData(
          top: top ?? _getCenterTop(context),
          left: left ?? _getCenterLeft(context),
          right: right ?? _getCenterRight(context),
          bottom: bottom ?? _getCenterBottom(context),
        );

      case LayoutPosition.gameBoard:
        return _PositionData(
          top: useSafeArea
              ? context.topSafeArea + context.scale(context.screenHeight * 0.35)
              : context.scale(context.screenHeight * 0.35),
          left: 0,
          right: 0,
        );

      case LayoutPosition.gameHUD:
        return _PositionData(
          top: useSafeArea
              ? context.topSafeArea + context.scale(context.screenHeight * 0.05)
              : context.scale(context.screenHeight * 0.05),
          left: 0,
          right: 0,
        );

      case LayoutPosition.gameControls:
        return _PositionData(
          top: useSafeArea
              ? context.topSafeArea - context.scale(6.0)
              : -context.scale(6.0),
          left: context.scale(16.0),
        );

      case LayoutPosition.custom:
        return _PositionData(
          top: top,
          bottom: bottom,
          left: left,
          right: right,
        );
    }
  }

  double _getCenterTop(BuildContext context) {
    return (context.screenHeight - (height ?? 0)) / 2;
  }

  double _getCenterLeft(BuildContext context) {
    return (context.screenWidth - (width ?? 0)) / 2;
  }

  double _getCenterRight(BuildContext context) {
    return _getCenterLeft(context);
  }

  double _getCenterBottom(BuildContext context) {
    return _getCenterTop(context);
  }
}

class _PositionData {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const _PositionData({this.top, this.bottom, this.left, this.right});
}

/// Preset positions for common layout scenarios.
enum LayoutPosition {
  /// Position at the top of the screen.
  top,

  /// Position at the bottom of the screen.
  bottom,

  /// Position at the center of the screen.
  center,

  /// Position for game board (centered with responsive margins).
  gameBoard,

  /// Position for game HUD (top area with player info).
  gameHUD,

  /// Position for game controls (top-left close button area).
  gameControls,

  /// Custom position using explicit top/bottom/left/right values.
  custom,
}

/// Configuration for responsive spacing values.
class LayoutSpacing {
  /// Spacing value for phone screens.
  final double phoneSpacing;

  /// Spacing value for tablet screens.
  final double tabletSpacing;

  const LayoutSpacing({this.phoneSpacing = 16.0, this.tabletSpacing = 20.0});

  /// Get the appropriate spacing value for the current context.
  double getValue(BuildContext context) {
    return context.scale(phoneSpacing);
  }

  /// Create a copy with modified values.
  LayoutSpacing copyWith({double? phoneSpacing, double? tabletSpacing}) {
    return LayoutSpacing(
      phoneSpacing: phoneSpacing ?? this.phoneSpacing,
      tabletSpacing: tabletSpacing ?? this.tabletSpacing,
    );
  }
}
