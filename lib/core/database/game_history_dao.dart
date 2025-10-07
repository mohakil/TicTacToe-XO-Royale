import 'package:drift/drift.dart';
import 'app_database.dart';

part 'game_history_dao.g.dart';

// ===== GAME HISTORY DAO =====

@DriftAccessor(tables: [GameHistory])
class GameHistoryDao extends DatabaseAccessor<AppDatabase>
    with _$GameHistoryDaoMixin {
  GameHistoryDao(super.db);

  // ===== GAME HISTORY OPERATIONS =====

  /// Insert a new game record
  Future<int> insertGame(GameHistoryCompanion game) {
    return into(gameHistory).insert(game);
  }

  /// Insert multiple games efficiently
  Future<void> insertGames(List<GameHistoryCompanion> games) async {
    await batch((batch) {
      batch.insertAll(gameHistory, games);
    });
  }

  /// Get games for a specific profile
  Future<List<GameHistoryData>> getGamesByProfile(
    String profileId, {
    int? limit,
  }) {
    // For now, we'll use a simple approach - assume 'default_user' corresponds to ID 1
    // In a real implementation, you'd want to look up the profile's integer ID
    final intId = profileId == 'default_user'
        ? 1
        : int.tryParse(profileId) ?? 1;

    final query = select(gameHistory)
      ..where((g) => g.profileId.equals(intId))
      ..orderBy([(g) => OrderingTerm.desc(g.playedAt)]);

    if (limit != null) {
      query.limit(limit);
    }

    return query.get();
  }

  /// Watch recent games for a profile reactively
  Stream<List<GameHistoryData>> watchRecentGames(
    String profileId, {
    int limit = 10,
  }) {
    // For now, we'll use a simple approach - assume 'default_user' corresponds to ID 1
    // In a real implementation, you'd want to look up the profile's integer ID
    final intId = profileId == 'default_user'
        ? 1
        : int.tryParse(profileId) ?? 1;

    return (select(gameHistory)
          ..where((g) => g.profileId.equals(intId))
          ..orderBy([(g) => OrderingTerm.desc(g.playedAt)])
          ..limit(limit))
        .watch();
  }

  /// Get the most recent game for a profile
  Future<GameHistoryData?> getLastGame(String profileId) {
    final intId = profileId == 'default_user'
        ? 1
        : int.tryParse(profileId) ?? 1;

    return (select(gameHistory)
          ..where((g) => g.profileId.equals(intId))
          ..orderBy([(g) => OrderingTerm.desc(g.playedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Get games by opponent type
  Future<List<GameHistoryData>> getGamesByOpponent(
    String profileId,
    String opponent,
  ) {
    final intId = profileId == 'default_user'
        ? 1
        : int.tryParse(profileId) ?? 1;

    return (select(gameHistory)
          ..where(
            (g) => g.profileId.equals(intId) & g.opponent.equals(opponent),
          )
          ..orderBy([(g) => OrderingTerm.desc(g.playedAt)]))
        .get();
  }

  /// Get games by result
  Future<List<GameHistoryData>> getGamesByResult(
    String profileId,
    String result,
  ) {
    final intId = profileId == 'default_user'
        ? 1
        : int.tryParse(profileId) ?? 1;

    return (select(gameHistory)
          ..where((g) => g.profileId.equals(intId) & g.result.equals(result))
          ..orderBy([(g) => OrderingTerm.desc(g.playedAt)]))
        .get();
  }

  /// Get games within a date range
  Future<List<GameHistoryData>> getGamesInDateRange(
    String profileId,
    DateTime start,
    DateTime end,
  ) {
    final intId = profileId == 'default_user'
        ? 1
        : int.tryParse(profileId) ?? 1;

    return (select(gameHistory)
          ..where(
            (g) =>
                g.profileId.equals(intId) &
                g.playedAt.isBetweenValues(start, end),
          )
          ..orderBy([(g) => OrderingTerm.desc(g.playedAt)]))
        .get();
  }

  /// Delete old games (older than specified days)
  Future<int> deleteOldGames({int olderThanDays = 30}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: olderThanDays));
    return (delete(
      gameHistory,
    )..where((g) => g.playedAt.isSmallerThanValue(cutoffDate))).go();
  }

  /// Delete all games for a profile
  Future<int> deleteGamesForProfile(String profileId) {
    final intId = profileId == 'default_user'
        ? 1
        : int.tryParse(profileId) ?? 1;

    return (delete(gameHistory)..where((g) => g.profileId.equals(intId))).go();
  }

  /// Get total game count for a profile
  Future<int> getGameCount(String profileId) async {
    final games = await getGamesByProfile(profileId);
    return games.length;
  }

  /// Get win rate for a profile
  Future<double> getWinRate(String profileId) async {
    final games = await getGamesByProfile(profileId);
    if (games.isEmpty) return 0.0;

    final wins = games.where((g) => g.result == 'win').length;
    return wins / games.length;
  }

  /// Get average game duration for a profile
  Future<Duration> getAverageGameDuration(String profileId) async {
    final games = await getGamesByProfile(profileId);
    if (games.isEmpty) return Duration.zero;

    final totalSeconds = games
        .map((g) => g.durationSeconds)
        .reduce((a, b) => a + b);
    final averageSeconds = totalSeconds ~/ games.length;
    return Duration(seconds: averageSeconds);
  }
}
