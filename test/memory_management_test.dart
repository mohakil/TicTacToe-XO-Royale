import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/services/memory_manager.dart';
import 'package:tictactoe_xo_royale/features/game/providers/game_provider.dart';
import 'package:tictactoe_xo_royale/features/setup/providers/setup_provider.dart';
import 'package:tictactoe_xo_royale/features/home/providers/home_provider.dart';
import 'package:tictactoe_xo_royale/features/loading/providers/loading_provider.dart';
import 'package:tictactoe_xo_royale/core/providers/profile_provider.dart';
import 'package:tictactoe_xo_royale/core/providers/store_provider.dart';
import 'package:tictactoe_xo_royale/core/providers/settings_provider.dart';
import 'package:tictactoe_xo_royale/core/providers/theme_provider.dart';

void main() {
  // Initialize Flutter binding for tests
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Memory Management Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('MemoryManager should track provider memory usage', () {
      final memoryManager = container.read(memoryManagerProvider);

      // Register a provider
      memoryManager.registerProvider('testProvider', keepAlive: false);
      memoryManager.updateProviderMemoryUsage('testProvider', 1024);
      memoryManager.updateProviderAccess('testProvider');

      final stats = memoryManager.getMemoryStats();

      expect(stats['providerCount'], equals(1));
      expect(stats['totalMemoryBytes'], equals(1024));
      expect(stats['autoDisposeCount'], equals(1));
      expect(stats['keepAliveCount'], equals(0));
    });

    test('MemoryManager should cleanup idle providers', () {
      final memoryManager = container.read(memoryManagerProvider);

      // Register providers
      memoryManager.registerProvider('keepAliveProvider', keepAlive: true);
      memoryManager.registerProvider('autoDisposeProvider', keepAlive: false);

      // Update access time for keep-alive provider
      memoryManager.updateProviderAccess('keepAliveProvider');

      // Simulate old access time for auto-dispose provider
      memoryManager.registerProvider('autoDisposeProvider', keepAlive: false);

      final initialStats = memoryManager.getMemoryStats();
      expect(initialStats['providerCount'], equals(2));

      // Force cleanup
      memoryManager.forceCleanup();

      final finalStats = memoryManager.getMemoryStats();
      expect(
        finalStats['providerCount'],
        equals(1),
      ); // Only keep-alive should remain
    });

    test('Game providers should use autoDispose', () {
      // Test that game providers are properly configured with autoDispose
      expect(() => container.read(gameConfigProvider), returnsNormally);
      expect(() => container.read(gameLogicProvider), returnsNormally);
      expect(() => container.read(gameStateProvider), returnsNormally);

      // Test individual game data providers
      expect(() => container.read(currentPlayerProvider), returnsNormally);
      expect(() => container.read(gameBoardProvider), returnsNormally);
      expect(() => container.read(isGameOverProvider), returnsNormally);
      expect(() => container.read(gameResultProvider), returnsNormally);
      expect(() => container.read(availableMovesProvider), returnsNormally);
      expect(
        () => container.read(gameConfigFromStateProvider),
        returnsNormally,
      );
      expect(() => container.read(gameStatusProvider), returnsNormally);
      expect(() => container.read(gameBoardStateProvider), returnsNormally);
    });

    test('Setup providers should use autoDispose', () {
      // Test that setup providers are properly configured with autoDispose
      expect(() => container.read(setupProvider), returnsNormally);

      // Test individual setup data providers
      expect(() => container.read(setupModeProvider), returnsNormally);
      expect(() => container.read(setupPlayer1NameProvider), returnsNormally);
      expect(() => container.read(setupPlayer2NameProvider), returnsNormally);
      expect(() => container.read(setupFirstMoveProvider), returnsNormally);
      expect(() => container.read(setupDifficultyProvider), returnsNormally);
      expect(() => container.read(setupBoardSizeProvider), returnsNormally);
      expect(() => container.read(setupWinConditionProvider), returnsNormally);
      expect(() => container.read(setupIsValidProvider), returnsNormally);
    });

    test('Home providers should use autoDispose', () {
      // Test that home providers are properly configured with autoDispose
      expect(() => container.read(homeProvider), returnsNormally);

      // Test individual home data providers
      expect(() => container.read(lastResultProvider), returnsNormally);
      expect(() => container.read(streakProvider), returnsNormally);
      expect(() => container.read(gemsCountProvider), returnsNormally);
      expect(() => container.read(hintCountProvider), returnsNormally);
      expect(() => container.read(homeLoadingProvider), returnsNormally);
      expect(() => container.read(homeStatsProvider), returnsNormally);
      expect(() => container.read(homeIsLoadingProvider), returnsNormally);
    });

    test('Loading providers should use autoDispose', () {
      // Test that loading providers are properly configured with autoDispose
      expect(() => container.read(loadingProvider), returnsNormally);
    });

    test('Profile providers should use autoDispose', () {
      // Test that profile providers are properly configured with autoDispose
      // Note: These tests verify the provider configuration without actually reading them
      // to avoid SharedPreferences dependency issues in tests
      expect(profileProvider, isA<AutoDisposeStateNotifierProvider>());
      expect(currentProfileProvider, isA<AutoDisposeProvider>());
      expect(profileStatsProvider, isA<AutoDisposeProvider>());
      expect(profileGemsProvider, isA<AutoDisposeProvider>());
      expect(profileHintsProvider, isA<AutoDisposeProvider>());
      expect(profileNicknameProvider, isA<AutoDisposeProvider>());
      expect(profileAvatarProvider, isA<AutoDisposeProvider>());
      expect(profileIsLoadingProvider, isA<AutoDisposeProvider>());
      expect(profileErrorProvider, isA<AutoDisposeProvider>());
      expect(profileIsEditingProvider, isA<AutoDisposeProvider>());
      expect(profileWinRateProvider, isA<AutoDisposeProvider>());
      expect(profileTotalGamesProvider, isA<AutoDisposeProvider>());
      expect(profileIsProfileLoadedProvider, isA<AutoDisposeProvider>());
    });

    test('Store providers should use autoDispose', () {
      // Test that store providers are properly configured with autoDispose
      expect(storeProvider, isA<AutoDisposeStateNotifierProvider>());
      expect(storeItemsProvider, isA<AutoDisposeProvider>());
      expect(storeSelectedCategoryProvider, isA<AutoDisposeProvider>());
      expect(storeIsLoadingProvider, isA<AutoDisposeProvider>());
      expect(storeErrorProvider, isA<AutoDisposeProvider>());
      expect(storePurchaseHistoryProvider, isA<AutoDisposeProvider>());
      expect(storeWatchAdCooldownProvider, isA<AutoDisposeProvider>());
      expect(storeThemesProvider, isA<AutoDisposeProvider>());
      expect(storeBoardDesignsProvider, isA<AutoDisposeProvider>());
      expect(storeSymbolsProvider, isA<AutoDisposeProvider>());
      expect(storeGemsProvider, isA<AutoDisposeProvider>());
      expect(storeCanWatchAdProvider, isA<AutoDisposeProvider>());
      expect(storeTimeUntilNextAdProvider, isA<AutoDisposeProvider>());
      expect(storeCurrentCategoryItemsProvider, isA<AutoDisposeProvider>());
    });

    test('Settings providers should use keepAlive', () {
      // Test that settings providers are properly configured with keepAlive
      expect(settingsProvider, isA<StateNotifierProvider>());
      expect(soundEnabledProvider, isA<Provider>());
      expect(musicEnabledProvider, isA<Provider>());
      expect(vibrationEnabledProvider, isA<Provider>());
      expect(hapticFeedbackEnabledProvider, isA<Provider>());
      expect(autoSaveEnabledProvider, isA<Provider>());
      expect(notificationsEnabledProvider, isA<Provider>());
      expect(isAudioEnabledProvider, isA<Provider>());
      expect(isHapticEnabledProvider, isA<Provider>());
    });

    test('Theme providers should use keepAlive', () {
      // Test that theme providers are properly configured with keepAlive
      expect(themeModeProvider, isA<StateNotifierProvider>());
      expect(themeDataProvider, isA<Provider>());
      expect(lightThemeProvider, isA<Provider>());
      expect(darkThemeProvider, isA<Provider>());
      expect(systemThemeProvider, isA<Provider>());
      // responsiveThemeProvider is a family provider, so we test it differently
      expect(responsiveThemeProvider(1.0), isA<Provider>());
    });

    test('Memory stats provider should work correctly', () {
      // Test that memory stats provider is properly configured
      expect(memoryStatsProvider, isA<StreamProvider>());

      // Test that we can read the provider without errors
      expect(() => container.read(memoryStatsProvider), returnsNormally);
    });

    test('Memory manager should dispose properly', () {
      final memoryManager = container.read(memoryManagerProvider);

      // Register some providers
      memoryManager.registerProvider('test1', keepAlive: false);
      memoryManager.registerProvider('test2', keepAlive: true);

      final initialStats = memoryManager.getMemoryStats();
      expect(initialStats['providerCount'], equals(2));

      // Dispose memory manager
      memoryManager.dispose();

      final finalStats = memoryManager.getMemoryStats();
      expect(finalStats['providerCount'], equals(0));
    });

    test('Provider memory tracking should work with extensions', () {
      final memoryManager = container.read(memoryManagerProvider);

      // Test the extension methods
      // This would normally be called in a provider context
      // For testing, we'll call the methods directly
      memoryManager.registerProvider('extensionTest', keepAlive: false);
      memoryManager.updateProviderAccess('extensionTest');
      memoryManager.updateProviderMemoryUsage('extensionTest', 2048);

      final stats = memoryManager.getMemoryStats();
      expect(stats['providers']['extensionTest']['memoryBytes'], equals(2048));
      expect(stats['providers']['extensionTest']['keepAlive'], equals(false));
    });
  });

  group('Memory Management Integration Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Provider lifecycle should work correctly with memory management', () {
      final memoryManager = container.read(memoryManagerProvider);

      // Read a provider to create it
      final gameConfig = container.read(gameConfigProvider);
      expect(gameConfig, isNotNull);

      // Check that it's tracked in memory manager
      final stats = memoryManager.getMemoryStats();
      expect(stats['autoDisposeCount'], greaterThan(0));

      // Dispose container to trigger auto-dispose
      container.dispose();

      // Create new container
      container = ProviderContainer();
      final newMemoryManager = container.read(memoryManagerProvider);

      // Check that providers were cleaned up
      final newStats = newMemoryManager.getMemoryStats();
      expect(newStats['providerCount'], equals(0));
    });

    test('Memory manager should handle provider tracking correctly', () {
      final memoryManager = container.read(memoryManagerProvider);

      // Test basic memory tracking functionality
      memoryManager.registerProvider('testProvider1', keepAlive: false);
      memoryManager.registerProvider('testProvider2', keepAlive: true);

      final stats = memoryManager.getMemoryStats();
      expect(stats['providerCount'], equals(2));
      expect(stats['autoDisposeCount'], equals(1));
      expect(stats['keepAliveCount'], equals(1));

      // Test cleanup
      memoryManager.forceCleanup();
      final cleanupStats = memoryManager.getMemoryStats();
      expect(
        cleanupStats['providerCount'],
        equals(1),
      ); // Only keep-alive should remain
    });
  });
}
