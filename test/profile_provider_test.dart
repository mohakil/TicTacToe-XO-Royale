import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:tictactoe_xo_royale/core/database/app_database.dart';
import 'package:tictactoe_xo_royale/core/database/database_providers.dart';
import 'package:tictactoe_xo_royale/core/models/game_history.dart';
import 'package:tictactoe_xo_royale/core/models/player_profile.dart'
    as app_models;
import 'package:tictactoe_xo_royale/core/providers/profile_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProfileProvider Tests', () {
    late ProviderContainer container;
    late AppDatabase testDatabase;

    setUp(() {
      // Create in-memory database for testing
      testDatabase = AppDatabase(NativeDatabase.memory());

      // Override the database provider with test database
      container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(testDatabase)],
      );
    });

    tearDown(() async {
      // Close the test database
      await testDatabase.close();
      container.dispose();
    });

    group('Profile Provider', () {
      test('should provide profile state after async loading', () async {
        // Read the profile notifier and trigger loading
        container.read(profileProvider.notifier);

        // Wait for async loading to complete
        await container.pump();

        final profileState = container.read(profileProvider);
        expect(profileState, isA<ProfileState>());

        // Profile should be loaded after pump
        if (profileState.profile != null) {
          expect(profileState.profile!.nickname, equals('Player'));
          expect(profileState.profile!.gems, equals(100));
          expect(profileState.profile!.hints, equals(5));
        }
      });
    });

    group('Individual Profile Providers', () {
      test('currentProfileProvider should provide profile', () {
        final profile = container.read(currentProfileProvider);
        expect(profile, isA<app_models.PlayerProfile>());
        expect(profile!.nickname, equals('Player'));
      });

      test('profileStatsProvider should provide stats', () {
        final stats = container.read(profileStatsProvider);
        expect(stats, isA<app_models.PlayerStats>());
        expect(stats!.wins, equals(0));
        expect(stats.losses, equals(0));
        expect(stats.draws, equals(0));
      });

      test('profileGemsProvider should provide gems', () {
        final gems = container.read(profileGemsProvider);
        expect(gems, equals(100));
      });

      test('profileHintsProvider should provide hints', () {
        final hints = container.read(profileHintsProvider);
        expect(hints, equals(5));
      });

      test('profileNicknameProvider should provide nickname', () {
        final nickname = container.read(profileNicknameProvider);
        expect(nickname, equals('Player'));
      });

      test('profileAvatarProvider should provide avatar', () {
        final avatar = container.read(profileAvatarProvider);
        expect(avatar, isA<String>());
      });

      test('profileIsLoadingProvider should provide loading state', () {
        final isLoading = container.read(profileIsLoadingProvider);
        expect(isLoading, isA<bool>());
      });

      test('profileErrorProvider should provide error state', () {
        final error = container.read(profileErrorProvider);
        expect(error, isNull);
      });

      test('profileIsEditingProvider should provide editing state', () {
        final isEditing = container.read(profileIsEditingProvider);
        expect(isEditing, isA<bool>());
      });
    });

    group('Computed Properties', () {
      test('profileWinRateProvider should provide win rate', () {
        final winRate = container.read(profileWinRateProvider);
        expect(winRate, isA<double>());
        expect(winRate, equals(0.0)); // No games played yet
      });

      test('profileTotalGamesProvider should provide total games', () {
        final totalGames = container.read(profileTotalGamesProvider);
        expect(totalGames, isA<int>());
        expect(totalGames, equals(0)); // No games played yet
      });

      test('profileIsProfileLoadedProvider should provide loaded state', () {
        final isLoaded = container.read(profileIsProfileLoadedProvider);
        expect(isLoaded, isA<bool>());
      });
    });

    group('Profile Extensions', () {
      test('should provide profile display name', () {
        container.read(profileProvider);
        final displayName = container.read(
          profileProvider.select((p) => p.profile?.nickname ?? 'Player'),
        );
        expect(displayName, equals('Player'));
      });

      test('should provide gems display', () {
        container.read(profileGemsProvider);
        final gemsDisplay = container.read(
          profileGemsProvider.select((g) => '$g 💎'),
        );
        expect(gemsDisplay, equals('100 💎'));
      });

      test('should provide hints display', () {
        container.read(profileHintsProvider);
        final hintsDisplay = container.read(
          profileHintsProvider.select((h) => '$h 💡'),
        );
        expect(hintsDisplay, equals('5 💡'));
      });
    });
  });

  group('Game History Storage', () {
    test('should add game to history successfully', () async {
      // Arrange
      final testDatabase = AppDatabase(NativeDatabase.memory());
      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(testDatabase)],
      );
      final profileNotifier = container.read(profileProvider.notifier);

      // Create a test game history item
      final gameHistory = GameHistoryItem(
        opponent: 'Robot',
        result: GameResult.win,
        boardSize: '3x3',
        date: DateTime.now(),
        duration: const Duration(seconds: 45),
        score: 'X won in 8 moves',
      );

      // Act
      await profileNotifier.addGameToHistory(gameHistory);

      // Assert - verify that the game was added to the database
      final recentGames = await profileNotifier.recentGames;
      expect(recentGames.length, 1);
      expect(recentGames.first.opponent, 'Robot');
      expect(recentGames.first.result, GameResult.win);

      // Clean up
      await testDatabase.close();
      container.dispose();
    });

    test('should handle multiple games in history', () async {
      // Arrange
      final testDatabase = AppDatabase(NativeDatabase.memory());
      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(testDatabase)],
      );
      final profileNotifier = container.read(profileProvider.notifier);

      // Create multiple test games
      final games = [
        GameHistoryItem(
          opponent: 'Robot',
          result: GameResult.win,
          boardSize: '3x3',
          date: DateTime.now().subtract(const Duration(minutes: 5)),
          duration: const Duration(seconds: 45),
          score: 'X won in 8 moves',
        ),
        GameHistoryItem(
          opponent: 'Easy Robot',
          result: GameResult.loss,
          boardSize: '3x3',
          date: DateTime.now().subtract(const Duration(minutes: 3)),
          duration: const Duration(seconds: 30),
          score: 'O won in 6 moves',
        ),
        GameHistoryItem(
          opponent: 'Hard Robot',
          result: GameResult.draw,
          boardSize: '4x4',
          date: DateTime.now().subtract(const Duration(minutes: 1)),
          duration: const Duration(seconds: 60),
          score: 'Draw after 12 moves',
        ),
      ];

      // Act - add all games
      for (final game in games) {
        await profileNotifier.addGameToHistory(game);
      }

      // Assert - verify all games were added
      final recentGames = await profileNotifier.recentGames;
      expect(recentGames.length, 3);

      // Verify they are in the correct order (most recent first)
      expect(recentGames.first.opponent, 'Hard Robot');
      expect(recentGames.last.opponent, 'Robot');

      // Clean up
      await testDatabase.close();
      container.dispose();
    });
  });
}
