import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import 'package:tictactoe_xo_royale/core/database/database_providers.dart';
import 'package:tictactoe_xo_royale/core/database/settings_dao.dart';
import 'package:tictactoe_xo_royale/core/database/app_database.dart' as db;

part 'settings_provider.g.dart';

// Settings state class
@immutable
class AppSettings {
  const AppSettings({
    required this.soundEnabled,
    required this.musicEnabled,
    required this.vibrationEnabled,
    required this.hapticFeedbackEnabled,
    required this.autoSaveEnabled,
    required this.notificationsEnabled,
  });

  final bool soundEnabled;
  final bool musicEnabled;
  final bool vibrationEnabled;
  final bool hapticFeedbackEnabled;
  final bool autoSaveEnabled;
  final bool notificationsEnabled;

  // Convenience getters for testing and computed values
  bool get isAudioEnabled => soundEnabled || musicEnabled;
  bool get isHapticEnabled => hapticFeedbackEnabled;

  // Copy with method for immutable updates
  AppSettings copyWith({
    bool? soundEnabled,
    bool? musicEnabled,
    bool? vibrationEnabled,
    bool? hapticFeedbackEnabled,
    bool? autoSaveEnabled,
    bool? notificationsEnabled,
  }) => AppSettings(
    soundEnabled: soundEnabled ?? this.soundEnabled,
    musicEnabled: musicEnabled ?? this.musicEnabled,
    vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    hapticFeedbackEnabled: hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
    autoSaveEnabled: autoSaveEnabled ?? this.autoSaveEnabled,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
  );

  // Default settings
  factory AppSettings.defaults() => const AppSettings(
    soundEnabled: true,
    musicEnabled: true,
    vibrationEnabled: true,
    hapticFeedbackEnabled: true,
    autoSaveEnabled: true,
    notificationsEnabled: true,
  );

  // Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'soundEnabled': soundEnabled,
    'musicEnabled': musicEnabled,
    'vibrationEnabled': vibrationEnabled,
    'hapticFeedbackEnabled': hapticFeedbackEnabled,
    'autoSaveEnabled': autoSaveEnabled,
    'notificationsEnabled': notificationsEnabled,
  };

  // Create from JSON
  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
    soundEnabled: json['soundEnabled'] ?? true,
    musicEnabled: json['musicEnabled'] ?? true,
    vibrationEnabled: json['vibrationEnabled'] ?? true,
    hapticFeedbackEnabled: json['hapticFeedbackEnabled'] ?? true,
    autoSaveEnabled: json['autoSaveEnabled'] ?? true,
    notificationsEnabled: json['notificationsEnabled'] ?? true,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          runtimeType == other.runtimeType &&
          soundEnabled == other.soundEnabled &&
          musicEnabled == other.musicEnabled &&
          vibrationEnabled == other.vibrationEnabled &&
          hapticFeedbackEnabled == other.hapticFeedbackEnabled &&
          autoSaveEnabled == other.autoSaveEnabled &&
          notificationsEnabled == other.notificationsEnabled;

  @override
  int get hashCode => Object.hash(
    runtimeType,
    soundEnabled,
    musicEnabled,
    vibrationEnabled,
    hapticFeedbackEnabled,
    autoSaveEnabled,
    notificationsEnabled,
  );

  @override
  String toString() =>
      'AppSettings(soundEnabled: $soundEnabled, musicEnabled: $musicEnabled, '
      'vibrationEnabled: $vibrationEnabled, hapticFeedbackEnabled: $hapticFeedbackEnabled, '
      'autoSaveEnabled: $autoSaveEnabled, notificationsEnabled: $notificationsEnabled)';
}

// Settings notifier with proper disposal
@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  // DAO dependencies (initialized in build method)
  late SettingsDao _settingsDao;

  @override
  AppSettings build() {
    ref.onDispose(() {
      _mounted = false;
    });

    // Initialize DAO from ref
    _settingsDao = ref.watch(settingsDaoProvider);

    _loadSettings();
    return const AppSettings(
      soundEnabled: true,
      musicEnabled: true,
      vibrationEnabled: true,
      hapticFeedbackEnabled: true,
      autoSaveEnabled: true,
      notificationsEnabled: true,
    );
  }

  // Mounted flag for proper disposal
  bool _mounted = true;

  // Load settings from database with mounted checks
  Future<void> _loadSettings() async {
    try {
      // Load settings from database (will create defaults if none exist)
      final dbSettings = await _settingsDao.getSettings();

      // Create settings object with database values
      final appSettings = AppSettings(
        soundEnabled: dbSettings.soundEnabled,
        musicEnabled: dbSettings.musicEnabled,
        vibrationEnabled: dbSettings.vibrationEnabled,
        hapticFeedbackEnabled: dbSettings.hapticFeedbackEnabled,
        autoSaveEnabled: dbSettings.autoSaveEnabled,
        notificationsEnabled: dbSettings.notificationsEnabled,
      );
      if (_mounted) {
        state = appSettings;
      }
    } on DriftWrappedException catch (e) {
      if (_mounted) {
        debugPrint('Database error while loading settings: ${e.message}');
      }
      // Keep default settings if loading fails
    } catch (error) {
      if (_mounted) {
        debugPrint('Failed to load settings: $error');
      }
      // Keep default settings if loading fails
    }
  }

  // Save settings to database with mounted checks
  Future<void> _saveSettings() async {
    try {
      // Create database settings companion
      final dbSettings = db.AppSettingsCompanion(
        soundEnabled: Value(state.soundEnabled),
        musicEnabled: Value(state.musicEnabled),
        vibrationEnabled: Value(state.vibrationEnabled),
        hapticFeedbackEnabled: Value(state.hapticFeedbackEnabled),
        autoSaveEnabled: Value(state.autoSaveEnabled),
        notificationsEnabled: Value(state.notificationsEnabled),
      );

      await _settingsDao.updateSettings(dbSettings);
    } on DriftWrappedException catch (e) {
      if (_mounted) {
        throw Exception('Database error while saving settings: ${e.message}');
      }
    } catch (error) {
      if (_mounted) {
        throw Exception('Settings save failed: $error');
      }
    }
  }

  // Update sound setting
  Future<void> setSoundEnabled({required bool enabled}) async {
    state = state.copyWith(soundEnabled: enabled);
    await _saveSettings();
  }

  // Update music setting
  Future<void> setMusicEnabled({required bool enabled}) async {
    state = state.copyWith(musicEnabled: enabled);
    await _saveSettings();
  }

  // Update vibration setting
  Future<void> setVibrationEnabled({required bool enabled}) async {
    state = state.copyWith(vibrationEnabled: enabled);
    await _saveSettings();
  }

  // Update haptic feedback setting
  Future<void> setHapticFeedbackEnabled({required bool enabled}) async {
    state = state.copyWith(hapticFeedbackEnabled: enabled);
    await _saveSettings();
  }

  // Update auto save setting
  Future<void> setAutoSaveEnabled({required bool enabled}) async {
    state = state.copyWith(autoSaveEnabled: enabled);
    await _saveSettings();
  }

  // Update notifications setting
  Future<void> setNotificationsEnabled({required bool enabled}) async {
    state = state.copyWith(notificationsEnabled: enabled);
    await _saveSettings();
  }

  // Toggle sound
  Future<void> toggleSound() async {
    await setSoundEnabled(enabled: !state.soundEnabled);
  }

  // Toggle music
  Future<void> toggleMusic() async {
    await setMusicEnabled(enabled: !state.musicEnabled);
  }

  // Toggle vibration
  Future<void> toggleVibration() async {
    await setVibrationEnabled(enabled: !state.vibrationEnabled);
  }

  // Toggle haptic feedback
  Future<void> toggleHapticFeedback() async {
    await setHapticFeedbackEnabled(enabled: !state.hapticFeedbackEnabled);
  }

  // Reset to defaults
  Future<void> resetToDefaults() async {
    state = AppSettings.defaults();
    await _saveSettings();
  }

  // Check if any audio is enabled
  bool get isAudioEnabled => state.soundEnabled || state.musicEnabled;

  // Check if any haptic feedback is enabled
  bool get isHapticEnabled =>
      state.vibrationEnabled || state.hapticFeedbackEnabled;
}

// Codegen handles provider with keepAlive: true via annotation

// ✅ OPTIMIZED: Use select for granular rebuilds instead of individual providers
// Individual settings providers for granular rebuilds
final soundEnabledProvider = Provider<bool>((ref) {
  return ref.watch(
    settingsProvider.select((settings) => settings.soundEnabled),
  );
});

final musicEnabledProvider = Provider<bool>((ref) {
  return ref.watch(
    settingsProvider.select((settings) => settings.musicEnabled),
  );
});

final vibrationEnabledProvider = Provider<bool>((ref) {
  return ref.watch(
    settingsProvider.select((settings) => settings.vibrationEnabled),
  );
});

final hapticFeedbackEnabledProvider = Provider<bool>((ref) {
  return ref.watch(
    settingsProvider.select((settings) => settings.hapticFeedbackEnabled),
  );
});

final autoSaveEnabledProvider = Provider<bool>((ref) {
  return ref.watch(
    settingsProvider.select((settings) => settings.autoSaveEnabled),
  );
});

final notificationsEnabledProvider = Provider<bool>((ref) {
  return ref.watch(
    settingsProvider.select((settings) => settings.notificationsEnabled),
  );
});

// ✅ OPTIMIZED: Computed providers using select for better performance with keepAlive
final isAudioEnabledProvider = Provider<bool>((ref) {
  return ref.watch(
    settingsProvider.select(
      (settings) => settings.soundEnabled || settings.musicEnabled,
    ),
  );
});

final isHapticEnabledProvider = Provider<bool>((ref) {
  return ref.watch(
    settingsProvider.select(
      (settings) => settings.vibrationEnabled || settings.hapticFeedbackEnabled,
    ),
  );
});

// Provider for accessing the SettingsNotifier instance
// Note: This is a workaround for Riverpod 3.0 compatibility
final settingsNotifierProvider = Provider<SettingsNotifier>((ref) {
  // Access the notifier through the provider's internal mechanism
  final container = ref.container;
  return container.read(settingsProvider.notifier);
});

// ✅ OPTIMIZED: Extension methods for easy access with select-based providers
extension SettingsProviderExtension on WidgetRef {
  // Get settings notifier - workaround for Riverpod 3.0
  SettingsNotifier get settingsNotifier {
    try {
      return read(settingsNotifierProvider);
    } catch (e) {
      throw StateError('Settings provider not available: $e');
    }
  }

  // Get individual settings using select for granular rebuilds
  bool get soundEnabled => watch(soundEnabledProvider);
  bool get musicEnabled => watch(musicEnabledProvider);
  bool get vibrationEnabled => watch(vibrationEnabledProvider);
  bool get hapticFeedbackEnabled => watch(hapticFeedbackEnabledProvider);
  bool get autoSaveEnabled => watch(autoSaveEnabledProvider);
  bool get notificationsEnabled => watch(notificationsEnabledProvider);

  // Get computed settings
  bool get isAudioEnabled => watch(isAudioEnabledProvider);
  bool get isHapticEnabled => watch(isHapticEnabledProvider);

  // Get all settings - Note: Use ref.watch(settingsProvider) in widgets instead
  AppSettings get settings {
    // This is a workaround for Riverpod 3.0 - use ref.watch(settingsProvider) directly in widgets
    throw UnimplementedError(
      'Use ref.watch(settingsProvider) directly in widgets',
    );
  }
}

// ✅ OPTIMIZED: Extension methods for BuildContext with proper error handling
extension SettingsContextExtension on BuildContext {
  // Get settings from provider with error handling
  AppSettings? get settings {
    try {
      return ProviderScope.containerOf(this).read(settingsProvider);
    } catch (e) {
      debugPrint('Failed to read settings: $e');
      return null;
    }
  }
}
