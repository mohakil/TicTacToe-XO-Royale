import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';
import 'profile_dao.dart';
import 'game_history_dao.dart';
import 'achievement_dao.dart';
import 'settings_dao.dart';
import 'theme_dao.dart';
import 'store_dao.dart';

// ===== DATABASE PROVIDERS =====

// Provider for the main AppDatabase instance
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// Provider for ProfileDao
final profileDaoProvider = Provider<ProfileDao>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return ProfileDao(database);
});

// Provider for GameHistoryDao
final gameHistoryDaoProvider = Provider<GameHistoryDao>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return GameHistoryDao(database);
});

// Provider for AchievementDao
final achievementDaoProvider = Provider<AchievementDao>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return AchievementDao(database);
});

// Provider for SettingsDao
final settingsDaoProvider = Provider<SettingsDao>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return SettingsDao(database);
});

// Provider for ThemeDao
final themeDaoProvider = Provider<ThemeDao>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return ThemeDao(database);
});

// Provider for StoreDao
final storeDaoProvider = Provider<StoreDao>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return StoreDao(database);
});

// ===== UTILITY PROVIDERS =====

// Provider for converting string profile IDs to integer IDs consistently
final profileIdConverterProvider = Provider<int Function(String)>((ref) {
  return (String profileId) {
    if (profileId == 'default_user') return 1;
    return int.tryParse(profileId) ?? 1;
  };
});

// Provider for the default profile ID (used throughout the app)
final defaultProfileIdProvider = Provider<int>((ref) => 1);
