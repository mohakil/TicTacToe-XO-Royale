import 'package:flutter/material.dart';

class AppDimensions {
  // Private constructor to prevent instantiation
  AppDimensions._();

  // Base spacing unit (4-pt system)
  static const double _baseUnit = 4;

  // Spacing tokens
  static const double spacing4 = _baseUnit;
  static const double spacing8 = _baseUnit * 2;
  static const double spacing12 = _baseUnit * 3;
  static const double spacing16 = _baseUnit * 4;
  static const double spacing20 = _baseUnit * 5;
  static const double spacing24 = _baseUnit * 6;
  static const double spacing32 = _baseUnit * 8;
  static const double spacing40 = _baseUnit * 10;
  static const double spacing48 = _baseUnit * 12;
  static const double spacing64 = _baseUnit * 16;
  static const double spacing80 = _baseUnit * 20;
  static const double spacing96 = _baseUnit * 24;

  // Border radius tokens
  static const double radius4 = _baseUnit;
  static const double radius8 = _baseUnit * 2;
  static const double radius12 = _baseUnit * 3;
  static const double radius16 = _baseUnit * 4;
  static const double radius20 = _baseUnit * 5;
  static const double radius24 = _baseUnit * 6;
  static const double radius32 = _baseUnit * 8;

  // Icon sizes
  static const double iconSize16 = _baseUnit * 4;
  static const double iconSize20 = _baseUnit * 5;
  static const double iconSize24 = _baseUnit * 6;
  static const double iconSize28 = _baseUnit * 7;
  static const double iconSize32 = _baseUnit * 8;
  static const double iconSize40 = _baseUnit * 10;
  static const double iconSize48 = _baseUnit * 12;
  static const double iconSize56 = _baseUnit * 14;
  static const double iconSize64 = _baseUnit * 16;

  // Button sizes
  static const double buttonHeight48 = _baseUnit * 12;
  static const double buttonHeight56 = _baseUnit * 14;
  static const double buttonHeight64 = _baseUnit * 16;
  static const double buttonMinWidth = 120;
  static const double buttonMaxWidth = 400;

  // Input field sizes
  static const double inputHeight48 = _baseUnit * 12;
  static const double inputHeight56 = _baseUnit * 14;
  static const double inputHeight64 = _baseUnit * 16;
  static const double inputMinWidth = 200;
  static const double inputMaxWidth = 400;

  // Card sizes
  static const double cardMinHeight = 120;
  static const double cardMaxHeight = 400;
  static const double cardMinWidth = 200;
  static const double cardMaxWidth = 600;

  // Game board dimensions
  static const double boardMinSize = 280;
  static const double boardMaxSize = 600;
  static const double boardAspectRatio = 1; // Square
  static const double cellMinSize = 80;
  static const double cellMaxSize = 120;
  static const double cellBorderWidth = 2;
  static const double cellCornerRadius = 8;

  // Screen breakpoints
  static const double phoneBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  static const double largeTabletBreakpoint = 1200;

  // Responsive sizing multipliers
  static const double phoneMultiplier = 1;
  static const double tabletMultiplier = 1.2;
  static const double largeTabletMultiplier = 1.4;
  static const double desktopMultiplier = 1.6;

  // Safe area insets
  static const double safeAreaTop = 24;
  static const double safeAreaBottom = 24;
  static const double safeAreaLeft = 16;
  static const double safeAreaRight = 16;

  // App bar dimensions
  static const double appBarHeight = 56;
  static const double appBarHeightLarge = 64;
  static const double appBarElevation = 0;

  // Bottom navigation dimensions
  static const double bottomNavHeight = 80;
  static const double bottomNavHeightLarge = 96;
  static const double bottomNavElevation = 8;

  // Navigation rail dimensions
  static const double navRailWidth = 72;
  static const double navRailWidthExpanded = 200;
  static const double navRailElevation = 1;

  // Dialog dimensions
  static const double dialogMinWidth = 280;
  static const double dialogMaxWidth = 560;
  static const double dialogMinHeight = 200;
  static const double dialogMaxHeight = 600;
  static const double dialogElevation = 24;

  // Snackbar dimensions
  static const double snackbarHeight = 48;
  static const double snackbarElevation = 6;
  static const double snackbarMargin = 16;

  // Tooltip dimensions
  static const double tooltipMaxWidth = 200;
  static const double tooltipElevation = 6;
  static const double tooltipMargin = 8;

  // Floating action button dimensions
  static const double fabSize = 56;
  static const double fabSizeLarge = 64;
  static const double fabSizeSmall = 40;
  static const double fabElevation = 6;

  // Progress indicator dimensions
  static const double progressIndicatorSize = 40;
  static const double progressIndicatorSizeLarge = 56;
  static const double progressIndicatorStrokeWidth = 4;

  // Divider dimensions
  static const double dividerThickness = 1;
  static const double dividerIndent = 16;
  static const double dividerEndIndent = 16;

  // List tile dimensions
  static const double listTileHeight = 56;
  static const double listTileHeightDense = 48;
  static const double listTileHeightLarge = 72;
  static const double listTileLeadingWidth = 40;
  static const double listTileTrailingWidth = 40;

  // Chip dimensions
  static const double chipHeight = 32;
  static const double chipHeightLarge = 40;
  static const double chipMinWidth = 80;

  // Avatar dimensions
  static const double avatarSize = 40;
  static const double avatarSizeLarge = 56;
  static const double avatarSizeSmall = 32;

  // Badge dimensions
  static const double badgeSize = 16;
  static const double badgeSizeLarge = 20;
  static const double badgeSizeSmall = 12;

  // Helper methods for responsive sizing
  static double getResponsiveSize(double baseSize, double scaleFactor) =>
      baseSize * scaleFactor;

  static double getPhoneSize(double baseSize) => baseSize * phoneMultiplier;

  static double getTabletSize(double baseSize) => baseSize * tabletMultiplier;

  static double getLargeTabletSize(double baseSize) =>
      baseSize * largeTabletMultiplier;

  static double getDesktopSize(double baseSize) => baseSize * desktopMultiplier;

  // Helper methods for screen size detection
  static bool isPhone(BuildContext context) =>
      MediaQuery.of(context).size.width < phoneBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= phoneBreakpoint && width < tabletBreakpoint;
  }

  static bool isLargeTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= tabletBreakpoint && width < largeTabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopBreakpoint;

  // Helper methods for orientation detection
  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  // Helper methods for safe area handling
  static EdgeInsets getSafeAreaInsets(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.padding;
  }

  static double getTopSafeArea(BuildContext context) =>
      MediaQuery.of(context).padding.top;

  static double getBottomSafeArea(BuildContext context) =>
      MediaQuery.of(context).padding.bottom;

  static double getLeftSafeArea(BuildContext context) =>
      MediaQuery.of(context).padding.left;

  static double getRightSafeArea(BuildContext context) =>
      MediaQuery.of(context).padding.right;

  // Helper methods for game board sizing
  static double getBoardSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final minDimension = size.width < size.height ? size.width : size.height;

    if (isPhone(context)) {
      return (minDimension * 0.8).clamp(boardMinSize, boardMaxSize);
    } else if (isTablet(context)) {
      return (minDimension * 0.7).clamp(boardMinSize, boardMaxSize);
    } else {
      return (minDimension * 0.6).clamp(boardMinSize, boardMaxSize);
    }
  }

  static double getCellSize(BuildContext context, int boardSize) {
    final boardDimension = getBoardSize(context);
    final cellDimension =
        (boardDimension - (boardSize - 1) * cellBorderWidth) / boardSize;
    return cellDimension.clamp(cellMinSize, cellMaxSize);
  }

  // Helper methods for spacing
  static EdgeInsets getPadding({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    if (all != null) {
      return EdgeInsets.all(all);
    }
    return EdgeInsets.only(
      left: left ?? horizontal ?? 0,
      top: top ?? vertical ?? 0,
      right: right ?? horizontal ?? 0,
      bottom: bottom ?? vertical ?? 0,
    );
  }

  static EdgeInsets getMargin({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    if (all != null) {
      return EdgeInsets.all(all);
    }
    return EdgeInsets.only(
      left: left ?? horizontal ?? 0,
      top: top ?? vertical ?? 0,
      right: right ?? horizontal ?? 0,
      bottom: bottom ?? vertical ?? 0,
    );
  }
}
