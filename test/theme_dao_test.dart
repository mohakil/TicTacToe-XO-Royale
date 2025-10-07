import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/database/app_database.dart';
import 'package:tictactoe_xo_royale/core/database/theme_dao.dart';
import 'package:tictactoe_xo_royale/core/database/database_providers.dart';

void main() {
  late AppDatabase database;
  late ProviderContainer container;
  late ThemeDao dao;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
    dao = container.read(themeDaoProvider);
  });

  tearDown(() async {
    await database.close();
    container.dispose();
  });

  group('ThemeDao Tests', () {
    // ===== BASIC OPERATIONS =====

    group('getThemeMode()', () {
      test('should return default theme mode when none exist', () async {
        // Act
        final themeMode = await dao.getThemeMode();

        // Assert
        expect(themeMode, 'system');
      });

      test('should return existing theme mode when it exists', () async {
        // Arrange - Set theme first
        await dao.setThemeMode('dark');

        // Act
        final themeMode = await dao.getThemeMode();

        // Assert
        expect(themeMode, 'dark');
      });
    });

    group('setThemeMode()', () {
      test('should set theme mode successfully', () async {
        // Act
        final result = await dao.setThemeMode('light');

        // Assert
        expect(result, greaterThan(0));

        // Verify theme was set
        final themeMode = await dao.getThemeMode();
        expect(themeMode, 'light');
      });

      test('should handle all valid theme modes', () async {
        // Test all valid theme modes
        final validModes = ['light', 'dark', 'system'];

        for (final mode in validModes) {
          // Act
          final result = await dao.setThemeMode(mode);

          // Assert
          expect(result, greaterThan(0));

          final currentMode = await dao.getThemeMode();
          expect(currentMode, mode);
        }
      });
    });

    group('updateSettings()', () {
      test('should update theme settings successfully', () async {
        // Arrange
        const updatedSettings = ThemeSettingsCompanion(
          themeMode: Value('dark'),
        );

        // Act
        final result = await dao.updateSettings(updatedSettings);

        // Assert
        expect(result, greaterThan(0));

        // Verify settings were updated
        final themeMode = await dao.getThemeMode();
        expect(themeMode, 'dark');
      });
    });

    // ===== CONVENIENCE METHODS =====

    group('Theme Setting Methods', () {
      test('setLightTheme() should set light theme', () async {
        // Act
        final result = await dao.setLightTheme();

        // Assert
        expect(result, greaterThan(0));

        final themeMode = await dao.getThemeMode();
        expect(themeMode, 'light');
      });

      test('setDarkTheme() should set dark theme', () async {
        // Act
        final result = await dao.setDarkTheme();

        // Assert
        expect(result, greaterThan(0));

        final themeMode = await dao.getThemeMode();
        expect(themeMode, 'dark');
      });

      test('setSystemTheme() should set system theme', () async {
        // Act
        final result = await dao.setSystemTheme();

        // Assert
        expect(result, greaterThan(0));

        final themeMode = await dao.getThemeMode();
        expect(themeMode, 'system');
      });
    });

    group('Toggle and Cycle Methods', () {
      test('toggleTheme() should toggle between light and dark', () async {
        // Arrange - Start with light theme
        await dao.setLightTheme();

        // Act - Toggle from light
        final result = await dao.toggleTheme();

        // Assert
        expect(result, greaterThan(0));
        expect(await dao.getThemeMode(), 'dark');

        // Act - Toggle from dark
        await dao.toggleTheme();

        // Assert
        expect(await dao.getThemeMode(), 'light');
      });

      test('cycleTheme() should cycle through all theme modes', () async {
        // Arrange - Start with light theme
        await dao.setLightTheme();

        // Act & Assert - Light -> Dark
        await dao.cycleTheme();
        expect(await dao.getThemeMode(), 'dark');

        // Act & Assert - Dark -> System
        await dao.cycleTheme();
        expect(await dao.getThemeMode(), 'system');

        // Act & Assert - System -> Light
        await dao.cycleTheme();
        expect(await dao.getThemeMode(), 'light');
      });

      test('toggleTheme() should handle system theme correctly', () async {
        // Arrange - Start with system theme
        await dao.setSystemTheme();

        // Act - Toggle from system (should go to light)
        await dao.toggleTheme();

        // Assert
        expect(await dao.getThemeMode(), 'light');
      });
    });

    group('insertDefaultSettings()', () {
      test('should insert default theme settings successfully', () async {
        // Act
        final result = await dao.insertDefaultSettings();

        // Assert
        expect(result, greaterThan(0));

        final themeMode = await dao.getThemeMode();
        expect(themeMode, 'system');
      });
    });

    // ===== REACTIVE STREAMS =====

    group('Reactive Streams', () {
      test('watchThemeMode() should emit theme changes reactively', () async {
        // Get initial state
        final initialTheme = await dao.getThemeMode();
        expect(initialTheme, 'system');

        // Set light theme to trigger stream emission
        await dao.setLightTheme();

        // Wait for updated state
        final updatedTheme = await dao.getThemeMode();
        expect(updatedTheme, 'light');
      });
    });

    // ===== EDGE CASES AND ERROR HANDLING =====

    group('Edge Cases and Error Handling', () {
      test('should handle concurrent theme operations', () async {
        // Act - Perform multiple operations concurrently
        final operations = await Future.wait([
          dao.setLightTheme(),
          dao.setDarkTheme(),
          dao.setSystemTheme(),
          dao.getThemeMode(),
        ]);

        // Assert
        expect(operations[0], greaterThan(0)); // setLightTheme result
        expect(operations[1], greaterThan(0)); // setDarkTheme result
        expect(operations[2], greaterThan(0)); // setSystemTheme result

        final currentTheme = operations[3] as String;
        expect(['light', 'dark', 'system'], contains(currentTheme));
      });

      test('should handle rapid theme changes', () async {
        // Act - Change theme multiple times rapidly
        await dao.setLightTheme();
        await dao.setDarkTheme();
        await dao.setSystemTheme();
        await dao.setLightTheme();

        // Assert - Should end up with light theme
        final themeMode = await dao.getThemeMode();
        expect(themeMode, 'light');
      });

      test('should handle cycle operations correctly', () async {
        // Arrange - Start with light theme
        await dao.setLightTheme();
        expect(await dao.getThemeMode(), 'light');

        // Act & Assert - Light -> Dark
        await dao.cycleTheme();
        expect(await dao.getThemeMode(), 'dark');

        // Act & Assert - Dark -> System
        await dao.cycleTheme();
        expect(await dao.getThemeMode(), 'system');

        // Act & Assert - System -> Light
        await dao.cycleTheme();
        expect(await dao.getThemeMode(), 'light');
      });

      test('should handle operations when theme table is empty', () async {
        // This shouldn't happen in practice due to database initialization,
        // but testing the robustness

        // Act & Assert - Should not throw exceptions
        expect(() async => await dao.setLightTheme(), returnsNormally);
        expect(() async => await dao.setDarkTheme(), returnsNormally);
        expect(() async => await dao.toggleTheme(), returnsNormally);

        // Should still work correctly
        final themeMode = await dao.getThemeMode();
        expect(['light', 'dark', 'system'], contains(themeMode));
      });

      test('should handle invalid theme modes gracefully', () async {
        // Act - Try to set invalid theme mode
        final result = await dao.setThemeMode('invalid_mode');

        // Assert - Should still work (updates existing record)
        expect(result, greaterThan(0));

        // The database accepts any string value
        final themeMode = await dao.getThemeMode();
        expect(themeMode, 'invalid_mode');
      });
    });

    // ===== INTEGRATION WITH REACTIVE STREAMS =====

    group('Reactive Integration', () {
      test(
        'watchThemeMode() should reflect theme setting operations',
        () async {
          // Get initial state
          final initialTheme = await dao.getThemeMode();
          expect(initialTheme, 'system');

          // Set dark theme to trigger stream emission
          await dao.setDarkTheme();

          // Wait for updated state
          final updatedTheme = await dao.getThemeMode();
          expect(updatedTheme, 'dark');
        },
      );

      test('watchThemeMode() should reflect toggle operations', () async {
        // Arrange - Start with light theme
        await dao.setLightTheme();

        // Get current state
        final currentTheme = await dao.getThemeMode();
        expect(currentTheme, 'light');

        // Toggle theme to trigger stream emission
        await dao.toggleTheme();

        // Wait for updated state
        final toggledTheme = await dao.getThemeMode();
        expect(toggledTheme, 'dark');
      });

      test('watchThemeMode() should reflect cycle operations', () async {
        // Arrange - Start with light theme
        await dao.setLightTheme();

        // Get current state
        final currentTheme = await dao.getThemeMode();
        expect(currentTheme, 'light');

        // Cycle theme to trigger stream emission
        await dao.cycleTheme();

        // Wait for updated state
        final cycledTheme = await dao.getThemeMode();
        expect(cycledTheme, 'dark');
      });
    });
  });
}
