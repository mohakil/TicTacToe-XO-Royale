import 'package:drift/drift.dart';
import 'app_database.dart';

part 'settings_dao.g.dart';

// ===== SETTINGS DAO =====

@DriftAccessor(tables: [AppSettings])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  // ===== SETTINGS OPERATIONS =====

  /// Get current app settings (should always exist, defaults created on DB creation)
  Future<AppSetting> getSettings() async {
    final results = await select(appSettings).get();
    if (results.isEmpty) {
      // If no settings exist, create default settings
      await _createDefaultSettings();
      // Return the newly created settings
      final newResults = await select(appSettings).get();
      return newResults.first;
    }
    // Return the first (and should be only) settings
    return results.first;
  }

  /// Create default settings (internal method)
  Future<void> _createDefaultSettings() async {
    await updateSettings(
      const AppSettingsCompanion(
        soundEnabled: Value(true),
        musicEnabled: Value(true),
        vibrationEnabled: Value(true),
        hapticFeedbackEnabled: Value(true),
        autoSaveEnabled: Value(true),
        notificationsEnabled: Value(true),
      ),
    );
  }

  /// Watch settings reactively for real-time UI updates
  Stream<AppSetting> watchSettings() {
    return select(appSettings).watchSingle();
  }

  /// Update app settings
  Future<int> updateSettings(AppSettingsCompanion settings) {
    return update(appSettings).write(settings);
  }

  /// Toggle sound setting
  Future<int> toggleSound() async {
    final current = await getSettings();
    return updateSettings(
      AppSettingsCompanion(soundEnabled: Value(!current.soundEnabled)),
    );
  }

  /// Toggle music setting
  Future<int> toggleMusic() async {
    final current = await getSettings();
    return updateSettings(
      AppSettingsCompanion(musicEnabled: Value(!current.musicEnabled)),
    );
  }

  /// Toggle vibration setting
  Future<int> toggleVibration() async {
    final current = await getSettings();
    return updateSettings(
      AppSettingsCompanion(vibrationEnabled: Value(!current.vibrationEnabled)),
    );
  }

  /// Toggle haptic feedback setting
  Future<int> toggleHapticFeedback() async {
    final current = await getSettings();
    return updateSettings(
      AppSettingsCompanion(
        hapticFeedbackEnabled: Value(!current.hapticFeedbackEnabled),
      ),
    );
  }

  /// Toggle auto-save setting
  Future<int> toggleAutoSave() async {
    final current = await getSettings();
    return updateSettings(
      AppSettingsCompanion(autoSaveEnabled: Value(!current.autoSaveEnabled)),
    );
  }

  /// Toggle notifications setting
  Future<int> toggleNotifications() async {
    final current = await getSettings();
    return updateSettings(
      AppSettingsCompanion(
        notificationsEnabled: Value(!current.notificationsEnabled),
      ),
    );
  }

  /// Set sound enabled
  Future<int> setSoundEnabled(bool enabled) {
    return updateSettings(AppSettingsCompanion(soundEnabled: Value(enabled)));
  }

  /// Set music enabled
  Future<int> setMusicEnabled(bool enabled) {
    return updateSettings(AppSettingsCompanion(musicEnabled: Value(enabled)));
  }

  /// Set vibration enabled
  Future<int> setVibrationEnabled(bool enabled) {
    return updateSettings(
      AppSettingsCompanion(vibrationEnabled: Value(enabled)),
    );
  }

  /// Set haptic feedback enabled
  Future<int> setHapticFeedbackEnabled(bool enabled) {
    return updateSettings(
      AppSettingsCompanion(hapticFeedbackEnabled: Value(enabled)),
    );
  }

  /// Set auto-save enabled
  Future<int> setAutoSaveEnabled(bool enabled) {
    return updateSettings(
      AppSettingsCompanion(autoSaveEnabled: Value(enabled)),
    );
  }

  /// Set notifications enabled
  Future<int> setNotificationsEnabled(bool enabled) {
    return updateSettings(
      AppSettingsCompanion(notificationsEnabled: Value(enabled)),
    );
  }

  /// Reset all settings to defaults
  Future<int> resetToDefaults() {
    return updateSettings(
      const AppSettingsCompanion(
        soundEnabled: Value(true),
        musicEnabled: Value(true),
        vibrationEnabled: Value(true),
        hapticFeedbackEnabled: Value(true),
        autoSaveEnabled: Value(true),
        notificationsEnabled: Value(true),
      ),
    );
  }

  /// Create default settings (used during database initialization)
  Future<int> insertDefaultSettings() {
    return into(appSettings).insert(
      const AppSettingsCompanion(
        soundEnabled: Value(true),
        musicEnabled: Value(true),
        vibrationEnabled: Value(true),
        hapticFeedbackEnabled: Value(true),
        autoSaveEnabled: Value(true),
        notificationsEnabled: Value(true),
      ),
    );
  }
}
