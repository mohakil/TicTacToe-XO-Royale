import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictactoe_xo_royale/core/providers/settings_provider.dart';

void main() {
  group('SettingsProvider Tests', () {
    late ProviderContainer container;

    setUp(() {
      // Use SharedPreferences.setMockInitialValues for testing
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('Initial Settings Tests', () {
      test('Should provide default settings initially', () {
        final settings = container.read(settingsProvider);
        expect(settings, isA<AppSettings>());
        expect(settings.soundEnabled, isTrue);
        expect(settings.musicEnabled, isTrue);
        expect(settings.hapticFeedbackEnabled, isTrue);
        expect(settings.autoSaveEnabled, isTrue);
        expect(settings.performanceMode, equals(PerformanceMode.balanced));
      });

      test('Should provide default boolean settings', () {
        final soundEnabled = container.read(soundEnabledProvider);
        final musicEnabled = container.read(musicEnabledProvider);
        final hapticEnabled = container.read(hapticFeedbackEnabledProvider);
        final autoSaveEnabled = container.read(autoSaveEnabledProvider);

        expect(soundEnabled, isTrue);
        expect(musicEnabled, isTrue);
        expect(hapticEnabled, isTrue);
        expect(autoSaveEnabled, isTrue);
      });

      test('Should provide default performance mode', () {
        final performanceMode = container.read(performanceModeProvider);
        expect(performanceMode, equals(PerformanceMode.balanced));
      });
    });

    group('Settings Update Tests', () {
      test('Should update sound settings', () async {
        final notifier = container.read(settingsProvider.notifier);
        await notifier.setSoundEnabled(enabled: false);

        final settings = container.read(settingsProvider);
        expect(settings.soundEnabled, isFalse);
      });

      test('Should update music settings', () async {
        final notifier = container.read(settingsProvider.notifier);
        await notifier.setMusicEnabled(enabled: false);

        final settings = container.read(settingsProvider);
        expect(settings.musicEnabled, isFalse);
      });

      test('Should update haptic feedback settings', () async {
        final notifier = container.read(settingsProvider.notifier);
        await notifier.setHapticFeedbackEnabled(enabled: false);

        final settings = container.read(settingsProvider);
        expect(settings.hapticFeedbackEnabled, isFalse);
      });

      test('Should update auto save settings', () async {
        final notifier = container.read(settingsProvider.notifier);
        await notifier.setAutoSaveEnabled(enabled: false);

        final settings = container.read(settingsProvider);
        expect(settings.autoSaveEnabled, isFalse);
      });

      test('Should update performance mode', () async {
        final notifier = container.read(settingsProvider.notifier);
        await notifier.setPerformanceMode(PerformanceMode.performance);

        final settings = container.read(settingsProvider);
        expect(settings.performanceMode, equals(PerformanceMode.performance));
      });
    });

    group('Computed Provider Tests', () {
      test('Should compute audio enabled state', () {
        final audioEnabled = container.read(isAudioEnabledProvider);
        expect(audioEnabled, isTrue);
      });

      test('Should compute haptic enabled state', () {
        final hapticEnabled = container.read(isHapticEnabledProvider);
        expect(hapticEnabled, isTrue);
      });
    });

    group('Settings Reset Tests', () {
      test('Should reset to default settings', () async {
        final notifier = container.read(settingsProvider.notifier);

        // Change some settings first
        await notifier.setSoundEnabled(enabled: false);
        await notifier.setMusicEnabled(enabled: false);

        // Reset to defaults
        await notifier.resetToDefaults();

        final settings = container.read(settingsProvider);
        expect(settings.soundEnabled, isTrue);
        expect(settings.musicEnabled, isTrue);
      });

      test('Should handle settings reset gracefully', () async {
        final notifier = container.read(settingsProvider.notifier);

        expect(notifier.resetToDefaults, returnsNormally);

        final settings = container.read(settingsProvider);
        expect(settings, isA<AppSettings>());
      });
    });
  });
}
