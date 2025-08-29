import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictactoe_xo_royale/app/theme/app_theme.dart';

// ✅ OPTIMIZED: Provider for theme mode with KeepAlive for persistence
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

// ✅ OPTIMIZED: Theme data provider using select for granular rebuilds
final themeDataProvider = Provider<ThemeData>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  return themeMode == ThemeMode.light
      ? AppTheme.lightTheme
      : AppTheme.darkTheme;
});

// ✅ OPTIMIZED: Light theme provider with KeepAlive
final lightThemeProvider = Provider<ThemeData>((ref) {
  ref.keepAlive(); // Keep alive since theme data is expensive to create
  return AppTheme.lightTheme;
});

// ✅ OPTIMIZED: Dark theme provider with KeepAlive
final darkThemeProvider = Provider<ThemeData>((ref) {
  ref.keepAlive(); // Keep alive since theme data is expensive to create
  return AppTheme.darkTheme;
});

// ✅ OPTIMIZED: System theme provider with KeepAlive
final systemThemeProvider = Provider<ThemeData>((ref) {
  ref.keepAlive(); // Keep alive since theme data is expensive to create
  final brightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
  return brightness == Brightness.light
      ? AppTheme.lightTheme
      : AppTheme.darkTheme;
});

// ✅ OPTIMIZED: Responsive theme provider using select for granular rebuilds
final responsiveThemeProvider = Provider.family<ThemeData, double>((
  ref,
  scaleFactor,
) {
  final baseTheme = ref.watch(themeDataProvider);
  return AppTheme.getResponsiveTheme(baseTheme, scaleFactor);
});

// ✅ OPTIMIZED: Theme mode notifier with improved error handling
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  // Storage key for theme mode
  static const String _storageKey = 'theme_mode';

  // Load theme mode from storage with error handling
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeIndex = prefs.getInt(_storageKey);
      if (themeModeIndex != null &&
          themeModeIndex >= 0 &&
          themeModeIndex < ThemeMode.values.length) {
        state = ThemeMode.values[themeModeIndex];
      }
    } on Exception catch (e) {
      // If loading fails, keep default system theme
      debugPrint('Failed to load theme mode: $e');
      // Don't change state, keep the default system theme
    }
  }

  // Save theme mode to storage with error handling
  Future<void> _saveThemeMode(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_storageKey, themeMode.index);
    } on Exception catch (e) {
      debugPrint('Failed to save theme mode: $e');
      // Don't throw error, just log it
    }
  }

  // Set theme mode with error handling
  Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      state = themeMode;
      await _saveThemeMode(themeMode);
    } on Exception catch (e) {
      debugPrint('Failed to set theme mode: $e');
      // Revert to previous state if save fails
      // Note: In a production app, you might want to show a user-friendly error
    }
  }

  // Toggle between light and dark themes
  Future<void> toggleTheme() async {
    try {
      final newThemeMode = state == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
      await setThemeMode(newThemeMode);
    } on Exception catch (e) {
      debugPrint('Failed to toggle theme: $e');
    }
  }

  // Set light theme
  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }

  // Set dark theme
  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }

  // Set system theme
  Future<void> setSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }

  // Check if current theme is light
  bool get isLightTheme => state == ThemeMode.light;

  // Check if current theme is dark
  bool get isDarkTheme => state == ThemeMode.dark;

  // Check if current theme is system
  bool get isSystemTheme => state == ThemeMode.system;

  // Get theme name for display
  String get themeName {
    switch (state) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  // Get theme icon for display
  IconData get themeIcon {
    switch (state) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}

// ✅ OPTIMIZED: Extension methods for easy access with select-based providers
extension ThemeProviderExtension on WidgetRef {
  // Get theme notifier
  ThemeModeNotifier get themeNotifier => read(themeModeProvider.notifier);

  // Get current theme mode
  ThemeMode get themeMode => watch(themeModeProvider);

  // Get current theme data
  ThemeData get themeData => watch(themeDataProvider);

  // Get light theme
  ThemeData get lightTheme => watch(lightThemeProvider);

  // Get dark theme
  ThemeData get darkTheme => watch(darkThemeProvider);

  // Get system theme
  ThemeData get systemTheme => watch(systemThemeProvider);

  // Get responsive theme for a specific scale factor
  ThemeData getResponsiveTheme(double scaleFactor) =>
      watch(responsiveThemeProvider(scaleFactor));

  // Check if current theme is light
  bool get isLightTheme =>
      watch(themeModeProvider.select((mode) => mode == ThemeMode.light));

  // Check if current theme is dark
  bool get isDarkTheme =>
      watch(themeModeProvider.select((mode) => mode == ThemeMode.dark));

  // Check if current theme is system
  bool get isSystemTheme =>
      watch(themeModeProvider.select((mode) => mode == ThemeMode.system));

  // Get theme name for display
  String get themeName => watch(
    themeModeProvider.select((mode) {
      switch (mode) {
        case ThemeMode.light:
          return 'Light';
        case ThemeMode.dark:
          return 'Dark';
        case ThemeMode.system:
          return 'System';
      }
    }),
  );

  // Get theme icon for display
  IconData get themeIcon => watch(
    themeModeProvider.select((mode) {
      switch (mode) {
        case ThemeMode.light:
          return Icons.light_mode;
        case ThemeMode.dark:
          return Icons.dark_mode;
        case ThemeMode.system:
          return Icons.brightness_auto;
      }
    }),
  );
}

// ✅ OPTIMIZED: Extension methods for BuildContext with proper error handling
extension ThemeContextExtension on BuildContext {
  // Get theme mode from provider with error handling
  ThemeMode? get themeMode {
    try {
      return ProviderScope.containerOf(this).read(themeModeProvider);
    } on Exception catch (e) {
      debugPrint('Failed to read theme mode: $e');
      return null;
    }
  }

  // Get theme data from provider with error handling
  ThemeData? get themeData {
    try {
      return ProviderScope.containerOf(this).read(themeDataProvider);
    } on Exception catch (e) {
      debugPrint('Failed to read theme data: $e');
      return null;
    }
  }

  // Get theme notifier from provider with error handling
  ThemeModeNotifier? get themeNotifier {
    try {
      return ProviderScope.containerOf(this).read(themeModeProvider.notifier);
    } on Exception catch (e) {
      debugPrint('Failed to read theme notifier: $e');
      return null;
    }
  }
}
