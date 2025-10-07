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
  throw UnimplementedError('Database provider must be overridden');
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
