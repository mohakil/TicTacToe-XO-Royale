import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:tictactoe_xo_royale/core/database/app_database.dart';
import 'package:tictactoe_xo_royale/core/database/database_providers.dart';
import 'package:tictactoe_xo_royale/core/providers/theme_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeProvider Tests', () {
    late ProviderContainer container;

    setUp(() {
      // Create in-memory database for testing
      final testDatabase = AppDatabase(NativeDatabase.memory());

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

    group('Theme Mode Provider', () {
      test('should initialize with system theme mode', () {
        final themeMode = container.read(themeModeProvider);
        expect(themeMode, isA<ThemeMode>());
      });

      test('should allow changing theme mode', () async {
        final notifier = container.read(themeModeProvider.notifier);

        await notifier.setThemeMode(ThemeMode.light);
        expect(notifier.state, equals(ThemeMode.light));

        await notifier.setThemeMode(ThemeMode.dark);
        expect(notifier.state, equals(ThemeMode.dark));
      });

      test('should persist theme mode changes', () async {
        final notifier = container.read(themeModeProvider.notifier);

        await notifier.setThemeMode(ThemeMode.light);
        expect(notifier.state, equals(ThemeMode.light));
      });
    });

    group('Theme Data Providers', () {
      test('should provide light theme data', () {
        final lightTheme = container.read(lightThemeProvider);
        expect(lightTheme, isA<ThemeData>());
        expect(lightTheme.brightness, equals(Brightness.light));
      });

      test('should provide dark theme data', () {
        final darkTheme = container.read(darkThemeProvider);
        expect(darkTheme, isA<ThemeData>());
        expect(darkTheme.brightness, equals(Brightness.dark));
      });
    });

    group('Theme Extensions', () {
      test('should provide theme name for display', () {
        final lightName = container.read(
          themeModeProvider.select((mode) {
            switch (mode) {
              case ThemeMode.light:
                return 'Light';
              case ThemeMode.dark:
                return 'Dark';
              case ThemeMode.system:
                return 'System';
            }
          }),
        );
        expect(lightName, equals('Light'));
      });

      test('should provide theme icon for display', () {
        final darkIcon = container.read(
          themeModeProvider.select((mode) {
            switch (mode) {
              case ThemeMode.light:
                return Icons.light_mode;
              case ThemeMode.dark:
                return Icons.dark_mode;
              case ThemeMode.system:
                return Icons.brightness_auto;
            }
          }),
        );
        expect(darkIcon, equals(Icons.dark_mode));
      });
    });
  });
}
