import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:tictactoe_xo_royale/core/database/app_database.dart' as db;
import 'package:tictactoe_xo_royale/core/database/database_providers.dart';
import 'package:tictactoe_xo_royale/core/providers/settings_provider.dart';

void main() {
  group('SettingsProvider Tests', () {
    late ProviderContainer container;

    setUp(() {
      // Create in-memory database for testing
      final testDatabase = db.AppDatabase(NativeDatabase.memory());

      // Override the database provider with test database
      container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(testDatabase)],
      );
    });

    tearDown(() async {
      // Close the test database
      final database = container.read(appDatabaseProvider);
      await database.close();

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
