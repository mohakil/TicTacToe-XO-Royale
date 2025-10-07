import 'package:flutter/material.dart';

/// Device type enumeration for responsive design (Mobile & Tablet only)
enum DeviceType { phone, tablet }

/// Core responsive configuration manager
/// Provides global responsive utilities with singleton pattern
class ResponsiveConfig {
  // Singleton instance
  static ResponsiveConfig? _instance;
  static ResponsiveConfig get instance {
    _instance ??= ResponsiveConfig._();
    return _instance!;
  }

  // Private constructor for singleton
  ResponsiveConfig._();

  // Breakpoint definitions (Mobile & Tablet only)
  static const double phoneBreakpoint = 600;
  static const double tabletBreakpoint = 900;

  // Scaling multipliers (Mobile & Tablet only)
  static const double phoneMultiplier = 1.0;
  static const double tabletMultiplier = 1.2;

  /// Detects device type based on screen width (Mobile & Tablet only)
  DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < phoneBreakpoint) {
      return DeviceType.phone;
    } else {
      return DeviceType.tablet;
    }
  }

  /// Gets responsive scaling factor for current device (Mobile & Tablet only)
  double getScaleFactor(BuildContext context) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.phone:
        return phoneMultiplier;
      case DeviceType.tablet:
        return tabletMultiplier;
    }
  }

  /// Scales a base size value based on current device type
  double scaleSize(double baseSize, BuildContext context) {
    return baseSize * getScaleFactor(context);
  }

  /// Gets responsive size with minimum and maximum bounds
  double scaleSizeWithBounds(
    double baseSize,
    BuildContext context, {
    double? minSize,
    double? maxSize,
  }) {
    final scaledSize = scaleSize(baseSize, context);

    if (minSize != null && scaledSize < minSize) {
      return minSize;
    }

    if (maxSize != null && scaledSize > maxSize) {
      return maxSize;
    }

    return scaledSize;
  }

  /// Detects if device is in landscape orientation
  bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Detects if device is in portrait orientation
  bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Gets safe area insets for current context
  EdgeInsets getSafeAreaInsets(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Gets top safe area height
  double getTopSafeArea(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  /// Gets bottom safe area height
  double getBottomSafeArea(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  /// Gets left safe area width
  double getLeftSafeArea(BuildContext context) {
    return MediaQuery.of(context).padding.left;
  }

  /// Gets right safe area width
  double getRightSafeArea(BuildContext context) {
    return MediaQuery.of(context).padding.right;
  }

  /// Checks if current device is phone
  bool isPhone(BuildContext context) {
    return getDeviceType(context) == DeviceType.phone;
  }

  /// Checks if current device is tablet
  bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  /// Gets current screen width
  double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Gets current screen height
  double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Gets screen aspect ratio
  double getAspectRatio(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width / size.height;
  }

  /// Checks if screen is considered wide (good for tablets)
  bool isWideScreen(BuildContext context) {
    return getScreenWidth(context) >= tabletBreakpoint;
  }

  /// Checks if screen is considered narrow (phones in portrait)
  bool isNarrowScreen(BuildContext context) {
    return getScreenWidth(context) < phoneBreakpoint;
  }

  /// Gets appropriate grid cross axis count based on device type (Mobile & Tablet only)
  int getGridCrossAxisCount(
    BuildContext context, {
    int phoneCount = 1,
    int tabletCount = 2,
  }) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.phone:
        return phoneCount;
      case DeviceType.tablet:
        return tabletCount;
    }
  }

  /// Gets responsive padding based on device type (Mobile & Tablet only)
  EdgeInsets getResponsivePadding(
    BuildContext context, {
    double phonePadding = 16.0,
    double tabletPadding = 24.0,
  }) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.phone:
        return EdgeInsets.all(phonePadding);
      case DeviceType.tablet:
        return EdgeInsets.all(tabletPadding);
    }
  }

  /// Gets responsive spacing between elements (Mobile & Tablet only)
  double getResponsiveSpacing(
    BuildContext context, {
    double phoneSpacing = 16.0,
    double tabletSpacing = 24.0,
  }) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.phone:
        return phoneSpacing;
      case DeviceType.tablet:
        return tabletSpacing;
    }
  }

  /// Gets responsive font size (Mobile & Tablet only)
  double getResponsiveFontSize(
    BuildContext context, {
    double phoneSize = 14.0,
    double tabletSize = 16.0,
  }) {
    final deviceType = getDeviceType(context);
    final baseSize = deviceType == DeviceType.phone ? phoneSize : tabletSize;

    // Apply system text scaling factor (using textScaler for newer Flutter versions)
    final textScaleFactor = MediaQuery.of(context).textScaler.scale(1.0);

    return baseSize * textScaleFactor;
  }

  /// Gets responsive text style with system scaling support
  TextStyle getResponsiveTextStyle(
    BuildContext context,
    TextStyle baseStyle, {
    double? phoneSize,
    double? tabletSize,
  }) {
    final responsiveFontSize = getResponsiveFontSize(
      context,
      phoneSize: phoneSize ?? baseStyle.fontSize ?? 14.0,
      tabletSize:
          tabletSize ?? (baseStyle.fontSize ?? 14.0) * 1.14, // 14% larger
    );

    return baseStyle.copyWith(fontSize: responsiveFontSize);
  }

  /// Gets system text scale factor
  double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaler.scale(1.0);
  }

  /// Checks if text scaling is enabled
  bool isTextScalingEnabled(BuildContext context) {
    return MediaQuery.of(context).textScaler.scale(1.0) > 1.0;
  }

  /// Gets platform-specific animation duration based on device type
  Duration getResponsiveAnimationDuration(
    BuildContext context, {
    Duration phoneDuration = const Duration(milliseconds: 250),
    Duration tabletDuration = const Duration(milliseconds: 300),
  }) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.phone:
        return phoneDuration;
      case DeviceType.tablet:
        return tabletDuration;
    }
  }

  /// Gets responsive icon size based on device type
  double getResponsiveIconSize(
    BuildContext context, {
    double phoneSize = 24.0,
    double tabletSize = 28.0,
  }) {
    final deviceType = getDeviceType(context);
    final baseSize = deviceType == DeviceType.phone ? phoneSize : tabletSize;

    // Apply system text scaling to icons for consistency
    final textScaleFactor = MediaQuery.of(context).textScaler.scale(1.0);

    return baseSize * textScaleFactor;
  }

  /// Gets responsive button height based on device type
  double getResponsiveButtonHeight(
    BuildContext context, {
    double phoneHeight = 48.0,
    double tabletHeight = 56.0,
  }) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.phone:
        return phoneHeight;
      case DeviceType.tablet:
        return tabletHeight;
    }
  }

  /// Gets responsive minimum touch target size (48dp minimum for accessibility)
  double getMinimumTouchTargetSize(BuildContext context) {
    // Base minimum touch target is 48dp
    const baseMinSize = 48.0;

    // Scale with device but maintain minimum accessibility standard
    final scaledSize = scaleSize(baseMinSize, context);

    // Ensure minimum 48dp for accessibility
    return scaledSize < baseMinSize ? baseMinSize : scaledSize;
  }

  /// Checks if current device has notch/safe area
  bool hasNotch(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return padding.top > 20.0; // Most notches add >20dp top padding
  }

  /// Gets responsive list item height
  double getResponsiveListItemHeight(
    BuildContext context, {
    double phoneHeight = 56.0,
    double tabletHeight = 64.0,
  }) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.phone:
        return phoneHeight;
      case DeviceType.tablet:
        return tabletHeight;
    }
  }

  /// Gets responsive card elevation based on device type
  double getResponsiveCardElevation(
    BuildContext context, {
    double phoneElevation = 2.0,
    double tabletElevation = 4.0,
  }) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.phone:
        return phoneElevation;
      case DeviceType.tablet:
        return tabletElevation;
    }
  }

  /// Gets platform-adaptive border radius based on device type
  BorderRadius getResponsiveBorderRadius(
    BuildContext context, {
    double phoneRadius = 8.0,
    double tabletRadius = 12.0,
  }) {
    final deviceType = getDeviceType(context);
    final radius = deviceType == DeviceType.phone ? phoneRadius : tabletRadius;

    return BorderRadius.circular(radius);
  }

  /// Gets responsive app bar height based on device type
  double getResponsiveAppBarHeight(
    BuildContext context, {
    double phoneHeight = 56.0,
    double tabletHeight = 64.0,
  }) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.phone:
        return phoneHeight;
      case DeviceType.tablet:
        return tabletHeight;
    }
  }

  /// Gets responsive dialog width based on device type
  double getResponsiveDialogWidth(
    BuildContext context, {
    double phoneWidth = 320.0,
    double tabletWidth = 400.0,
  }) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.phone:
        return phoneWidth;
      case DeviceType.tablet:
        return tabletWidth;
    }
  }

  /// Gets responsive navigation icon size
  double getNavigationIconSize(BuildContext context) {
    return getResponsiveIconSize(context, phoneSize: 24.0, tabletSize: 28.0);
  }

  /// Gets responsive floating action button size
  double getResponsiveFabSize(
    BuildContext context, {
    double phoneSize = 56.0,
    double tabletSize = 64.0,
  }) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.phone:
        return phoneSize;
      case DeviceType.tablet:
        return tabletSize;
    }
  }

  /// Gets responsive chip spacing
  double getResponsiveChipSpacing(
    BuildContext context, {
    double phoneSpacing = 8.0,
    double tabletSpacing = 12.0,
  }) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.phone:
        return phoneSpacing;
      case DeviceType.tablet:
        return tabletSpacing;
    }
  }

  /// Gets responsive text field height
  double getResponsiveTextFieldHeight(
    BuildContext context, {
    double phoneHeight = 48.0,
    double tabletHeight = 56.0,
  }) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.phone:
        return phoneHeight;
      case DeviceType.tablet:
        return tabletHeight;
    }
  }
}
