import 'package:drift/drift.dart';
import 'app_database.dart';

part 'theme_dao.g.dart';

// ===== THEME DAO =====

@DriftAccessor(tables: [ThemeSettings])
class ThemeDao extends DatabaseAccessor<AppDatabase> with _$ThemeDaoMixin {
  ThemeDao(super.db);

  // ===== THEME OPERATIONS =====

  /// Get current theme mode (should always exist, defaults created on DB creation)
  Future<String> getThemeMode() async {
    final results = await select(themeSettings).get();
    if (results.isEmpty) {
      // If no theme settings exist, create default and return system
      await insertDefaultSettings();
      return 'system';
    }
    // Return the first (and should be only) theme setting
    return results.first.themeMode;
  }

  /// Watch theme mode reactively for real-time UI updates
  Stream<String> watchThemeMode() {
    return select(
      themeSettings,
    ).watchSingle().map((settings) => settings.themeMode);
  }

  /// Set theme mode
  Future<int> setThemeMode(String themeMode) {
    return updateSettings(ThemeSettingsCompanion(themeMode: Value(themeMode)));
  }

  /// Update theme settings
  Future<int> updateSettings(ThemeSettingsCompanion settings) {
    return update(themeSettings).write(settings);
  }

  /// Set light theme
  Future<int> setLightTheme() {
    return setThemeMode('light');
  }

  /// Set dark theme
  Future<int> setDarkTheme() {
    return setThemeMode('dark');
  }

  /// Set system theme (follows system setting)
  Future<int> setSystemTheme() {
    return setThemeMode('system');
  }

  /// Toggle between light and dark themes
  Future<int> toggleTheme() async {
    final current = await getThemeMode();
    final newMode = current == 'light' ? 'dark' : 'light';
    return setThemeMode(newMode);
  }

  /// Cycle through all theme modes (light -> dark -> system -> light...)
  Future<int> cycleTheme() async {
    final current = await getThemeMode();
    final newMode = switch (current) {
      'light' => 'dark',
      'dark' => 'system',
      'system' => 'light',
      _ => 'light', // fallback
    };
    return setThemeMode(newMode);
  }

  /// Create default theme settings (used during database initialization)
  Future<int> insertDefaultSettings() {
    return into(
      themeSettings,
    ).insert(const ThemeSettingsCompanion(themeMode: Value('system')));
  }
}
