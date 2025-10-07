import 'package:drift/drift.dart';

import 'profile_dao.dart';
import 'game_history_dao.dart';
import 'achievement_dao.dart';
import 'settings_dao.dart';
import 'theme_dao.dart';
import 'store_dao.dart';

part 'app_database.g.dart';

// ===== TABLE DEFINITIONS =====

// Player Profiles Table
class PlayerProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nickname => text()();
  TextColumn get avatarUrlOrProvider => text().nullable()();
  IntColumn get gems => integer()();
  IntColumn get hints => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  String get tableName => 'player_profiles';
}

// Player Stats Table
class PlayerStats extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(PlayerProfiles, #id)();
  IntColumn get wins => integer()();
  IntColumn get losses => integer()();
  IntColumn get draws => integer()();
  IntColumn get streak => integer()();
  IntColumn get totalGames =>
      integer()(); // Computed but stored for performance

  @override
  String get tableName => 'player_stats';

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY(profile_id) REFERENCES player_profiles(id) ON DELETE CASCADE',
  ];
}

// Game History Table
class GameHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(PlayerProfiles, #id)();
  TextColumn get opponent =>
      text()(); // 'Player', 'Robot', or specific robot name
  TextColumn get result => text()(); // 'win', 'loss', 'draw'
  TextColumn get boardSize => text()(); // '3x3', '4x4', etc.
  IntColumn get durationSeconds => integer()(); // Duration in seconds
  TextColumn get score => text()(); // Final score representation
  DateTimeColumn get playedAt => dateTime()();

  @override
  String get tableName => 'game_history';

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY(profile_id) REFERENCES player_profiles(id) ON DELETE CASCADE',
  ];
}

// Achievements Table
class Achievements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(PlayerProfiles, #id)();
  TextColumn get achievementId =>
      text()(); // References hardcoded achievement data
  BoolColumn get isUnlocked => boolean()();
  IntColumn get progress => integer()();
  DateTimeColumn get unlockedDate => dateTime().nullable()();

  @override
  String get tableName => 'achievements';

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY(profile_id) REFERENCES player_profiles(id) ON DELETE CASCADE',
  ];
}

// App Settings Table
class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get soundEnabled => boolean()();
  BoolColumn get musicEnabled => boolean()();
  BoolColumn get vibrationEnabled => boolean()();
  BoolColumn get hapticFeedbackEnabled => boolean()();
  BoolColumn get autoSaveEnabled => boolean()();
  BoolColumn get notificationsEnabled => boolean()();

  @override
  String get tableName => 'app_settings';
}

// Theme Settings Table
class ThemeSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get themeMode => text()(); // 'light', 'dark', 'system'

  @override
  String get tableName => 'theme_settings';
}

// Store Items Table
class StoreItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(PlayerProfiles, #id)();
  TextColumn get itemId => text()(); // References hardcoded store item data
  IntColumn get quantity => integer()();
  DateTimeColumn get purchasedDate => dateTime()();

  @override
  String get tableName => 'store_items';

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY(profile_id) REFERENCES player_profiles(id) ON DELETE CASCADE',
  ];
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
  AppDatabase(super.executor);

  // drift_flutter handles executor creation automatically
  // Removed createExecutor() method - use driftDatabase() in main.dart instead

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
    await into(
      themeSettings,
    ).insert(const ThemeSettingsCompanion(themeMode: Value('system')));
  }

  @override
  int get schemaVersion => 1;
}
