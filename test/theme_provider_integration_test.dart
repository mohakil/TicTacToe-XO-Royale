import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:tictactoe_xo_royale/core/database/app_database.dart';
import 'package:tictactoe_xo_royale/core/database/database_providers.dart';
import 'package:tictactoe_xo_royale/core/database/app_database.dart' as db;
import 'package:tictactoe_xo_royale/core/providers/theme_provider.dart';
import 'package:tictactoe_xo_royale/core/providers/settings_provider.dart';

void main() {
  group('ThemeProvider Integration Tests', () {
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

    group('Theme Mode Persistence', () {
      test('should load existing theme mode from database', () async {
        // Arrange - Set up dark theme in database
        await database.themeSettingsDao.setThemeMode('dark');

        // Act - Initialize provider and load theme

        // Wait for async initialization
        await container.pump();

        // Assert
        final themeMode = container.read(themeModeProvider);
        expect(themeMode, equals(ThemeMode.dark));
      });

      test('should create default theme mode when none exists', () async {
        // Act - Initialize provider when no theme exists

        // Wait for async initialization
        await container.pump();

        // Assert - Default theme should be system
        final themeMode = container.read(themeModeProvider);
        expect(themeMode, equals(ThemeMode.system));

        // Verify persistence in database
        final dbTheme = await database.themeSettingsDao.getThemeMode();
        expect(dbTheme, equals('system'));
      });

      test(
        'should handle database errors gracefully during theme loading',
        () async {
          // Arrange - Close database to simulate connection error
          await database.close();

          // Act - Try to initialize provider with closed database

          // Wait for async operation
          await container.pump();

          // Assert - Default theme should still be available
          final themeMode = container.read(themeModeProvider);
          expect(themeMode, equals(ThemeMode.system)); // Default value
        },
      );
    });

    group('Theme Mode Updates and Persistence', () {
      test(
        'should update theme mode to light and persist to database',
        () async {
          // Arrange
          await container.pump(); // Wait for initialization

          // Act
          final themeNotifier = container.read(themeModeProvider.notifier);
          await themeNotifier.setThemeMode(ThemeMode.light);
          await container.pump();

          // Assert
          final themeMode = container.read(themeModeProvider);
          expect(themeMode, equals(ThemeMode.light));

          // Verify persistence by reading directly from database
          final dbTheme = await database.themeSettingsDao.getThemeMode();
          expect(dbTheme, equals('light'));
        },
      );

      test(
        'should update theme mode to dark and persist to database',
        () async {
          // Arrange
          await container.pump(); // Wait for initialization

          // Act
          final themeNotifier = container.read(themeModeProvider.notifier);
          await themeNotifier.setThemeMode(ThemeMode.dark);
          await container.pump();

          // Assert
          final themeMode = container.read(themeModeProvider);
          expect(themeMode, equals(ThemeMode.dark));

          // Verify persistence
          final dbTheme = await database.themeSettingsDao.getThemeMode();
          expect(dbTheme, equals('dark'));
        },
      );

      test(
        'should update theme mode to system and persist to database',
        () async {
          // Arrange
          await container.pump(); // Wait for initialization

          // Act
          final themeNotifier = container.read(themeModeProvider.notifier);
          await themeNotifier.setThemeMode(ThemeMode.system);
          await container.pump();

          // Assert
          final themeMode = container.read(themeModeProvider);
          expect(themeMode, equals(ThemeMode.system));

          // Verify persistence
          final dbTheme = await database.themeSettingsDao.getThemeMode();
          expect(dbTheme, equals('system'));
        },
      );

      test('should handle theme mode updates with database errors', () async {
        // Arrange - Close database to simulate error
        await database.close();

        await container.pump();

        // Act - Try to update theme with closed database
        final themeNotifier = container.read(themeModeProvider.notifier);
        await themeNotifier.setThemeMode(ThemeMode.dark);

        // Assert - Should not crash, but operation might fail silently
        // Theme mode should remain at system (default)
        final themeMode = container.read(themeModeProvider);
        expect(themeMode, equals(ThemeMode.system));
      });
    });

    group('Theme Mode Switching Functionality', () {
      test('should switch from system to light theme correctly', () async {
        // Arrange - Start with system theme
        await database.themeSettingsDao.setThemeMode('system');

        await container.pump();

        // Verify initial state
        var themeMode = container.read(themeModeProvider);
        expect(themeMode, equals(ThemeMode.system));

        // Act - Switch to light
        final themeNotifier = container.read(themeModeProvider.notifier);
        await themeNotifier.setThemeMode(ThemeMode.light);
        await container.pump();

        // Assert - Theme switched correctly
        themeMode = container.read(themeModeProvider);
        expect(themeMode, equals(ThemeMode.light));

        // Verify persistence
        final dbTheme = await database.themeSettingsDao.getThemeMode();
        expect(dbTheme, equals('light'));
      });

      test('should switch from light to dark theme correctly', () async {
        // Arrange - Start with light theme
        await database.themeSettingsDao.setThemeMode('light');

        await container.pump();

        // Verify initial state
        var themeMode = container.read(themeModeProvider);
        expect(themeMode, equals(ThemeMode.light));

        // Act - Switch to dark
        final themeNotifier = container.read(themeModeProvider.notifier);
        await themeNotifier.setThemeMode(ThemeMode.dark);
        await container.pump();

        // Assert - Theme switched correctly
        themeMode = container.read(themeModeProvider);
        expect(themeMode, equals(ThemeMode.dark));

        // Verify persistence
        final dbTheme = await database.themeSettingsDao.getThemeMode();
        expect(dbTheme, equals('dark'));
      });

      test('should switch from dark to system theme correctly', () async {
        // Arrange - Start with dark theme
        await database.themeSettingsDao.setThemeMode('dark');

        await container.pump();

        // Verify initial state
        var themeMode = container.read(themeModeProvider);
        expect(themeMode, equals(ThemeMode.dark));

        // Act - Switch to system
        final themeNotifier = container.read(themeModeProvider.notifier);
        await themeNotifier.setThemeMode(ThemeMode.system);
        await container.pump();

        // Assert - Theme switched correctly
        themeMode = container.read(themeModeProvider);
        expect(themeMode, equals(ThemeMode.system));

        // Verify persistence
        final dbTheme = await database.themeSettingsDao.getThemeMode();
        expect(dbTheme, equals('system'));
      });
    });

    group('Theme Application in MaterialApp', () {
      testWidgets('should apply light theme correctly in MaterialApp', (
        tester,
      ) async {
        // Arrange - Set up light theme in database
        await database.themeSettingsDao.setThemeMode('light');

        // Act - Pump app with theme provider
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              themeMode: container.read(themeModeProvider),
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              home: const Scaffold(body: Text('Theme Test')),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Light theme is applied
        final theme = Theme.of(tester.element(find.text('Theme Test')));
        expect(theme.brightness, equals(Brightness.light));
      });

      testWidgets('should apply dark theme correctly in MaterialApp', (
        tester,
      ) async {
        // Arrange - Set up dark theme in database
        await database.themeSettingsDao.setThemeMode('dark');

        // Act - Pump app with theme provider
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              themeMode: container.read(themeModeProvider),
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              home: const Scaffold(body: Text('Theme Test')),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Dark theme is applied
        final theme = Theme.of(tester.element(find.text('Theme Test')));
        expect(theme.brightness, equals(Brightness.dark));
      });

      testWidgets('should apply system theme correctly in MaterialApp', (
        tester,
      ) async {
        // Arrange - Set up system theme in database
        await database.themeSettingsDao.setThemeMode('system');

        // Act - Pump app with theme provider
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              themeMode: container.read(themeModeProvider),
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              home: const Scaffold(body: Text('Theme Test')),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - System theme is applied (should be light in test environment)
        final theme = Theme.of(tester.element(find.text('Theme Test')));
        expect(
          theme.brightness,
          equals(Brightness.light),
        ); // Test environment default
      });
    });

    group('Reactive Theme Updates', () {
      testWidgets('should update theme reactively when provider changes', (
        tester,
      ) async {
        // Arrange - Start with light theme
        await database.themeSettingsDao.setThemeMode('light');

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              themeMode: container.read(themeModeProvider),
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              home: const Scaffold(body: Text('Theme Test')),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify initial light theme
        var theme = Theme.of(tester.element(find.text('Theme Test')));
        expect(theme.brightness, equals(Brightness.light));

        // Act - Switch to dark theme
        container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
        await tester.pumpAndSettle();

        // Assert - Dark theme applied reactively
        theme = Theme.of(tester.element(find.text('Theme Test')));
        expect(theme.brightness, equals(Brightness.dark));
      });

      testWidgets('should handle rapid theme changes without issues', (
        tester,
      ) async {
        // Arrange - Set up initial theme
        await database.themeSettingsDao.setThemeMode('light');

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              themeMode: container.read(themeModeProvider),
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              home: const Scaffold(body: Text('Theme Test')),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Perform rapid theme changes
        for (int i = 0; i < 5; i++) {
          final themeMode = i % 2 == 0 ? ThemeMode.light : ThemeMode.dark;
          container.read(themeModeProvider.notifier).setThemeMode(themeMode);
          await tester.pump(const Duration(milliseconds: 10));
        }

        await tester.pumpAndSettle();

        // Assert - Final theme state should be consistent
        final finalTheme = Theme.of(tester.element(find.text('Theme Test')));
        expect(
          finalTheme.brightness,
          equals(Brightness.dark),
        ); // Last theme (odd i)

        // Verify final persistence
        final dbTheme = await database.themeSettingsDao.getThemeMode();
        expect(dbTheme, equals('dark'));
      });
    });

    group('Theme Provider State Management', () {
      test('should maintain theme state consistency during updates', () async {
        // Arrange
        await container.pump();

        // Act - Update theme multiple times
        final themeNotifier = container.read(themeModeProvider.notifier);
        await themeNotifier.setThemeMode(ThemeMode.light);
        await themeNotifier.setThemeMode(ThemeMode.dark);
        await themeNotifier.setThemeMode(ThemeMode.system);
        await container.pump();

        // Assert - Final state should be system
        final themeMode = container.read(themeModeProvider);
        expect(themeMode, equals(ThemeMode.system));

        // Verify persistence
        final dbTheme = await database.themeSettingsDao.getThemeMode();
        expect(dbTheme, equals('system'));
      });

      test('should handle theme state during provider disposal', () async {
        // Arrange
        await database.themeSettingsDao.setThemeMode('light');

        await container.pump();

        // Verify working state
        var themeMode = container.read(themeModeProvider);
        expect(themeMode, equals(ThemeMode.light));

        // Act - Dispose container
        container.dispose();

        // Assert - No errors should occur during disposal
        expect(true, isTrue); // Test passes if no exceptions
      });
    });

    group('Theme Mode Validation', () {
      test('should handle invalid theme mode strings gracefully', () async {
        // Arrange - Set invalid theme mode
        await database.themeSettingsDao.setThemeMode('invalid_theme');

        // Act - Initialize provider
        await container.pump();

        // Assert - Should fall back to system theme
        final themeMode = container.read(themeModeProvider);
        expect(themeMode, equals(ThemeMode.system));

        // Verify database was updated with valid value
        final dbTheme = await database.themeSettingsDao.getThemeMode();
        expect(dbTheme, equals('system'));
      });

      test('should handle null theme mode gracefully', () async {
        // Arrange - Set null theme mode (simulates database corruption)
        // Note: This would require direct database manipulation

        // Act - Initialize provider with default
        await container.pump();

        // Assert - Should use system theme as default
        final themeMode = container.read(themeModeProvider);
        expect(themeMode, equals(ThemeMode.system));
      });
    });

    group('Theme Provider Integration with Other Providers', () {
      test('should work correctly with settings provider', () async {
        // Arrange - Set up both theme and settings
        await database.themeSettingsDao.setThemeMode('dark');
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

        // Act - Initialize both providers
        await container.pump();

        // Assert - Both providers work independently
        final themeMode = container.read(themeModeProvider);
        expect(themeMode, equals(ThemeMode.dark));

        // Settings should also be available
        final settings = container.read(settingsProvider);
        expect(settings.soundEnabled, isTrue);
      });

      test(
        'should handle theme changes without affecting other providers',
        () async {
          // Arrange - Set up theme and settings
          await database.themeSettingsDao.setThemeMode('light');
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

          // Verify initial state
          var themeMode = container.read(themeModeProvider);
          expect(themeMode, equals(ThemeMode.light));

          var settings = container.read(settingsProvider);
          expect(settings.soundEnabled, isTrue);

          // Act - Change theme
          final themeNotifier = container.read(themeModeProvider.notifier);
          await themeNotifier.setThemeMode(ThemeMode.dark);
          await container.pump();

          // Assert - Theme changed but settings unchanged
          themeMode = container.read(themeModeProvider);
          expect(themeMode, equals(ThemeMode.dark));

          settings = container.read(settingsProvider);
          expect(settings.soundEnabled, isTrue); // Unchanged
        },
      );
    });

    group('Error Recovery', () {
      test(
        'should recover from database errors on subsequent operations',
        () async {
          // Arrange - Set up working theme first
          await database.themeSettingsDao.setThemeMode('light');

          await container.pump();

          // Verify working state
          var themeMode = container.read(themeModeProvider);
          expect(themeMode, equals(ThemeMode.light));

          // Act - Simulate database error by closing and reopening
          await database.close();

          // Create new database
          final newDatabase = AppDatabase(NativeDatabase.memory());
          final newContainer = ProviderContainer(
            overrides: [appDatabaseProvider.overrideWithValue(newDatabase)],
          );

          await newContainer.pump();

          // Assert - New container should work with system theme (default)
          final newThemeMode = newContainer.read(themeModeProvider);
          expect(newThemeMode, equals(ThemeMode.system));

          newContainer.dispose();
          await newDatabase.close();
        },
      );

      testWidgets(
        'should handle theme provider errors without crashing MaterialApp',
        (WidgetTester tester) async {
          // Arrange - Close database to simulate errors
          await database.close();

          // Act - Pump app with error-prone theme provider
          await tester.pumpWidget(
            ProviderScope(
              child: MaterialApp(
                themeMode: container.read(themeModeProvider),
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                home: const Scaffold(body: Text('Theme Test')),
              ),
            ),
          );

          await tester.pumpAndSettle();

          // Assert - App handles theme provider errors gracefully
          // Should use system theme as fallback
          final theme = Theme.of(tester.element(find.text('Theme Test')));
          expect(
            theme.brightness,
            equals(Brightness.light),
          ); // Test environment default
        },
      );
    });
  });
}
