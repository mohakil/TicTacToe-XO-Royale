import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/providers/services_provider.dart';
import 'package:vibration/vibration.dart';

/// Haptic service for managing vibration feedback
class HapticService {
  HapticService({required this.ref});

  final Ref ref;

  // Haptic patterns for different game events
  static const Map<String, List<int>> _hapticPatterns = {
    'light': [0, 50],
    'medium': [0, 100],
    'heavy': [0, 200],
    'success': [0, 100, 50, 100],
    'error': [0, 200, 50, 200, 50, 200],
    'move': [0, 30],
    'win': [0, 100, 50, 100, 50, 100],
    'lose': [0, 300, 100, 300],
    'draw': [0, 150, 50, 150],
    'button_tap': [0, 20],
    'card_flip': [0, 40, 20, 40],
    'gem_collect': [0, 60, 30, 60],
    'purchase': [0, 80, 40, 80],
    'hint': [0, 50, 25, 50],
    'notification': [0, 100, 50, 100],
  };

  // Vibration intensities

  /// Check if device supports haptic feedback
  bool _hasHapticSupport = false;
  bool _hasVibrationSupport = false;

  /// Initialize the haptic service with platform-specific optimizations
  Future<void> initialize() async {
    try {
      // Check device capabilities
      _hasHapticSupport = true; // Flutter HapticFeedback is always available
      _hasVibrationSupport = await Vibration.hasVibrator();

      // Platform-specific initialization
      await initializePlatformSpecific();

      if (kDebugMode) {
        print(
          'HapticService: Initialized for ${Platform.operatingSystem} - Haptic: $_hasHapticSupport, Vibration: $_hasVibrationSupport',
        );
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('HapticService: Failed to initialize: $e');
      }
    }
  }

  /// Initialize platform-specific haptic features
  Future<void> initializePlatformSpecific() async {
    try {
      if (Platform.isAndroid) {
        await initializeAndroidHaptics();
      } else if (Platform.isIOS) {
        await _initializeIOSHaptics();
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('HapticService: Platform-specific initialization failed: $e');
      }
    }
  }

  /// Initialize Android-specific haptic features
  Future<void> initializeAndroidHaptics() async {
    try {
      // Check for advanced vibration patterns support
      _hasVibrationSupport = await Vibration.hasVibrator();
      if (_hasVibrationSupport) {
        // Check for amplitude control support
        _hasVibrationSupport = await Vibration.hasAmplitudeControl();
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('HapticService: Android haptic initialization failed: $e');
      }
      // Fallback to basic vibration
      _hasVibrationSupport = await Vibration.hasVibrator();
    }
  }

  /// Initialize iOS-specific haptic features
  Future<void> _initializeIOSHaptics() async {
    try {
      // iOS has excellent haptic support through HapticFeedback
      // Additional iOS-specific configurations can be added here
      const platform = MethodChannel(
        'com.astrixforge.tictactoe_xo_royale/haptics',
      );
      final result = await platform.invokeMethod('initializeHaptics');
      if (kDebugMode) {
        print('HapticService: iOS haptic engine initialized: $result');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        // Fallback to standard HapticFeedback
        print(
          'HapticService: iOS platform channel failed, using standard feedback: $e',
        );
      }
    }
  }

  /// Check if haptic feedback is available
  bool get hasHapticSupport => _hasHapticSupport;
  bool get hasVibrationSupport => _hasVibrationSupport;

  /// Trigger haptic feedback using Flutter's HapticFeedback with platform optimizations
  Future<void> triggerHapticFeedback(String type) async {
    try {
      if (_hasHapticSupport) {
        if (Platform.isIOS) {
          await _triggerIOSHapticFeedback(type);
        } else if (Platform.isAndroid) {
          await _triggerAndroidHapticFeedback(type);
        } else {
          await _triggerGenericHapticFeedback(type);
        }
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('HapticService: Failed to trigger haptic feedback: $e');
      }
    }
  }

  /// Trigger iOS-specific haptic feedback
  Future<void> _triggerIOSHapticFeedback(String type) async {
    try {
      // iOS has excellent haptic support, use native feedback
      switch (type) {
        case 'light':
          await HapticFeedback.lightImpact();
          break;
        case 'medium':
          await HapticFeedback.mediumImpact();
          break;
        case 'heavy':
          await HapticFeedback.heavyImpact();
          break;
        case 'selection':
          await HapticFeedback.selectionClick();
          break;
        case 'success':
          // iOS success feedback with custom pattern
          await _triggerIOSCustomHaptic('success');
          break;
        case 'error':
          // iOS error feedback
          await _triggerIOSCustomHaptic('error');
          break;
        case 'vibrate':
          await HapticFeedback.vibrate();
          break;
        default:
          await HapticFeedback.selectionClick();
          break;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('HapticService: iOS haptic feedback failed: $e');
      }
      // Fallback to generic feedback
      await _triggerGenericHapticFeedback(type);
    }
  }

  /// Trigger Android-specific haptic feedback
  Future<void> _triggerAndroidHapticFeedback(String type) async {
    try {
      // Android has good vibration support, combine with haptic feedback
      switch (type) {
        case 'light':
          await HapticFeedback.lightImpact();
          if (_hasVibrationSupport) {
            await Vibration.vibrate(duration: 50, amplitude: 50);
          }
          break;
        case 'medium':
          await HapticFeedback.mediumImpact();
          if (_hasVibrationSupport) {
            await Vibration.vibrate(duration: 100, amplitude: 100);
          }
          break;
        case 'heavy':
          await HapticFeedback.heavyImpact();
          if (_hasVibrationSupport) {
            await Vibration.vibrate(duration: 200, amplitude: 150);
          }
          break;
        case 'selection':
          await HapticFeedback.selectionClick();
          if (_hasVibrationSupport) {
            await Vibration.vibrate(duration: 20, amplitude: 30);
          }
          break;
        case 'success':
          await HapticFeedback.mediumImpact();
          if (_hasVibrationSupport) {
            await Vibration.vibrate(pattern: [0, 100, 50, 100], amplitude: 128);
          }
          break;
        case 'error':
          if (_hasVibrationSupport) {
            await Vibration.vibrate(
              pattern: [0, 200, 50, 200, 50, 200],
              amplitude: 255,
            );
          } else {
            await HapticFeedback.vibrate();
          }
          break;
        case 'vibrate':
          if (_hasVibrationSupport) {
            await Vibration.vibrate(duration: 300, amplitude: 200);
          } else {
            await HapticFeedback.vibrate();
          }
          break;
        default:
          await HapticFeedback.selectionClick();
          break;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('HapticService: Android haptic feedback failed: $e');
      }
      // Fallback to generic feedback
      await _triggerGenericHapticFeedback(type);
    }
  }

  /// Trigger generic haptic feedback for other platforms
  Future<void> _triggerGenericHapticFeedback(String type) async {
    try {
      switch (type) {
        case 'light':
          await HapticFeedback.lightImpact();
          break;
        case 'medium':
          await HapticFeedback.mediumImpact();
          break;
        case 'heavy':
          await HapticFeedback.heavyImpact();
          break;
        case 'selection':
          await HapticFeedback.selectionClick();
          break;
        case 'vibrate':
          await HapticFeedback.vibrate();
          break;
        default:
          await HapticFeedback.selectionClick();
          break;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('HapticService: Generic haptic feedback failed: $e');
      }
    }
  }

  /// Trigger custom iOS haptic feedback patterns
  Future<void> _triggerIOSCustomHaptic(String pattern) async {
    try {
      const platform = MethodChannel(
        'com.astrixforge.tictactoe_xo_royale/haptics',
      );
      await platform.invokeMethod('playHapticPattern', {'pattern': pattern});
    } on Exception catch (e) {
      if (kDebugMode) {
        print('HapticService: iOS custom haptic failed: $e');
      }
      // Fallback to standard feedback
      switch (pattern) {
        case 'success':
          await HapticFeedback.mediumImpact();
          await Future.delayed(const Duration(milliseconds: 100));
          await HapticFeedback.lightImpact();
          break;
        case 'error':
          await HapticFeedback.heavyImpact();
          await Future.delayed(const Duration(milliseconds: 150));
          await HapticFeedback.heavyImpact();
          break;
      }
    }
  }

  /// Trigger vibration using the vibration package
  Future<void> triggerVibration(List<int> pattern, {int? intensity}) async {
    try {
      if (_hasVibrationSupport) {
        if (intensity != null) {
          // Use custom intensity if supported
          await Vibration.vibrate(
            pattern: pattern,
            intensities: List.filled(pattern.length, intensity),
          );
        } else {
          await Vibration.vibrate(pattern: pattern);
        }
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('HapticService: Failed to trigger vibration: $e');
      }
    }
  }

  /// Trigger a light haptic feedback
  Future<void> lightImpact() async {
    final hapticSettings = ref.read(hapticSettingsProvider);
    if (!hapticSettings.vibrationEnabled ||
        !hapticSettings.hapticFeedbackEnabled) {
      return;
    }

    try {
      await triggerHapticFeedback('light');
      await triggerVibration(_hapticPatterns['light']!);

      if (kDebugMode) {
        print('HapticService: Light impact triggered');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('HapticService: Failed to trigger light impact: $e');
      }
    }
  }

  /// Trigger a medium haptic feedback
  Future<void> mediumImpact() async {
    final hapticSettings = ref.read(hapticSettingsProvider);
    if (!hapticSettings.vibrationEnabled ||
        !hapticSettings.hapticFeedbackEnabled) {
      return;
    }

    try {
      await triggerHapticFeedback('medium');
      await triggerVibration(_hapticPatterns['medium']!);

      if (kDebugMode) {
        print('HapticService: Medium impact triggered');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('HapticService: Failed to trigger medium impact: $e');
      }
    }
  }

  /// Trigger a heavy haptic feedback
  Future<void> heavyImpact() async {
    final hapticSettings = ref.read(hapticSettingsProvider);
    if (!hapticSettings.vibrationEnabled ||
        !hapticSettings.hapticFeedbackEnabled) {
      return;
    }

    try {
      await triggerHapticFeedback('heavy');
      await triggerVibration(_hapticPatterns['heavy']!);

      if (kDebugMode) {
        print('HapticService: Heavy impact triggered');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('HapticService: Failed to trigger heavy impact: $e');
      }
    }
  }

  /// Trigger selection click haptic feedback
  Future<void> selectionClick() async {
    final hapticSettings = ref.read(hapticSettingsProvider);
    if (!hapticSettings.vibrationEnabled ||
        !hapticSettings.hapticFeedbackEnabled) {
      return;
    }

    try {
      await triggerHapticFeedback('selection');
      await triggerVibration(_hapticPatterns['button_tap']!);

      if (kDebugMode) {
        print('HapticService: Selection click triggered');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('HapticService: Failed to trigger selection click: $e');
      }
    }
  }

  /// Trigger custom haptic feedback by name
  Future<void> triggerCustomHaptic(String hapticName) async {
    final hapticSettings = ref.read(hapticSettingsProvider);
    if (!hapticSettings.vibrationEnabled ||
        !hapticSettings.hapticFeedbackEnabled) {
      return;
    }

    try {
      final pattern = _hapticPatterns[hapticName];
      if (pattern != null) {
        await triggerVibration(pattern);

        if (kDebugMode) {
          print('HapticService: Custom haptic $hapticName triggered');
        }
      } else {
        if (kDebugMode) {
          print('HapticService: Unknown haptic pattern: $hapticName');
        }
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('HapticService: Failed to trigger custom haptic $hapticName: $e');
      }
    }
  }

  /// Trigger game-specific haptic feedback
  Future<void> gameMove() async {
    await triggerCustomHaptic('move');
  }

  Future<void> gameWin() async {
    await triggerCustomHaptic('win');
  }

  Future<void> gameLose() async {
    await triggerCustomHaptic('lose');
  }

  Future<void> gameDraw() async {
    await triggerCustomHaptic('draw');
  }

  Future<void> buttonTap() async {
    await triggerCustomHaptic('button_tap');
  }

  Future<void> cardFlip() async {
    await triggerCustomHaptic('card_flip');
  }

  Future<void> gemCollect() async {
    await triggerCustomHaptic('gem_collect');
  }

  Future<void> purchase() async {
    await triggerCustomHaptic('purchase');
  }

  Future<void> hint() async {
    await triggerCustomHaptic('hint');
  }

  Future<void> notification() async {
    await triggerCustomHaptic('notification');
  }

  /// Get available haptic patterns
  List<String> get availableHapticPatterns => _hapticPatterns.keys.toList();

  /// Get haptic pattern for a specific name
  List<int>? getHapticPattern(String name) => _hapticPatterns[name];

  /// Check if device supports specific haptic type
  Future<bool> supportsHapticType(String type) async {
    try {
      return _hasHapticSupport;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('HapticService: Failed to check haptic type support: $e');
      }
      return false;
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    try {
      // Stop any ongoing vibrations
      await Vibration.cancel();

      if (kDebugMode) {
        print('HapticService: Disposed successfully');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('HapticService: Failed to dispose: $e');
      }
    }
  }
}
