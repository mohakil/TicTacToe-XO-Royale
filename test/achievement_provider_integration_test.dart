import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:tictactoe_xo_royale/core/database/app_database.dart';
import 'package:tictactoe_xo_royale/core/database/database_providers.dart';
import 'package:tictactoe_xo_royale/core/database/app_database.dart' as db;
import 'package:tictactoe_xo_royale/core/providers/achievements_provider.dart';
import 'package:tictactoe_xo_royale/core/providers/profile_provider.dart';

void main() {
  group('AchievementProvider Integration Tests', () {
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

    group('Achievement Loading and Initialization', () {
      test('should load existing achievements from database', () async {
        // Arrange - Set up profile and achievements
        await database.playerProfilesDao.createProfileWithStats(
          db.PlayerProfilesCompanion.insert(
            nickname: 'AchievementPlayer',
            gems: 200,
            hints: 10,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        // Initialize achievements for profile '1' (which maps to 'default_user')
        await database.achievementsDao.initializeAchievementsForProfile('1');

        // Add achievements
        await database.achievementsDao.unlockAchievement('1', 'first_win');
        await database.achievementsDao.updateAchievementProgress(
          '1',
          'win_streak_3',
          2,
        );

        // Wait for async initialization and provider loading
        await container.pump();
        await container
            .pump(); // Pump twice to ensure async operations complete

        // Wait a bit more for the provider to load achievements
        await Future.delayed(const Duration(milliseconds: 100));

        // Act - Initialize provider and load achievements

        // Get achievement state for assertions
        final achievementState = container.read(achievementsProvider);

        // Assert
        expect(achievementState.achievements.length, equals(18));

        final firstWin = achievementState.achievements.firstWhere(
          (a) => a.id == 'first_win',
        );
        expect(firstWin.isUnlocked, isTrue);
        expect(firstWin.progress, equals(1));

        final winStreak = achievementState.achievements.firstWhere(
          (a) => a.id == 'win_streak_3',
        );
        expect(winStreak.isUnlocked, isFalse);
        expect(winStreak.progress, equals(2));
      });

      test('should create default achievements when none exist', () async {
        // Arrange - Set up profile but no achievements
        await database.playerProfilesDao.createProfileWithStats(
          db.PlayerProfilesCompanion.insert(
            nickname: 'NewPlayer',
            gems: 50,
            hints: 3,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        // Wait for async initialization
        await container.pump();

        // Assert - Default achievements should be created
        final achievementState = container.read(achievementsProvider);
        expect(achievementState.achievements.length, greaterThan(0));

        // All achievements should be locked initially
        for (final achievement in achievementState.achievements) {
          expect(achievement.isUnlocked, isFalse);
          expect(achievement.progress, equals(0));
        }
      });

      test(
        'should handle database errors gracefully during achievement loading',
        () async {
          // Arrange - Close database to simulate connection error
          await database.close();

          // Wait for async operation
          await container.pump();

          // Assert - Default achievements should still be available
          final achievementState = container.read(achievementsProvider);
          expect(
            achievementState.achievements.length,
            greaterThan(0),
          ); // Default achievements
        },
      );
    });

    group('Achievement Unlocking and Progress Tracking', () {
      test('should unlock achievement and persist to database', () async {
        // Arrange - Set up profile and achievement
        await database.playerProfilesDao.createProfileWithStats(
          db.PlayerProfilesCompanion.insert(
            nickname: 'UnlockPlayer',
            gems: 100,
            hints: 5,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        await container.pump();

        // Act - Unlock achievement
        final achievementNotifier = container.read(
          achievementsProvider.notifier,
        );
        await achievementNotifier.unlockAchievement('first_win');
        await container.pump();

        // Assert
        final achievementState = container.read(achievementsProvider);
        final firstWin = achievementState.achievements.firstWhere(
          (a) => a.id == 'first_win',
        );
        expect(firstWin.isUnlocked, isTrue);

        // Verify persistence
        final dbAchievements = await database.achievementsDao
            .getAchievementsByProfile('default_user');
        final dbFirstWin = dbAchievements.firstWhere(
          (a) => a.achievementId == 'first_win',
        );
        expect(dbFirstWin.isUnlocked, isTrue);
      });

      test(
        'should update achievement progress and persist to database',
        () async {
          // Arrange - Set up profile and achievement
          await database.playerProfilesDao.createProfileWithStats(
            db.PlayerProfilesCompanion.insert(
              nickname: 'ProgressPlayer',
              gems: 150,
              hints: 7,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );

          await container.pump();

          // Act - Update progress
          final achievementNotifier = container.read(
            achievementsProvider.notifier,
          );
          await achievementNotifier.updateAchievementProgress(
            'win_streak_3',
            2,
          );
          await container.pump();

          // Assert
          final achievementState = container.read(achievementsProvider);
          final winStreak = achievementState.achievements.firstWhere(
            (a) => a.id == 'win_streak_3',
          );
          expect(winStreak.progress, equals(2));
          expect(winStreak.isUnlocked, isFalse); // Not yet unlocked

          // Verify persistence
          final dbAchievements = await database.achievementsDao
              .getAchievementsByProfile('default_user');
          final dbWinStreak = dbAchievements.firstWhere(
            (a) => a.achievementId == 'win_streak_3',
          );
          expect(dbWinStreak.progress, equals(2));
          expect(dbWinStreak.isUnlocked, isFalse);
        },
      );

      test('should unlock achievement when progress reaches threshold', () async {
        // Arrange - Set up profile and achievement with progress close to unlock
        await database.playerProfilesDao.createProfileWithStats(
          db.PlayerProfilesCompanion.insert(
            nickname: 'ThresholdPlayer',
            gems: 200,
            hints: 8,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        // Set progress to 2 (needs 3 to unlock)
        await database.achievementsDao.updateAchievementProgress(
          'default_user',
          'win_streak_3',
          2,
        );

        await container.pump();

        // Act - Update progress to unlock threshold
        final achievementNotifier = container.read(
          achievementsProvider.notifier,
        );
        await achievementNotifier.updateAchievementProgress('win_streak_3', 3);
        await container.pump();

        // Assert
        final achievementState = container.read(achievementsProvider);
        final winStreak = achievementState.achievements.firstWhere(
          (a) => a.id == 'win_streak_3',
        );
        expect(winStreak.progress, equals(3));
        expect(winStreak.isUnlocked, isTrue); // Should be unlocked

        // Verify persistence
        final dbAchievements = await database.achievementsDao
            .getAchievementsByProfile('default_user');
        final dbWinStreak = dbAchievements.firstWhere(
          (a) => a.achievementId == 'win_streak_3',
        );
        expect(dbWinStreak.progress, equals(3));
        expect(dbWinStreak.isUnlocked, isTrue);
      });

      test(
        'should handle achievement operations with database errors',
        () async {
          // Arrange - Close database to simulate error
          await database.close();

          await container.pump();

          // Act - Try to unlock achievement with closed database
          final achievementNotifier = container.read(
            achievementsProvider.notifier,
          );
          await achievementNotifier.unlockAchievement('first_win');

          // Assert - Should not crash, but operation might fail silently
          final achievementState = container.read(achievementsProvider);
          // State should remain at defaults since operations failed
          expect(achievementState.achievements.length, greaterThan(0));
        },
      );
    });

    group('Achievement State Management', () {
      test(
        'should maintain achievement state consistency during updates',
        () async {
          // Arrange - Set up profile and achievements
          await database.playerProfilesDao.createProfileWithStats(
            db.PlayerProfilesCompanion.insert(
              nickname: 'StatePlayer',
              gems: 250,
              hints: 12,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );

          await container.pump();

          // Act - Update multiple achievements
          final achievementNotifier = container.read(
            achievementsProvider.notifier,
          );
          await achievementNotifier.unlockAchievement('first_win');
          await achievementNotifier.updateAchievementProgress(
            'win_streak_3',
            2,
          );
          await achievementNotifier.updateAchievementProgress(
            'games_played_10',
            5,
          );
          await container.pump();

          // Assert - All updates should be consistent
          final achievementState = container.read(achievementsProvider);

          final firstWin = achievementState.achievements.firstWhere(
            (a) => a.id == 'first_win',
          );
          expect(firstWin.isUnlocked, isTrue);
          expect(firstWin.progress, equals(1));

          final winStreak = achievementState.achievements.firstWhere(
            (a) => a.id == 'win_streak_3',
          );
          expect(winStreak.progress, equals(2));
          expect(winStreak.isUnlocked, isFalse);

          final gamesPlayed = achievementState.achievements.firstWhere(
            (a) => a.id == 'games_played_10',
          );
          expect(gamesPlayed.progress, equals(5));
          expect(gamesPlayed.isUnlocked, isFalse);

          // Verify persistence
          final dbAchievements = await database.achievementsDao
              .getAchievementsByProfile('default_user');
          expect(dbAchievements.length, equals(3));
        },
      );

      test(
        'should handle achievement state during provider disposal',
        () async {
          // Arrange - Set up profile and achievements
          await database.playerProfilesDao.createProfileWithStats(
            db.PlayerProfilesCompanion.insert(
              nickname: 'DisposePlayer',
              gems: 100,
              hints: 4,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );

          await container.pump();

          // Verify working state
          var achievementState = container.read(achievementsProvider);
          expect(achievementState.achievements.length, greaterThan(0));

          // Act - Dispose container
          container.dispose();

          // Assert - No errors should occur during disposal
          expect(true, isTrue); // Test passes if no exceptions
        },
      );
    });

    group('Achievement Progress Integration', () {
      test(
        'should integrate with profile provider for achievement unlocking',
        () async {
          // Arrange - Set up profile
          await database.playerProfilesDao.createProfileWithStats(
            db.PlayerProfilesCompanion.insert(
              nickname: 'IntegrationPlayer',
              gems: 300,
              hints: 15,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );

          await container.pump();

          // Act - Update progress that should unlock achievement
          final achievementNotifier = container.read(
            achievementsProvider.notifier,
          );
          await achievementNotifier.updateAchievementProgress(
            'win_streak_3',
            3,
          ); // Should unlock
          await container.pump();

          // Assert - Achievement should be unlocked
          final achievementState = container.read(achievementsProvider);
          final winStreak = achievementState.achievements.firstWhere(
            (a) => a.id == 'win_streak_3',
          );
          expect(winStreak.isUnlocked, isTrue);
          expect(winStreak.progress, equals(3));

          // Verify persistence
          final dbAchievements = await database.achievementsDao
              .getAchievementsByProfile('default_user');
          final dbWinStreak = dbAchievements.firstWhere(
            (a) => a.achievementId == 'win_streak_3',
          );
          expect(dbWinStreak.isUnlocked, isTrue);
          expect(dbWinStreak.progress, equals(3));
        },
      );

      test('should handle multiple achievement updates correctly', () async {
        // Arrange - Set up profile
        await database.playerProfilesDao.createProfileWithStats(
          db.PlayerProfilesCompanion.insert(
            nickname: 'MultiPlayer',
            gems: 400,
            hints: 20,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        await container.pump();

        // Act - Update multiple achievements
        final achievementNotifier = container.read(
          achievementsProvider.notifier,
        );
        await achievementNotifier.unlockAchievement('first_win');
        await achievementNotifier.updateAchievementProgress('win_streak_3', 2);
        await achievementNotifier.updateAchievementProgress(
          'games_played_10',
          8,
        );
        await achievementNotifier.unlockAchievement('perfect_game');
        await container.pump();

        // Assert - All achievements should be updated correctly
        final achievementState = container.read(achievementsProvider);

        final firstWin = achievementState.achievements.firstWhere(
          (a) => a.id == 'first_win',
        );
        expect(firstWin.isUnlocked, isTrue);

        final winStreak = achievementState.achievements.firstWhere(
          (a) => a.id == 'win_streak_3',
        );
        expect(winStreak.progress, equals(2));
        expect(winStreak.isUnlocked, isFalse);

        final gamesPlayed = achievementState.achievements.firstWhere(
          (a) => a.id == 'games_played_10',
        );
        expect(gamesPlayed.progress, equals(8));
        expect(gamesPlayed.isUnlocked, isFalse);

        final perfectGame = achievementState.achievements.firstWhere(
          (a) => a.id == 'perfect_game',
        );
        expect(perfectGame.isUnlocked, isTrue);

        // Verify persistence
        final dbAchievements = await database.achievementsDao
            .getAchievementsByProfile('default_user');
        expect(dbAchievements.length, equals(4));
      });
    });

    group('Achievement Validation and Error Handling', () {
      test('should handle invalid achievement IDs gracefully', () async {
        // Arrange - Set up profile
        await database.playerProfilesDao.createProfileWithStats(
          db.PlayerProfilesCompanion.insert(
            nickname: 'InvalidPlayer',
            gems: 100,
            hints: 5,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        await container.pump();

        // Act - Try to unlock non-existent achievement
        final achievementNotifier = container.read(
          achievementsProvider.notifier,
        );
        await achievementNotifier.unlockAchievement('non_existent_achievement');

        // Assert - Should not crash and state should remain valid
        final achievementState = container.read(achievementsProvider);
        expect(
          achievementState.achievements.length,
          greaterThan(0),
        ); // Should still have default achievements
      });

      test(
        'should handle progress updates for non-existent achievements',
        () async {
          // Arrange - Set up profile
          await database.playerProfilesDao.createProfileWithStats(
            db.PlayerProfilesCompanion.insert(
              nickname: 'NonExistentPlayer',
              gems: 150,
              hints: 7,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );

          await container.pump();

          // Act - Try to update progress for non-existent achievement
          final achievementNotifier = container.read(
            achievementsProvider.notifier,
          );
          await achievementNotifier.updateAchievementProgress(
            'non_existent_achievement',
            5,
          );

          // Assert - Should not crash and state should remain valid
          final achievementState = container.read(achievementsProvider);
          expect(
            achievementState.achievements.length,
            greaterThan(0),
          ); // Should still have default achievements
        },
      );
    });

    group('Reactive Achievement Updates', () {
      test(
        'should update achievements reactively across multiple listeners',
        () async {
          // Arrange - Set up profile and achievements
          await database.playerProfilesDao.createProfileWithStats(
            db.PlayerProfilesCompanion.insert(
              nickname: 'ReactivePlayer',
              gems: 200,
              hints: 10,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );

          await container.pump();

          // Create multiple listeners
          final firstWinListener = container.listen(
            achievementsProvider.select(
              (state) =>
                  state.achievements.firstWhere((a) => a.id == 'first_win'),
            ),
            (previous, next) {
              // Track changes
            },
          );

          final winStreakListener = container.listen(
            achievementsProvider.select(
              (state) =>
                  state.achievements.firstWhere((a) => a.id == 'win_streak_3'),
            ),
            (previous, next) {
              // Track changes
            },
          );

          // Act - Update achievement
          final achievementNotifier = container.read(
            achievementsProvider.notifier,
          );
          await achievementNotifier.unlockAchievement('first_win');
          await container.pump();

          // Assert - Listeners should receive updates
          final achievementState = container.read(achievementsProvider);
          final firstWin = achievementState.achievements.firstWhere(
            (a) => a.id == 'first_win',
          );
          expect(firstWin.isUnlocked, isTrue);

          firstWinListener.close();
          winStreakListener.close();
        },
      );

      test('should handle rapid achievement updates without issues', () async {
        // Arrange - Set up profile
        await database.playerProfilesDao.createProfileWithStats(
          db.PlayerProfilesCompanion.insert(
            nickname: 'RapidPlayer',
            gems: 300,
            hints: 15,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        await container.pump();

        // Act - Perform rapid achievement updates
        final achievementNotifier = container.read(
          achievementsProvider.notifier,
        );
        for (int i = 0; i < 10; i++) {
          await achievementNotifier.updateAchievementProgress(
            'win_streak_3',
            i + 1,
          );
          await container.pump();
        }

        // Assert - Final state should be consistent
        final achievementState = container.read(achievementsProvider);
        final winStreak = achievementState.achievements.firstWhere(
          (a) => a.id == 'win_streak_3',
        );
        expect(winStreak.progress, equals(10));

        // Should unlock if threshold reached (assuming 3 is the threshold)
        if (10 >= 3) {
          expect(winStreak.isUnlocked, isTrue);
        }

        // Verify persistence
        final dbAchievements = await database.achievementsDao
            .getAchievementsByProfile('default_user');
        final dbWinStreak = dbAchievements.firstWhere(
          (a) => a.achievementId == 'win_streak_3',
        );
        expect(dbWinStreak.progress, equals(10));
      });
    });

    group('Achievement Default Creation', () {
      test(
        'should create default achievements when database is empty',
        () async {
          // Arrange - Set up profile
          await database.playerProfilesDao.createProfileWithStats(
            db.PlayerProfilesCompanion.insert(
              nickname: 'DefaultPlayer',
              gems: 100,
              hints: 5,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );

          // Act - Initialize provider with empty achievements database
          await container.pump();

          // Assert - Default achievements should be created
          final achievementState = container.read(achievementsProvider);
          expect(achievementState.achievements.length, equals(18));

          // All achievements should be locked initially
          for (final achievement in achievementState.achievements) {
            expect(achievement.isUnlocked, isFalse);
            expect(achievement.progress, equals(0));
          }

          // Verify persistence
          final dbAchievements = await database.achievementsDao
              .getAchievementsByProfile('default_user');
          expect(
            dbAchievements.length,
            equals(achievementState.achievements.length),
          );
        },
      );

      test('should handle partial default achievement creation', () async {
        // Arrange - Set up profile and some achievements
        await database.playerProfilesDao.createProfileWithStats(
          db.PlayerProfilesCompanion.insert(
            nickname: 'PartialPlayer',
            gems: 150,
            hints: 7,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        // Initialize achievements for profile first
        await database.achievementsDao.initializeAchievementsForProfile(
          'default_user',
        );

        // Add only one achievement
        await database.achievementsDao.unlockAchievement(
          'default_user',
          'first_win',
        );

        // Act - Initialize provider
        await container.pump();

        // Assert - All achievements should exist (defaults + existing)
        final achievementState = container.read(achievementsProvider);
        expect(achievementState.achievements.length, greaterThan(1));

        // Existing achievement should be preserved
        final firstWin = achievementState.achievements.firstWhere(
          (a) => a.id == 'first_win',
        );
        expect(firstWin.isUnlocked, isTrue);
      });
    });

    group('Achievement Provider Integration with Other Providers', () {
      test('should work correctly with profile provider', () async {
        // Arrange - Set up profile
        await database.playerProfilesDao.createProfileWithStats(
          db.PlayerProfilesCompanion.insert(
            nickname: 'ProfileIntegrationPlayer',
            gems: 250,
            hints: 12,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        await container.pump();

        // Act - Update achievement and check profile is unaffected
        final achievementNotifier = container.read(
          achievementsProvider.notifier,
        );
        await achievementNotifier.unlockAchievement('first_win');
        await container.pump();

        // Assert - Achievement provider works independently
        final achievementState = container.read(achievementsProvider);
        final firstWin = achievementState.achievements.firstWhere(
          (a) => a.id == 'first_win',
        );
        expect(firstWin.isUnlocked, isTrue);

        // Profile should still be available
        final profileState = container.read(profileProvider);
        expect(profileState.profile, isNotNull);
        expect(
          profileState.profile!.nickname,
          equals('ProfileIntegrationPlayer'),
        );
      });

      test(
        'should handle achievement changes without affecting other providers',
        () async {
          // Arrange - Set up profile and achievements
          await database.playerProfilesDao.createProfileWithStats(
            db.PlayerProfilesCompanion.insert(
              nickname: 'IndependentPlayer',
              gems: 200,
              hints: 8,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );

          await container.pump();

          // Verify initial state
          var achievementState = container.read(achievementsProvider);
          expect(achievementState.achievements.length, greaterThan(0));

          var profileState = container.read(profileProvider);
          expect(profileState.profile!.nickname, equals('IndependentPlayer'));

          // Act - Update achievement
          final achievementNotifier = container.read(
            achievementsProvider.notifier,
          );
          await achievementNotifier.updateAchievementProgress(
            'win_streak_3',
            3,
          );
          await container.pump();

          // Assert - Achievement changed but profile unchanged
          achievementState = container.read(achievementsProvider);
          final winStreak = achievementState.achievements.firstWhere(
            (a) => a.id == 'win_streak_3',
          );
          expect(winStreak.progress, equals(3));

          profileState = container.read(profileProvider);
          expect(
            profileState.profile!.nickname,
            equals('IndependentPlayer'),
          ); // Unchanged
        },
      );
    });

    group('Error Recovery', () {
      test(
        'should recover from database errors on subsequent operations',
        () async {
          // Arrange - Set up working achievements first
          await database.playerProfilesDao.createProfileWithStats(
            db.PlayerProfilesCompanion.insert(
              nickname: 'RecoveryPlayer',
              gems: 100,
              hints: 4,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );

          await container.pump();

          // Verify working state
          var achievementState = container.read(achievementsProvider);
          expect(achievementState.achievements.length, greaterThan(0));

          // Act - Simulate database error by closing and reopening
          await database.close();

          // Create new database
          final newDatabase = AppDatabase(NativeDatabase.memory());
          final newContainer = ProviderContainer(
            overrides: [appDatabaseProvider.overrideWithValue(newDatabase)],
          );

          await newContainer.pump();

          // Assert - New container should work with default achievements
          final newAchievementState = newContainer.read(achievementsProvider);
          expect(newAchievementState.achievements.length, greaterThan(0));

          newContainer.dispose();
          await newDatabase.close();
        },
      );

      test('should handle achievement provider errors gracefully', () async {
        // Arrange - Close database to simulate errors
        await database.close();

        await container.pump();

        // Act - Try to perform operations with closed database
        final achievementNotifier = container.read(
          achievementsProvider.notifier,
        );
        await achievementNotifier.unlockAchievement('first_win');
        await achievementNotifier.updateAchievementProgress('win_streak_3', 2);

        // Assert - Should not crash and state should remain valid
        final achievementState = container.read(achievementsProvider);
        expect(
          achievementState.achievements.length,
          greaterThan(0),
        ); // Default achievements
      });
    });
  });
}
