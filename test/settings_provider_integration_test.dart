import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:tictactoe_xo_royale/core/database/app_database.dart';
import 'package:tictactoe_xo_royale/core/database/database_providers.dart';
import 'package:tictactoe_xo_royale/core/database/app_database.dart' as db;
import 'package:tictactoe_xo_royale/core/providers/settings_provider.dart';

void main() {
  group('SettingsProvider Integration Tests', () {
    late ProviderContainer container;
    late AppDatabase database;

    setUp(() {
      // Create in-memory database for testing
      database = AppDatabase(NativeDatabase.memory());

      // Create provider container with database overrides
      container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
      );
    });

    tearDown(() async {
      container.dispose();
      await database.close();
    });

    group('Settings Loading and Initialization', () {
      test('should load existing settings from database', () async {
        // Arrange - Create settings in the database
        await database.appSettingsDao.updateSettings(
          db.AppSettingsCompanion(
            soundEnabled: Value(true),
            musicEnabled: Value(false),
            vibrationEnabled: Value(true),
            hapticFeedbackEnabled: Value(false),
            autoSaveEnabled: Value(true),
            notificationsEnabled: Value(false),
          ),
        );

        // Act - Initialize provider and load settings

        // Wait for async initialization
        await container.pump();

        // Assert
        final settings = container.read(settingsProvider);
        expect(settings.soundEnabled, isTrue);
        expect(settings.musicEnabled, isFalse);
        expect(settings.vibrationEnabled, isTrue);
        expect(settings.hapticFeedbackEnabled, isFalse);
        expect(settings.autoSaveEnabled, isTrue);
        expect(settings.notificationsEnabled, isFalse);
      });

      test('should create default settings when none exist', () async {
        // Act - Initialize provider when no settings exist

        // Wait for async initialization
        await container.pump();

        // Assert
        final settings = container.read(settingsProvider);
        expect(settings.soundEnabled, isTrue); // Default
        expect(settings.musicEnabled, isTrue); // Default
        expect(settings.vibrationEnabled, isTrue); // Default
        expect(settings.hapticFeedbackEnabled, isTrue); // Default
        expect(settings.autoSaveEnabled, isTrue); // Default
        expect(settings.notificationsEnabled, isTrue); // Default
      });

      test(
        'should handle database errors gracefully during settings loading',
        () async {
          // Arrange - Close database to simulate connection error
          await database.close();

          // Act - Try to initialize provider with closed database

          // Wait for async operation
          await container.pump();

          // Assert - Default settings should still be available
          final settings = container.read(settingsProvider);
          expect(settings.soundEnabled, isTrue); // Default value
          expect(settings.musicEnabled, isTrue); // Default value
        },
      );
    });

    group('Settings Updates and Persistence', () {
      test('should update sound setting and persist to database', () async {
        // Arrange
        await database.appSettingsDao.updateSettings(
          db.AppSettingsCompanion(
            soundEnabled: Value(true),
            musicEnabled: Value(true),
            vibrationEnabled: Value(true),
            hapticFeedbackEnabled: Value(true),
            autoSaveEnabled: Value(true),
            notificationsEnabled: Value(true),
          ),
        );

        await container.pump(); // Wait for initialization

        // Act
        final settingsNotifier = container.read(settingsProvider.notifier);
        await settingsNotifier.setSoundEnabled(enabled: false);
        await container.pump();

        // Assert
        final settings = container.read(settingsProvider);
        expect(settings.soundEnabled, isFalse);

        // Verify persistence by reading directly from database
        final dbSettings = await database.appSettingsDao.getSettings();
        expect(dbSettings.soundEnabled, isFalse);
      });

      test('should update music setting and persist to database', () async {
        // Arrange
        await database.appSettingsDao.updateSettings(
          db.AppSettingsCompanion(
            soundEnabled: Value(true),
            musicEnabled: Value(true),
            vibrationEnabled: Value(true),
            hapticFeedbackEnabled: Value(true),
            autoSaveEnabled: Value(true),
            notificationsEnabled: Value(true),
          ),
        );

        await container.pump(); // Wait for initialization

        // Act
        final settingsNotifier = container.read(settingsProvider.notifier);
        await settingsNotifier.setMusicEnabled(enabled: false);
        await container.pump();

        // Assert
        final settings = container.read(settingsProvider);
        expect(settings.musicEnabled, isFalse);

        // Verify persistence
        final dbSettings = await database.appSettingsDao.getSettings();
        expect(dbSettings.musicEnabled, isFalse);
      });

      test('should update vibration setting and persist to database', () async {
        // Arrange
        await database.appSettingsDao.updateSettings(
          db.AppSettingsCompanion(
            soundEnabled: Value(true),
            musicEnabled: Value(true),
            vibrationEnabled: Value(true),
            hapticFeedbackEnabled: Value(true),
            autoSaveEnabled: Value(true),
            notificationsEnabled: Value(true),
          ),
        );

        await container.pump(); // Wait for initialization

        // Act
        final settingsNotifier = container.read(settingsProvider.notifier);
        await settingsNotifier.setVibrationEnabled(enabled: false);
        await container.pump();

        // Assert
        final settings = container.read(settingsProvider);
        expect(settings.vibrationEnabled, isFalse);

        // Verify persistence
        final dbSettings = await database.appSettingsDao.getSettings();
        expect(dbSettings.vibrationEnabled, isFalse);
      });

      test(
        'should update haptic feedback setting and persist to database',
        () async {
          // Arrange
          await database.appSettingsDao.updateSettings(
            db.AppSettingsCompanion(
              soundEnabled: Value(true),
              musicEnabled: Value(true),
              vibrationEnabled: Value(true),
              hapticFeedbackEnabled: Value(true),
              autoSaveEnabled: Value(true),
              notificationsEnabled: Value(true),
            ),
          );

          await container.pump(); // Wait for initialization

          // Act
          final settingsNotifier = container.read(settingsProvider.notifier);
          await settingsNotifier.setHapticFeedbackEnabled(enabled: false);
          await container.pump();

          // Assert
          final settings = container.read(settingsProvider);
          expect(settings.hapticFeedbackEnabled, isFalse);

          // Verify persistence
          final dbSettings = await database.appSettingsDao.getSettings();
          expect(dbSettings.hapticFeedbackEnabled, isFalse);
        },
      );

      test('should update auto save setting and persist to database', () async {
        // Arrange
        await database.appSettingsDao.updateSettings(
          db.AppSettingsCompanion(
            soundEnabled: Value(true),
            musicEnabled: Value(true),
            vibrationEnabled: Value(true),
            hapticFeedbackEnabled: Value(true),
            autoSaveEnabled: Value(true),
            notificationsEnabled: Value(true),
          ),
        );

        await container.pump(); // Wait for initialization

        // Act
        final settingsNotifier = container.read(settingsProvider.notifier);
        await settingsNotifier.setAutoSaveEnabled(enabled: false);
        await container.pump();

        // Assert
        final settings = container.read(settingsProvider);
        expect(settings.autoSaveEnabled, isFalse);

        // Verify persistence
        final dbSettings = await database.appSettingsDao.getSettings();
        expect(dbSettings.autoSaveEnabled, isFalse);
      });

      test(
        'should update notifications setting and persist to database',
        () async {
          // Arrange
          await database.appSettingsDao.updateSettings(
            db.AppSettingsCompanion(
              soundEnabled: Value(true),
              musicEnabled: Value(true),
              vibrationEnabled: Value(true),
              hapticFeedbackEnabled: Value(true),
              autoSaveEnabled: Value(true),
              notificationsEnabled: Value(true),
            ),
          );

          await container.pump(); // Wait for initialization

          // Act
          final settingsNotifier = container.read(settingsProvider.notifier);
          await settingsNotifier.setNotificationsEnabled(enabled: false);
          await container.pump();

          // Assert
          final settings = container.read(settingsProvider);
          expect(settings.notificationsEnabled, isFalse);

          // Verify persistence
          final dbSettings = await database.appSettingsDao.getSettings();
          expect(dbSettings.notificationsEnabled, isFalse);
        },
      );
    });

    group('Toggle Methods', () {
      test('should toggle sound setting correctly', () async {
        // Arrange - Start with sound disabled
        await database.appSettingsDao.updateSettings(
          db.AppSettingsCompanion(
            soundEnabled: Value(false),
            musicEnabled: Value(true),
            vibrationEnabled: Value(true),
            hapticFeedbackEnabled: Value(true),
            autoSaveEnabled: Value(true),
            notificationsEnabled: Value(true),
          ),
        );

        await container.pump();

        // Act - Toggle sound
        final settingsNotifier = container.read(settingsProvider.notifier);
        await settingsNotifier.toggleSound();
        await container.pump();

        // Assert
        final settings = container.read(settingsProvider);
        expect(settings.soundEnabled, isTrue); // Should be toggled on

        // Verify persistence
        final dbSettings = await database.appSettingsDao.getSettings();
        expect(dbSettings.soundEnabled, isTrue);
      });

      test('should toggle music setting correctly', () async {
        // Arrange - Start with music enabled
        await database.appSettingsDao.updateSettings(
          db.AppSettingsCompanion(
            soundEnabled: Value(true),
            musicEnabled: Value(true),
            vibrationEnabled: Value(true),
            hapticFeedbackEnabled: Value(true),
            autoSaveEnabled: Value(true),
            notificationsEnabled: Value(true),
          ),
        );

        await container.pump();

        // Act - Toggle music
        final settingsNotifier = container.read(settingsProvider.notifier);
        await settingsNotifier.toggleMusic();
        await container.pump();

        // Assert
        final settings = container.read(settingsProvider);
        expect(settings.musicEnabled, isFalse); // Should be toggled off

        // Verify persistence
        final dbSettings = await database.appSettingsDao.getSettings();
        expect(dbSettings.musicEnabled, isFalse);
      });

      test('should toggle vibration setting correctly', () async {
        // Arrange - Start with vibration enabled
        await database.appSettingsDao.updateSettings(
          db.AppSettingsCompanion(
            soundEnabled: Value(true),
            musicEnabled: Value(true),
            vibrationEnabled: Value(true),
            hapticFeedbackEnabled: Value(true),
            autoSaveEnabled: Value(true),
            notificationsEnabled: Value(true),
          ),
        );

        await container.pump();

        // Act - Toggle vibration
        final settingsNotifier = container.read(settingsProvider.notifier);
        await settingsNotifier.toggleVibration();
        await container.pump();

        // Assert
        final settings = container.read(settingsProvider);
        expect(settings.vibrationEnabled, isFalse); // Should be toggled off

        // Verify persistence
        final dbSettings = await database.appSettingsDao.getSettings();
        expect(dbSettings.vibrationEnabled, isFalse);
      });

      test('should toggle haptic feedback setting correctly', () async {
        // Arrange - Start with haptic enabled
        await database.appSettingsDao.updateSettings(
          db.AppSettingsCompanion(
            soundEnabled: Value(true),
            musicEnabled: Value(true),
            vibrationEnabled: Value(true),
            hapticFeedbackEnabled: Value(true),
            autoSaveEnabled: Value(true),
            notificationsEnabled: Value(true),
          ),
        );

        await container.pump();

        // Act - Toggle haptic feedback
        final settingsNotifier = container.read(settingsProvider.notifier);
        await settingsNotifier.toggleHapticFeedback();
        await container.pump();

        // Assert
        final settings = container.read(settingsProvider);
        expect(
          settings.hapticFeedbackEnabled,
          isFalse,
        ); // Should be toggled off

        // Verify persistence
        final dbSettings = await database.appSettingsDao.getSettings();
        expect(dbSettings.hapticFeedbackEnabled, isFalse);
      });
    });

    group('Computed Properties', () {
      test('should compute isAudioEnabled correctly', () async {
        // Arrange - Settings with only sound enabled
        await database.appSettingsDao.updateSettings(
          db.AppSettingsCompanion(
            soundEnabled: Value(true),
            musicEnabled: Value(false),
            vibrationEnabled: Value(true),
            hapticFeedbackEnabled: Value(true),
            autoSaveEnabled: Value(true),
            notificationsEnabled: Value(true),
          ),
        );

        await container.pump();

        // Act & Assert
        final settings = container.read(settingsProvider);
        expect(settings.isAudioEnabled, isTrue); // Sound enabled

        // Disable sound
        final settingsNotifier = container.read(settingsProvider.notifier);
        await settingsNotifier.setSoundEnabled(enabled: false);
        await container.pump();

        final updatedSettings = container.read(settingsProvider);
        expect(updatedSettings.isAudioEnabled, isFalse); // No audio enabled
      });

      test('should compute isHapticEnabled correctly', () async {
        // Arrange - Settings with only vibration enabled
        await database.appSettingsDao.updateSettings(
          db.AppSettingsCompanion(
            soundEnabled: Value(true),
            musicEnabled: Value(true),
            vibrationEnabled: Value(true),
            hapticFeedbackEnabled: Value(false),
            autoSaveEnabled: Value(true),
            notificationsEnabled: Value(true),
          ),
        );

        await container.pump();

        // Act & Assert
        final settings = container.read(settingsProvider);
        expect(settings.isHapticEnabled, isTrue); // Vibration enabled

        // Disable vibration
        final settingsNotifier = container.read(settingsProvider.notifier);
        await settingsNotifier.setVibrationEnabled(enabled: false);
        await container.pump();

        final updatedSettings = container.read(settingsProvider);
        expect(updatedSettings.isHapticEnabled, isFalse); // No haptic enabled
      });

      test('should handle mixed audio/haptic settings correctly', () async {
        // Arrange - Mixed settings
        await database.appSettingsDao.updateSettings(
          db.AppSettingsCompanion(
            soundEnabled: Value(true),
            musicEnabled: Value(false),
            vibrationEnabled: Value(false),
            hapticFeedbackEnabled: Value(true),
            autoSaveEnabled: Value(true),
            notificationsEnabled: Value(true),
          ),
        );

        await container.pump();

        // Assert
        final settings = container.read(settingsProvider);
        expect(settings.isAudioEnabled, isTrue); // Sound enabled
        expect(settings.isHapticEnabled, isTrue); // Haptic enabled
      });
    });

    group('Reset Functionality', () {
      test('should reset settings to defaults', () async {
        // Arrange - Set up custom settings
        await database.appSettingsDao.updateSettings(
          db.AppSettingsCompanion(
            soundEnabled: Value(false),
            musicEnabled: Value(false),
            vibrationEnabled: Value(false),
            hapticFeedbackEnabled: Value(false),
            autoSaveEnabled: Value(false),
            notificationsEnabled: Value(false),
          ),
        );

        await container.pump();

        // Verify custom settings
        var settings = container.read(settingsProvider);
        expect(settings.soundEnabled, isFalse);
        expect(settings.musicEnabled, isFalse);

        // Act - Reset to defaults
        final settingsNotifier = container.read(settingsProvider.notifier);
        await settingsNotifier.resetToDefaults();
        await container.pump();

        // Assert - Settings reset to defaults
        settings = container.read(settingsProvider);
        expect(settings.soundEnabled, isTrue); // Default
        expect(settings.musicEnabled, isTrue); // Default
        expect(settings.vibrationEnabled, isTrue); // Default
        expect(settings.hapticFeedbackEnabled, isTrue); // Default
        expect(settings.autoSaveEnabled, isTrue); // Default
        expect(settings.notificationsEnabled, isTrue); // Default

        // Verify persistence
        final dbSettings = await database.appSettingsDao.getSettings();
        expect(dbSettings.soundEnabled, isTrue);
        expect(dbSettings.musicEnabled, isTrue);
        expect(dbSettings.vibrationEnabled, isTrue);
        expect(dbSettings.hapticFeedbackEnabled, isTrue);
        expect(dbSettings.autoSaveEnabled, isTrue);
        expect(dbSettings.notificationsEnabled, isTrue);
      });
    });

    group('Extension Methods Integration', () {
      test('should provide all extension methods correctly', () async {
        // Arrange
        await container.pump();

        // Act & Assert - Test all extension methods
        expect(
          () => container.read(settingsProvider.notifier),
          returnsNormally,
        );
        expect(() => container.read(soundEnabledProvider), returnsNormally);
        expect(() => container.read(musicEnabledProvider), returnsNormally);
        expect(() => container.read(vibrationEnabledProvider), returnsNormally);
        expect(
          () => container.read(hapticFeedbackEnabledProvider),
          returnsNormally,
        );
        expect(() => container.read(autoSaveEnabledProvider), returnsNormally);
        expect(
          () => container.read(notificationsEnabledProvider),
          returnsNormally,
        );
        expect(() => container.read(isAudioEnabledProvider), returnsNormally);
        expect(() => container.read(isHapticEnabledProvider), returnsNormally);
      });

      test('should update extension methods reactively', () async {
        // Arrange
        await database.appSettingsDao.updateSettings(
          db.AppSettingsCompanion(
            soundEnabled: Value(true),
            musicEnabled: Value(true),
            vibrationEnabled: Value(true),
            hapticFeedbackEnabled: Value(true),
            autoSaveEnabled: Value(true),
            notificationsEnabled: Value(true),
          ),
        );

        await container.pump();

        // Act - Update sound setting
        final settingsNotifier = container.read(settingsProvider.notifier);
        await settingsNotifier.setSoundEnabled(enabled: false);
        await container.pump();

        // Assert - Extension methods reflect updates
        expect(container.read(soundEnabledProvider), isFalse);
        expect(
          container.read(isAudioEnabledProvider),
          isTrue,
        ); // Music still enabled
      });

      test('should handle computed properties in extension methods', () async {
        // Arrange - Settings with only sound enabled
        await database.appSettingsDao.updateSettings(
          db.AppSettingsCompanion(
            soundEnabled: Value(true),
            musicEnabled: Value(false),
            vibrationEnabled: Value(false),
            hapticFeedbackEnabled: Value(false),
            autoSaveEnabled: Value(true),
            notificationsEnabled: Value(true),
          ),
        );

        await container.pump();

        // Assert - Computed properties work correctly
        expect(container.read(isAudioEnabledProvider), isTrue); // Sound enabled
        expect(
          container.read(isHapticEnabledProvider),
          isFalse,
        ); // No haptic enabled
      });
    });

    group('Error Handling', () {
      test('should handle database errors during settings save', () async {
        // Arrange - Close database to simulate error
        await database.close();

        await container.pump();

        // Act - Try to update setting with closed database
        final settingsNotifier = container.read(settingsProvider.notifier);
        await settingsNotifier.setSoundEnabled(enabled: false);

        // Assert - Should not crash, but operation might fail silently
        // The provider should handle errors gracefully
        final settings = container.read(settingsProvider);
        // Settings should remain at default values since save failed
        expect(settings.soundEnabled, isTrue); // Still default
      });

      test(
        'should recover from database errors on subsequent operations',
        () async {
          // Arrange - Set up working settings first
          await database.appSettingsDao.updateSettings(
            db.AppSettingsCompanion(
              soundEnabled: Value(true),
              musicEnabled: Value(true),
              vibrationEnabled: Value(true),
              hapticFeedbackEnabled: Value(true),
              autoSaveEnabled: Value(true),
              notificationsEnabled: Value(true),
            ),
          );

          await container.pump();

          // Verify working state
          var settings = container.read(settingsProvider);
          expect(settings.soundEnabled, isTrue);

          // Act - Simulate database error by closing and reopening
          await database.close();

          // Create new database
          final newDatabase = AppDatabase(NativeDatabase.memory());
          final newContainer = ProviderContainer(
            overrides: [appDatabaseProvider.overrideWithValue(newDatabase)],
          );

          // Wait for new container to initialize
          await newContainer.pump();

          // Assert - New container should work with default settings
          final newSettings = newContainer.read(settingsProvider);
          expect(newSettings.soundEnabled, isTrue); // Default value

          newContainer.dispose();
          await newDatabase.close();
        },
      );
    });

    group('Reactive Updates', () {
      test(
        'should update settings reactively across multiple listeners',
        () async {
          // Arrange - Set up settings
          await database.appSettingsDao.updateSettings(
            db.AppSettingsCompanion(
              soundEnabled: Value(true),
              musicEnabled: Value(true),
              vibrationEnabled: Value(true),
              hapticFeedbackEnabled: Value(true),
              autoSaveEnabled: Value(true),
              notificationsEnabled: Value(true),
            ),
          );

          await container.pump();

          // Create multiple listeners
          final soundListener = container.listen(soundEnabledProvider, (
            previous,
            next,
          ) {
            // Track changes
          });

          final musicListener = container.listen(musicEnabledProvider, (
            previous,
            next,
          ) {
            // Track changes
          });

          // Act - Update sound setting
          final settingsNotifier = container.read(settingsProvider.notifier);
          await settingsNotifier.setSoundEnabled(enabled: false);
          await container.pump();

          // Assert - Both listeners should receive updates
          expect(container.read(soundEnabledProvider), isFalse);
          expect(
            container.read(musicEnabledProvider),
            isTrue,
          ); // Music unchanged

          soundListener.close();
          musicListener.close();
        },
      );

      test('should handle rapid setting changes without issues', () async {
        // Arrange
        await container.pump();

        // Act - Perform rapid setting changes
        final settingsNotifier = container.read(settingsProvider.notifier);
        for (int i = 0; i < 10; i++) {
          await settingsNotifier.setSoundEnabled(enabled: i % 2 == 0);
          await settingsNotifier.setMusicEnabled(enabled: i % 2 == 1);
          await container.pump();
        }

        // Assert - Final state should be consistent
        final settings = container.read(settingsProvider);
        expect(settings.soundEnabled, isFalse); // Last sound setting (even i)
        expect(settings.musicEnabled, isTrue); // Last music setting (odd i)

        // Verify persistence
        final dbSettings = await database.appSettingsDao.getSettings();
        expect(dbSettings.soundEnabled, isFalse);
        expect(dbSettings.musicEnabled, isTrue);
      });
    });

    group('Default Settings Creation', () {
      test('should create default settings when database is empty', () async {
        // Act - Initialize provider with empty database
        await container.pump();

        // Assert - Default settings should be created and available
        final settings = container.read(settingsProvider);
        expect(settings.soundEnabled, isTrue);
        expect(settings.musicEnabled, isTrue);
        expect(settings.vibrationEnabled, isTrue);
        expect(settings.hapticFeedbackEnabled, isTrue);
        expect(settings.autoSaveEnabled, isTrue);
        expect(settings.notificationsEnabled, isTrue);

        // Verify persistence in database
        final dbSettings = await database.appSettingsDao.getSettings();
        expect(dbSettings.soundEnabled, isTrue);
        expect(dbSettings.musicEnabled, isTrue);
        expect(dbSettings.vibrationEnabled, isTrue);
        expect(dbSettings.hapticFeedbackEnabled, isTrue);
        expect(dbSettings.autoSaveEnabled, isTrue);
        expect(dbSettings.notificationsEnabled, isTrue);
      });

      test('should handle partial default settings creation', () async {
        // Arrange - Create settings with only some fields set
        await database.appSettingsDao.updateSettings(
          db.AppSettingsCompanion(
            soundEnabled: Value(true),
            // Leave others as defaults (null values)
          ),
        );

        // Act - Initialize provider
        await container.pump();

        // Assert - All settings should have proper default values
        final settings = container.read(settingsProvider);
        expect(settings.soundEnabled, isTrue); // Explicitly set
        expect(settings.musicEnabled, isTrue); // Default
        expect(settings.vibrationEnabled, isTrue); // Default
        expect(settings.hapticFeedbackEnabled, isTrue); // Default
        expect(settings.autoSaveEnabled, isTrue); // Default
        expect(settings.notificationsEnabled, isTrue); // Default
      });
    });

    group('Settings State Management', () {
      test(
        'should maintain settings state consistency during updates',
        () async {
          // Arrange
          await database.appSettingsDao.updateSettings(
            db.AppSettingsCompanion(
              soundEnabled: Value(true),
              musicEnabled: Value(true),
              vibrationEnabled: Value(true),
              hapticFeedbackEnabled: Value(true),
              autoSaveEnabled: Value(true),
              notificationsEnabled: Value(true),
            ),
          );

          await container.pump();

          // Act - Update multiple settings
          final settingsNotifier = container.read(settingsProvider.notifier);
          await settingsNotifier.setSoundEnabled(enabled: false);
          await settingsNotifier.setVibrationEnabled(enabled: false);
          await settingsNotifier.setAutoSaveEnabled(enabled: false);
          await container.pump();

          // Assert - All updates should be consistent
          final settings = container.read(settingsProvider);
          expect(settings.soundEnabled, isFalse);
          expect(settings.musicEnabled, isTrue); // Unchanged
          expect(settings.vibrationEnabled, isFalse);
          expect(settings.hapticFeedbackEnabled, isTrue); // Unchanged
          expect(settings.autoSaveEnabled, isFalse);
          expect(settings.notificationsEnabled, isTrue); // Unchanged

          // Verify computed properties
          expect(settings.isAudioEnabled, isTrue); // Music still enabled
          expect(settings.isHapticEnabled, isFalse); // No haptic enabled

          // Verify persistence
          final dbSettings = await database.appSettingsDao.getSettings();
          expect(dbSettings.soundEnabled, isFalse);
          expect(dbSettings.musicEnabled, isTrue);
          expect(dbSettings.vibrationEnabled, isFalse);
          expect(dbSettings.hapticFeedbackEnabled, isTrue);
          expect(dbSettings.autoSaveEnabled, isFalse);
          expect(dbSettings.notificationsEnabled, isTrue);
        },
      );

      test('should handle settings state during provider disposal', () async {
        // Arrange
        await database.appSettingsDao.updateSettings(
          db.AppSettingsCompanion(
            soundEnabled: Value(true),
            musicEnabled: Value(true),
            vibrationEnabled: Value(true),
            hapticFeedbackEnabled: Value(true),
            autoSaveEnabled: Value(true),
            notificationsEnabled: Value(true),
          ),
        );

        await container.pump();

        // Act - Dispose container
        container.dispose();

        // Assert - No errors should occur during disposal
        // This test mainly ensures no exceptions are thrown
        expect(true, isTrue); // Test passes if no exceptions
      });
    });
  });
}
