import 'package:drift/drift.dart';
import 'app_database.dart';

part 'profile_dao.g.dart';

// ===== PROFILE DAO =====

@DriftAccessor(tables: [PlayerProfiles, PlayerStats])
class ProfileDao extends DatabaseAccessor<AppDatabase> with _$ProfileDaoMixin {
  ProfileDao(super.db);

  // ===== PROFILE OPERATIONS =====

  /// Get a single profile by ID
  Future<PlayerProfile?> getProfile(String id) {
    // For now, we'll use a simple approach - assume 'default_user' corresponds to ID 1
    final intId = id == 'default_user' ? 1 : int.parse(id);

    return (select(
      playerProfiles,
    )..where((p) => p.id.equals(intId))).getSingleOrNull();
  }

  /// Watch a profile reactively
  Stream<PlayerProfile?> watchProfile(String id) {
    // For now, we'll use a simple approach - assume 'default_user' corresponds to ID 1
    final intId = id == 'default_user' ? 1 : int.parse(id);

    return (select(
      playerProfiles,
    )..where((p) => p.id.equals(intId))).watchSingleOrNull();
  }

  /// Insert a new profile
  Future<int> insertProfile(PlayerProfilesCompanion profile) {
    return into(playerProfiles).insert(profile);
  }

  /// Update an existing profile
  Future<bool> updateProfile(PlayerProfile profile) {
    return update(playerProfiles).replace(profile);
  }

  /// Delete a profile
  Future<int> deleteProfile(String id) {
    // For now, we'll use a simple approach - assume 'default_user' corresponds to ID 1
    final intId = id == 'default_user' ? 1 : int.parse(id);

    return (delete(playerProfiles)..where((p) => p.id.equals(intId))).go();
  }

  // ===== STATS OPERATIONS =====

  /// Get stats for a profile
  Future<PlayerStat?> getStats(String profileId) {
    // For now, we'll use a simple approach - assume 'default_user' corresponds to ID 1
    final intId = profileId == 'default_user' ? 1 : int.parse(profileId);

    return (select(
      playerStats,
    )..where((s) => s.profileId.equals(intId))).getSingleOrNull();
  }

  /// Update stats for a profile
  Future<int> updateStats(String profileId, PlayerStatsCompanion stats) {
    // For now, we'll use a simple approach - assume 'default_user' corresponds to ID 1
    final intId = profileId == 'default_user' ? 1 : int.parse(profileId);

    return (update(
      playerStats,
    )..where((s) => s.profileId.equals(intId))).write(stats);
  }

  /// Insert stats for a profile (used when creating new profile)
  Future<int> insertStats(PlayerStatsCompanion stats) {
    return into(playerStats).insert(stats);
  }

  // ===== COMBINED OPERATIONS =====

  /// Get profile with stats in a single query
  Future<PlayerProfileWithStats?> getProfileWithStats(String profileId) async {
    // For now, we'll use a simple approach - assume 'default_user' corresponds to ID 1
    final profileIdInt = profileId == 'default_user' ? 1 : int.parse(profileId);

    final result = await (select(playerProfiles).join([
      leftOuterJoin(
        playerStats,
        playerStats.profileId.equalsExp(playerProfiles.id),
      ),
    ])..where(playerProfiles.id.equals(profileIdInt))).getSingleOrNull();

    if (result == null) return null;

    return PlayerProfileWithStats(
      profile: result.readTable(playerProfiles),
      stats: result.readTableOrNull(playerStats),
    );
  }

  /// Create a new profile with default stats
  Future<int> createProfileWithStats(PlayerProfilesCompanion profile) async {
    final profileId = await transaction(() async {
      // Insert profile
      final id = await into(playerProfiles).insert(profile);

      // Insert default stats
      await into(playerStats).insert(
        PlayerStatsCompanion(
          profileId: Value(id),
          wins: const Value(0),
          losses: const Value(0),
          draws: const Value(0),
          streak: const Value(0),
          totalGames: const Value(0),
        ),
      );

      return id;
    });

    return profileId;
  }

  /// Update profile and stats atomically
  Future<void> updateProfileAndStats(
    PlayerProfile profile,
    PlayerStatsCompanion stats,
  ) async {
    await transaction(() async {
      // Update profile
      await update(playerProfiles).replace(profile);

      // Update stats
      await (update(
        playerStats,
      )..where((s) => s.profileId.equals(profile.id))).write(stats);
    });
  }
}

// ===== DATA CLASSES FOR JOINED QUERIES =====

class PlayerProfileWithStats {
  final PlayerProfile profile;
  final PlayerStat? stats;

  PlayerProfileWithStats({required this.profile, this.stats});
}
