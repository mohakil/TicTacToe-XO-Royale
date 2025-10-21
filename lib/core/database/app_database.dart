import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'profile_dao.dart';
import 'game_history_dao.dart';
import 'achievement_dao.dart';
import 'settings_dao.dart';
import 'theme_dao.dart';
import 'store_dao.dart';

part 'app_database.g.dart';

// ===== ENUM DEFINITIONS =====

enum GameResult { win, loss, draw }

enum OpponentType { player, robotEasy, robotMedium, robotHard, robotLegendary }

enum AppThemeMode { light, dark, system }

enum AchievementCategory { gameplay, milestone, special }

// ===== TABLE DEFINITIONS =====

// Player Profiles Table
@TableIndex(name: 'player_profiles_nickname_idx', columns: {#nickname})
@TableIndex(name: 'player_profiles_created_at_idx', columns: {#createdAt})
class PlayerProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nickname => text().withLength(min: 1, max: 50)();
  TextColumn get avatarUrlOrProvider => text().nullable()();
  IntColumn get gems => integer().withDefault(const Constant(0))();
  IntColumn get hints => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();

  @override
  String get tableName => 'player_profiles';
}

// Player Stats Table
@TableIndex(name: 'player_stats_profile_id_idx', columns: {#profileId})
@TableIndex(name: 'player_stats_total_games_idx', columns: {#totalGames})
class PlayerStats extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId =>
      integer().references(PlayerProfiles, #id, onDelete: KeyAction.cascade)();
  IntColumn get wins => integer().withDefault(const Constant(0))();
  IntColumn get losses => integer().withDefault(const Constant(0))();
  IntColumn get draws => integer().withDefault(const Constant(0))();
  IntColumn get streak => integer().withDefault(const Constant(0))();
  IntColumn get totalGames => integer().withDefault(const Constant(0))();

  @override
  String get tableName => 'player_stats';
}

// Game History Table
@TableIndex(name: 'game_history_profile_id_idx', columns: {#profileId})
@TableIndex(name: 'game_history_played_at_idx', columns: {#playedAt})
@TableIndex(name: 'game_history_result_idx', columns: {#result})
@TableIndex(name: 'game_history_opponent_idx', columns: {#opponent})
class GameHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId =>
      integer().references(PlayerProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get opponent =>
      text().withLength(min: 1, max: 50)(); // Player or robot type
  IntColumn get result => intEnum<GameResult>()(); // Game result using enum
  TextColumn get boardSize =>
      text().withLength(min: 3, max: 5)(); // '3x3', '4x4', etc.
  IntColumn get durationSeconds => integer()(); // Duration in seconds
  TextColumn get score =>
      text().withLength(min: 1, max: 20)(); // Final score representation
  DateTimeColumn get playedAt =>
      dateTime().clientDefault(() => DateTime.now())();

  @override
  String get tableName => 'game_history';
}

// Achievements Table
@TableIndex(name: 'achievements_profile_id_idx', columns: {#profileId})
@TableIndex(name: 'achievements_achievement_id_idx', columns: {#achievementId})
@TableIndex(name: 'achievements_is_unlocked_idx', columns: {#isUnlocked})
@TableIndex(name: 'achievements_unlocked_date_idx', columns: {#unlockedDate})
class Achievements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId =>
      integer().references(PlayerProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get achievementId => text().withLength(
    min: 1,
    max: 50,
  )(); // References hardcoded achievement data
  BoolColumn get isUnlocked => boolean().withDefault(const Constant(false))();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  DateTimeColumn get unlockedDate => dateTime().nullable()();

  @override
  String get tableName => 'achievements';
}

// App Settings Table
class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get soundEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get musicEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get vibrationEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get hapticFeedbackEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get autoSaveEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();

  @override
  String get tableName => 'app_settings';
}

// Theme Settings Table
class ThemeSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get themeMode =>
      integer().withDefault(const Constant(2))(); // AppThemeMode.system.index

  @override
  String get tableName => 'theme_settings';
}

// Store Items Table
@TableIndex(name: 'store_items_profile_id_idx', columns: {#profileId})
@TableIndex(name: 'store_items_item_id_idx', columns: {#itemId})
@TableIndex(name: 'store_items_purchased_date_idx', columns: {#purchasedDate})
class StoreItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId =>
      integer().references(PlayerProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get itemId => text().withLength(
    min: 1,
    max: 50,
  )(); // References hardcoded store item data
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  DateTimeColumn get purchasedDate =>
      dateTime().clientDefault(() => DateTime.now())();

  @override
  String get tableName => 'store_items';
}

// Main App Database
@DriftDatabase(
  tables: [
    PlayerProfiles,
    PlayerStats,
    GameHistory,
    Achievements,
    AppSettings,
    ThemeSettings,
    StoreItems,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'tictactoe_db'));

  // ===== DAO ACCESSORS =====
  // These provide direct access to DAO instances for testing and external use

  late final ProfileDao playerProfilesDao = ProfileDao(this);
  late final ProfileDao playerStatsDao = ProfileDao(
    this,
  ); // Same DAO for both tables
  late final GameHistoryDao gameHistoryDao = GameHistoryDao(this);
  late final AchievementDao achievementsDao = AchievementDao(this);
  late final SettingsDao appSettingsDao = SettingsDao(this);
  late final ThemeDao themeSettingsDao = ThemeDao(this);
  late final StoreDao storeItemsDao = StoreDao(this);

  // ===== DATABASE METHODS =====
  // All CRUD operations are generated automatically by Drift
  // Access them via the generated managers or custom queries as needed

  // ===== MIGRATION STRATEGY =====
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Insert default settings
        await insertDefaultSettings();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle future migrations here
        if (from < 2) {
          // Example migration for version 2
          // await m.addColumn(achievements, achievements.someNewColumn);
        }
      },
      beforeOpen: (details) async {
        // Enable foreign key constraints for data integrity
        await customStatement('PRAGMA foreign_keys = ON');

        if (details.wasCreated) {
          await insertDefaultSettings();
        }
      },
    );
  }

  // Insert default settings when database is created
  Future<void> insertDefaultSettings() async {
    // Default app settings
    await into(appSettings).insert(
      const AppSettingsCompanion(
        soundEnabled: Value(true),
        musicEnabled: Value(true),
        vibrationEnabled: Value(true),
        hapticFeedbackEnabled: Value(true),
        autoSaveEnabled: Value(true),
        notificationsEnabled: Value(true),
      ),
    );

    // Default theme settings (system theme)
    await into(themeSettings).insert(
      const ThemeSettingsCompanion(themeMode: Value(2)),
    ); // AppThemeMode.system.index
  }

  @override
  int get schemaVersion => 1;
}
