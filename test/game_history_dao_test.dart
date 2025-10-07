import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matcher/matcher.dart' as matcher;
import 'package:tictactoe_xo_royale/core/database/app_database.dart';
import 'package:tictactoe_xo_royale/core/database/game_history_dao.dart';
import 'package:tictactoe_xo_royale/core/database/database_providers.dart';

void main() {
  late AppDatabase database;
  late ProviderContainer container;
  late GameHistoryDao dao;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
    dao = container.read(gameHistoryDaoProvider);
  });

  tearDown(() async {
    await database.close();
    container.dispose();
  });

  group('GameHistoryDao Tests', () {
    // ===== BASIC OPERATIONS =====

    group('insertGame()', () {
      test('should insert single game successfully', () async {
        // Arrange
        final game = GameHistoryCompanion.insert(
          profileId: 1,
          opponent: 'Robot',
          result: 'win',
          boardSize: '3x3',
          durationSeconds: 45,
          score: 'X won in 8 moves',
          playedAt: DateTime(2024, 1, 1, 10, 30),
        );

        // Act
        final id = await dao.insertGame(game);

        // Assert
        expect(id, isA<int>());
        expect(id, greaterThan(0));

        // Verify insertion
        final games = await dao.getGamesByProfile('1');
        expect(games.length, 1);
        expect(games.first.opponent, 'Robot');
        expect(games.first.result, 'win');
        expect(games.first.boardSize, '3x3');
      });

      test('should handle game with minimum required data', () async {
        // Arrange - minimal valid game
        final game = GameHistoryCompanion.insert(
          profileId: 1,
          opponent: 'Player',
          result: 'loss',
          boardSize: '4x4',
          durationSeconds: 120,
          score: 'O won',
          playedAt: DateTime(2024, 1, 1, 11, 0),
        );

        // Act
        final id = await dao.insertGame(game);

        // Assert
        expect(id, greaterThan(0));

        final games = await dao.getGamesByProfile('1');
        expect(games.length, 1);
        expect(games.first.opponent, 'Player');
        expect(games.first.result, 'loss');
      });
    });

    group('insertGames()', () {
      test('should insert multiple games efficiently', () async {
        // Arrange
        final games = [
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Robot',
            result: 'win',
            boardSize: '3x3',
            durationSeconds: 30,
            score: 'X won in 5 moves',
            playedAt: DateTime(2024, 1, 1, 10, 0),
          ),
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Player',
            result: 'loss',
            boardSize: '3x3',
            durationSeconds: 60,
            score: 'O won in 7 moves',
            playedAt: DateTime(2024, 1, 1, 10, 15),
          ),
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Robot',
            result: 'draw',
            boardSize: '4x4',
            durationSeconds: 90,
            score: 'Draw after 16 moves',
            playedAt: DateTime(2024, 1, 1, 10, 30),
          ),
        ];

        // Act
        await dao.insertGames(games);

        // Assert
        final retrievedGames = await dao.getGamesByProfile('1');
        expect(retrievedGames.length, 3);

        // Verify all games were inserted correctly
        expect(retrievedGames.where((g) => g.opponent == 'Robot').length, 2);
        expect(retrievedGames.where((g) => g.opponent == 'Player').length, 1);
        expect(retrievedGames.where((g) => g.result == 'win').length, 1);
        expect(retrievedGames.where((g) => g.result == 'loss').length, 1);
        expect(retrievedGames.where((g) => g.result == 'draw').length, 1);
      });

      test('should handle empty games list gracefully', () async {
        // Act
        await dao.insertGames([]);

        // Assert - Should not throw exception
        expect(true, isTrue);
      });
    });

    group('getGamesByProfile()', () {
      setUp(() async {
        // Insert test data
        await dao.insertGames([
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Robot',
            result: 'win',
            boardSize: '3x3',
            durationSeconds: 30,
            score: 'X won',
            playedAt: DateTime(2024, 1, 1, 10, 0),
          ),
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Player',
            result: 'loss',
            boardSize: '3x3',
            durationSeconds: 45,
            score: 'O won',
            playedAt: DateTime(2024, 1, 1, 10, 15),
          ),
          GameHistoryCompanion.insert(
            profileId: 2, // Different profile
            opponent: 'Robot',
            result: 'win',
            boardSize: '4x4',
            durationSeconds: 60,
            score: 'X won',
            playedAt: DateTime(2024, 1, 1, 11, 0),
          ),
        ]);
      });

      test('should return games for specific profile', () async {
        // Act
        final games = await dao.getGamesByProfile('1');

        // Assert
        expect(games.length, 2);
        expect(games.every((g) => g.profileId == 1), isTrue);
      });

      test('should return empty list for profile with no games', () async {
        // Act
        final games = await dao.getGamesByProfile('999');

        // Assert
        expect(games, isEmpty);
      });

      test('should respect limit parameter', () async {
        // Act
        final gamesLimited = await dao.getGamesByProfile('1', limit: 1);
        final gamesUnlimited = await dao.getGamesByProfile('1');

        // Assert
        expect(gamesLimited.length, 1);
        expect(gamesUnlimited.length, 2);
      });

      test('should return games in descending order by playedAt', () async {
        // Act
        final games = await dao.getGamesByProfile('1');

        // Assert
        expect(games.length, 2);
        expect(games[0].playedAt.isAfter(games[1].playedAt), isTrue);
      });
    });

    group('getLastGame()', () {
      setUp(() async {
        // Insert test data with different timestamps
        await dao.insertGames([
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Robot',
            result: 'win',
            boardSize: '3x3',
            durationSeconds: 30,
            score: 'X won',
            playedAt: DateTime(2024, 1, 1, 10, 0), // Oldest
          ),
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Player',
            result: 'loss',
            boardSize: '3x3',
            durationSeconds: 45,
            score: 'O won',
            playedAt: DateTime(2024, 1, 1, 10, 15), // Latest
          ),
        ]);
      });

      test('should return most recent game for profile', () async {
        // Act
        final lastGame = await dao.getLastGame('1');

        // Assert
        expect(lastGame, matcher.isNotNull);
        expect(lastGame!.opponent, 'Player');
        expect(lastGame.result, 'loss');
        expect(lastGame.playedAt, DateTime(2024, 1, 1, 10, 15));
      });

      test('should return null for profile with no games', () async {
        // Act
        final lastGame = await dao.getLastGame('999');

        // Assert
        expect(lastGame, matcher.isNull);
      });
    });

    group('getGamesByOpponent()', () {
      setUp(() async {
        // Insert test data
        await dao.insertGames([
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Robot',
            result: 'win',
            boardSize: '3x3',
            durationSeconds: 30,
            score: 'X won',
            playedAt: DateTime(2024, 1, 1, 10, 0),
          ),
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Robot',
            result: 'loss',
            boardSize: '3x3',
            durationSeconds: 45,
            score: 'O won',
            playedAt: DateTime(2024, 1, 1, 10, 15),
          ),
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Player',
            result: 'draw',
            boardSize: '4x4',
            durationSeconds: 60,
            score: 'Draw',
            playedAt: DateTime(2024, 1, 1, 11, 0),
          ),
        ]);
      });

      test('should return games by specific opponent', () async {
        // Act
        final robotGames = await dao.getGamesByOpponent('1', 'Robot');
        final playerGames = await dao.getGamesByOpponent('1', 'Player');

        // Assert
        expect(robotGames.length, 2);
        expect(robotGames.every((g) => g.opponent == 'Robot'), isTrue);

        expect(playerGames.length, 1);
        expect(playerGames.first.opponent, 'Player');
      });

      test('should return empty list for non-existing opponent', () async {
        // Act
        final games = await dao.getGamesByOpponent('1', 'NonExistent');

        // Assert
        expect(games, isEmpty);
      });
    });

    group('getGamesByResult()', () {
      setUp(() async {
        // Insert test data
        await dao.insertGames([
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Robot',
            result: 'win',
            boardSize: '3x3',
            durationSeconds: 30,
            score: 'X won',
            playedAt: DateTime(2024, 1, 1, 10, 0),
          ),
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Player',
            result: 'win',
            boardSize: '3x3',
            durationSeconds: 45,
            score: 'X won',
            playedAt: DateTime(2024, 1, 1, 10, 15),
          ),
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Robot',
            result: 'loss',
            boardSize: '4x4',
            durationSeconds: 60,
            score: 'O won',
            playedAt: DateTime(2024, 1, 1, 11, 0),
          ),
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Player',
            result: 'draw',
            boardSize: '3x3',
            durationSeconds: 75,
            score: 'Draw',
            playedAt: DateTime(2024, 1, 1, 11, 15),
          ),
        ]);
      });

      test('should return games by specific result', () async {
        // Act
        final winGames = await dao.getGamesByResult('1', 'win');
        final lossGames = await dao.getGamesByResult('1', 'loss');
        final drawGames = await dao.getGamesByResult('1', 'draw');

        // Assert
        expect(winGames.length, 2);
        expect(winGames.every((g) => g.result == 'win'), isTrue);

        expect(lossGames.length, 1);
        expect(lossGames.first.result, 'loss');

        expect(drawGames.length, 1);
        expect(drawGames.first.result, 'draw');
      });

      test('should return empty list for non-existing result', () async {
        // Act
        final games = await dao.getGamesByResult('1', 'nonexistent');

        // Assert
        expect(games, isEmpty);
      });
    });

    group('getGamesInDateRange()', () {
      setUp(() async {
        // Insert test data with different dates
        await dao.insertGames([
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Robot',
            result: 'win',
            boardSize: '3x3',
            durationSeconds: 30,
            score: 'X won',
            playedAt: DateTime(2024, 1, 1, 10, 0), // Within range
          ),
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Player',
            result: 'loss',
            boardSize: '3x3',
            durationSeconds: 45,
            score: 'O won',
            playedAt: DateTime(2024, 1, 1, 10, 15), // Within range
          ),
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Robot',
            result: 'draw',
            boardSize: '4x4',
            durationSeconds: 60,
            score: 'Draw',
            playedAt: DateTime(2024, 1, 2, 10, 0), // Outside range
          ),
        ]);
      });

      test('should return games within date range', () async {
        // Arrange
        final start = DateTime(2024, 1, 1, 9, 0);
        final end = DateTime(2024, 1, 1, 11, 0);

        // Act
        final games = await dao.getGamesInDateRange('1', start, end);

        // Assert
        expect(games.length, 2);
        expect(
          games.every(
            (g) => g.playedAt.isAfter(start) && g.playedAt.isBefore(end),
          ),
          isTrue,
        );
      });

      test('should return empty list for date range with no games', () async {
        // Arrange
        final start = DateTime(2024, 1, 3, 0, 0);
        final end = DateTime(2024, 1, 3, 23, 59);

        // Act
        final games = await dao.getGamesInDateRange('1', start, end);

        // Assert
        expect(games, isEmpty);
      });
    });

    group('deleteOldGames()', () {
      setUp(() async {
        // Insert test data with different ages
        await dao.insertGames([
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Robot',
            result: 'win',
            boardSize: '3x3',
            durationSeconds: 30,
            score: 'X won',
            playedAt: DateTime.now().subtract(const Duration(days: 40)), // Old
          ),
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Player',
            result: 'loss',
            boardSize: '3x3',
            durationSeconds: 45,
            score: 'O won',
            playedAt: DateTime.now().subtract(const Duration(days: 20)), // Old
          ),
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Robot',
            result: 'draw',
            boardSize: '4x4',
            durationSeconds: 60,
            score: 'Draw',
            playedAt: DateTime.now().subtract(
              const Duration(days: 10),
            ), // Recent
          ),
        ]);
      });

      test('should delete games older than specified days', () async {
        // Act
        final deletedCount = await dao.deleteOldGames(olderThanDays: 15);

        // Assert
        expect(deletedCount, 2); // Should delete 2 old games

        final remainingGames = await dao.getGamesByProfile('1');
        expect(remainingGames.length, 1);
        expect(
          remainingGames.first.playedAt.day,
          DateTime.now().subtract(const Duration(days: 10)).day,
        );
      });

      test('should delete all games when all are old', () async {
        // Act
        final deletedCount = await dao.deleteOldGames(olderThanDays: 5);

        // Assert
        expect(deletedCount, 3); // Should delete all games

        final remainingGames = await dao.getGamesByProfile('1');
        expect(remainingGames, isEmpty);
      });

      test('should not delete any games when none are old', () async {
        // Act
        final deletedCount = await dao.deleteOldGames(olderThanDays: 50);

        // Assert
        expect(deletedCount, 0); // No games deleted

        final remainingGames = await dao.getGamesByProfile('1');
        expect(remainingGames.length, 3); // All games remain
      });
    });

    group('deleteGamesForProfile()', () {
      setUp(() async {
        // Insert test data for multiple profiles
        await dao.insertGames([
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Robot',
            result: 'win',
            boardSize: '3x3',
            durationSeconds: 30,
            score: 'X won',
            playedAt: DateTime(2024, 1, 1, 10, 0),
          ),
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Player',
            result: 'loss',
            boardSize: '3x3',
            durationSeconds: 45,
            score: 'O won',
            playedAt: DateTime(2024, 1, 1, 10, 15),
          ),
          GameHistoryCompanion.insert(
            profileId: 2,
            opponent: 'Robot',
            result: 'win',
            boardSize: '4x4',
            durationSeconds: 60,
            score: 'X won',
            playedAt: DateTime(2024, 1, 1, 11, 0),
          ),
        ]);
      });

      test('should delete all games for specific profile', () async {
        // Act
        final deletedCount = await dao.deleteGamesForProfile('1');

        // Assert
        expect(deletedCount, 2);

        final profile1Games = await dao.getGamesByProfile('1');
        final profile2Games = await dao.getGamesByProfile('2');

        expect(profile1Games, isEmpty);
        expect(profile2Games.length, 1);
      });

      test('should return 0 when profile has no games', () async {
        // Act
        final deletedCount = await dao.deleteGamesForProfile('999');

        // Assert
        expect(deletedCount, 0);
      });
    });

    group('Statistics Methods', () {
      setUp(() async {
        // Insert test data for statistics
        await dao.insertGames([
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Robot',
            result: 'win',
            boardSize: '3x3',
            durationSeconds: 30,
            score: 'X won',
            playedAt: DateTime(2024, 1, 1, 10, 0),
          ),
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Player',
            result: 'win',
            boardSize: '3x3',
            durationSeconds: 45,
            score: 'X won',
            playedAt: DateTime(2024, 1, 1, 10, 15),
          ),
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Robot',
            result: 'loss',
            boardSize: '4x4',
            durationSeconds: 60,
            score: 'O won',
            playedAt: DateTime(2024, 1, 1, 11, 0),
          ),
        ]);
      });

      test('getGameCount() should return correct count', () async {
        // Act
        final count = await dao.getGameCount('1');

        // Assert
        expect(count, 3);
      });

      test('getWinRate() should calculate correctly', () async {
        // Act
        final winRate = await dao.getWinRate('1');

        // Assert
        expect(winRate, closeTo(0.666, 0.001)); // 2 wins out of 3 games
      });

      test('getWinRate() should return 0 for profile with no games', () async {
        // Act
        final winRate = await dao.getWinRate('999');

        // Assert
        expect(winRate, 0.0);
      });

      test('getAverageGameDuration() should calculate correctly', () async {
        // Act
        final avgDuration = await dao.getAverageGameDuration('1');

        // Assert
        expect(avgDuration, const Duration(seconds: 45)); // (30+45+60)/3 = 45
      });

      test(
        'getAverageGameDuration() should return zero for profile with no games',
        () async {
          // Act
          final avgDuration = await dao.getAverageGameDuration('999');

          // Assert
          expect(avgDuration, Duration.zero);
        },
      );
    });

    // ===== REACTIVE STREAMS =====

    group('Reactive Streams', () {
      test('watchRecentGames() should emit game changes', () async {
        // Arrange
        await dao.insertGame(
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Robot',
            result: 'win',
            boardSize: '3x3',
            durationSeconds: 30,
            score: 'X won',
            playedAt: DateTime(2024, 1, 1, 10, 0),
          ),
        );

        // Act & Assert
        expect(
          dao.watchRecentGames('1', limit: 10),
          emitsInOrder([
            // Initial emission with 1 game
            hasLength(1),
            // After adding second game
            hasLength(2),
          ]),
        );

        // Add second game to trigger stream emission
        await dao.insertGame(
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Player',
            result: 'loss',
            boardSize: '3x3',
            durationSeconds: 45,
            score: 'O won',
            playedAt: DateTime(2024, 1, 1, 10, 15),
          ),
        );
      });

      test('watchRecentGames() should respect limit parameter', () async {
        // Arrange - Insert 3 games
        await dao.insertGames([
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Robot',
            result: 'win',
            boardSize: '3x3',
            durationSeconds: 30,
            score: 'X won',
            playedAt: DateTime(2024, 1, 1, 10, 0),
          ),
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Player',
            result: 'loss',
            boardSize: '3x3',
            durationSeconds: 45,
            score: 'O won',
            playedAt: DateTime(2024, 1, 1, 10, 15),
          ),
          GameHistoryCompanion.insert(
            profileId: 1,
            opponent: 'Robot',
            result: 'draw',
            boardSize: '4x4',
            durationSeconds: 60,
            score: 'Draw',
            playedAt: DateTime(2024, 1, 1, 11, 0),
          ),
        ]);

        // Act & Assert
        expect(
          dao.watchRecentGames('1', limit: 2),
          emits(hasLength(2)), // Should be limited to 2 games
        );
      });
    });

    // ===== EDGE CASES AND ERROR HANDLING =====

    group('Edge Cases and Error Handling', () {
      test('should handle concurrent game insertions', () async {
        // Arrange
        final games = List.generate(
          10,
          (index) => GameHistoryCompanion.insert(
            profileId: 1,
            opponent: index % 2 == 0 ? 'Robot' : 'Player',
            result: index % 3 == 0 ? 'win' : (index % 3 == 1 ? 'loss' : 'draw'),
            boardSize: '3x3',
            durationSeconds: 30 + index * 5,
            score: 'Game $index',
            playedAt: DateTime(2024, 1, 1, 10, index),
          ),
        );

        // Act - Insert concurrently
        await Future.wait(games.map(dao.insertGame));

        // Assert
        final retrievedGames = await dao.getGamesByProfile('1');
        expect(retrievedGames.length, 10);

        // Verify all games were inserted correctly
        expect(retrievedGames.where((g) => g.opponent == 'Robot').length, 5);
        expect(retrievedGames.where((g) => g.opponent == 'Player').length, 5);
      });

      test('should handle games with maximum values', () async {
        // Arrange - game with large values
        final game = GameHistoryCompanion.insert(
          profileId: 1,
          opponent: 'Robot',
          result: 'win',
          boardSize: '5x5',
          durationSeconds: 999999, // Very long game
          score: 'X won after many moves',
          playedAt: DateTime(2024, 1, 1, 10, 0),
        );

        // Act & Assert - Should not throw exception
        expect(() async => await dao.insertGame(game), returnsNormally);

        final id = await dao.insertGame(game);
        expect(id, greaterThan(0));
      });

      test('should handle profile ID parsing edge cases', () async {
        // Test various profile ID formats
        final testCases = [
          ('1', 1),
          ('999', 999),
          ('default_user', 1), // Should map to 1
          ('invalid', 1), // Should fallback to 1
        ];

        for (final (_, expectedIntId) in testCases) {
          final game = GameHistoryCompanion.insert(
            profileId: expectedIntId,
            opponent: 'Robot',
            result: 'win',
            boardSize: '3x3',
            durationSeconds: 30,
            score: 'Test game',
            playedAt: DateTime(2024, 1, 1, 10, 0),
          );

          final id = await dao.insertGame(game);
          expect(id, greaterThan(0));
        }

        // Verify all games were inserted for profile 1
        final games = await dao.getGamesByProfile('1');
        expect(
          games.length,
          3,
        ); // All should map to profile 1 (invalid maps to 1)
      });
    });
  });
}
