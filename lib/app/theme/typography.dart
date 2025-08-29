import 'package:flutter/material.dart';

class AppTypography {
  // Font families
  static const String _soraFamily = 'Sora';
  static const String _interFamily = 'Inter';
  static const String _jetBrainsMonoFamily = 'JetBrainsMono';

  // Display and Heading styles (Sora Variable)
  static const TextStyle displayLarge = TextStyle(
    fontSize: 44,
    height: 52 / 44,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
    fontFamily: _soraFamily,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 36,
    height: 44 / 36,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    fontFamily: _soraFamily,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 28,
    height: 36 / 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    fontFamily: _soraFamily,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    fontFamily: _soraFamily,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    fontFamily: _soraFamily,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    fontFamily: _soraFamily,
  );

  // Body styles (Inter Variable)
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w500,
    fontFamily: _interFamily,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w500,
    fontFamily: _interFamily,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
    fontFamily: _interFamily,
  );

  // Label styles (Inter Variable)
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
    fontFamily: _interFamily,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    fontFamily: _interFamily,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    height: 16 / 11,
    fontWeight: FontWeight.w600,
    fontFamily: _interFamily,
  );

  // Scoreboard digits (JetBrains Mono)
  static const TextStyle scoreboardDigits = TextStyle(
    fontSize: 42,
    height: 48 / 42,
    fontWeight: FontWeight.w700,
    fontFamily: _jetBrainsMonoFamily,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle scoreboardDigitsLarge = TextStyle(
    fontSize: 56,
    height: 64 / 56,
    fontWeight: FontWeight.w700,
    fontFamily: _jetBrainsMonoFamily,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // X/O glyphs (Sora Variable)
  static const TextStyle gameMarkX = TextStyle(
    fontSize: 48,
    height: 56 / 48,
    fontWeight: FontWeight.w700,
    fontFamily: _soraFamily,
    letterSpacing: -0.5,
  );

  static const TextStyle gameMarkO = TextStyle(
    fontSize: 48,
    height: 56 / 48,
    fontWeight: FontWeight.w700,
    fontFamily: _soraFamily,
    letterSpacing: -0.5,
  );

  // Create TextTheme for Material 3
  static TextTheme get textTheme => const TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );

  // Helper method to scale typography based on text scale factor
  static TextStyle scaleTextStyle(TextStyle baseStyle, double scaleFactor) =>
      baseStyle.copyWith(fontSize: baseStyle.fontSize! * scaleFactor);

  // Helper method to get tablet-optimized typography
  static TextStyle getTabletStyle(TextStyle baseStyle) =>
      baseStyle.copyWith(fontSize: baseStyle.fontSize! + 2);

  // Helper method to get large tablet-optimized typography
  static TextStyle getLargeTabletStyle(TextStyle baseStyle) =>
      baseStyle.copyWith(fontSize: baseStyle.fontSize! + 4);
}
