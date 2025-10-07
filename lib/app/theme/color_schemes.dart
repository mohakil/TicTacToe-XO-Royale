import 'package:flutter/material.dart';

class AppColorSchemes {
  // Light Mode ColorScheme
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    // Neutral surfaces
    surface: Color(0xFFF7F8FB),
    surfaceContainer: Color(0xFFFFFFFF),
    surfaceDim: Color(0xFFEDEFF5),
    outline: Color(0xFFD6DAE3),
    onSurface: Color(0xFF0F1722),
    onSurfaceVariant: Color(0xFF3C4657),

    // Accents
    primary: Color(0xFF2DD4FF), // Electric Azure
    onPrimary: Color(0xFF031318),
    primaryContainer: Color(0xFFC7F3FF),
    secondary: Color(0xFFF43F9D), // Vivid Magenta
    onSecondary: Color(0xFF190912),
    secondaryContainer: Color(0xFFFFD7EC),
    tertiary: Color(0xFFA3E635), // Lime Pulse for success
    onTertiary: Color(0xFF0E1605),

    // Semantic
    error: Color(0xFFEF4444),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFEE2E2),
    onErrorContainer: Color(0xFF7F1D1D),

    // Additional colors for Material 3
    inverseSurface: Color(0xFF0F1722),
    onInverseSurface: Color(0xFFF7F8FB),
    inversePrimary: Color(0xFF7DE9FF),
    surfaceTint: Color(0xFF2DD4FF),
    outlineVariant: Color(0xFFC7D1DC),
    scrim: Color(0xFF000000),
    shadow: Color(0xFF000000),
  );

  // Dark Mode ColorScheme
  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    // Neutral surfaces
    surface: Color(0xFF0B0F14),
    surfaceContainer: Color(0xFF111722),
    surfaceDim: Color(0xFF080B10),
    outline: Color(0xFF223041),
    onSurface: Color(0xFFE6ECF7),
    onSurfaceVariant: Color(0xFF9AA6B8),

    // Accents
    primary: Color(0xFF7DE9FF),
    onPrimary: Color(0xFF001217),
    primaryContainer: Color(0xFF123847),
    secondary: Color(0xFFFF73C5),
    onSecondary: Color(0xFF1C0514),
    secondaryContainer: Color(0xFF3B1029),
    tertiary: Color(0xFFB6F05A),
    onTertiary: Color(0xFF0B1503),

    // Semantic
    error: Color(0xFFF87171),
    onError: Color(0xFF000000),
    errorContainer: Color(0xFF7F1D1D),
    onErrorContainer: Color(0xFFFEE2E2),

    // Additional colors for Material 3
    inverseSurface: Color(0xFFE6ECF7),
    onInverseSurface: Color(0xFF0B0F14),
    inversePrimary: Color(0xFF2DD4FF),
    surfaceTint: Color(0xFF7DE9FF),
    outlineVariant: Color(0xFF3E4C5C),
    scrim: Color(0xFF000000),
    shadow: Color(0xFF000000),
  );

  // Game-specific colors
  static const Color gameWin = Color(0xFF22C55E);
  static const Color gameLoss = Color(0xFFEF4444);
  static const Color gameDraw = Color(0xFF6B7280);
  static const Color gameGem = Color(0xFFFFC24D);
  static const Color gameHint = Color(0xFFFFB020);
  static const Color gameBoardLine = Color(0xFFD6DAE3);
  static const Color gameCellHover = Color(0xFFF1F5F9);
  static const Color gameCellPressed = Color(0xFFE2E8F0);

  // Special effects
  static const Color glowCyan = Color(0xFF00E5FF);
  static const Color glowMagenta = Color(0xFFFF4D9D);

  // Gradients
  static const LinearGradient azureMagenta = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2DD4FF), Color(0xFFF43F9D)],
  );

  static const RadialGradient deepSpace = RadialGradient(
    radius: 1,
    colors: [Color(0xFFF7F8FB), Color(0xFFEDEFF5)],
  );
}
