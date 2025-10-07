import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/models/robot_config.dart';
import 'package:tictactoe_xo_royale/core/providers/providers.dart';
import 'package:tictactoe_xo_royale/core/services/audio_service.dart';
import 'package:tictactoe_xo_royale/core/services/haptic_service.dart';
import 'package:tictactoe_xo_royale/core/services/robot_service.dart';

// Audio service provider with keepAlive for persistent audio management
final audioServiceProvider = Provider<AudioService>((ref) {
  ref.keepAlive(); // Keep alive since audio service should persist
  return AudioService(ref: ref);
});

// Haptic service provider with keepAlive for persistent haptic management
final hapticServiceProvider = Provider<HapticService>((ref) {
  ref.keepAlive(); // Keep alive since haptic service should persist
  return HapticService(ref: ref);
});

// Audio settings provider with keepAlive for persistent settings
final audioSettingsProvider =
    Provider<({bool soundEnabled, bool musicEnabled})>((ref) {
      ref.keepAlive(); // Keep alive since settings are persistent
      final settings = ref.watch(settingsProvider);
      return (
        soundEnabled: settings.soundEnabled,
        musicEnabled: settings.musicEnabled,
      );
    });

// Haptic settings provider with keepAlive for persistent settings
final hapticSettingsProvider =
    Provider<({bool vibrationEnabled, bool hapticFeedbackEnabled})>((ref) {
      ref.keepAlive(); // Keep alive since settings are persistent
      final settings = ref.watch(settingsProvider);
      return (
        vibrationEnabled: settings.vibrationEnabled,
        hapticFeedbackEnabled: settings.hapticFeedbackEnabled,
      );
    });

// Robot service provider for AI moves and hints
final robotServiceProvider = Provider<RobotService>((ref) {
  final gameConfig = ref.watch(gameProvider);
  final robotConfig = gameConfig.config.robot;
  return RobotService(config: robotConfig ?? RobotConfig.defaultConfig());
});
