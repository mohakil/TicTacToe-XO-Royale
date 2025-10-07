import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/app/theme/color_schemes.dart';
import 'package:tictactoe_xo_royale/app/theme/theme_extensions.dart';
import 'package:tictactoe_xo_royale/app/theme/typography.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Light theme
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: AppColorSchemes.light,
    textTheme: AppTypography.textTheme,
    extensions: const [
      GameColors.light,
      MotionDurations.defaultDurations,
      MotionEasings.defaultEasings,
      GameElevations.defaultElevations,
    ],

    // Material 3 component theming
    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(8),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),

    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 12),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD6DAE3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD6DAE3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF2DD4FF), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: Color(0xFF0F1722),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: Color(0xFFFFFFFF),
      selectedItemColor: Color(0xFF2DD4FF),
      unselectedItemColor: Color(0xFF3C4657),
      type: BottomNavigationBarType.fixed,
    ),

    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      backgroundColor: const Color(0xFFFFFFFF),
      indicatorColor: const Color(0xFFC7F3FF),
      labelTextStyle: WidgetStateProperty.all(
        AppTypography.labelMedium.copyWith(color: const Color(0xFF3C4657)),
      ),
      // selectedLabelTextStyle removed - not available in NavigationBarThemeData
    ),

    dialogTheme: DialogThemeData(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: const Color(0xFFFFFFFF),
    ),

    snackBarTheme: SnackBarThemeData(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: const Color(0xFF0F1722),
      contentTextStyle: AppTypography.bodyMedium.copyWith(
        color: const Color(0xFFFFFFFF),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: Color(0xFFD6DAE3),
      thickness: 1,
      space: 1,
    ),

    iconTheme: const IconThemeData(color: Color(0xFF3C4657), size: 24),

    primaryIconTheme: const IconThemeData(color: Color(0xFF2DD4FF), size: 24),
  );

  // Dark theme
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: AppColorSchemes.dark,
    textTheme: AppTypography.textTheme,
    extensions: const [
      GameColors.dark,
      MotionDurations.defaultDurations,
      MotionEasings.defaultEasings,
      GameElevations.defaultElevations,
    ],

    // Material 3 component theming
    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(8),
      color: const Color(0xFF111722),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),

    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 12),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF223041)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF223041)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF7DE9FF), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFF87171)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      fillColor: const Color(0xFF111722),
      filled: true,
    ),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: Color(0xFFE6ECF7),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: Color(0xFF111722),
      selectedItemColor: Color(0xFF7DE9FF),
      unselectedItemColor: Color(0xFF9AA6B8),
      type: BottomNavigationBarType.fixed,
    ),

    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      backgroundColor: const Color(0xFF111722),
      indicatorColor: const Color(0xFF123847),
      labelTextStyle: WidgetStateProperty.all(
        AppTypography.labelMedium.copyWith(color: const Color(0xFF9AA6B8)),
      ),
      // selectedLabelTextStyle removed - not available in NavigationBarThemeData
    ),

    dialogTheme: DialogThemeData(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: const Color(0xFF111722),
    ),

    snackBarTheme: SnackBarThemeData(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: const Color(0xFFE6ECF7),
      contentTextStyle: AppTypography.bodyMedium.copyWith(
        color: const Color(0xFF0B0F14),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: Color(0xFF223041),
      thickness: 1,
      space: 1,
    ),

    iconTheme: const IconThemeData(color: Color(0xFF9AA6B8), size: 24),

    primaryIconTheme: const IconThemeData(color: Color(0xFF7DE9FF), size: 24),
  );

  // Helper method to get theme based on brightness
  static ThemeData getTheme(Brightness brightness) =>
      brightness == Brightness.light ? lightTheme : darkTheme;

  // Helper method to get responsive theme adjustments
  static ThemeData getResponsiveTheme(
    ThemeData baseTheme,
    double scaleFactor,
  ) => baseTheme.copyWith(
    textTheme: baseTheme.textTheme.apply(
      bodyColor: baseTheme.textTheme.bodyLarge?.color,
      displayColor: baseTheme.textTheme.displayLarge?.color,
      fontSizeFactor: scaleFactor,
    ),
  );
}
