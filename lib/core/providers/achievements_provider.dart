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
    achievements: [], // ✅ FIXED: Start with empty list to prevent duplicates
    isLoading: false,
    error: null,
  );

  // Loading state
  factory AchievementsState.loading() =>
      const AchievementsState(achievements: [], isLoading: true, error: null);

  // Error state
  factory AchievementsState.error(String errorMessage) => AchievementsState(
    achievements: [], // ✅ FIXED: Start with empty list to prevent duplicates
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

    // Initialize profile ID converter (already defined as method above)

    // Load achievements asynchronously - don't await, let it complete in background
    _loadAchievementsAsync();
    return AchievementsState.initial();
  }

  // Load achievements from database asynchronously
  Future<void> _loadAchievementsAsync({bool isRefresh = false}) async {
    try {
      // Only show loading on initial load, not during refresh
      if (_isInitialLoad) {
        state = AchievementsState.loading();
      }

      // Load achievements from database
      final dbAchievements = await _achievementDao.getAchievementsByProfile(
        'default_user',
      );

      // Initialize achievements if none exist (with error handling)
      if (dbAchievements.isEmpty) {
        try {
          await _achievementDao.initializeAchievementsForProfile(
            'default_user',
          );
          // Reload after initialization
          final initializedAchievements = await _achievementDao
              .getAchievementsByProfile('default_user');
          dbAchievements.clear();
          dbAchievements.addAll(initializedAchievements);
        } catch (initError) {
          // If initialization fails, log but continue with empty achievements
          debugPrint('Warning: Failed to initialize achievements: $initError');
        }
      }

      // Convert database models to app models with progress validation
      final achievementsList = <Achievement>[];
      final allBaseAchievements = AchievementDataService.getAllAchievements();

      for (final dbAchievement in dbAchievements) {
        try {
          // Find the corresponding achievement from the data service
          final baseAchievement = allBaseAchievements.firstWhere(
            (achievement) => achievement.id == dbAchievement.achievementId,
          );

          // Validate and fix progress consistency
          final progress = _validateProgress(
            dbAchievement.progress,
            baseAchievement.maxProgress,
            dbAchievement.isUnlocked,
          );

          achievementsList.add(
            Achievement(
              id: dbAchievement.achievementId,
              title: baseAchievement.title,
              description: baseAchievement.description,
              icon: baseAchievement.icon,
              rarity: baseAchievement.rarity,
              maxProgress: baseAchievement.maxProgress,
              isUnlocked: dbAchievement.isUnlocked,
              progress: progress,
              unlockedDate: dbAchievement.unlockedDate,
            ),
          );
        } catch (e) {
          debugPrint(
            'Warning: Failed to process achievement ${dbAchievement.achievementId}: $e',
          );
          // Skip this achievement but continue processing others
        }
      }

      if (_mounted) {
        state = state.copyWith(
          achievements: achievementsList,
          isLoading: false,
        );
        _isInitialLoad = false; // Mark initial load as complete

        // Validate data integrity after loading
        _validateAchievementDataIntegrity();
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

  // Validate and fix progress consistency
  int _validateProgress(int currentProgress, int maxProgress, bool isUnlocked) {
    // Ensure progress is within valid bounds
    var validatedProgress = currentProgress.clamp(0, maxProgress);

    // If achievement is unlocked but progress is insufficient, fix it
    if (isUnlocked && validatedProgress < maxProgress) {
      validatedProgress = maxProgress;
    }

    // If progress meets or exceeds max but achievement isn't unlocked, fix it
    if (!isUnlocked && validatedProgress >= maxProgress) {
      validatedProgress =
          maxProgress - 1; // Keep it just below max to allow proper unlocking
    }

    return validatedProgress;
  }

  // Validate achievement data integrity and fix inconsistencies
  Future<void> _validateAchievementDataIntegrity() async {
    try {
      final achievements = state.achievements;
      bool needsUpdate = false;

      for (final achievement in achievements) {
        // Check for inconsistencies
        if (achievement.isUnlocked &&
            achievement.progress < achievement.maxProgress) {
          // Achievement is unlocked but progress is insufficient
          needsUpdate = true;
          await _achievementDao.updateProgress(
            'default_user',
            achievement.id,
            achievement.maxProgress,
          );
        } else if (!achievement.isUnlocked &&
            achievement.progress >= achievement.maxProgress) {
          // Achievement has sufficient progress but isn't unlocked
          needsUpdate = true;
          await _achievementDao.unlockAchievement(
            'default_user',
            achievement.id,
          );
        }
      }

      if (needsUpdate) {
        // Reload data after fixing inconsistencies
        await _loadAchievementsAsync();
      }
    } catch (e) {
      debugPrint('Warning: Failed to validate achievement data integrity: $e');
    }
  }

  // Unlock an achievement by ID
  Future<void> unlockAchievement(String achievementId) async {
    try {
      // Use DAO to unlock achievement in database
      await _achievementDao.unlockAchievement('default_user', achievementId);

      // Also update progress to max when unlocking
      final achievement = getAchievement(achievementId);
      if (achievement != null) {
        await _achievementDao.updateProgress(
          'default_user',
          achievementId,
          achievement.maxProgress,
        );
      }

      // Reload achievements to get updated state
      await _loadAchievementsAsync();
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
      final achievement = getAchievement(achievementId);
      if (achievement == null) return;

      // Validate progress bounds
      final validatedProgress = progress.clamp(0, achievement.maxProgress);

      // Use DAO to update achievement progress in database
      await _achievementDao.updateProgress(
        'default_user',
        achievementId,
        validatedProgress,
      );

      // Check if achievement should be unlocked
      if (validatedProgress >= achievement.maxProgress &&
          !achievement.isUnlocked) {
        await _achievementDao.unlockAchievement('default_user', achievementId);
      }

      // Reload achievements to get updated state
      await _loadAchievementsAsync();
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
    await _loadAchievementsAsync(isRefresh: true);
  }

  // Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

// Individual achievement data providers for granular rebuilds
final achievementsListProvider = Provider.autoDispose<List<Achievement>>((ref) {
  final achievements = ref.watch(achievementsProvider).achievements;

  // Ensure no duplicates by achievement ID
  final seenIds = <String>{};
  final deduplicatedAchievements = <Achievement>[];

  for (final achievement in achievements) {
    if (!seenIds.contains(achievement.id)) {
      seenIds.add(achievement.id);
      deduplicatedAchievements.add(achievement);
    }
  }

  return deduplicatedAchievements;
});

final unlockedAchievementsProvider = Provider.autoDispose<List<Achievement>>(
  (ref) =>
      ref.watch(achievementsListProvider).where((a) => a.isUnlocked).toList(),
);

final lockedAchievementsProvider = Provider.autoDispose<List<Achievement>>(
  (ref) =>
      ref.watch(achievementsListProvider).where((a) => !a.isUnlocked).toList(),
);

final unlockedAchievementsCountProvider = Provider.autoDispose<int>((ref) {
  final achievements = ref.watch(achievementsListProvider);
  return achievements.where((a) => a.isUnlocked).length;
});

final totalAchievementsCountProvider = Provider.autoDispose<int>((ref) {
  final achievements = ref.watch(achievementsListProvider);
  return achievements.length;
});

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
