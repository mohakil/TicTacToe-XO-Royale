import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import 'package:tictactoe_xo_royale/core/models/achievement.dart';
import 'package:tictactoe_xo_royale/features/achievements/services/achievement_data_service.dart';
import 'package:tictactoe_xo_royale/core/database/database_providers.dart';
import 'package:tictactoe_xo_royale/core/database/achievement_dao.dart';

part 'achievements_provider.g.dart';

// Achievements state class
@immutable
class AchievementsState {
  const AchievementsState({
    required this.achievements,
    required this.isLoading,
    required this.error,
  });

  final List<Achievement> achievements;
  final bool isLoading;
  final String? error;

  // Copy with method for immutable updates
  AchievementsState copyWith({
    List<Achievement>? achievements,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) => AchievementsState(
    achievements: achievements ?? this.achievements,
    isLoading: isLoading ?? this.isLoading,
    error: clearError ? null : (error ?? this.error),
  );

  // Initial state
  factory AchievementsState.initial() => AchievementsState(
    achievements: AchievementDataService.getAllAchievements(),
    isLoading: false,
    error: null,
  );

  // Loading state
  factory AchievementsState.loading() =>
      const AchievementsState(achievements: [], isLoading: true, error: null);

  // Error state
  factory AchievementsState.error(String errorMessage) => AchievementsState(
    achievements: AchievementDataService.getAllAchievements(),
    isLoading: false,
    error: errorMessage,
  );
}

// Achievements notifier
@Riverpod(keepAlive: true)
class AchievementsNotifier extends _$AchievementsNotifier {
  // DAO dependencies (initialized in build method)
  late AchievementDao _achievementDao;

  bool _mounted = true;
  bool _isInitialLoad = true;

  @override
  AchievementsState build() {
    ref.onDispose(() {
      _mounted = false;
    });

    // Initialize DAO from ref
    _achievementDao = ref.watch(achievementDaoProvider);

    // Load achievements asynchronously - don't await, let it complete in background
    _loadAchievements();
    return AchievementsState.initial();
  }

  // Load achievements from database
  Future<void> _loadAchievements({bool isRefresh = false}) async {
    try {
      // Only show loading on initial load, not during refresh
      if (_isInitialLoad) {
        state = AchievementsState.loading();
      }

      // Load achievements from database
      final dbAchievements = await _achievementDao.getAchievementsByProfile(
        'default_user',
      );

      // Initialize achievements if none exist
      if (dbAchievements.isEmpty) {
        await _achievementDao.initializeAchievementsForProfile('default_user');
        // Reload after initialization
        final initializedAchievements = await _achievementDao
            .getAchievementsByProfile('default_user');
        dbAchievements.clear();
        dbAchievements.addAll(initializedAchievements);
      }

      // Convert database models to app models
      final achievementsList = dbAchievements.map((dbAchievement) {
        // Find the corresponding achievement from the data service
        final baseAchievement = AchievementDataService.getAllAchievements()
            .firstWhere(
              (achievement) => achievement.id == dbAchievement.achievementId,
            );

        return Achievement(
          id: dbAchievement.achievementId,
          title: baseAchievement.title,
          description: baseAchievement.description,
          icon: baseAchievement.icon,
          rarity: baseAchievement.rarity,
          maxProgress: baseAchievement.maxProgress,
          isUnlocked: dbAchievement.isUnlocked,
          progress: dbAchievement.progress,
          unlockedDate: dbAchievement.unlockedDate,
        );
      }).toList();

      if (_mounted) {
        state = state.copyWith(
          achievements: achievementsList,
          isLoading: false,
        );
        _isInitialLoad = false; // Mark initial load as complete
      }
    } on DriftWrappedException catch (e) {
      if (_mounted) {
        state = AchievementsState.error(
          'Database error while loading achievements: ${e.message}',
        );
      }
    } catch (error) {
      if (_mounted) {
        state = AchievementsState.error('Failed to load achievements: $error');
      }
    }
  }

  // Unlock an achievement by ID
  Future<void> unlockAchievement(String achievementId) async {
    try {
      // Use DAO to unlock achievement in database
      await _achievementDao.unlockAchievement('default_user', achievementId);

      // Reload achievements to get updated state
      _loadAchievements();
    } on DriftWrappedException catch (e) {
      if (_mounted) {
        state = AchievementsState.error(
          'Database error while unlocking achievement: ${e.message}',
        );
      }
    } catch (error) {
      if (_mounted) {
        state = AchievementsState.error('Failed to unlock achievement: $error');
      }
    }
  }

  // Update achievement progress (for progressive achievements)
  Future<void> updateAchievementProgress(
    String achievementId,
    int progress,
  ) async {
    try {
      // Use DAO to update achievement progress in database
      await _achievementDao.updateProgress(
        'default_user',
        achievementId,
        progress,
      );

      // Reload achievements to get updated state
      _loadAchievements();
    } on DriftWrappedException catch (e) {
      if (_mounted) {
        state = AchievementsState.error(
          'Database error while updating achievement progress: ${e.message}',
        );
      }
    } catch (error) {
      if (_mounted) {
        state = AchievementsState.error(
          'Failed to update achievement progress: $error',
        );
      }
    }
  }

  // Get achievement by ID
  Achievement? getAchievement(String achievementId) {
    try {
      return state.achievements.firstWhere(
        (achievement) => achievement.id == achievementId,
      );
    } catch (e) {
      return null;
    }
  }

  // Get all achievements
  List<Achievement> get achievements => state.achievements;

  // Get unlocked achievements count
  int get unlockedAchievementsCount {
    return state.achievements
        .where((achievement) => achievement.isUnlocked)
        .length;
  }

  // Get total achievements count
  int get totalAchievementsCount => state.achievements.length;

  // Check if achievement is unlocked
  bool isAchievementUnlocked(String achievementId) {
    final achievement = getAchievement(achievementId);
    return achievement?.isUnlocked ?? false;
  }

  // Refresh achievements
  Future<void> refreshAchievements() async {
    await _loadAchievements(isRefresh: true);
  }

  // Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

// Individual achievement data providers for granular rebuilds
final achievementsListProvider = Provider.autoDispose<List<Achievement>>(
  (ref) => ref.watch(achievementsProvider).achievements,
);

final unlockedAchievementsProvider = Provider.autoDispose<List<Achievement>>(
  (ref) =>
      ref.watch(achievementsListProvider).where((a) => a.isUnlocked).toList(),
);

final lockedAchievementsProvider = Provider.autoDispose<List<Achievement>>(
  (ref) =>
      ref.watch(achievementsListProvider).where((a) => !a.isUnlocked).toList(),
);

final unlockedAchievementsCountProvider = Provider.autoDispose<int>(
  (ref) => ref.watch(achievementsProvider.notifier).unlockedAchievementsCount,
);

final totalAchievementsCountProvider = Provider.autoDispose<int>(
  (ref) => ref.watch(achievementsProvider.notifier).totalAchievementsCount,
);

final achievementsProgressProvider = Provider.autoDispose<double>((ref) {
  final achievements = ref.watch(achievementsListProvider);
  if (achievements.isEmpty) return 0.0;

  final unlockedCount = achievements.where((a) => a.isUnlocked).length;
  return unlockedCount / achievements.length;
});

// Achievement actions
final unlockAchievementProvider = FutureProvider.family<void, String>((
  ref,
  achievementId,
) async {
  await ref
      .read(achievementsProvider.notifier)
      .unlockAchievement(achievementId);
});

final updateAchievementProgressProvider =
    FutureProvider.family<void, (String, int)>((ref, params) async {
      final (achievementId, progress) = params;
      await ref
          .read(achievementsProvider.notifier)
          .updateAchievementProgress(achievementId, progress);
    });

// Extension methods for easy access
extension AchievementsProviderExtension on WidgetRef {
  // Get achievements notifier
  AchievementsNotifier get achievementsNotifier =>
      read(achievementsProvider.notifier);

  // Get achievements data
  List<Achievement> get achievements => watch(achievementsListProvider);
  List<Achievement> get unlockedAchievements =>
      watch(unlockedAchievementsProvider);
  List<Achievement> get lockedAchievements => watch(lockedAchievementsProvider);
  int get unlockedAchievementsCount => watch(unlockedAchievementsCountProvider);
  int get totalAchievementsCount => watch(totalAchievementsCountProvider);
  double get achievementsProgress => watch(achievementsProgressProvider);

  // Get achievements state
  AchievementsState get achievementsState => watch(achievementsProvider);
}

// Extension methods for BuildContext
extension AchievementsContextExtension on BuildContext {
  // Get achievements state with error handling
  AchievementsState? get achievementsState {
    try {
      return ProviderScope.containerOf(this).read(achievementsProvider);
    } catch (e) {
      debugPrint('Failed to read achievements state: $e');
      return null;
    }
  }

  // Achievement-related getters for BuildContext
  List<Achievement> get achievements {
    try {
      return ProviderScope.containerOf(this).read(achievementsListProvider);
    } catch (e) {
      debugPrint('Failed to read achievements: $e');
      return [];
    }
  }

  List<Achievement> get unlockedAchievements {
    try {
      return ProviderScope.containerOf(this).read(unlockedAchievementsProvider);
    } catch (e) {
      debugPrint('Failed to read unlocked achievements: $e');
      return [];
    }
  }

  List<Achievement> get lockedAchievements {
    try {
      return ProviderScope.containerOf(this).read(lockedAchievementsProvider);
    } catch (e) {
      debugPrint('Failed to read locked achievements: $e');
      return [];
    }
  }

  int get unlockedAchievementsCount {
    try {
      return ProviderScope.containerOf(
        this,
      ).read(unlockedAchievementsCountProvider);
    } catch (e) {
      debugPrint('Failed to read unlocked achievements count: $e');
      return 0;
    }
  }

  int get totalAchievementsCount {
    try {
      return ProviderScope.containerOf(
        this,
      ).read(totalAchievementsCountProvider);
    } catch (e) {
      debugPrint('Failed to read total achievements count: $e');
      return 0;
    }
  }

  double get achievementsProgress {
    try {
      return ProviderScope.containerOf(this).read(achievementsProgressProvider);
    } catch (e) {
      debugPrint('Failed to read achievements progress: $e');
      return 0.0;
    }
  }
}
