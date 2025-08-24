import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/theme/app_theme.dart';
import '../../app/theme/theme_extensions.dart';

// Provider for theme mode
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

// Provider for theme data
final themeDataProvider = Provider<ThemeData>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  return themeMode == ThemeMode.light
      ? AppTheme.lightTheme
      : AppTheme.darkTheme;
});

// Provider for light theme
final lightThemeProvider = Provider<ThemeData>((ref) {
  return AppTheme.lightTheme;
});

// Provider for dark theme
final darkThemeProvider = Provider<ThemeData>((ref) {
  return AppTheme.darkTheme;
});

// Provider for system theme
final systemThemeProvider = Provider<ThemeData>((ref) {
  final brightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
  return brightness == Brightness.light
      ? AppTheme.lightTheme
      : AppTheme.darkTheme;
});

// Provider for responsive theme adjustments
final responsiveThemeProvider = Provider.family<ThemeData, double>((
  ref,
  scaleFactor,
) {
  final baseTheme = ref.watch(themeDataProvider);
  return AppTheme.getResponsiveTheme(baseTheme, scaleFactor);
});

// Notifier for managing theme mode
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  // Storage key for theme mode
  static const String _storageKey = 'theme_mode';

  // Load theme mode from storage
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeIndex = prefs.getInt(_storageKey);
      if (themeModeIndex != null) {
        state = ThemeMode.values[themeModeIndex];
      }
    } catch (e) {
      // If loading fails, keep default system theme
      debugPrint('Failed to load theme mode: $e');
    }
  }

  // Save theme mode to storage
  Future<void> _saveThemeMode(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_storageKey, themeMode.index);
    } catch (e) {
      debugPrint('Failed to save theme mode: $e');
    }
  }

  // Set theme mode
  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = themeMode;
    await _saveThemeMode(themeMode);
  }

  // Toggle between light and dark themes
  Future<void> toggleTheme() async {
    final newThemeMode = state == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await setThemeMode(newThemeMode);
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

  // Get current theme mode as string
  String getThemeModeString() {
    switch (state) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  // Check if current theme is light
  bool get isLight => state == ThemeMode.light;

  // Check if current theme is dark
  bool get isDark => state == ThemeMode.dark;

  // Check if current theme is system
  bool get isSystem => state == ThemeMode.system;

  // Get effective theme mode (resolves system to actual light/dark)
  ThemeMode get effectiveThemeMode {
    if (state == ThemeMode.system) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark;
    }
    return state;
  }

  // Get effective brightness
  Brightness get effectiveBrightness {
    return effectiveThemeMode == ThemeMode.light
        ? Brightness.light
        : Brightness.dark;
  }

  // Check if effective theme is light
  bool get isEffectiveLight => effectiveBrightness == Brightness.light;

  // Check if effective theme is dark
  bool get isEffectiveDark => effectiveBrightness == Brightness.dark;
}

// Extension methods for easy theme access
extension ThemeProviderExtension on WidgetRef {
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

  // Get responsive theme
  ThemeData getResponsiveTheme(double scaleFactor) =>
      watch(responsiveThemeProvider(scaleFactor));

  // Check if current theme is light
  bool get isLightTheme => themeMode == ThemeMode.light;

  // Check if current theme is dark
  bool get isDarkTheme => themeMode == ThemeMode.dark;

  // Check if current theme is system
  bool get isSystemTheme => themeMode == ThemeMode.system;

  // Get effective theme mode
  ThemeMode get effectiveThemeMode =>
      read(themeModeProvider.notifier).effectiveThemeMode;

  // Get effective brightness
  Brightness get effectiveBrightness =>
      read(themeModeProvider.notifier).effectiveBrightness;

  // Check if effective theme is light
  bool get isEffectiveLightTheme =>
      read(themeModeProvider.notifier).isEffectiveLight;

  // Check if effective theme is dark
  bool get isEffectiveDarkTheme =>
      read(themeModeProvider.notifier).isEffectiveDark;
}

// Extension methods for BuildContext
extension ThemeContextExtension on BuildContext {
  // Get current theme data
  ThemeData get theme => Theme.of(this);

  // Get current color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  // Get current text theme
  TextTheme get textTheme => theme.textTheme;

  // Get game colors extension
  GameColors get gameColors => theme.gameColors;

  // Get motion durations extension
  MotionDurations get motionDurations => theme.motionDurations;

  // Get motion easings extension
  MotionEasings get motionEasings => theme.motionEasings;

  // Get game elevations extension
  GameElevations get gameElevations => theme.gameElevations;

  // Check if current theme is light
  bool get isLightTheme => theme.brightness == Brightness.light;

  // Check if current theme is dark
  bool get isDarkTheme => theme.brightness == Brightness.dark;

  // Get current brightness
  Brightness get brightness => theme.brightness;
}
