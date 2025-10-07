import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import 'package:tictactoe_xo_royale/app/theme/app_theme.dart';
import 'package:tictactoe_xo_royale/core/database/database_providers.dart';
import 'package:tictactoe_xo_royale/core/database/theme_dao.dart';

part 'theme_provider.g.dart';

// ✅ OPTIMIZED: Theme data provider using select for granular rebuilds
final themeDataProvider = Provider<ThemeData>((ref) {
  // ref.keepAlive(); // Already kept alive by @Riverpod(keepAlive: true)
  final themeMode = ref.watch(themeModeProvider);
  return themeMode == ThemeMode.light
      ? AppTheme.lightTheme
      : AppTheme.darkTheme;
});

// ✅ OPTIMIZED: Light theme provider with KeepAlive
final lightThemeProvider = Provider<ThemeData>((ref) {
  // ref.keepAlive(); // Already kept alive by @Riverpod(keepAlive: true)
  return AppTheme.lightTheme;
});

// ✅ OPTIMIZED: Dark theme provider with KeepAlive
final darkThemeProvider = Provider<ThemeData>((ref) {
  // ref.keepAlive(); // Already kept alive by @Riverpod(keepAlive: true)
  return AppTheme.darkTheme;
});

// ✅ OPTIMIZED: System theme provider with KeepAlive
final systemThemeProvider = Provider<ThemeData>((ref) {
  // ref.keepAlive(); // Already kept alive by @Riverpod(keepAlive: true)
  final brightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
  return brightness == Brightness.light
      ? AppTheme.lightTheme
      : AppTheme.darkTheme;
});

// ✅ OPTIMIZED: Responsive theme provider using select for granular rebuilds with keepAlive
final responsiveThemeProvider = Provider.family<ThemeData, double>((
  ref,
  scaleFactor,
) {
  ref.keepAlive(); // Keep alive since responsive theme calculations are expensive
  final baseTheme = ref.watch(themeDataProvider);
  return AppTheme.getResponsiveTheme(baseTheme, scaleFactor);
});

// ✅ OPTIMIZED: Theme mode notifier with improved error handling and proper disposal
@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  // DAO dependencies (initialized in build method)
  late ThemeDao _themeDao;

  // Mounted flag for proper disposal
  bool _mounted = true;

  // Helper methods for theme mode conversion
  String _convertThemeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  ThemeMode _convertStringToThemeMode(String themeModeString) {
    switch (themeModeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  @override
  ThemeMode build() {
    // ref.keepAlive(); // Already kept alive by @Riverpod(keepAlive: true)

    // Initialize DAO from ref
    _themeDao = ref.watch(themeDaoProvider);

    Future.microtask(_loadThemeMode);
    ref.onDispose(() {
      _mounted = false;
    });
    return ThemeMode.system;
  }

  // Load theme mode from database with error handling and mounted checks
  Future<void> _loadThemeMode() async {
    if (!_mounted) return;
    try {
      // Try to load existing theme mode from database
      final themeModeString = await _themeDao.getThemeMode();

      // Convert string to ThemeMode enum
      final themeMode = _convertStringToThemeMode(themeModeString);
      if (_mounted) {
        state = themeMode;
      }
    } on DriftWrappedException catch (e) {
      // If loading fails, keep default system theme
      debugPrint('Database error while loading theme mode: ${e.message}');
      // Don't change state, keep the default system theme
    } catch (error) {
      // If loading fails, keep default system theme
      debugPrint('Failed to load theme mode: $error');
      // Don't change state, keep the default system theme
    }
  }

  // Save theme mode to database with error handling and mounted checks
  Future<void> _saveThemeMode(ThemeMode themeMode) async {
    if (!_mounted) return;
    try {
      // Convert ThemeMode to string and save
      final themeModeString = _convertThemeModeToString(themeMode);
      await _themeDao.setThemeMode(themeModeString);
    } on DriftWrappedException catch (e) {
      debugPrint('Database error while saving theme mode: ${e.message}');
      throw Exception('Database error while saving theme mode: ${e.message}');
    } catch (error) {
      debugPrint('Failed to save theme mode: $error');
      throw Exception('Failed to save theme mode: $error');
    }
  }

  // Set theme mode with error handling and mounted checks
  Future<void> setThemeMode(ThemeMode themeMode) async {
    final previousState = state;
    try {
      if (_mounted) {
        state = themeMode;
        await _saveThemeMode(themeMode);
      }
    } on Exception catch (e) {
      if (_mounted) {
        state = previousState; // Revert on error
        debugPrint('Failed to set theme mode: $e');
      }
      rethrow;
    }
  }

  // Toggle between light and dark themes
  Future<void> toggleTheme() async {
    try {
      if (_mounted) {
        final newThemeMode = state == ThemeMode.light
            ? ThemeMode.dark
            : ThemeMode.light;
        await setThemeMode(newThemeMode);
      }
    } on Exception catch (e) {
      if (_mounted) {
        debugPrint('Failed to toggle theme: $e');
      }
      rethrow;
    }
  }

  // Set light theme
  Future<void> setLightTheme() async {
    if (_mounted) {
      await setThemeMode(ThemeMode.light);
    }
  }

  // Set dark theme
  Future<void> setDarkTheme() async {
    if (_mounted) {
      await setThemeMode(ThemeMode.dark);
    }
  }

  // Set system theme
  Future<void> setSystemTheme() async {
    if (_mounted) {
      await setThemeMode(ThemeMode.system);
    }
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

  @override
  bool updateShouldNotify(ThemeMode previous, ThemeMode next) =>
      previous != next;
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
    } catch (e) {
      debugPrint('Failed to read theme mode: $e');
      return null;
    }
  }

  // Get theme data from provider with error handling
  ThemeData? get themeData {
    try {
      return ProviderScope.containerOf(this).read(themeDataProvider);
    } catch (e) {
      debugPrint('Failed to read theme data: $e');
      return null;
    }
  }

  // Get theme notifier from provider with error handling
  ThemeModeNotifier? get themeNotifier {
    try {
      return ProviderScope.containerOf(this).read(themeModeProvider.notifier);
    } catch (e) {
      debugPrint('Failed to read theme notifier: $e');
      return null;
    }
  }
}
