import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matcher/matcher.dart' as matcher;
import 'package:tictactoe_xo_royale/core/database/app_database.dart';
import 'package:tictactoe_xo_royale/core/database/achievement_dao.dart';
import 'package:tictactoe_xo_royale/core/database/database_providers.dart';

void main() {
  late AppDatabase database;
  late ProviderContainer container;
  late AchievementDao dao;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
    dao = container.read(achievementDaoProvider);
  });

  tearDown(() async {
    await database.close();
    container.dispose();
  });

  group('AchievementDao Tests', () {
    // ===== BASIC OPERATIONS =====

    group('getAchievementsByProfile()', () {
      setUp(() async {
        // Initialize achievements for profile 1
        await dao.initializeAchievementsForProfile('1');
      });

      test('should return all achievements for profile', () async {
        // Act
        final achievements = await dao.getAchievementsByProfile('1');

        // Assert
        expect(achievements.length, 18); // 18 default achievements
        expect(achievements.every((a) => a.profileId == 1), isTrue);
        expect(
          achievements.where((a) => a.isUnlocked).length,
          0,
        ); // None unlocked initially
      });

      test(
        'should return empty list for profile with no achievements',
        () async {
          // Act
          final achievements = await dao.getAchievementsByProfile('999');

          // Assert
          expect(achievements, isEmpty);
        },
      );

      test(
        'should return achievements ordered by unlocked date (newest first)',
        () async {
          // Arrange - Unlock some achievements
          await dao.unlockAchievement('1', 'first_win');

          // Act
          final achievements = await dao.getAchievementsByProfile('1');

          // Assert
          expect(achievements.length, 18);
          // Unlocked achievement should be first (newest unlocked date)
          expect(achievements.first.achievementId, 'first_win');
          expect(achievements.first.isUnlocked, isTrue);
        },
      );
    });

    group('getAchievement()', () {
      setUp(() async {
        await dao.initializeAchievementsForProfile('1');
      });

      test('should return specific achievement when exists', () async {
        // Act
        final achievement = await dao.getAchievement('1', 'first_win');

        // Assert
        expect(achievement, matcher.isNotNull);
        expect(achievement!.achievementId, 'first_win');
        expect(achievement.profileId, 1);
        expect(achievement.isUnlocked, isFalse);
        expect(achievement.progress, 0);
      });

      test('should return null when achievement does not exist', () async {
        // Act
        final achievement = await dao.getAchievement('1', 'nonexistent');

        // Assert
        expect(achievement, matcher.isNull);
      });

      test('should return null when profile does not exist', () async {
        // Act
        final achievement = await dao.getAchievement('999', 'first_win');

        // Assert
        expect(achievement, matcher.isNull);
      });
    });

    group('unlockAchievement()', () {
      setUp(() async {
        await dao.initializeAchievementsForProfile('1');
      });

      test('should unlock achievement successfully', () async {
        // Act
        final result = await dao.unlockAchievement('1', 'first_win');

        // Assert
        expect(result, 1); // One row updated

        // Verify achievement was unlocked
        final achievement = await dao.getAchievement('1', 'first_win');
        expect(achievement!.isUnlocked, isTrue);
        expect(achievement.unlockedDate, matcher.isNotNull);
      });

      test('should return 0 when unlocking non-existing achievement', () async {
        // Act
        final result = await dao.unlockAchievement('1', 'nonexistent');

        // Assert
        expect(result, 0); // No rows updated
      });

      test('should return 0 when unlocking for non-existing profile', () async {
        // Act
        final result = await dao.unlockAchievement('999', 'first_win');

        // Assert
        expect(result, 0); // No rows updated
      });
    });

    group('updateProgress()', () {
      setUp(() async {
        await dao.initializeAchievementsForProfile('1');
      });

      test('should update progress successfully', () async {
        // Act
        final result = await dao.updateProgress('1', 'first_win', 5);

        // Assert
        expect(result, 1); // One row updated

        // Verify progress was updated
        final achievement = await dao.getAchievement('1', 'first_win');
        expect(achievement!.progress, 5);
        expect(achievement.isUnlocked, isFalse); // Not unlocked yet
      });

      test('should return 0 when updating non-existing achievement', () async {
        // Act
        final result = await dao.updateProgress('1', 'nonexistent', 5);

        // Assert
        expect(result, 0); // No rows updated
      });

      test('should handle zero progress', () async {
        // Act
        final result = await dao.updateProgress('1', 'first_win', 0);

        // Assert
        expect(result, 1);

        final achievement = await dao.getAchievement('1', 'first_win');
        expect(achievement!.progress, 0);
      });

      test('should handle large progress values', () async {
        // Act
        final result = await dao.updateProgress('1', 'first_win', 999999);

        // Assert
        expect(result, 1);

        final achievement = await dao.getAchievement('1', 'first_win');
        expect(achievement!.progress, 999999);
      });
    });

    group('setProgressAndCheckUnlock()', () {
      setUp(() async {
        await dao.initializeAchievementsForProfile('1');
      });

      test('should update progress and unlock when reaching max', () async {
        // Act
        final result = await dao.setProgressAndCheckUnlock(
          '1',
          'first_win',
          10,
          10,
        );

        // Assert
        expect(
          result,
          isTrue,
        ); // Should return true (progress updated and unlocked)

        // Verify achievement was unlocked
        final achievement = await dao.getAchievement('1', 'first_win');
        expect(achievement!.isUnlocked, isTrue);
        expect(achievement.progress, 10);
      });

      test(
        'should update progress but not unlock when not reaching max',
        () async {
          // Act
          final result = await dao.setProgressAndCheckUnlock(
            '1',
            'first_win',
            5,
            10,
          );

          // Assert
          expect(result, isTrue); // Should return true (progress updated)

          // Verify achievement was not unlocked
          final achievement = await dao.getAchievement('1', 'first_win');
          expect(achievement!.isUnlocked, isFalse);
          expect(achievement.progress, 5);
        },
      );

      test('should return false when no progress update occurs', () async {
        // Act - Try to update non-existing achievement
        final result = await dao.setProgressAndCheckUnlock(
          '1',
          'nonexistent',
          5,
          10,
        );

        // Assert
        expect(result, isFalse);
      });
    });

    group('insertAchievement()', () {
      test('should insert achievement successfully', () async {
        // Arrange
        final achievement = AchievementsCompanion(
          profileId: const Value(1),
          achievementId: const Value('test_achievement'),
          isUnlocked: const Value(false),
          progress: const Value(0),
        );

        // Act
        final id = await dao.insertAchievement(achievement);

        // Assert
        expect(id, isA<int>());
        expect(id, greaterThan(0));

        // Verify insertion
        final retrieved = await dao.getAchievement('1', 'test_achievement');
        expect(retrieved, matcher.isNotNull);
        expect(retrieved!.achievementId, 'test_achievement');
        expect(retrieved.isUnlocked, isFalse);
        expect(retrieved.progress, 0);
      });

      test('should handle achievement with unlocked status', () async {
        // Arrange
        final achievement = AchievementsCompanion(
          profileId: const Value(1),
          achievementId: const Value('unlocked_achievement'),
          isUnlocked: const Value(true),
          progress: const Value(100),
          unlockedDate: Value(DateTime(2024, 1, 1)),
        );

        // Act
        final id = await dao.insertAchievement(achievement);

        // Assert
        expect(id, greaterThan(0));

        final retrieved = await dao.getAchievement('1', 'unlocked_achievement');
        expect(retrieved!.isUnlocked, isTrue);
        expect(retrieved.progress, 100);
        expect(retrieved.unlockedDate, DateTime(2024, 1, 1));
      });
    });

    group('initializeAchievementsForProfile()', () {
      test('should initialize all default achievements for profile', () async {
        // Act
        await dao.initializeAchievementsForProfile('1');

        // Assert
        final achievements = await dao.getAchievementsByProfile('1');
        expect(achievements.length, 18);

        // Verify all expected achievements exist
        final achievementIds = achievements.map((a) => a.achievementId).toSet();
        expect(achievementIds, contains('first_win'));
        expect(achievementIds, contains('win_streak_3'));
        expect(achievementIds, contains('win_streak_5'));
        expect(achievementIds, contains('perfect_game'));

        // Verify all are initially locked
        expect(achievements.where((a) => a.isUnlocked).length, 0);
        expect(achievements.where((a) => a.progress == 0).length, 18);
      });

      test('should handle multiple profile initializations', () async {
        // Act
        await dao.initializeAchievementsForProfile('1');
        await dao.initializeAchievementsForProfile('2');

        // Assert
        final profile1Achievements = await dao.getAchievementsByProfile('1');
        final profile2Achievements = await dao.getAchievementsByProfile('2');

        expect(profile1Achievements.length, 18);
        expect(profile2Achievements.length, 18);

        // Ensure they're for different profiles
        expect(profile1Achievements.every((a) => a.profileId == 1), isTrue);
        expect(profile2Achievements.every((a) => a.profileId == 2), isTrue);
      });
    });

    group('Statistics Methods', () {
      setUp(() async {
        await dao.initializeAchievementsForProfile('1');
        // Unlock some achievements
        await dao.unlockAchievement('1', 'first_win');
        await dao.unlockAchievement('1', 'win_streak_3');
      });

      test('getUnlockedCount() should return correct count', () async {
        // Act
        final count = await dao.getUnlockedCount('1');

        // Assert
        expect(count, 2); // 2 unlocked achievements
      });

      test('getTotalCount() should return correct count', () async {
        // Act
        final count = await dao.getTotalCount('1');

        // Assert
        expect(count, 18); // 18 total achievements
      });

      test('isAchievementUnlocked() should return correct status', () async {
        // Act & Assert
        expect(await dao.isAchievementUnlocked('1', 'first_win'), isTrue);
        expect(await dao.isAchievementUnlocked('1', 'win_streak_3'), isTrue);
        expect(await dao.isAchievementUnlocked('1', 'win_streak_5'), isFalse);
        expect(await dao.isAchievementUnlocked('999', 'first_win'), isFalse);
      });

      test('should return 0 counts for profile with no achievements', () async {
        // Act
        final unlockedCount = await dao.getUnlockedCount('999');
        final totalCount = await dao.getTotalCount('999');

        // Assert
        expect(unlockedCount, 0);
        expect(totalCount, 0);
      });
    });

    // ===== REACTIVE STREAMS =====

    group('Reactive Streams', () {
      setUp(() async {
        await dao.initializeAchievementsForProfile('1');
      });

      test('watchAchievements() should emit achievement changes', () async {
        // Act & Assert
        final stream = dao.watchAchievements('1');

        // Wait for initial emission
        final initialAchievements = await stream.first;
        expect(initialAchievements.length, 18);

        // Unlock achievement to trigger stream emission
        await dao.unlockAchievement('1', 'first_win');

        // Wait for updated emission
        final updatedAchievements = await stream.first;
        expect(updatedAchievements.length, 18);
        expect(
          updatedAchievements
              .where((a) => a.achievementId == 'first_win')
              .first
              .isUnlocked,
          isTrue,
        );
      });

      test(
        'watchAchievements() should emit empty list for non-existing profile',
        () async {
          // Act & Assert
          final stream = dao.watchAchievements('999');
          final achievements = await stream.first;
          expect(achievements, isEmpty);
        },
      );
    });

    // ===== EDGE CASES AND ERROR HANDLING =====

    group('Edge Cases and Error Handling', () {
      test('should handle concurrent achievement operations', () async {
        // Arrange
        await dao.initializeAchievementsForProfile('1');

        // Act - Perform multiple operations concurrently
        final operations = await Future.wait([
          dao.unlockAchievement('1', 'first_win'),
          dao.updateProgress('1', 'win_streak_3', 1),
          dao.updateProgress('1', 'win_streak_5', 2),
          dao.getAchievementsByProfile('1'),
        ]);

        // Assert
        expect(operations[0], 1); // unlockAchievement result
        expect(operations[1], 1); // updateProgress result
        expect(operations[2], 1); // updateProgress result
        expect(
          (operations[3] as List).length,
          18,
        ); // getAchievementsByProfile result

        // Verify final state
        final achievements = await dao.getAchievementsByProfile('1');
        expect(
          achievements.where((a) => a.isUnlocked).length,
          1,
        ); // Only first_win unlocked
        expect(
          achievements
              .where((a) => a.achievementId == 'win_streak_3')
              .first
              .progress,
          1,
        );
        expect(
          achievements
              .where((a) => a.achievementId == 'win_streak_5')
              .first
              .progress,
          2,
        );
      });

      test('should handle achievement progress overflow', () async {
        // Arrange
        await dao.initializeAchievementsForProfile('1');

        // Act
        final result = await dao.updateProgress('1', 'first_win', 999999);

        // Assert
        expect(result, 1);

        final achievement = await dao.getAchievement('1', 'first_win');
        expect(achievement!.progress, 999999);
      });

      test('should handle multiple profile operations correctly', () async {
        // Arrange
        await dao.initializeAchievementsForProfile('1');
        await dao.initializeAchievementsForProfile('2');

        // Act
        await dao.unlockAchievement('1', 'first_win');
        await dao.unlockAchievement('2', 'win_streak_3');

        // Assert
        expect(await dao.isAchievementUnlocked('1', 'first_win'), isTrue);
        expect(await dao.isAchievementUnlocked('2', 'win_streak_3'), isTrue);
        expect(await dao.isAchievementUnlocked('1', 'win_streak_3'), isFalse);
        expect(await dao.isAchievementUnlocked('2', 'first_win'), isFalse);
      });

      test(
        'should handle achievement operations with string profile IDs',
        () async {
          // Arrange
          await dao.initializeAchievementsForProfile('123');

          // Act
          final result = await dao.unlockAchievement('123', 'first_win');

          // Assert
          expect(result, 1);

          final achievement = await dao.getAchievement('123', 'first_win');
          expect(achievement!.isUnlocked, isTrue);
        },
      );
    });
  });
}
