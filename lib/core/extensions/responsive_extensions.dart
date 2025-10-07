import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/utils/responsive_config.dart';

/// Extension methods for BuildContext to provide clean responsive API
extension ResponsiveBuildContext on BuildContext {
  /// Access to responsive configuration
  ResponsiveConfig get responsive => ResponsiveConfig.instance;

  /// Gets current device type
  DeviceType get deviceType => responsive.getDeviceType(this);

  /// Gets responsive scaling factor
  double get scaleFactor => responsive.getScaleFactor(this);

  /// Scales a size value based on current device
  double scale(double baseSize) => responsive.scaleSize(baseSize, this);

  /// Scales size with minimum and maximum bounds
  double scaleWithBounds(double baseSize, {double? minSize, double? maxSize}) =>
      responsive.scaleSizeWithBounds(
        baseSize,
        this,
        minSize: minSize,
        maxSize: maxSize,
      );

  /// Checks if device is in landscape orientation
  bool get isLandscape => responsive.isLandscape(this);

  /// Checks if device is in portrait orientation
  bool get isPortrait => responsive.isPortrait(this);

  /// Gets safe area insets
  EdgeInsets get safeArea => responsive.getSafeAreaInsets(this);

  /// Gets top safe area height
  double get topSafeArea => responsive.getTopSafeArea(this);

  /// Gets bottom safe area height
  double get bottomSafeArea => responsive.getBottomSafeArea(this);

  /// Gets left safe area width
  double get leftSafeArea => responsive.getLeftSafeArea(this);

  /// Gets right safe area width
  double get rightSafeArea => responsive.getRightSafeArea(this);

  /// Checks if current device is phone
  bool get isPhone => responsive.isPhone(this);

  /// Checks if current device is tablet
  bool get isTablet => responsive.isTablet(this);

  /// Gets current screen width
  double get screenWidth => responsive.getScreenWidth(this);

  /// Gets current screen height
  double get screenHeight => responsive.getScreenHeight(this);

  /// Gets screen aspect ratio
  double get aspectRatio => responsive.getAspectRatio(this);

  /// Checks if screen is considered wide
  bool get isWideScreen => responsive.isWideScreen(this);

  /// Checks if screen is considered narrow
  bool get isNarrowScreen => responsive.isNarrowScreen(this);

  /// Gets appropriate grid cross axis count (Mobile & Tablet only)
  int getGridCrossAxisCount({int phoneCount = 1, int tabletCount = 2}) =>
      responsive.getGridCrossAxisCount(
        this,
        phoneCount: phoneCount,
        tabletCount: tabletCount,
      );

  /// Gets responsive padding (Mobile & Tablet only)
  EdgeInsets getResponsivePadding({
    double phonePadding = 16.0,
    double tabletPadding = 24.0,
  }) => responsive.getResponsivePadding(
    this,
    phonePadding: phonePadding,
    tabletPadding: tabletPadding,
  );

  /// Gets responsive spacing (Mobile & Tablet only)
  double getResponsiveSpacing({
    double phoneSpacing = 16.0,
    double tabletSpacing = 24.0,
  }) => responsive.getResponsiveSpacing(
    this,
    phoneSpacing: phoneSpacing,
    tabletSpacing: tabletSpacing,
  );

  /// Gets responsive font size (Mobile & Tablet only)
  double getResponsiveFontSize({
    double phoneSize = 14.0,
    double tabletSize = 16.0,
  }) => responsive.getResponsiveFontSize(
    this,
    phoneSize: phoneSize,
    tabletSize: tabletSize,
  );

  /// Gets responsive text style with system scaling support
  TextStyle getResponsiveTextStyle(
    TextStyle baseStyle, {
    double? phoneSize,
    double? tabletSize,
  }) => responsive.getResponsiveTextStyle(
    this,
    baseStyle,
    phoneSize: phoneSize,
    tabletSize: tabletSize,
  );

  /// Gets system text scale factor
  double get textScaleFactor => responsive.getTextScaleFactor(this);

  /// Checks if text scaling is enabled
  bool get isTextScalingEnabled => responsive.isTextScalingEnabled(this);

  /// Gets responsive animation duration based on device type
  Duration getResponsiveAnimationDuration({
    Duration phoneDuration = const Duration(milliseconds: 250),
    Duration tabletDuration = const Duration(milliseconds: 300),
  }) => responsive.getResponsiveAnimationDuration(
    this,
    phoneDuration: phoneDuration,
    tabletDuration: tabletDuration,
  );

  /// Gets responsive icon size based on device type
  double getResponsiveIconSize({
    double phoneSize = 24.0,
    double tabletSize = 28.0,
  }) => responsive.getResponsiveIconSize(
    this,
    phoneSize: phoneSize,
    tabletSize: tabletSize,
  );

  /// Gets responsive button height based on device type
  double getResponsiveButtonHeight({
    double phoneHeight = 48.0,
    double tabletHeight = 56.0,
  }) => responsive.getResponsiveButtonHeight(
    this,
    phoneHeight: phoneHeight,
    tabletHeight: tabletHeight,
  );

  /// Gets minimum touch target size (48dp minimum for accessibility)
  double get minimumTouchTargetSize =>
      responsive.getMinimumTouchTargetSize(this);

  /// Checks if current device has notch/safe area
  bool get hasNotch => responsive.hasNotch(this);

  /// Gets responsive list item height
  double getResponsiveListItemHeight({
    double phoneHeight = 56.0,
    double tabletHeight = 64.0,
  }) => responsive.getResponsiveListItemHeight(
    this,
    phoneHeight: phoneHeight,
    tabletHeight: tabletHeight,
  );

  /// Gets responsive card elevation based on device type
  double getResponsiveCardElevation({
    double phoneElevation = 2.0,
    double tabletElevation = 4.0,
  }) => responsive.getResponsiveCardElevation(
    this,
    phoneElevation: phoneElevation,
    tabletElevation: tabletElevation,
  );

  /// Gets platform-adaptive border radius based on device type
  BorderRadius getResponsiveBorderRadius({
    double phoneRadius = 8.0,
    double tabletRadius = 12.0,
  }) => responsive.getResponsiveBorderRadius(
    this,
    phoneRadius: phoneRadius,
    tabletRadius: tabletRadius,
  );

  /// Gets responsive app bar height based on device type
  double getResponsiveAppBarHeight({
    double phoneHeight = 56.0,
    double tabletHeight = 64.0,
  }) => responsive.getResponsiveAppBarHeight(
    this,
    phoneHeight: phoneHeight,
    tabletHeight: tabletHeight,
  );

  /// Gets responsive dialog width based on device type
  double getResponsiveDialogWidth({
    double phoneWidth = 320.0,
    double tabletWidth = 400.0,
  }) => responsive.getResponsiveDialogWidth(
    this,
    phoneWidth: phoneWidth,
    tabletWidth: tabletWidth,
  );

  /// Gets responsive navigation icon size
  double get navigationIconSize => responsive.getNavigationIconSize(this);

  /// Gets responsive floating action button size
  double getResponsiveFabSize({
    double phoneSize = 56.0,
    double tabletSize = 64.0,
  }) => responsive.getResponsiveFabSize(
    this,
    phoneSize: phoneSize,
    tabletSize: tabletSize,
  );

  /// Gets responsive chip spacing
  double getResponsiveChipSpacing({
    double phoneSpacing = 8.0,
    double tabletSpacing = 12.0,
  }) => responsive.getResponsiveChipSpacing(
    this,
    phoneSpacing: phoneSpacing,
    tabletSpacing: tabletSpacing,
  );

  /// Gets responsive text field height
  double getResponsiveTextFieldHeight({
    double phoneHeight = 48.0,
    double tabletHeight = 56.0,
  }) => responsive.getResponsiveTextFieldHeight(
    this,
    phoneHeight: phoneHeight,
    tabletHeight: tabletHeight,
  );
}

/// Extension methods for double values to provide responsive scaling
extension ResponsiveDouble on double {
  /// Scales this double value based on current device context
  double scale(BuildContext context) =>
      ResponsiveConfig.instance.scaleSize(this, context);

  /// Scales with bounds
  double scaleWithBounds(BuildContext context, {double? min, double? max}) =>
      ResponsiveConfig.instance.scaleSizeWithBounds(
        this,
        context,
        minSize: min,
        maxSize: max,
      );
}
