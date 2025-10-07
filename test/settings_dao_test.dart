import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/database/app_database.dart';
import 'package:tictactoe_xo_royale/core/database/settings_dao.dart';
import 'package:tictactoe_xo_royale/core/database/database_providers.dart';

void main() {
  late AppDatabase database;
  late ProviderContainer container;
  late SettingsDao dao;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
    dao = container.read(settingsDaoProvider);
  });

  tearDown(() async {
    await database.close();
    container.dispose();
  });

  group('SettingsDao Tests', () {
    // ===== BASIC OPERATIONS =====

    group('getSettings()', () {
      test('should return default settings when none exist', () async {
        // Act
        final settings = await dao.getSettings();

        // Assert
        expect(settings.id, 1);
        expect(settings.soundEnabled, isTrue);
        expect(settings.musicEnabled, isTrue);
        expect(settings.vibrationEnabled, isTrue);
        expect(settings.hapticFeedbackEnabled, isTrue);
        expect(settings.autoSaveEnabled, isTrue);
        expect(settings.notificationsEnabled, isTrue);
      });

      test('should return existing settings when they exist', () async {
        // Arrange - Update settings first
        await dao.updateSettings(
          const AppSettingsCompanion(
            soundEnabled: Value(false),
            musicEnabled: Value(false),
            vibrationEnabled: Value(false),
          ),
        );

        // Act
        final settings = await dao.getSettings();

        // Assert
        expect(settings.soundEnabled, isFalse);
        expect(settings.musicEnabled, isFalse);
        expect(settings.vibrationEnabled, isFalse);
        // Other settings should remain default
        expect(settings.hapticFeedbackEnabled, isTrue);
        expect(settings.autoSaveEnabled, isTrue);
        expect(settings.notificationsEnabled, isTrue);
      });
    });

    group('updateSettings()', () {
      test('should update settings successfully', () async {
        // Arrange
        const updatedSettings = AppSettingsCompanion(
          soundEnabled: Value(false),
          musicEnabled: Value(true),
          vibrationEnabled: Value(false),
          hapticFeedbackEnabled: Value(true),
          autoSaveEnabled: Value(false),
          notificationsEnabled: Value(true),
        );

        // Act
        final result = await dao.updateSettings(updatedSettings);

        // Assert
        expect(result, greaterThan(0)); // At least one row updated

        // Verify settings were updated
        final settings = await dao.getSettings();
        expect(settings.soundEnabled, isFalse);
        expect(settings.musicEnabled, isTrue);
        expect(settings.vibrationEnabled, isFalse);
        expect(settings.hapticFeedbackEnabled, isTrue);
        expect(settings.autoSaveEnabled, isFalse);
        expect(settings.notificationsEnabled, isTrue);
      });

      test('should handle partial updates', () async {
        // Arrange - Update only some settings
        const partialSettings = AppSettingsCompanion(
          soundEnabled: Value(false),
          musicEnabled: Value(false),
        );

        // Act
        final result = await dao.updateSettings(partialSettings);

        // Assert
        expect(result, 1);

        final settings = await dao.getSettings();
        expect(settings.soundEnabled, isFalse);
        expect(settings.musicEnabled, isFalse);
        // Other settings should remain default
        expect(settings.vibrationEnabled, isTrue);
        expect(settings.hapticFeedbackEnabled, isTrue);
      });
    });

    group('watchSettings()', () {
      test('should emit settings changes reactively', () async {
        // Get initial state
        final initialSettings = await dao.getSettings();
        expect(initialSettings.soundEnabled, isTrue);

        // Update settings to trigger stream emission
        await dao.updateSettings(
          const AppSettingsCompanion(soundEnabled: Value(false)),
        );

        // Wait for updated state
        final updatedSettings = await dao.getSettings();
        expect(updatedSettings.soundEnabled, isFalse);
      });
    });

    // ===== CONVENIENCE METHODS =====

    group('Toggle Methods', () {
      test('toggleSound() should toggle sound setting', () async {
        // Act
        final result = await dao.toggleSound();

        // Assert
        expect(result, 1);

        final settings = await dao.getSettings();
        expect(
          settings.soundEnabled,
          isFalse,
        ); // Should be toggled from default true
      });

      test('toggleMusic() should toggle music setting', () async {
        // Act
        final result = await dao.toggleMusic();

        // Assert
        expect(result, 1);

        final settings = await dao.getSettings();
        expect(
          settings.musicEnabled,
          isFalse,
        ); // Should be toggled from default true
      });

      test('toggleVibration() should toggle vibration setting', () async {
        // Act
        final result = await dao.toggleVibration();

        // Assert
        expect(result, 1);

        final settings = await dao.getSettings();
        expect(
          settings.vibrationEnabled,
          isFalse,
        ); // Should be toggled from default true
      });

      test(
        'toggleHapticFeedback() should toggle haptic feedback setting',
        () async {
          // Act
          final result = await dao.toggleHapticFeedback();

          // Assert
          expect(result, 1);

          final settings = await dao.getSettings();
          expect(
            settings.hapticFeedbackEnabled,
            isFalse,
          ); // Should be toggled from default true
        },
      );

      test('toggleAutoSave() should toggle auto-save setting', () async {
        // Act
        final result = await dao.toggleAutoSave();

        // Assert
        expect(result, 1);

        final settings = await dao.getSettings();
        expect(
          settings.autoSaveEnabled,
          isFalse,
        ); // Should be toggled from default true
      });

      test(
        'toggleNotifications() should toggle notifications setting',
        () async {
          // Act
          final result = await dao.toggleNotifications();

          // Assert
          expect(result, 1);

          final settings = await dao.getSettings();
          expect(
            settings.notificationsEnabled,
            isFalse,
          ); // Should be toggled from default true
        },
      );
    });

    group('Set Methods', () {
      test('setSoundEnabled() should set sound enabled state', () async {
        // Act
        final result = await dao.setSoundEnabled(false);

        // Assert
        expect(result, 1);

        final settings = await dao.getSettings();
        expect(settings.soundEnabled, isFalse);
      });

      test('setMusicEnabled() should set music enabled state', () async {
        // Act
        final result = await dao.setMusicEnabled(false);

        // Assert
        expect(result, 1);

        final settings = await dao.getSettings();
        expect(settings.musicEnabled, isFalse);
      });

      test(
        'setVibrationEnabled() should set vibration enabled state',
        () async {
          // Act
          final result = await dao.setVibrationEnabled(false);

          // Assert
          expect(result, 1);

          final settings = await dao.getSettings();
          expect(settings.vibrationEnabled, isFalse);
        },
      );

      test(
        'setHapticFeedbackEnabled() should set haptic feedback enabled state',
        () async {
          // Act
          final result = await dao.setHapticFeedbackEnabled(false);

          // Assert
          expect(result, 1);

          final settings = await dao.getSettings();
          expect(settings.hapticFeedbackEnabled, isFalse);
        },
      );

      test('setAutoSaveEnabled() should set auto-save enabled state', () async {
        // Act
        final result = await dao.setAutoSaveEnabled(false);

        // Assert
        expect(result, 1);

        final settings = await dao.getSettings();
        expect(settings.autoSaveEnabled, isFalse);
      });

      test(
        'setNotificationsEnabled() should set notifications enabled state',
        () async {
          // Act
          final result = await dao.setNotificationsEnabled(false);

          // Assert
          expect(result, 1);

          final settings = await dao.getSettings();
          expect(settings.notificationsEnabled, isFalse);
        },
      );
    });

    group('resetToDefaults()', () {
      setUp(() async {
        // Change some settings first
        await dao.updateSettings(
          const AppSettingsCompanion(
            soundEnabled: Value(false),
            musicEnabled: Value(false),
            vibrationEnabled: Value(false),
          ),
        );
      });

      test('should reset all settings to defaults', () async {
        // Act
        final result = await dao.resetToDefaults();

        // Assert
        expect(result, 1);

        final settings = await dao.getSettings();
        expect(settings.soundEnabled, isTrue);
        expect(settings.musicEnabled, isTrue);
        expect(settings.vibrationEnabled, isTrue);
        expect(settings.hapticFeedbackEnabled, isTrue);
        expect(settings.autoSaveEnabled, isTrue);
        expect(settings.notificationsEnabled, isTrue);
      });
    });

    group('insertDefaultSettings()', () {
      test('should insert default settings successfully', () async {
        // Act
        final result = await dao.insertDefaultSettings();

        // Assert
        expect(result, 1);

        final settings = await dao.getSettings();
        expect(settings.soundEnabled, isTrue);
        expect(settings.musicEnabled, isTrue);
        expect(settings.vibrationEnabled, isTrue);
        expect(settings.hapticFeedbackEnabled, isTrue);
        expect(settings.autoSaveEnabled, isTrue);
        expect(settings.notificationsEnabled, isTrue);
      });
    });

    // ===== EDGE CASES AND ERROR HANDLING =====

    group('Edge Cases and Error Handling', () {
      test('should handle concurrent settings operations', () async {
        // Act - Perform multiple operations concurrently
        final operations = await Future.wait([
          dao.setSoundEnabled(false),
          dao.setMusicEnabled(true),
          dao.toggleVibration(),
          dao.getSettings(),
        ]);

        // Assert
        expect(operations[0], 1); // setSoundEnabled result
        expect(operations[1], 1); // setMusicEnabled result
        expect(operations[2], 1); // toggleVibration result

        final settings = operations[3] as AppSetting;
        expect(settings.soundEnabled, isFalse);
        expect(settings.musicEnabled, isTrue);
        expect(
          settings.vibrationEnabled,
          isFalse,
        ); // Was toggled from default true
      });

      test('should handle rapid toggle operations', () async {
        // Act - Toggle same setting multiple times rapidly
        await dao.toggleSound();
        await dao.toggleSound();
        await dao.toggleSound();

        // Assert
        final settings = await dao.getSettings();
        expect(
          settings.soundEnabled,
          isFalse,
        ); // Should end up false after 3 toggles from true
      });

      test('should maintain consistency during mixed operations', () async {
        // Act - Mix of set and toggle operations
        await dao.setSoundEnabled(false);
        await dao.toggleMusic();
        await dao.setVibrationEnabled(true);
        await dao.toggleHapticFeedback();

        // Assert
        final settings = await dao.getSettings();
        expect(settings.soundEnabled, isFalse);
        expect(settings.musicEnabled, isFalse); // Toggled from true
        expect(settings.vibrationEnabled, isTrue);
        expect(settings.hapticFeedbackEnabled, isFalse); // Toggled from true
        expect(settings.autoSaveEnabled, isTrue); // Unchanged
        expect(settings.notificationsEnabled, isTrue); // Unchanged
      });

      test('should handle operations when settings table is empty', () async {
        // This shouldn't happen in practice due to database initialization,
        // but testing the robustness

        // Act & Assert - Should not throw exceptions
        expect(() async => await dao.toggleSound(), returnsNormally);
        expect(() async => await dao.setMusicEnabled(false), returnsNormally);
        expect(() async => await dao.resetToDefaults(), returnsNormally);

        // Should still work correctly
        final settings = await dao.getSettings();
        expect(
          settings.soundEnabled,
          isFalse,
        ); // From toggle (toggles from default true)
        expect(settings.musicEnabled, isFalse); // From set
      });
    });

    // ===== INTEGRATION WITH REACTIVE STREAMS =====

    group('Reactive Integration', () {
      test('watchSettings() should reflect toggle operations', () async {
        // Act & Assert
        final stream = dao.watchSettings();

        // Wait for initial emission
        final initialSettings = await stream.first;
        expect(initialSettings.soundEnabled, isTrue);

        // Toggle sound to trigger stream emission
        await dao.toggleSound();

        // Wait for updated emission
        final updatedSettings = await stream.first;
        expect(updatedSettings.soundEnabled, isFalse);
      });

      test('watchSettings() should reflect set operations', () async {
        // Get initial state
        final initialSettings = await dao.getSettings();
        expect(initialSettings.musicEnabled, isTrue);

        // Set music to false to trigger stream emission
        await dao.setMusicEnabled(false);

        // Wait for updated state
        final updatedSettings = await dao.getSettings();
        expect(updatedSettings.musicEnabled, isFalse);
      });

      test('watchSettings() should reflect reset operations', () async {
        // Arrange - Change some settings first
        await dao.setSoundEnabled(false);
        await dao.setMusicEnabled(false);

        // Get current state
        final currentSettings = await dao.getSettings();
        expect(currentSettings.soundEnabled, isFalse);
        expect(currentSettings.musicEnabled, isFalse);

        // Reset to defaults to trigger stream emission
        await dao.resetToDefaults();

        // Wait for updated state
        final resetSettings = await dao.getSettings();
        expect(resetSettings.soundEnabled, isTrue);
        expect(resetSettings.musicEnabled, isTrue);
      });
    });
  });
}
