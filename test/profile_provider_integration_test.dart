import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart' hide isNotNull, isNull;
import 'package:matcher/matcher.dart' show isNotNull, isNull;
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:tictactoe_xo_royale/core/database/app_database.dart';
import 'package:tictactoe_xo_royale/core/database/database_providers.dart';
import 'package:tictactoe_xo_royale/core/database/app_database.dart' as db;
import 'package:tictactoe_xo_royale/core/models/game_history.dart';
import 'package:tictactoe_xo_royale/core/models/player_profile.dart' as model;
import 'package:tictactoe_xo_royale/core/providers/profile_provider.dart';

void main() {
  group('ProfileProvider Integration Tests', () {
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

    group('Profile Loading and Initialization', () {
      test('should load existing profile with stats from database', () async {
        // Arrange - Create a profile in the database
        final testProfile = model.PlayerProfile(
          id: '1',
          nickname: 'TestUser',
          avatarUrlOrProvider: 'avatar1',
          stats: const model.PlayerStats(
            wins: 5,
            losses: 3,
            draws: 2,
            streak: 2,
          ),
          gems: 100,
          hints: 10,
        );

        await database.playerProfilesDao.createProfileWithStats(
          db.PlayerProfilesCompanion.insert(
            nickname: testProfile.nickname,
            avatarUrlOrProvider: Value(testProfile.avatarUrlOrProvider),
            gems: testProfile.gems,
            hints: testProfile.hints,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        // Act - Initialize provider and load profile

        // Wait for async initialization
        await container.pump();

        // Assert
        final profileState = container.read(profileProvider);

        expect(profileState.profile, isNotNull);
        expect(profileState.profile!.nickname, equals('TestUser'));
        expect(profileState.profile!.gems, equals(100));
        expect(profileState.profile!.hints, equals(10));
        expect(profileState.profile!.stats.wins, equals(5));
        expect(profileState.profile!.stats.losses, equals(3));
        expect(profileState.profile!.stats.draws, equals(2));
        expect(profileState.profile!.stats.streak, equals(2));
        expect(profileState.isLoading, isFalse);
        expect(profileState.error, isNull);
      });

      test('should create default profile when none exists', () async {
        // Act - Initialize provider when no profile exists

        // Wait for async initialization
        await container.pump();

        // Assert
        final profileState = container.read(profileProvider);

        expect(profileState.profile, isNotNull);
        expect(profileState.profile!.nickname, equals('Player'));
        expect(profileState.profile!.gems, equals(50));
        expect(profileState.profile!.hints, equals(3));
        expect(profileState.profile!.stats.wins, equals(0));
        expect(profileState.profile!.stats.losses, equals(0));
        expect(profileState.profile!.stats.draws, equals(0));
        expect(profileState.profile!.stats.streak, equals(0));
        expect(profileState.isLoading, isFalse);
        expect(profileState.error, isNull);
      });

      test(
        'should handle database errors gracefully during profile loading',
        () async {
          // Arrange - Close database to simulate connection error
          await database.close();

          // Act - Try to initialize provider with closed database

          // Wait for async operation
          await container.pump();

          // Assert
          final profileState = container.read(profileProvider);

          expect(profileState.error, isNotNull);
          expect(profileState.error!.contains('Database error'), isTrue);
          expect(profileState.isLoading, isFalse);
        },
      );
    });

    group('Profile Updates and Persistence', () {
      test('should update profile nickname and persist to database', () async {
        // Arrange
        await container.pump(); // Wait for initialization

        // Act
        final profileNotifier = container.read(profileProvider.notifier);
        await profileNotifier.updateNickname('NewNickname');
        await container.pump();

        // Assert
        final profileState = container.read(profileProvider);
        expect(profileState.profile!.nickname, equals('NewNickname'));

        // Verify persistence by reading directly from database
        final dbProfile = await database.playerProfilesDao.getProfileWithStats(
          'default_user',
        );
        expect(dbProfile!.profile.nickname, equals('NewNickname'));
      });

      test('should update profile avatar and persist to database', () async {
        // Arrange
        await container.pump(); // Wait for initialization

        // Act
        final profileNotifier = container.read(profileProvider.notifier);
        await profileNotifier.updateAvatar('new_avatar');
        await container.pump();

        // Assert
        final profileState = container.read(profileProvider);
        expect(profileState.profile!.avatarUrlOrProvider, equals('new_avatar'));

        // Verify persistence by reading directly from database
        final dbProfile = await database.playerProfilesDao.getProfileWithStats(
          'default_user',
        );
        expect(dbProfile!.profile.avatarUrlOrProvider, equals('new_avatar'));
      });

      test('should add gems and persist to database', () async {
        // Arrange
        await container.pump(); // Wait for initialization

        // Act
        final profileNotifier = container.read(profileProvider.notifier);
        await profileNotifier.addGems(50);
        await container.pump();

        // Assert
        final profileState = container.read(profileProvider);
        expect(
          profileState.profile!.gems,
          equals(100),
        ); // 50 default + 50 added

        // Verify persistence
        final dbProfile = await database.playerProfilesDao.getProfileWithStats(
          'default_user',
        );
        expect(dbProfile!.profile.gems, equals(100));
      });

      test('should spend gems when sufficient funds available', () async {
        // Arrange
        await container.pump(); // Wait for initialization

        // Act
        final profileNotifier = container.read(profileProvider.notifier);
        final success = await profileNotifier.spendGems(25);
        await container.pump();

        // Assert
        expect(success, isTrue);
        final profileState = container.read(profileProvider);
        expect(profileState.profile!.gems, equals(25)); // 50 default - 25 spent

        // Verify persistence
        final dbProfile = await database.playerProfilesDao.getProfileWithStats(
          'default_user',
        );
        expect(dbProfile!.profile.gems, equals(25));
      });

      test('should not spend gems when insufficient funds', () async {
        // Arrange
        await container.pump(); // Wait for initialization

        // Act
        final profileNotifier = container.read(profileProvider.notifier);
        final success = await profileNotifier.spendGems(
          100,
        ); // More than available
        await container.pump();

        // Assert
        expect(success, isFalse);
        final profileState = container.read(profileProvider);
        expect(
          profileState.profile!.gems,
          equals(50),
        ); // Should remain unchanged

        // Verify no change in database
        final dbProfile = await database.playerProfilesDao.getProfileWithStats(
          'default_user',
        );
        expect(dbProfile!.profile.gems, equals(50));
      });

      test('should use hints and persist to database', () async {
        // Arrange
        await container.pump(); // Wait for initialization

        // Act
        final profileNotifier = container.read(profileProvider.notifier);
        final success = await profileNotifier.useHint();
        await container.pump();

        // Assert
        expect(success, isTrue);
        final profileState = container.read(profileProvider);
        expect(profileState.profile!.hints, equals(2)); // 3 default - 1 used

        // Verify persistence
        final dbProfile = await database.playerProfilesDao.getProfileWithStats(
          'default_user',
        );
        expect(dbProfile!.profile.hints, equals(2));
      });

      test('should not use hints when none available', () async {
        // Arrange - Set up profile with 0 hints
        await container.pump();

        // Use all hints first
        final profileNotifier = container.read(profileProvider.notifier);
        await profileNotifier.useHint();
        await profileNotifier.useHint();
        await profileNotifier.useHint();
        await container.pump();

        // Act - Try to use hint when none available
        final success = await profileNotifier.useHint();
        await container.pump();

        // Assert
        expect(success, isFalse);
        final profileState = container.read(profileProvider);
        expect(profileState.profile!.hints, equals(0)); // Should remain 0

        // Verify no change in database
        final dbProfile = await database.playerProfilesDao.getProfileWithStats(
          'default_user',
        );
        expect(dbProfile!.profile.hints, equals(0));
      });
    });

    group('Game Stats Updates', () {
      test('should update stats after winning game', () async {
        // Arrange
        await container.pump(); // Wait for initialization

        // Act
        final profileNotifier = container.read(profileProvider.notifier);
        await profileNotifier.updateGameStats(isWin: true);
        await container.pump();

        // Assert
        final profileState = container.read(profileProvider);
        expect(profileState.profile!.stats.wins, equals(1));
        expect(profileState.profile!.stats.streak, equals(1));
        expect(profileState.profile!.stats.totalGames, equals(1));

        // Verify persistence
        final dbProfile = await database.playerProfilesDao.getProfileWithStats(
          'default_user',
        );
        expect(dbProfile!.stats!.wins, equals(1));
        expect(dbProfile.stats!.streak, equals(1));
        expect(dbProfile.stats!.totalGames, equals(1));
      });

      test('should update stats after losing game', () async {
        // Arrange
        await container.pump(); // Wait for initialization

        // Act
        final profileNotifier = container.read(profileProvider.notifier);
        await profileNotifier.updateGameStats(isWin: false);
        await container.pump();

        // Assert
        final profileState = container.read(profileProvider);
        expect(profileState.profile!.stats.losses, equals(1));
        expect(profileState.profile!.stats.streak, equals(0));
        expect(profileState.profile!.stats.totalGames, equals(1));

        // Verify persistence
        final dbProfile = await database.playerProfilesDao.getProfileWithStats(
          'default_user',
        );
        expect(dbProfile!.stats!.losses, equals(1));
        expect(dbProfile.stats!.streak, equals(0));
        expect(dbProfile.stats!.totalGames, equals(1));
      });

      test('should update stats after draw game', () async {
        // Arrange
        await container.pump(); // Wait for initialization

        // Act
        final profileNotifier = container.read(profileProvider.notifier);
        await profileNotifier.updateGameStats(isDraw: true);
        await container.pump();

        // Assert
        final profileState = container.read(profileProvider);
        expect(profileState.profile!.stats.draws, equals(1));
        expect(profileState.profile!.stats.streak, equals(0));
        expect(profileState.profile!.stats.totalGames, equals(1));

        // Verify persistence
        final dbProfile = await database.playerProfilesDao.getProfileWithStats(
          'default_user',
        );
        expect(dbProfile!.stats!.draws, equals(1));
        expect(dbProfile.stats!.streak, equals(0));
        expect(dbProfile.stats!.totalGames, equals(1));
      });

      test('should maintain streak correctly after consecutive wins', () async {
        // Arrange
        await container.pump(); // Wait for initialization

        // Act - Multiple wins
        final profileNotifier = container.read(profileProvider.notifier);
        await profileNotifier.updateGameStats(isWin: true);
        await profileNotifier.updateGameStats(isWin: true);
        await profileNotifier.updateGameStats(isWin: true);
        await container.pump();

        // Assert
        final profileState = container.read(profileProvider);
        expect(profileState.profile!.stats.wins, equals(3));
        expect(profileState.profile!.stats.streak, equals(3));
        expect(profileState.profile!.stats.totalGames, equals(3));

        // Verify persistence
        final dbProfile = await database.playerProfilesDao.getProfileWithStats(
          'default_user',
        );
        expect(dbProfile!.stats!.streak, equals(3));
      });

      test('should reset streak after loss', () async {
        // Arrange
        await container.pump();

        // Win first
        final profileNotifier = container.read(profileProvider.notifier);
        await profileNotifier.updateGameStats(isWin: true);
        await container.pump();

        // Act - Lose after win
        await profileNotifier.updateGameStats(isWin: false);
        await container.pump();

        // Assert
        final profileState = container.read(profileProvider);
        expect(profileState.profile!.stats.wins, equals(1));
        expect(profileState.profile!.stats.losses, equals(1));
        expect(profileState.profile!.stats.streak, equals(0));
        expect(profileState.profile!.stats.totalGames, equals(2));
      });
    });

    group('Game History Integration', () {
      test('should add game to history and update stats atomically', () async {
        // Arrange
        await container.pump(); // Wait for initialization

        final game = GameHistoryItem(
          opponent: 'Robot',
          result: GameResult.win,
          boardSize: '3x3',
          date: DateTime.now(),
          duration: const Duration(minutes: 2),
          score: '100',
        );

        // Act
        final profileNotifier = container.read(profileProvider.notifier);
        await profileNotifier.addGameToHistory(game);
        await container.pump();

        // Assert - Profile stats updated
        final profileState = container.read(profileProvider);
        expect(profileState.profile!.stats.wins, equals(1));
        expect(profileState.profile!.stats.streak, equals(1));

        // Assert - Game added to history
        final gameHistory = await profileNotifier.gameHistory;
        expect(gameHistory.length, equals(1));
        expect(gameHistory.first.opponent, equals('Robot'));
        expect(gameHistory.first.result, equals(GameResult.win));

        // Verify persistence in database
        final dbGames = await database.gameHistoryDao.getGamesByProfile(
          'default_user',
        );
        expect(dbGames.length, equals(1));
        expect(dbGames.first.opponent, equals('Robot'));
        expect(dbGames.first.result, equals('win'));
      });

      test('should provide reactive game history stream', () async {
        // Arrange
        await container.pump(); // Wait for initialization

        // Act & Assert - Listen to game history stream
        final profileNotifier = container.read(profileProvider.notifier);
        final gameHistoryStream = profileNotifier.gameHistoryStream;

        expect(gameHistoryStream, isA<Stream<List<GameHistoryItem>>>());

        // Add a game and verify stream updates
        final game = GameHistoryItem(
          opponent: 'Robot',
          result: GameResult.win,
          boardSize: '3x3',
          date: DateTime.now(),
          duration: const Duration(minutes: 1),
          score: '50',
        );

        await profileNotifier.addGameToHistory(game);
        await container.pump();

        // The stream should emit updated history
        final history = await gameHistoryStream.first;
        expect(history.length, greaterThan(0));
      });

      test('should get recent games (first 3)', () async {
        // Arrange
        await container.pump();

        // Add multiple games
        final profileNotifier = container.read(profileProvider.notifier);
        for (int i = 0; i < 5; i++) {
          final game = GameHistoryItem(
            opponent: 'Robot$i',
            result: GameResult.win,
            boardSize: '3x3',
            date: DateTime.now().add(Duration(minutes: i)),
            duration: Duration(minutes: i + 1),
            score: '${50 + i}',
          );
          await profileNotifier.addGameToHistory(game);
        }
        await container.pump();

        // Act
        final recentGames = await profileNotifier.recentGames;

        // Assert
        expect(recentGames.length, equals(3)); // Should return only first 3
        expect(
          recentGames.first.opponent,
          equals('Robot0'),
        ); // Most recent first
      });

      test('should handle game history database errors gracefully', () async {
        // Arrange
        await database.close(); // Close database to simulate error

        await container.pump();

        // Act
        final game = GameHistoryItem(
          opponent: 'Robot',
          result: GameResult.win,
          boardSize: '3x3',
          date: DateTime.now(),
          duration: const Duration(minutes: 1),
          score: '50',
        );

        final profileNotifier = container.read(profileProvider.notifier);
        await profileNotifier.addGameToHistory(game);
        await container.pump();

        // Assert - Error should be set but not crash
        final profileState = container.read(profileProvider);
        expect(profileState.error, isNotNull);
        expect(profileState.error!.contains('Database error'), isTrue);
      });
    });

    group('Profile Reset Functionality', () {
      test('should reset profile to defaults', () async {
        // Arrange
        await container.pump();

        // Modify profile first
        final profileNotifier = container.read(profileProvider.notifier);
        await profileNotifier.updateNickname('ModifiedName');
        await profileNotifier.addGems(100);
        await profileNotifier.updateGameStats(isWin: true);
        await container.pump();

        // Verify modifications
        final modifiedState = container.read(profileProvider);
        expect(modifiedState.profile!.nickname, equals('ModifiedName'));
        expect(modifiedState.profile!.gems, equals(150)); // 50 + 100
        expect(modifiedState.profile!.stats.wins, equals(1));

        // Act - Reset profile
        await profileNotifier.resetProfile();
        await container.pump();

        // Assert - Profile reset to defaults
        final resetState = container.read(profileProvider);
        expect(resetState.profile!.nickname, equals('Player'));
        expect(resetState.profile!.gems, equals(50));
        expect(resetState.profile!.hints, equals(3));
        expect(resetState.profile!.stats.wins, equals(0));
        expect(resetState.profile!.stats.losses, equals(0));
        expect(resetState.profile!.stats.draws, equals(0));
        expect(resetState.profile!.stats.streak, equals(0));
      });
    });

    group('Extension Methods Integration', () {
      test('should provide all extension methods correctly', () async {
        // Arrange
        await container.pump();

        // Act & Assert - Test all extension methods
        expect(() => container.read(profileProvider.notifier), returnsNormally);
        expect(() => container.read(currentProfileProvider), returnsNormally);
        expect(() => container.read(profileStatsProvider), returnsNormally);
        expect(() => container.read(profileGemsProvider), returnsNormally);
        expect(() => container.read(profileHintsProvider), returnsNormally);
        expect(() => container.read(profileNicknameProvider), returnsNormally);
        expect(() => container.read(profileAvatarProvider), returnsNormally);
        expect(() => container.read(profileIsLoadingProvider), returnsNormally);
        expect(() => container.read(profileErrorProvider), returnsNormally);
        expect(() => container.read(profileIsEditingProvider), returnsNormally);
        expect(() => container.read(profileWinRateProvider), returnsNormally);
        expect(
          () => container.read(profileTotalGamesProvider),
          returnsNormally,
        );
        expect(
          () => container.read(profileIsProfileLoadedProvider),
          returnsNormally,
        );
      });

      test('should update extension methods reactively', () async {
        // Arrange
        await container.pump();

        // Act - Update profile
        final profileNotifier = container.read(profileProvider.notifier);
        await profileNotifier.updateNickname('TestName');
        await profileNotifier.addGems(25);
        await container.pump();

        // Assert - Extension methods reflect updates
        expect(container.read(profileNicknameProvider), equals('TestName'));
        expect(container.read(profileGemsProvider), equals(75)); // 50 + 25
      });
    });
  });
}
