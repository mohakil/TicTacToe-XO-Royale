import 'package:flutter/material.dart';

/// Utility class for dynamic type support and accessibility
class DynamicTypeSupport {
  /// Get scaled text style that respects system text scale factor
  /// Ensures no truncation occurs when text is scaled
  static TextStyle getScaledTextStyle({
    required TextStyle baseStyle,
    required BuildContext context,
    double? minScale,
    double? maxScale,
    bool allowOverflow = false,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final textScaler = mediaQuery.textScaler;

    // Apply scale factor with optional bounds
    final effectiveScale = textScaler
        .scale(1.0)
        .clamp(minScale ?? 0.8, maxScale ?? 2.0);

    return baseStyle.copyWith(
      fontSize: baseStyle.fontSize != null
          ? baseStyle.fontSize! * effectiveScale
          : null,
      height: baseStyle.height != null
          ? baseStyle.height! * effectiveScale
          : null,
      // Ensure text doesn't get cut off
      overflow: allowOverflow ? TextOverflow.visible : TextOverflow.ellipsis,
    );
  }

  /// Get responsive text style that adapts to screen size and text scale
  static TextStyle getResponsiveTextStyle({
    required TextStyle baseStyle,
    required BuildContext context,
    required DynamicTypeScreenSize screenSize,
    double? minScale,
    double? maxScale,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final textScaler = mediaQuery.textScaler;

    // Base responsive scaling based on screen size
    double responsiveScale = 1.0;
    switch (screenSize) {
      case DynamicTypeScreenSize.phone:
        responsiveScale = 1.0;
        break;
      case DynamicTypeScreenSize.tablet:
        responsiveScale = 1.1;
        break;
      case DynamicTypeScreenSize.largeTablet:
        responsiveScale = 1.2;
        break;
      case DynamicTypeScreenSize.desktop:
        responsiveScale = 1.3;
        break;
    }

    // Combine responsive and accessibility scaling
    final effectiveScale = (textScaler.scale(
      responsiveScale,
    )).clamp(minScale ?? 0.8, maxScale ?? 2.5);

    return baseStyle.copyWith(
      fontSize: baseStyle.fontSize != null
          ? baseStyle.fontSize! * effectiveScale
          : null,
      height: baseStyle.height != null
          ? baseStyle.height! * effectiveScale
          : null,
    );
  }

  /// Check if current text scale factor is within acceptable bounds
  static bool isTextScaleFactorAcceptable(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final textScaler = mediaQuery.textScaler;

    // Acceptable range: 0.8x to 2.0x
    return textScaler.scale(1.0) >= 0.8 && textScaler.scale(1.0) <= 2.0;
  }

  /// Get text scale factor status for debugging
  static String getTextScaleFactorStatus(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final textScaler = mediaQuery.textScaler;
    final scale = textScaler.scale(1.0);

    if (scale < 0.8) {
      return 'Text scale factor too small: ${scale.toStringAsFixed(2)}x';
    } else if (scale > 2.0) {
      return 'Text scale factor too large: ${scale.toStringAsFixed(2)}x';
    } else {
      return 'Text scale factor acceptable: ${scale.toStringAsFixed(2)}x';
    }
  }

  /// Create a text widget that automatically scales with system settings
  static Widget createScaledText({
    required String text,
    required TextStyle style,
    required BuildContext context,
    double? minScale,
    double? maxScale,
    TextAlign? textAlign,
    int? maxLines,
    bool softWrap = true,
    TextOverflow? overflow,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scaledStyle = getScaledTextStyle(
          baseStyle: style,
          context: context,
          minScale: minScale,
          maxScale: maxScale,
          allowOverflow: overflow == TextOverflow.visible,
        );

        return Text(
          text,
          style: scaledStyle,
          textAlign: textAlign,
          maxLines: maxLines,
          softWrap: softWrap,
          overflow: overflow ?? TextOverflow.ellipsis,
        );
      },
    );
  }

  /// Create a responsive text widget that adapts to screen size and text scale
  static Widget createResponsiveText({
    required String text,
    required TextStyle style,
    required BuildContext context,
    required DynamicTypeScreenSize screenSize,
    double? minScale,
    double? maxScale,
    TextAlign? textAlign,
    int? maxLines,
    bool softWrap = true,
    TextOverflow? overflow,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final responsiveStyle = getResponsiveTextStyle(
          baseStyle: style,
          context: context,
          screenSize: screenSize,
          minScale: minScale,
          maxScale: maxScale,
        );

        return Text(
          text,
          style: responsiveStyle,
          textAlign: textAlign,
          maxLines: maxLines,
          softWrap: softWrap,
          overflow: overflow ?? TextOverflow.ellipsis,
        );
      },
    );
  }

  /// Check if text will overflow given constraints and style
  static bool willTextOverflow({
    required String text,
    required TextStyle style,
    required Size constraints,
    required BuildContext context,
    int? maxLines,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
    );

    textPainter.layout(maxWidth: constraints.width);
    return textPainter.height > constraints.height;
  }

  /// Get recommended text size that fits within constraints
  static double getOptimalTextSize({
    required String text,
    required TextStyle baseStyle,
    required Size constraints,
    required BuildContext context,
    double minSize = 8.0,
    double maxSize = 72.0,
    int? maxLines,
  }) {
    double currentSize = maxSize;

    while (currentSize > minSize) {
      final testStyle = baseStyle.copyWith(fontSize: currentSize);
      final textPainter = TextPainter(
        text: TextSpan(text: text, style: testStyle),
        textDirection: TextDirection.ltr,
        maxLines: maxLines,
      );

      textPainter.layout(maxWidth: constraints.width);

      if (textPainter.height <= constraints.height) {
        break;
      }

      currentSize -= 1.0;
    }

    return currentSize.clamp(minSize, maxSize);
  }
}

/// Screen size categories for responsive text scaling
enum DynamicTypeScreenSize { phone, tablet, largeTablet, desktop }
