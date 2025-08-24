import 'package:flutter/material.dart';
import 'color_schemes.dart';
import 'typography.dart';
import 'theme_extensions.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorSchemes.light,
      textTheme: AppTypography.textTheme,
      extensions: [
        GameColors.light,
        MotionDurations.defaultDurations,
        MotionEasings.defaultEasings,
        GameElevations.defaultElevations,
      ],

      // Material 3 component theming
      cardTheme: CardThemeData(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: const EdgeInsets.all(8.0),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        ),
      ),

      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFFD6DAE3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFFD6DAE3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFF2DD4FF), width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
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
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        backgroundColor: const Color(0xFFFFFFFF),
      ),

      snackBarTheme: SnackBarThemeData(
        elevation: 6.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        backgroundColor: const Color(0xFF0F1722),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: const Color(0xFFFFFFFF),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: Color(0xFFD6DAE3),
        thickness: 1.0,
        space: 1.0,
      ),

      iconTheme: const IconThemeData(color: Color(0xFF3C4657), size: 24.0),

      primaryIconTheme: const IconThemeData(
        color: Color(0xFF2DD4FF),
        size: 24.0,
      ),
    );
  }

  // Dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorSchemes.dark,
      textTheme: AppTypography.textTheme,
      extensions: [
        GameColors.dark,
        MotionDurations.defaultDurations,
        MotionEasings.defaultEasings,
        GameElevations.defaultElevations,
      ],

      // Material 3 component theming
      cardTheme: CardThemeData(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: const EdgeInsets.all(8.0),
        color: const Color(0xFF111722),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        ),
      ),

      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFF223041)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFF223041)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFF7DE9FF), width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFFF87171)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
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
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        backgroundColor: const Color(0xFF111722),
      ),

      snackBarTheme: SnackBarThemeData(
        elevation: 6.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        backgroundColor: const Color(0xFFE6ECF7),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: const Color(0xFF0B0F14),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: Color(0xFF223041),
        thickness: 1.0,
        space: 1.0,
      ),

      iconTheme: const IconThemeData(color: Color(0xFF9AA6B8), size: 24.0),

      primaryIconTheme: const IconThemeData(
        color: Color(0xFF7DE9FF),
        size: 24.0,
      ),
    );
  }

  // Helper method to get theme based on brightness
  static ThemeData getTheme(Brightness brightness) {
    return brightness == Brightness.light ? lightTheme : darkTheme;
  }

  // Helper method to get responsive theme adjustments
  static ThemeData getResponsiveTheme(ThemeData baseTheme, double scaleFactor) {
    return baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(
        bodyColor: baseTheme.textTheme.bodyLarge?.color,
        displayColor: baseTheme.textTheme.displayLarge?.color,
        fontSizeFactor: scaleFactor,
      ),
    );
  }
}
