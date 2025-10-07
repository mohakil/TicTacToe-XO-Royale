import 'package:drift/drift.dart';
import 'app_database.dart';

part 'achievement_dao.g.dart';

// ===== ACHIEVEMENT DAO =====

@DriftAccessor(tables: [Achievements])
class AchievementDao extends DatabaseAccessor<AppDatabase>
    with _$AchievementDaoMixin {
  AchievementDao(super.db);

  // ===== ACHIEVEMENT OPERATIONS =====

  /// Get all achievements for a profile
  Future<List<Achievement>> getAchievementsByProfile(String profileId) {
    // Handle both 'default_user' and numeric profile IDs
    final intId = profileId == 'default_user'
        ? 1
        : int.tryParse(profileId) ?? 1;

    return (select(achievements)
          ..where((a) => a.profileId.equals(intId))
          ..orderBy([(a) => OrderingTerm.desc(a.unlockedDate)]))
        .get();
  }

  /// Watch achievements for a profile reactively
  Stream<List<Achievement>> watchAchievements(String profileId) {
    // Handle both 'default_user' and numeric profile IDs
    final intId = profileId == 'default_user'
        ? 1
        : int.tryParse(profileId) ?? 1;

    return (select(achievements)
          ..where((a) => a.profileId.equals(intId))
          ..orderBy([(a) => OrderingTerm.desc(a.unlockedDate)]))
        .watch();
  }

  /// Get a specific achievement for a profile
  Future<Achievement?> getAchievement(String profileId, String achievementId) {
    // Handle both 'default_user' and numeric profile IDs
    final intId = profileId == 'default_user'
        ? 1
        : int.tryParse(profileId) ?? 1;

    return (select(achievements)..where(
          (a) =>
              a.profileId.equals(intId) & a.achievementId.equals(achievementId),
        ))
        .getSingleOrNull();
  }

  /// Unlock an achievement for a profile
  Future<int> unlockAchievement(String profileId, String achievementId) {
    // Handle both 'default_user' and numeric profile IDs
    final intId = profileId == 'default_user'
        ? 1
        : int.tryParse(profileId) ?? 1;

    return (update(achievements)..where(
          (a) =>
              a.profileId.equals(intId) & a.achievementId.equals(achievementId),
        ))
        .write(
          AchievementsCompanion(
            isUnlocked: const Value(true),
            unlockedDate: Value(DateTime.now()),
          ),
        );
  }

  /// Update achievement progress for a profile
  Future<int> updateProgress(
    String profileId,
    String achievementId,
    int progress,
  ) {
    // Handle both 'default_user' and numeric profile IDs
    final intId = profileId == 'default_user'
        ? 1
        : int.tryParse(profileId) ?? 1;

    return (update(achievements)..where(
          (a) =>
              a.profileId.equals(intId) & a.achievementId.equals(achievementId),
        ))
        .write(AchievementsCompanion(progress: Value(progress)));
  }

  /// Update achievement progress (alias for updateProgress for backward compatibility)
  Future<int> updateAchievementProgress(
    String profileId,
    String achievementId,
    int progress,
  ) {
    return updateProgress(profileId, achievementId, progress);
  }

  /// Set achievement progress and unlock if complete
  Future<bool> setProgressAndCheckUnlock(
    String profileId,
    String achievementId,
    int progress,
    int maxProgress,
  ) async {
    // Handle both 'default_user' and numeric profile IDs
    final intId = profileId == 'default_user'
        ? 1
        : int.tryParse(profileId) ?? 1;

    final updated =
        await (update(achievements)..where(
              (a) =>
                  a.profileId.equals(intId) &
                  a.achievementId.equals(achievementId),
            ))
            .write(AchievementsCompanion(progress: Value(progress)));

    // Check if achievement should be unlocked
    if (progress >= maxProgress) {
      await unlockAchievement(profileId, achievementId);
    }

    return updated > 0 || progress >= maxProgress;
  }

  /// Insert a new achievement record (used during profile creation)
  Future<int> insertAchievement(AchievementsCompanion achievement) {
    return into(achievements).insert(achievement);
  }

  /// Initialize all achievements for a new profile
  Future<void> initializeAchievementsForProfile(String profileId) async {
    // Handle both 'default_user' and numeric profile IDs
    final intId = profileId == 'default_user'
        ? 1
        : int.tryParse(profileId) ?? 1;

    // Import the achievement data service to get all achievement IDs
    // This would typically come from a predefined list of achievements
    final achievementIds = [
      'first_win',
      'win_streak_3',
      'win_streak_5',
      'win_streak_10',
      'perfect_game',
      'robot_easy',
      'robot_medium',
      'robot_hard',
      'robot_legendary',
      'board_explorer',
      'board_master',
      'win_condition_explorer',
      'win_condition_master',
      'local_player',
      'centurion',
      'legend',
      'comeback_kid',
      'underdog',
    ];

    await batch((batch) {
      for (final achievementId in achievementIds) {
        batch.insert(
          achievements,
          AchievementsCompanion(
            profileId: Value(intId),
            achievementId: Value(achievementId),
            isUnlocked: const Value(false),
            progress: const Value(0),
          ),
        );
      }
    });
  }

  /// Get unlocked achievements count for a profile
  Future<int> getUnlockedCount(String profileId) async {
    // Handle both 'default_user' and numeric profile IDs
    final intId = profileId == 'default_user'
        ? 1
        : int.tryParse(profileId) ?? 1;

    final unlockedAchievements =
        await (select(achievements)..where(
              (a) => a.profileId.equals(intId) & a.isUnlocked.equals(true),
            ))
            .get();
    return unlockedAchievements.length;
  }

  /// Get total achievements count for a profile
  Future<int> getTotalCount(String profileId) async {
    // Handle both 'default_user' and numeric profile IDs
    final intId = profileId == 'default_user'
        ? 1
        : int.tryParse(profileId) ?? 1;

    final totalAchievements = await (select(
      achievements,
    )..where((a) => a.profileId.equals(intId))).get();
    return totalAchievements.length;
  }

  /// Check if achievement is unlocked
  Future<bool> isAchievementUnlocked(
    String profileId,
    String achievementId,
  ) async {
    // Handle both 'default_user' and numeric profile IDs
    final intId = profileId == 'default_user'
        ? 1
        : int.tryParse(profileId) ?? 1;

    final achievement =
        await (select(achievements)..where(
              (a) =>
                  a.profileId.equals(intId) &
                  a.achievementId.equals(achievementId),
            ))
            .getSingleOrNull();
    return achievement?.isUnlocked ?? false;
  }
}
