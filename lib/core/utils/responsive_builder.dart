import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/app/constants/dimensions.dart';

/// Responsive layout builder that adapts to different screen sizes and orientations
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ResponsiveLayout layout) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = ResponsiveLayout.fromConstraints(constraints);
        return builder(context, layout);
      },
    );
  }
}

/// Responsive layout information based on screen size and orientation
class ResponsiveLayout {
  final ScreenSize screenSize;
  final Orientation orientation;
  final Size size;
  final EdgeInsets safeAreaInsets;

  const ResponsiveLayout({
    required this.screenSize,
    required this.orientation,
    required this.size,
    required this.safeAreaInsets,
  });

  factory ResponsiveLayout.fromContext(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final orientation = mediaQuery.orientation;
    final safeAreaInsets = mediaQuery.padding;

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

    return ResponsiveLayout(
      screenSize: screenSize,
      orientation: orientation,
      size: size,
      safeAreaInsets: safeAreaInsets,
    );
  }

  factory ResponsiveLayout.fromConstraints(BoxConstraints constraints) {
    final size = Size(constraints.maxWidth, constraints.maxHeight);
    final orientation = size.width > size.height
        ? Orientation.landscape
        : Orientation.portrait;

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

    return ResponsiveLayout(
      screenSize: screenSize,
      orientation: orientation,
      size: size,
      safeAreaInsets: EdgeInsets.zero, // Not available from constraints
    );
  }

  /// Check if current layout is phone
  bool get isPhone => screenSize == ScreenSize.phone;

  /// Check if current layout is tablet
  bool get isTablet =>
      screenSize == ScreenSize.tablet || screenSize == ScreenSize.largeTablet;

  /// Check if current layout is desktop
  bool get isDesktop => screenSize == ScreenSize.desktop;

  /// Check if current layout is portrait
  bool get isPortrait => orientation == Orientation.portrait;

  /// Check if current layout is landscape
  bool get isLandscape => orientation == Orientation.landscape;

  /// Get responsive padding based on screen size
  EdgeInsets get responsivePadding {
    switch (screenSize) {
      case ScreenSize.phone:
        return const EdgeInsets.all(16.0);
      case ScreenSize.tablet:
        return const EdgeInsets.all(24.0);
      case ScreenSize.largeTablet:
        return const EdgeInsets.all(32.0);
      case ScreenSize.desktop:
        return const EdgeInsets.all(40.0);
    }
  }

  /// Get responsive margin based on screen size
  EdgeInsets get responsiveMargin {
    switch (screenSize) {
      case ScreenSize.phone:
        return const EdgeInsets.all(8.0);
      case ScreenSize.tablet:
        return const EdgeInsets.all(16.0);
      case ScreenSize.largeTablet:
        return const EdgeInsets.all(24.0);
      case ScreenSize.desktop:
        return const EdgeInsets.all(32.0);
    }
  }

  /// Get responsive spacing between elements
  double get responsiveSpacing {
    switch (screenSize) {
      case ScreenSize.phone:
        return 16.0;
      case ScreenSize.tablet:
        return 24.0;
      case ScreenSize.largeTablet:
        return 32.0;
      case ScreenSize.desktop:
        return 40.0;
    }
  }

  /// Get responsive border radius
  double get responsiveBorderRadius {
    switch (screenSize) {
      case ScreenSize.phone:
        return 12.0;
      case ScreenSize.tablet:
        return 16.0;
      case ScreenSize.largeTablet:
        return 20.0;
      case ScreenSize.desktop:
        return 24.0;
    }
  }

  /// Get responsive icon size
  double get responsiveIconSize {
    switch (screenSize) {
      case ScreenSize.phone:
        return 24.0;
      case ScreenSize.tablet:
        return 28.0;
      case ScreenSize.largeTablet:
        return 32.0;
      case ScreenSize.desktop:
        return 36.0;
    }
  }

  /// Get responsive button height
  double get responsiveButtonHeight {
    switch (screenSize) {
      case ScreenSize.phone:
        return 48.0;
      case ScreenSize.tablet:
        return 56.0;
      case ScreenSize.largeTablet:
        return 64.0;
      case ScreenSize.desktop:
        return 72.0;
    }
  }

  /// Get responsive text scale factor
  double get responsiveTextScale {
    switch (screenSize) {
      case ScreenSize.phone:
        return 1.0;
      case ScreenSize.tablet:
        return 1.1;
      case ScreenSize.largeTablet:
        return 1.2;
      case ScreenSize.desktop:
        return 1.3;
    }
  }

  /// Get responsive column count for grid layouts
  int get responsiveColumnCount {
    if (isPhone) {
      return isPortrait ? 1 : 2;
    } else if (isTablet) {
      return isPortrait ? 2 : 3;
    } else {
      return isPortrait ? 3 : 4;
    }
  }

  /// Get responsive board size multiplier
  double get responsiveBoardMultiplier {
    if (isPhone) {
      return 0.8;
    } else if (isTablet) {
      return 0.7;
    } else {
      return 0.6;
    }
  }

  /// Get responsive navigation type
  NavigationType get responsiveNavigationType {
    if (isPhone) {
      return NavigationType.bottomBar;
    } else if (isTablet) {
      return isPortrait ? NavigationType.bottomBar : NavigationType.rail;
    } else {
      return NavigationType.rail;
    }
  }
}

/// Screen size categories
enum ScreenSize { phone, tablet, largeTablet, desktop }

/// Navigation type based on screen size
enum NavigationType { bottomBar, rail, drawer }

/// Responsive widget builders for common patterns
class ResponsiveWidgets {
  /// Build responsive grid with appropriate column count
  static Widget responsiveGrid({
    required BuildContext context,
    required List<Widget> children,
    double spacing = 16.0,
    double runSpacing = 16.0,
    EdgeInsets? padding,
  }) {
    return ResponsiveBuilder(
      builder: (context, layout) {
        final columnCount = layout.responsiveColumnCount;
        final responsivePadding = padding ?? layout.responsivePadding;

        return Padding(
          padding: responsivePadding,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              crossAxisSpacing: spacing,
              mainAxisSpacing: runSpacing,
              childAspectRatio: 1.0,
            ),
            itemCount: children.length,
            itemBuilder: (context, index) => children[index],
          ),
        );
      },
    );
  }

  /// Build responsive list with appropriate spacing
  static Widget responsiveList({
    required BuildContext context,
    required List<Widget> children,
    double spacing = 16.0,
    EdgeInsets? padding,
    ScrollPhysics? physics,
  }) {
    return ResponsiveBuilder(
      builder: (context, layout) {
        final responsivePadding = padding ?? layout.responsivePadding;

        return Padding(
          padding: responsivePadding,
          child: ListView.separated(
            itemCount: children.length,
            separatorBuilder: (context, index) => SizedBox(height: spacing),
            itemBuilder: (context, index) => children[index],
            physics: physics,
          ),
        );
      },
    );
  }

  /// Build responsive card with appropriate sizing
  static Widget responsiveCard({
    required BuildContext context,
    required Widget child,
    EdgeInsets? margin,
    EdgeInsets? padding,
    double? elevation,
    double? borderRadius,
  }) {
    return ResponsiveBuilder(
      builder: (context, layout) {
        final responsiveMargin = margin ?? layout.responsiveMargin;
        final responsivePadding = padding ?? layout.responsivePadding;
        final responsiveElevation = elevation ?? (layout.isPhone ? 2.0 : 4.0);
        final responsiveBorderRadius =
            borderRadius ?? layout.responsiveBorderRadius;

        return Card(
          margin: responsiveMargin,
          elevation: responsiveElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsiveBorderRadius),
          ),
          child: Padding(padding: responsivePadding, child: child),
        );
      },
    );
  }

  /// Build responsive button with appropriate sizing
  static Widget responsiveButton({
    required BuildContext context,
    required Widget child,
    VoidCallback? onPressed,
    EdgeInsets? padding,
    double? height,
    double? borderRadius,
  }) {
    return ResponsiveBuilder(
      builder: (context, layout) {
        final responsivePadding =
            padding ??
            EdgeInsets.symmetric(
              horizontal: layout.responsivePadding.left,
              vertical: layout.responsivePadding.top,
            );
        final responsiveHeight = height ?? layout.responsiveButtonHeight;
        final responsiveBorderRadius =
            borderRadius ?? layout.responsiveBorderRadius;

        return SizedBox(
          height: responsiveHeight,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              padding: responsivePadding,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(responsiveBorderRadius),
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
