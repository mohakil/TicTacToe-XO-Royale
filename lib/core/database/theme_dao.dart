import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'app_database.dart';

part 'theme_dao.g.dart';

// ===== APP THEME MODE EXTENSIONS =====

extension AppThemeModeExtension on AppThemeMode {
  String get displayName {
    switch (this) {
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
      case AppThemeMode.system:
        return 'system';
    }
  }

  /// Convert to Flutter's ThemeMode for UI usage
  ThemeMode toFlutterThemeMode() {
    switch (this) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}

extension StringToAppThemeMode on String {
  AppThemeMode get toAppThemeMode {
    switch (this) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      case 'system':
      default:
        return AppThemeMode.system;
    }
  }
}

/// Convert Flutter's ThemeMode to AppThemeMode
AppThemeMode flutterThemeModeToApp(ThemeMode flutterMode) {
  switch (flutterMode) {
    case ThemeMode.light:
      return AppThemeMode.light;
    case ThemeMode.dark:
      return AppThemeMode.dark;
    case ThemeMode.system:
      return AppThemeMode.system;
  }
}

// ===== THEME DAO =====

@DriftAccessor(tables: [ThemeSettings])
class ThemeDao extends DatabaseAccessor<AppDatabase> with _$ThemeDaoMixin {
  ThemeDao(super.db);

  // ===== THEME OPERATIONS =====

  /// Get current theme mode (should always exist, defaults created on DB creation)
  Future<AppThemeMode> getThemeMode() async {
    final results = await select(themeSettings).get();
    if (results.isEmpty) {
      // If no theme settings exist, create default and return system
      await insertDefaultSettings();
      return AppThemeMode.system;
    }
    // Return the first (and should be only) theme setting (convert int to enum)
    final themeModeInt = results.first.themeMode;
    return AppThemeMode.values[themeModeInt];
  }

  /// Watch theme mode reactively for real-time UI updates
  Stream<AppThemeMode> watchThemeMode() {
    return select(
      themeSettings,
    ).watchSingle().map((settings) => AppThemeMode.values[settings.themeMode]);
  }

  /// Set theme mode
  Future<int> setThemeMode(AppThemeMode themeMode) {
    return updateSettings(
      ThemeSettingsCompanion(themeMode: Value(themeMode.index)),
    );
  }

  /// Update theme settings
  Future<int> updateSettings(ThemeSettingsCompanion settings) {
    return update(themeSettings).write(settings);
  }

  /// Set light theme
  Future<int> setLightTheme() {
    return setThemeMode(AppThemeMode.light);
  }

  /// Set dark theme
  Future<int> setDarkTheme() {
    return setThemeMode(AppThemeMode.dark);
  }

  /// Set system theme (follows system setting)
  Future<int> setSystemTheme() {
    return setThemeMode(AppThemeMode.system);
  }

  /// Toggle between light and dark themes
  Future<int> toggleTheme() async {
    final current = await getThemeMode();
    final newMode = current == AppThemeMode.light
        ? AppThemeMode.dark
        : AppThemeMode.light;
    return setThemeMode(newMode);
  }

  /// Cycle through all theme modes (light -> dark -> system -> light...)
  Future<int> cycleTheme() async {
    final current = await getThemeMode();
    final newMode = switch (current) {
      AppThemeMode.light => AppThemeMode.dark,
      AppThemeMode.dark => AppThemeMode.system,
      AppThemeMode.system => AppThemeMode.light,
    };
    return setThemeMode(newMode);
  }

  /// Create default theme settings (used during database initialization)
  Future<int> insertDefaultSettings() {
    return into(themeSettings).insert(
      const ThemeSettingsCompanion(themeMode: Value(2)),
    ); // AppThemeMode.system.index
  }
}
