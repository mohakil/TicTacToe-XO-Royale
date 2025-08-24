import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';

/// Haptic service for managing vibration feedback
class HapticService {
  HapticService._();

  static final HapticService _instance = HapticService._();
  static HapticService get instance => _instance;

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

  /// Initialize the haptic service
  Future<void> initialize() async {
    try {
      // Check device capabilities
      _hasHapticSupport = true; // Flutter HapticFeedback is always available
      _hasVibrationSupport = await Vibration.hasVibrator();

      if (kDebugMode) {
        print(
          'HapticService: Initialized - Haptic: $_hasHapticSupport, Vibration: $_hasVibrationSupport',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('HapticService: Failed to initialize: $e');
      }
    }
  }

  /// Check if haptic feedback is available
  bool get hasHapticSupport => _hasHapticSupport;
  bool get hasVibrationSupport => _hasVibrationSupport;

  /// Trigger haptic feedback using Flutter's HapticFeedback
  Future<void> _triggerHapticFeedback(String type) async {
    try {
      if (_hasHapticSupport) {
        switch (type) {
          case 'light':
            HapticFeedback.lightImpact();
            break;
          case 'medium':
            HapticFeedback.mediumImpact();
            break;
          case 'heavy':
            HapticFeedback.heavyImpact();
            break;
          case 'selection':
            HapticFeedback.selectionClick();
            break;
          case 'vibrate':
            HapticFeedback.vibrate();
            break;
          default:
            HapticFeedback.selectionClick();
            break;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('HapticService: Failed to trigger haptic feedback: $e');
      }
    }
  }

  /// Trigger vibration using the vibration package
  Future<void> _triggerVibration(List<int> pattern, {int? intensity}) async {
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
    } catch (e) {
      if (kDebugMode) {
        print('HapticService: Failed to trigger vibration: $e');
      }
    }
  }

  /// Trigger a light haptic feedback
  Future<void> lightImpact({WidgetRef? ref}) async {
    if (!_isHapticEnabled(ref)) return;

    try {
      await _triggerHapticFeedback('light');
      await _triggerVibration(_hapticPatterns['light']!);

      if (kDebugMode) {
        print('HapticService: Light impact triggered');
      }
    } catch (e) {
      if (kDebugMode) {
        print('HapticService: Failed to trigger light impact: $e');
      }
    }
  }

  /// Trigger a medium haptic feedback
  Future<void> mediumImpact({WidgetRef? ref}) async {
    if (!_isHapticEnabled(ref)) return;

    try {
      await _triggerHapticFeedback('medium');
      await _triggerVibration(_hapticPatterns['medium']!);

      if (kDebugMode) {
        print('HapticService: Medium impact triggered');
      }
    } catch (e) {
      if (kDebugMode) {
        print('HapticService: Failed to trigger medium impact: $e');
      }
    }
  }

  /// Trigger a heavy haptic feedback
  Future<void> heavyImpact({WidgetRef? ref}) async {
    if (!_isHapticEnabled(ref)) return;

    try {
      await _triggerHapticFeedback('heavy');
      await _triggerVibration(_hapticPatterns['heavy']!);

      if (kDebugMode) {
        print('HapticService: Heavy impact triggered');
      }
    } catch (e) {
      if (kDebugMode) {
        print('HapticService: Failed to trigger heavy impact: $e');
      }
    }
  }

  /// Trigger selection click haptic feedback
  Future<void> selectionClick({WidgetRef? ref}) async {
    if (!_isHapticEnabled(ref)) return;

    try {
      await _triggerHapticFeedback('selection');
      await _triggerVibration(_hapticPatterns['button_tap']!);

      if (kDebugMode) {
        print('HapticService: Selection click triggered');
      }
    } catch (e) {
      if (kDebugMode) {
        print('HapticService: Failed to trigger selection click: $e');
      }
    }
  }

  /// Trigger custom haptic feedback by name
  Future<void> triggerCustomHaptic(String hapticName, {WidgetRef? ref}) async {
    if (!_isHapticEnabled(ref)) return;

    try {
      final pattern = _hapticPatterns[hapticName];
      if (pattern != null) {
        await _triggerVibration(pattern);

        if (kDebugMode) {
          print('HapticService: Custom haptic $hapticName triggered');
        }
      } else {
        if (kDebugMode) {
          print('HapticService: Unknown haptic pattern: $hapticName');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('HapticService: Failed to trigger custom haptic $hapticName: $e');
      }
    }
  }

  /// Trigger game-specific haptic feedback
  Future<void> gameMove({WidgetRef? ref}) async {
    await triggerCustomHaptic('move', ref: ref);
  }

  Future<void> gameWin({WidgetRef? ref}) async {
    await triggerCustomHaptic('win', ref: ref);
  }

  Future<void> gameLose({WidgetRef? ref}) async {
    await triggerCustomHaptic('lose', ref: ref);
  }

  Future<void> gameDraw({WidgetRef? ref}) async {
    await triggerCustomHaptic('draw', ref: ref);
  }

  Future<void> buttonTap({WidgetRef? ref}) async {
    await triggerCustomHaptic('button_tap', ref: ref);
  }

  Future<void> cardFlip({WidgetRef? ref}) async {
    await triggerCustomHaptic('card_flip', ref: ref);
  }

  Future<void> gemCollect({WidgetRef? ref}) async {
    await triggerCustomHaptic('gem_collect', ref: ref);
  }

  Future<void> purchase({WidgetRef? ref}) async {
    await triggerCustomHaptic('purchase', ref: ref);
  }

  Future<void> hint({WidgetRef? ref}) async {
    await triggerCustomHaptic('hint', ref: ref);
  }

  Future<void> notification({WidgetRef? ref}) async {
    await triggerCustomHaptic('notification', ref: ref);
  }

  /// Check if haptic feedback is enabled based on user settings
  bool _isHapticEnabled(WidgetRef? ref) {
    if (ref == null) return true; // Default to enabled if no ref provided

    try {
      final settings = ref.read(settingsProvider);
      return settings.vibrationEnabled && settings.hapticFeedbackEnabled;
    } catch (e) {
      if (kDebugMode) {
        print('HapticService: Failed to read settings: $e');
      }
      return true; // Default to enabled on error
    }
  }

  /// Get available haptic patterns
  List<String> get availableHapticPatterns => _hapticPatterns.keys.toList();

  /// Get haptic pattern for a specific name
  List<int>? getHapticPattern(String name) => _hapticPatterns[name];

  /// Check if device supports specific haptic type
  Future<bool> supportsHapticType(String type) async {
    try {
      return _hasHapticSupport;
    } catch (e) {
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
    } catch (e) {
      if (kDebugMode) {
        print('HapticService: Failed to dispose: $e');
      }
    }
  }
}

/// Provider for HapticService
final hapticServiceProvider = Provider<HapticService>((ref) {
  return HapticService.instance;
});

/// Provider for haptic settings
final hapticSettingsProvider =
    Provider<({bool vibrationEnabled, bool hapticFeedbackEnabled})>((ref) {
      final settings = ref.watch(settingsProvider);
      return (
        vibrationEnabled: settings.vibrationEnabled,
        hapticFeedbackEnabled: settings.hapticFeedbackEnabled,
      );
    });
