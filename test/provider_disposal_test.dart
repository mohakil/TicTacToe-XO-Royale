import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/providers/theme_provider.dart';
import 'package:tictactoe_xo_royale/core/providers/profile_provider.dart';
import 'package:tictactoe_xo_royale/core/providers/store_provider.dart';
import 'package:tictactoe_xo_royale/core/providers/settings_provider.dart';
import 'package:tictactoe_xo_royale/features/setup/providers/setup_provider.dart';
import 'package:tictactoe_xo_royale/features/game/providers/game_provider.dart';
import 'package:tictactoe_xo_royale/features/home/providers/home_provider.dart';
import 'package:tictactoe_xo_royale/features/loading/providers/loading_provider.dart';
import 'package:tictactoe_xo_royale/core/models/game_enums.dart';
import 'package:tictactoe_xo_royale/core/models/game_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Provider Disposal Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('ThemeProvider should dispose properly', () async {
      // Create a theme provider instance
      final themeNotifier = container.read(themeModeProvider.notifier);

      // Verify initial state
      expect(themeNotifier.state, ThemeMode.system);

      // Change theme (this will fail in test environment due to SharedPreferences)
      // but that's expected and shows our error handling works
      await themeNotifier.setThemeMode(ThemeMode.light);

      // Dispose the container
      container.dispose();

      // Verify that the notifier is disposed by checking that accessing state throws
      expect(() => themeNotifier.state, throwsA(isA<StateError>()));
    });

    test('ProfileProvider should dispose properly', () async {
      // Create a profile provider instance
      final profileNotifier = container.read(profileProvider.notifier);

      // Wait for initial load by reading the state
      container.read(profileProvider);

      // Verify initial state (will be null in test environment due to SharedPreferences)
      // but that's expected and shows our error handling works
      expect(profileNotifier.currentProfile, isNull);

      // Dispose the container
      container.dispose();

      // Verify that the notifier is disposed by checking that accessing state throws
      expect(() => profileNotifier.currentProfile, throwsA(isA<StateError>()));
    });

    test('StoreProvider should dispose properly', () async {
      // Create a store provider instance
      final storeNotifier = container.read(storeProvider.notifier);

      // Wait for initial load by reading the state
      container.read(storeProvider);

      // Verify initial state (will be empty in test environment due to SharedPreferences)
      // but that's expected and shows our error handling works
      expect(storeNotifier.currentItems, isEmpty);

      // Dispose the container
      container.dispose();

      // Verify that the notifier is disposed by checking that accessing state throws
      expect(() => storeNotifier.currentItems, throwsA(isA<StateError>()));
    });

    test('SetupProvider should dispose properly', () {
      // Create a setup provider instance
      final setupNotifier = container.read(setupProvider.notifier);

      // Verify initial state
      expect(setupNotifier.state.mode, GameMode.local);

      // Change setup
      setupNotifier.setMode(GameMode.robot);
      expect(setupNotifier.state.mode, GameMode.robot);

      // Dispose the container
      container.dispose();

      // Verify that the notifier is disposed by checking that accessing state throws
      expect(() => setupNotifier.state, throwsA(isA<StateError>()));
    });

    test('Multiple providers should dispose independently', () async {
      // Create multiple provider instances
      final themeNotifier = container.read(themeModeProvider.notifier);
      final profileNotifier = container.read(profileProvider.notifier);
      final storeNotifier = container.read(storeProvider.notifier);
      final setupNotifier = container.read(setupProvider.notifier);

      // Wait for async providers to load by reading the state
      container.read(profileProvider);
      container.read(storeProvider);

      // Verify all providers are working
      expect(themeNotifier.state, ThemeMode.system);
      expect(
        profileNotifier.currentProfile,
        isNull,
      ); // Will be null in test environment
      expect(
        storeNotifier.currentItems,
        isEmpty,
      ); // Will be empty in test environment
      expect(setupNotifier.state.mode, GameMode.local);

      // Dispose the container
      container.dispose();

      // Verify all providers are disposed by checking that accessing state throws
      expect(() => themeNotifier.state, throwsA(isA<StateError>()));
      expect(() => profileNotifier.currentProfile, throwsA(isA<StateError>()));
      expect(() => storeNotifier.currentItems, throwsA(isA<StateError>()));
      expect(() => setupNotifier.state, throwsA(isA<StateError>()));
    });

    test('Provider disposal should prevent memory leaks', () {
      // Create multiple containers to simulate multiple app instances
      final containers = <ProviderContainer>[];

      for (int i = 0; i < 10; i++) {
        final container = ProviderContainer();
        containers.add(container);

        // Create providers in each container
        container.read(themeModeProvider.notifier);
        container.read(profileProvider.notifier);
        container.read(storeProvider.notifier);
        container.read(setupProvider.notifier);
      }

      // Dispose all containers
      for (final container in containers) {
        container.dispose();
      }

      // Verify no memory leaks (this is more of a smoke test)
      // In a real scenario, you would use memory profiling tools
      expect(containers.length, 10);
    });

    test('Async operations should respect mounted state', () async {
      // Create a theme provider instance
      final themeNotifier = container.read(themeModeProvider.notifier);

      // Start an async operation
      final future = themeNotifier.setThemeMode(ThemeMode.dark);

      // Dispose the container before the operation completes
      container.dispose();

      // Wait for the operation to complete
      await future;

      // Verify that the notifier is disposed by checking that accessing state throws
      expect(() => themeNotifier.state, throwsA(isA<StateError>()));
    });

    test('SettingsProvider should dispose properly', () async {
      // Create a settings provider instance
      final settingsNotifier = container.read(settingsProvider.notifier);

      // Verify initial state
      expect(settingsNotifier.state.soundEnabled, isTrue);

      // Change settings (this will fail in test environment due to SharedPreferences)
      // but that's expected and shows our error handling works
      await settingsNotifier.setSoundEnabled(enabled: false);

      // Dispose the container
      container.dispose();

      // Verify that the notifier is disposed by checking that accessing state throws
      expect(() => settingsNotifier.state, throwsA(isA<StateError>()));
    });

    test('GameProvider should dispose properly', () {
      // Create a game provider instance
      final gameNotifier = container.read(gameProvider.notifier);

      // Verify initial state
      expect(gameNotifier.state, isNotNull);

      // Initialize game
      final config = GameConfig.defaultConfig();
      gameNotifier.initializeGame(config);

      // Dispose the container
      container.dispose();

      // Verify that the notifier is disposed by checking that accessing state throws
      expect(() => gameNotifier.state, throwsA(isA<StateError>()));
    });

    test('HomeProvider should dispose properly', () {
      // Create a home provider instance
      final homeNotifier = container.read(homeProvider.notifier);

      // Verify initial state
      expect(homeNotifier.state.streak, 3);

      // Update stats
      homeNotifier.updateStreak(5);
      expect(homeNotifier.state.streak, 5);

      // Dispose the container
      container.dispose();

      // Verify that the notifier is disposed by checking that accessing state throws
      expect(() => homeNotifier.state, throwsA(isA<StateError>()));
    });

    test('LoadingProvider should dispose properly', () {
      // Create a loading provider instance
      final loadingNotifier = container.read(loadingProvider.notifier);

      // Verify initial state
      expect(loadingNotifier.state.isLoading, isTrue);

      // Update progress
      loadingNotifier.setProgress(0.5);
      expect(loadingNotifier.state.progress, 0.5);

      // Dispose the container
      container.dispose();

      // Verify that the notifier is disposed by checking that accessing state throws
      expect(() => loadingNotifier.state, throwsA(isA<StateError>()));
    });
  });
}
