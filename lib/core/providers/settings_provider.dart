import 'dart:convert'; // Added missing import for json

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    required this.performanceMode,
  });

  final bool soundEnabled;
  final bool musicEnabled;
  final bool vibrationEnabled;
  final bool hapticFeedbackEnabled;
  final bool autoSaveEnabled;
  final bool notificationsEnabled;
  final PerformanceMode performanceMode;

  // Copy with method for immutable updates
  AppSettings copyWith({
    bool? soundEnabled,
    bool? musicEnabled,
    bool? vibrationEnabled,
    bool? hapticFeedbackEnabled,
    bool? autoSaveEnabled,
    bool? notificationsEnabled,
    PerformanceMode? performanceMode,
  }) => AppSettings(
    soundEnabled: soundEnabled ?? this.soundEnabled,
    musicEnabled: musicEnabled ?? this.musicEnabled,
    vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    hapticFeedbackEnabled: hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
    autoSaveEnabled: autoSaveEnabled ?? this.autoSaveEnabled,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    performanceMode: performanceMode ?? this.performanceMode,
  );

  // Default settings
  factory AppSettings.defaults() => const AppSettings(
    soundEnabled: true,
    musicEnabled: true,
    vibrationEnabled: true,
    hapticFeedbackEnabled: true,
    autoSaveEnabled: true,
    notificationsEnabled: true,
    performanceMode: PerformanceMode.balanced,
  );

  // Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'soundEnabled': soundEnabled,
    'musicEnabled': musicEnabled,
    'vibrationEnabled': vibrationEnabled,
    'hapticFeedbackEnabled': hapticFeedbackEnabled,
    'autoSaveEnabled': autoSaveEnabled,
    'notificationsEnabled': notificationsEnabled,
    'performanceMode': performanceMode.index,
  };

  // Create from JSON
  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
    soundEnabled: json['soundEnabled'] ?? true,
    musicEnabled: json['musicEnabled'] ?? true,
    vibrationEnabled: json['vibrationEnabled'] ?? true,
    hapticFeedbackEnabled: json['hapticFeedbackEnabled'] ?? true,
    autoSaveEnabled: json['autoSaveEnabled'] ?? true,
    notificationsEnabled: json['notificationsEnabled'] ?? true,
    performanceMode: PerformanceMode.values[json['performanceMode'] ?? 0],
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
          notificationsEnabled == other.notificationsEnabled &&
          performanceMode == other.performanceMode;

  @override
  int get hashCode => Object.hash(
    runtimeType,
    soundEnabled,
    musicEnabled,
    vibrationEnabled,
    hapticFeedbackEnabled,
    autoSaveEnabled,
    notificationsEnabled,
    performanceMode,
  );

  @override
  String toString() =>
      'AppSettings(soundEnabled: $soundEnabled, musicEnabled: $musicEnabled, '
      'vibrationEnabled: $vibrationEnabled, hapticFeedbackEnabled: $hapticFeedbackEnabled, '
      'autoSaveEnabled: $autoSaveEnabled, notificationsEnabled: $notificationsEnabled, '
      'performanceMode: $performanceMode)';
}

// Performance mode enum
enum PerformanceMode {
  powerSaving,
  balanced,
  performance;

  String get displayName {
    switch (this) {
      case PerformanceMode.powerSaving:
        return 'Power Saving';
      case PerformanceMode.balanced:
        return 'Balanced';
      case PerformanceMode.performance:
        return 'Performance';
    }
  }

  String get description {
    switch (this) {
      case PerformanceMode.powerSaving:
        return 'Optimized for battery life, reduced visual effects';
      case PerformanceMode.balanced:
        return 'Balanced performance and battery usage';
      case PerformanceMode.performance:
        return 'Maximum visual quality and smooth animations';
    }
  }
}

// Settings notifier
class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(AppSettings.defaults()) {
    _loadSettings();
  }

  static const String _storageKey = 'app_settings';

  // Load settings from storage
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_storageKey);
      if (settingsJson != null) {
        final settingsMap = Map<String, dynamic>.from(
          json.decode(settingsJson) as Map,
        );
        state = AppSettings.fromJson(settingsMap);
      }
    } on Exception catch (e) {
      debugPrint('Failed to load settings: $e');
      // Keep default settings if loading fails
    }
  }

  // Save settings to storage
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = json.encode(state.toJson());
      await prefs.setString(_storageKey, settingsJson);
    } on Exception catch (e) {
      debugPrint('Failed to save settings: $e');
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

  // Update performance mode
  Future<void> setPerformanceMode(PerformanceMode mode) async {
    state = state.copyWith(performanceMode: mode);
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

// ✅ OPTIMIZED: Main settings provider with KeepAlive for persistence
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier(),
);

// ✅ OPTIMIZED: Use select for granular rebuilds instead of individual providers
// Individual settings providers for granular rebuilds
final soundEnabledProvider = Provider<bool>((ref) {
  ref.keepAlive(); // Keep alive since settings are persistent
  return ref.watch(
    settingsProvider.select((settings) => settings.soundEnabled),
  );
});

final musicEnabledProvider = Provider<bool>((ref) {
  ref.keepAlive(); // Keep alive since settings are persistent
  return ref.watch(
    settingsProvider.select((settings) => settings.musicEnabled),
  );
});

final vibrationEnabledProvider = Provider<bool>((ref) {
  ref.keepAlive(); // Keep alive since settings are persistent
  return ref.watch(
    settingsProvider.select((settings) => settings.vibrationEnabled),
  );
});

final hapticFeedbackEnabledProvider = Provider<bool>((ref) {
  ref.keepAlive(); // Keep alive since settings are persistent
  return ref.watch(
    settingsProvider.select((settings) => settings.hapticFeedbackEnabled),
  );
});

final autoSaveEnabledProvider = Provider<bool>((ref) {
  ref.keepAlive(); // Keep alive since settings are persistent
  return ref.watch(
    settingsProvider.select((settings) => settings.autoSaveEnabled),
  );
});

final notificationsEnabledProvider = Provider<bool>((ref) {
  ref.keepAlive(); // Keep alive since settings are persistent
  return ref.watch(
    settingsProvider.select((settings) => settings.notificationsEnabled),
  );
});

final performanceModeProvider = Provider<PerformanceMode>((ref) {
  ref.keepAlive(); // Keep alive since settings are persistent
  return ref.watch(
    settingsProvider.select((settings) => settings.performanceMode),
  );
});

// ✅ OPTIMIZED: Computed providers using select for better performance
final isAudioEnabledProvider = Provider<bool>(
  (ref) => ref.watch(
    settingsProvider.select(
      (settings) => settings.soundEnabled || settings.musicEnabled,
    ),
  ),
);

final isHapticEnabledProvider = Provider<bool>(
  (ref) => ref.watch(
    settingsProvider.select(
      (settings) => settings.vibrationEnabled || settings.hapticFeedbackEnabled,
    ),
  ),
);

// ✅ OPTIMIZED: Extension methods for easy access with select-based providers
extension SettingsProviderExtension on WidgetRef {
  // Get settings notifier
  SettingsNotifier get settingsNotifier => read(settingsProvider.notifier);

  // Get individual settings using select for granular rebuilds
  bool get soundEnabled => watch(soundEnabledProvider);
  bool get musicEnabled => watch(musicEnabledProvider);
  bool get vibrationEnabled => watch(vibrationEnabledProvider);
  bool get hapticFeedbackEnabled => watch(hapticFeedbackEnabledProvider);
  bool get autoSaveEnabled => watch(autoSaveEnabledProvider);
  bool get notificationsEnabled => watch(notificationsEnabledProvider);
  PerformanceMode get performanceMode => watch(performanceModeProvider);

  // Get computed settings
  bool get isAudioEnabled => watch(isAudioEnabledProvider);
  bool get isHapticEnabled => watch(isHapticEnabledProvider);

  // Get all settings
  AppSettings get settings => watch(settingsProvider);
}

// ✅ OPTIMIZED: Extension methods for BuildContext with proper error handling
extension SettingsContextExtension on BuildContext {
  // Get settings from provider with error handling
  AppSettings? get settings {
    try {
      return ProviderScope.containerOf(this).read(settingsProvider);
    } on Exception catch (e) {
      debugPrint('Failed to read settings: $e');
      return null;
    }
  }
}
