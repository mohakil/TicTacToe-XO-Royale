import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/app/constants/dimensions.dart';
import 'package:tictactoe_xo_royale/core/utils/responsive_builder.dart';

/// Adaptive padding that adjusts based on screen size and safe areas
class AdaptivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool respectSafeArea;
  final bool respectKeyboard;
  final EdgeInsets? minimumPadding;

  const AdaptivePadding({
    required this.child,
    super.key,
    this.padding,
    this.margin,
    this.respectSafeArea = true,
    this.respectKeyboard = true,
    this.minimumPadding,
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final mediaQuery = MediaQuery.of(context);
      final size = mediaQuery.size;
      final safeAreaInsets = mediaQuery.padding;
      final viewInsets = mediaQuery.viewInsets;

      // Determine screen size category
      ScreenSize screenSize;
      if (size.width < AppDimensions.phoneBreakpoint) {
        screenSize = ScreenSize.phone;
      } else if (size.width < AppDimensions.tabletBreakpoint) {
        screenSize = ScreenSize.tablet;
      } else if (size.width < AppDimensions.largeTabletBreakpoint) {
        screenSize = ScreenSize.largeTablet;
      } else {
        screenSize = ScreenSize.desktop;
      }

      // Calculate adaptive padding
      final adaptivePadding = _calculateAdaptivePadding(
        screenSize,
        safeAreaInsets,
        viewInsets,
        padding,
        minimumPadding,
      );

      // Calculate adaptive margin
      final adaptiveMargin = _calculateAdaptiveMargin(screenSize, margin);

      return Container(
        margin: adaptiveMargin,
        padding: adaptivePadding,
        child: child,
      );
    },
  );

  /// Calculate adaptive padding based on screen size and safe areas
  EdgeInsets _calculateAdaptivePadding(
    ScreenSize screenSize,
    EdgeInsets safeAreaInsets,
    EdgeInsets viewInsets,
    EdgeInsets? customPadding,
    EdgeInsets? minimumPadding,
  ) {
    // Base padding based on screen size
    EdgeInsets basePadding;
    switch (screenSize) {
      case ScreenSize.phone:
        basePadding = const EdgeInsets.all(16);
        break;
      case ScreenSize.tablet:
        basePadding = const EdgeInsets.all(24);
        break;
      case ScreenSize.largeTablet:
        basePadding = const EdgeInsets.all(32);
        break;
      case ScreenSize.desktop:
        basePadding = const EdgeInsets.all(40);
        break;
    }

    // Apply custom padding if provided
    if (customPadding != null) {
      basePadding = customPadding;
    }

    // Apply safe area adjustments
    var finalPadding = basePadding;
    if (respectSafeArea) {
      finalPadding = EdgeInsets.only(
        left: basePadding.left + safeAreaInsets.left,
        top: basePadding.top + safeAreaInsets.top,
        right: basePadding.right + safeAreaInsets.right,
        bottom: basePadding.bottom + safeAreaInsets.bottom,
      );
    }

    // Apply keyboard adjustments
    if (respectKeyboard && viewInsets.bottom > 0) {
      finalPadding = finalPadding.copyWith(
        bottom: finalPadding.bottom + viewInsets.bottom,
      );
    }

    // Apply minimum padding constraints
    if (minimumPadding != null) {
      finalPadding = EdgeInsets.only(
        left: finalPadding.left.clamp(minimumPadding.left, double.infinity),
        top: finalPadding.top.clamp(minimumPadding.top, double.infinity),
        right: finalPadding.right.clamp(minimumPadding.right, double.infinity),
        bottom: finalPadding.bottom.clamp(
          minimumPadding.bottom,
          double.infinity,
        ),
      );
    }

    return finalPadding;
  }

  /// Calculate adaptive margin based on screen size
  EdgeInsets _calculateAdaptiveMargin(
    ScreenSize screenSize,
    EdgeInsets? customMargin,
  ) {
    if (customMargin != null) {
      return customMargin;
    }

    switch (screenSize) {
      case ScreenSize.phone:
        return const EdgeInsets.all(8);
      case ScreenSize.tablet:
        return const EdgeInsets.all(16);
      case ScreenSize.largeTablet:
        return const EdgeInsets.all(24);
      case ScreenSize.desktop:
        return const EdgeInsets.all(32);
    }
  }
}

// Screen size categories are defined in responsive_builder.dart

/// Convenience widgets for common padding patterns
class AdaptivePaddingWidgets {
  /// Horizontal padding that adapts to screen size
  Widget horizontalAdaptivePadding({
    required BuildContext context,
    required Widget child,
    double? left,
    double? right,
    bool respectSafeArea = true,
  }) => LayoutBuilder(
    builder: (context, constraints) {
      final size = constraints.maxWidth;
      ScreenSize screenSize;
      if (size < AppDimensions.phoneBreakpoint) {
        screenSize = ScreenSize.phone;
      } else if (size < AppDimensions.tabletBreakpoint) {
        screenSize = ScreenSize.tablet;
      } else if (size < AppDimensions.largeTabletBreakpoint) {
        screenSize = ScreenSize.largeTablet;
      } else {
        screenSize = ScreenSize.desktop;
      }

      final padding = _getHorizontalPadding(screenSize, left, right);
      final mediaQuery = MediaQuery.of(context);
      final safeAreaInsets = mediaQuery.padding;

      return Padding(
        padding: EdgeInsets.only(
          left: respectSafeArea
              ? padding.left + safeAreaInsets.left
              : padding.left,
          right: respectSafeArea
              ? padding.right + safeAreaInsets.right
              : padding.right,
        ),
        child: child,
      );
    },
  );

  /// Horizontal padding that adapts to screen size
  static Widget horizontal({
    required BuildContext context,
    required Widget child,
    double? left,
    double? right,
    bool respectSafeArea = true,
  }) => LayoutBuilder(
    builder: (context, constraints) {
      final size = constraints.maxWidth;
      ScreenSize screenSize;
      if (size < AppDimensions.phoneBreakpoint) {
        screenSize = ScreenSize.phone;
      } else if (size < AppDimensions.tabletBreakpoint) {
        screenSize = ScreenSize.tablet;
      } else if (size < AppDimensions.largeTabletBreakpoint) {
        screenSize = ScreenSize.largeTablet;
      } else {
        screenSize = ScreenSize.desktop;
      }

      final padding = _getHorizontalPadding(screenSize, left, right);
      final mediaQuery = MediaQuery.of(context);
      final safeAreaInsets = mediaQuery.padding;

      return Padding(
        padding: EdgeInsets.only(
          left: respectSafeArea
              ? padding.left + safeAreaInsets.left
              : padding.left,
          right: respectSafeArea
              ? padding.right + safeAreaInsets.right
              : padding.right,
        ),
        child: child,
      );
    },
  );

  /// Vertical padding that adapts to screen size
  static Widget vertical({
    required BuildContext context,
    required Widget child,
    double? top,
    double? bottom,
    bool respectSafeArea = true,
  }) => LayoutBuilder(
    builder: (context, constraints) {
      final size = constraints.maxHeight;
      ScreenSize screenSize;
      if (size < 600) {
        // Height-based breakpoint
        screenSize = ScreenSize.phone;
      } else if (size < 900) {
        screenSize = ScreenSize.tablet;
      } else if (size < 1200) {
        screenSize = ScreenSize.largeTablet;
      } else {
        screenSize = ScreenSize.desktop;
      }

      final padding = _getVerticalPadding(screenSize, top, bottom);
      final mediaQuery = MediaQuery.of(context);
      final safeAreaInsets = mediaQuery.padding;

      return Padding(
        padding: EdgeInsets.only(
          top: respectSafeArea ? padding.top + safeAreaInsets.top : padding.top,
          bottom: respectSafeArea
              ? padding.bottom + safeAreaInsets.bottom
              : padding.bottom,
        ),
        child: child,
      );
    },
  );

  /// All-around padding that adapts to screen size
  static Widget all({
    required BuildContext context,
    required Widget child,
    double? padding,
    bool respectSafeArea = true,
  }) => LayoutBuilder(
    builder: (context, constraints) {
      final size = constraints.maxWidth;
      ScreenSize screenSize;
      if (size < AppDimensions.phoneBreakpoint) {
        screenSize = ScreenSize.phone;
      } else if (size < AppDimensions.tabletBreakpoint) {
        screenSize = ScreenSize.tablet;
      } else if (size < AppDimensions.largeTabletBreakpoint) {
        screenSize = ScreenSize.largeTablet;
      } else {
        screenSize = ScreenSize.desktop;
      }

      final adaptivePadding = padding ?? _getAllPadding(screenSize);
      final mediaQuery = MediaQuery.of(context);
      final safeAreaInsets = mediaQuery.padding;

      return Padding(
        padding: respectSafeArea
            ? EdgeInsets.all(adaptivePadding) + safeAreaInsets
            : EdgeInsets.all(adaptivePadding),
        child: child,
      );
    },
  );

  /// Get horizontal padding based on screen size
  static EdgeInsets _getHorizontalPadding(
    ScreenSize screenSize,
    double? left,
    double? right,
  ) {
    final basePadding = _getBasePadding(screenSize);
    return EdgeInsets.only(
      left: left ?? basePadding,
      right: right ?? basePadding,
    );
  }

  /// Get vertical padding based on screen size
  static EdgeInsets _getVerticalPadding(
    ScreenSize screenSize,
    double? top,
    double? bottom,
  ) {
    final basePadding = _getBasePadding(screenSize);
    return EdgeInsets.only(
      top: top ?? basePadding,
      bottom: bottom ?? basePadding,
    );
  }

  /// Get all-around padding based on screen size
  static double _getAllPadding(ScreenSize screenSize) =>
      _getBasePadding(screenSize);

  /// Get base padding value for a screen size
  static double _getBasePadding(ScreenSize screenSize) {
    switch (screenSize) {
      case ScreenSize.phone:
        return 16;
      case ScreenSize.tablet:
        return 24;
      case ScreenSize.largeTablet:
        return 32;
      case ScreenSize.desktop:
        return 40;
    }
  }
}

/// Extension methods for easier adaptive padding usage
extension AdaptivePaddingExtension on Widget {
  /// Add adaptive horizontal padding
  Widget adaptiveHorizontalPadding(
    BuildContext context, {
    double? left,
    double? right,
    bool respectSafeArea = true,
  }) => AdaptivePaddingWidgets.horizontal(
    context: context,
    child: this,
    left: left,
    right: right,
    respectSafeArea: respectSafeArea,
  );

  /// Add adaptive vertical padding
  Widget adaptiveVerticalPadding(
    BuildContext context, {
    double? top,
    double? bottom,
    bool respectSafeArea = true,
  }) => AdaptivePaddingWidgets.vertical(
    context: context,
    child: this,
    top: top,
    bottom: bottom,
    respectSafeArea: respectSafeArea,
  );

  /// Add adaptive all-around padding
  Widget adaptivePadding(
    BuildContext context, {
    double? padding,
    bool respectSafeArea = true,
  }) => AdaptivePaddingWidgets.all(
    context: context,
    child: this,
    padding: padding,
    respectSafeArea: respectSafeArea,
  );
}
