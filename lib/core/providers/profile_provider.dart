import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import 'package:tictactoe_xo_royale/core/database/database_providers.dart';
import 'package:tictactoe_xo_royale/core/database/achievement_dao.dart';
import 'package:tictactoe_xo_royale/core/database/game_history_dao.dart';
import 'package:tictactoe_xo_royale/core/database/profile_dao.dart';
import 'package:tictactoe_xo_royale/core/database/app_database.dart' as db;
import 'package:tictactoe_xo_royale/core/models/game_history.dart';
import 'package:tictactoe_xo_royale/core/models/player_profile.dart';

part 'profile_provider.g.dart';

// Profile state class
@immutable
class ProfileState {
  const ProfileState({
    required this.profile,
    required this.isLoading,
    required this.error,
    required this.isEditing,
  });

  final PlayerProfile? profile;
  final bool isLoading;
  final String? error;
  final bool isEditing;

  // Copy with method for immutable updates
  ProfileState copyWith({
    PlayerProfile? profile,
    bool? isLoading,
    String? error,
    bool? isEditing,
    bool clearError = false,
  }) => ProfileState(
    profile: profile ?? this.profile,
    isLoading: isLoading ?? this.isLoading,
    error: clearError ? null : (error ?? this.error),
    isEditing: isEditing ?? this.isEditing,
  );

  // Initial state
  factory ProfileState.initial() => const ProfileState(
    profile: null,
    isLoading: true,
    error: null,
    isEditing: false,
  );

  // Success state
  factory ProfileState.success(PlayerProfile profile) => ProfileState(
    profile: profile,
    isLoading: false,
    error: null,
    isEditing: false,
  );

  // Error state
  factory ProfileState.error(String errorMessage) => ProfileState(
    profile: null,
    isLoading: false,
    error: errorMessage,
    isEditing: false,
  );

  // Loading state
  factory ProfileState.loading() => const ProfileState(
    profile: null,
    isLoading: true,
    error: null,
    isEditing: false,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileState &&
          runtimeType == other.runtimeType &&
          profile == other.profile &&
          isLoading == other.isLoading &&
          error == other.error &&
          isEditing == other.isEditing;

  @override
  int get hashCode =>
      Object.hash(runtimeType, profile, isLoading, error, isEditing);

  @override
  String toString() =>
      'ProfileState(profile: $profile, isLoading: $isLoading, '
      'error: $error, isEditing: $isEditing)';
}

// Profile notifier
@Riverpod(keepAlive: true)
class ProfileNotifier extends _$ProfileNotifier {
  bool _mounted = true;
  bool _isInitialLoad = true;

  // DAO dependencies (initialized in build method)
  late ProfileDao _profileDao;
  late GameHistoryDao _gameHistoryDao;
  late AchievementDao _achievementDao;

  @override
  ProfileState build() {
    ref.onDispose(() {
      _mounted = false;
    });

    // Initialize DAOs from ref
    _profileDao = ref.watch(profileDaoProvider);
    _gameHistoryDao = ref.watch(gameHistoryDaoProvider);
    _achievementDao = ref.watch(achievementDaoProvider);

    // Initialize game history stream
    _gameHistoryStream = _gameHistoryDao
        .watchRecentGames('default_user', limit: 20)
        .map((games) => games.map(_convertDatabaseGameToAppGame).toList());

    _loadProfile();
    return ProfileState.initial();
  }

  // Load profile from database
  Future<void> _loadProfile({bool isRefresh = false}) async {
    try {
      // Only show loading on initial load, not during refresh
      if (_isInitialLoad) {
        state = ProfileState.loading();
      }

      // Try to load existing profile with stats from database
      final profileWithStats = await _profileDao.getProfileWithStats(
        'default_user',
      );

      if (profileWithStats != null) {
        // Convert database models to app model
        final playerProfile = _convertDatabaseProfileWithStatsToAppProfile(
          profileWithStats,
        );

        // Check if achievements exist and initialize if needed
        final existingAchievements = await _achievementDao
            .getAchievementsByProfile('default_user');
        if (existingAchievements.isEmpty) {
          await _achievementDao.initializeAchievementsForProfile(
            'default_user',
          );
        }

        if (_mounted) {
          state = ProfileState.success(playerProfile);
          _isInitialLoad = false; // Mark initial load as complete
        }
      } else {
        // Create default profile if none exists
        final defaultProfile = PlayerProfile.defaultProfile();
        await _createDefaultProfile(defaultProfile);
        if (_mounted) {
          state = ProfileState.success(defaultProfile);
          _isInitialLoad = false; // Mark initial load as complete
        }
      }
    } on DriftWrappedException catch (e) {
      if (_mounted) {
        state = state.copyWith(
          isLoading: false,
          error: 'Database error while loading profile: ${e.message}',
        );
      }
    } catch (error) {
      if (_mounted) {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load profile: $error',
        );
      }
    }
  }

  // Convert database profile with stats to app model
  PlayerProfile _convertDatabaseProfileWithStatsToAppProfile(
    PlayerProfileWithStats profileWithStats,
  ) {
    final dbProfile = profileWithStats.profile;
    final dbStats = profileWithStats.stats;

    // Convert stats if available, otherwise use defaults
    final stats = dbStats != null
        ? PlayerStats(
            wins: dbStats.wins,
            losses: dbStats.losses,
            draws: dbStats.draws,
            streak: dbStats.streak,
          )
        : const PlayerStats(wins: 0, losses: 0, draws: 0, streak: 0);

    return PlayerProfile(
      id: dbProfile.id.toString(), // Convert int to string
      nickname: dbProfile.nickname,
      avatarUrlOrProvider: dbProfile.avatarUrlOrProvider,
      stats: stats,
      gems: dbProfile.gems,
      hints: dbProfile.hints,
    );
  }

  // Create default profile in database
  Future<void> _createDefaultProfile(PlayerProfile defaultProfile) async {
    try {
      // Use ProfileDao.createProfileWithStats to create profile and stats together
      await _profileDao.createProfileWithStats(
        db.PlayerProfilesCompanion.insert(
          nickname: defaultProfile.nickname,
          avatarUrlOrProvider: Value(defaultProfile.avatarUrlOrProvider),
          gems: defaultProfile.gems,
          hints: defaultProfile.hints,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      // Initialize achievements for the new profile
      await _achievementDao.initializeAchievementsForProfile('default_user');
    } on DriftWrappedException catch (e) {
      if (_mounted) {
        state = state.copyWith(
          isLoading: false,
          error: 'Database error while creating default profile: ${e.message}',
        );
      }
    } catch (error) {
      if (_mounted) {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to create default profile: $error',
        );
      }
    }
  }

  // Save profile to database with mounted checks
  Future<void> _saveProfile(PlayerProfile profile) async {
    try {
      // Use ProfileDao.updateProfileAndStats for atomic updates
      await _profileDao.updateProfileAndStats(
        db.PlayerProfile(
          id: int.parse(profile.id),
          nickname: profile.nickname,
          avatarUrlOrProvider: profile.avatarUrlOrProvider,
          gems: profile.gems,
          hints: profile.hints,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        db.PlayerStatsCompanion(
          wins: Value(profile.stats.wins),
          losses: Value(profile.stats.losses),
          draws: Value(profile.stats.draws),
          streak: Value(profile.stats.streak),
          totalGames: Value(profile.stats.totalGames),
        ),
      );
    } on DriftWrappedException catch (e) {
      if (_mounted) {
        throw Exception('Database error while saving profile: ${e.message}');
      }
    } catch (error) {
      if (_mounted) {
        throw Exception('Profile operation failed: $error');
      }
    }
  }

  // Update profile
  Future<void> updateProfile(PlayerProfile updatedProfile) async {
    try {
      state = state.copyWith(isLoading: true);
      await _saveProfile(updatedProfile);
      if (_mounted) {
        state = ProfileState.success(updatedProfile);
      }
    } on DriftWrappedException catch (e) {
      if (_mounted) {
        throw Exception('Database error while updating profile: ${e.message}');
      }
    } catch (error) {
      if (_mounted) {
        throw Exception('Profile operation failed: $error');
      }
    }
  }

  // Update nickname
  Future<void> updateNickname(String newNickname) async {
    final currentProfile = state.profile;
    if (currentProfile != null) {
      try {
        // Update profile in database directly for better performance
        final dbProfile = db.PlayerProfile(
          id: int.parse(currentProfile.id),
          nickname: newNickname,
          avatarUrlOrProvider: currentProfile.avatarUrlOrProvider,
          gems: currentProfile.gems,
          hints: currentProfile.hints,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _profileDao.updateProfile(dbProfile);

        // Update local state
        final updatedProfile = PlayerProfile(
          id: currentProfile.id,
          nickname: newNickname,
          avatarUrlOrProvider: currentProfile.avatarUrlOrProvider,
          stats: currentProfile.stats,
          gems: currentProfile.gems,
          hints: currentProfile.hints,
        );

        if (_mounted) {
          state = ProfileState.success(updatedProfile);
        }
      } on DriftWrappedException catch (e) {
        if (_mounted) {
          state = state.copyWith(
            isLoading: false,
            error: 'Database error while updating nickname: ${e.message}',
          );
        }
      } catch (error) {
        if (_mounted) {
          state = state.copyWith(
            isLoading: false,
            error: 'Failed to update nickname: $error',
          );
        }
      }
    }
  }

  // Update avatar
  Future<void> updateAvatar(String? avatarUrlOrProvider) async {
    final currentProfile = state.profile;
    if (currentProfile != null) {
      try {
        // Update profile in database directly for better performance
        final dbProfile = db.PlayerProfile(
          id: int.parse(currentProfile.id),
          nickname: currentProfile.nickname,
          avatarUrlOrProvider: avatarUrlOrProvider,
          gems: currentProfile.gems,
          hints: currentProfile.hints,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _profileDao.updateProfile(dbProfile);

        // Update local state
        final updatedProfile = PlayerProfile(
          id: currentProfile.id,
          nickname: currentProfile.nickname,
          avatarUrlOrProvider: avatarUrlOrProvider,
          stats: currentProfile.stats,
          gems: currentProfile.gems,
          hints: currentProfile.hints,
        );

        if (_mounted) {
          state = ProfileState.success(updatedProfile);
        }
      } on DriftWrappedException catch (e) {
        if (_mounted) {
          state = state.copyWith(
            isLoading: false,
            error: 'Database error while updating avatar: ${e.message}',
          );
        }
      } catch (error) {
        if (_mounted) {
          state = state.copyWith(
            isLoading: false,
            error: 'Failed to update avatar: $error',
          );
        }
      }
    }
  }

  // Add gems
  Future<void> addGems(int amount) async {
    final currentProfile = state.profile;
    if (currentProfile != null) {
      try {
        // Update gems in database directly
        final newGems = currentProfile.gems + amount;
        final dbProfile = db.PlayerProfile(
          id: int.parse(currentProfile.id),
          nickname: currentProfile.nickname,
          avatarUrlOrProvider: currentProfile.avatarUrlOrProvider,
          gems: newGems,
          hints: currentProfile.hints,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _profileDao.updateProfile(dbProfile);

        // Update local state
        final updatedProfile = PlayerProfile(
          id: currentProfile.id,
          nickname: currentProfile.nickname,
          avatarUrlOrProvider: currentProfile.avatarUrlOrProvider,
          stats: currentProfile.stats,
          gems: newGems,
          hints: currentProfile.hints,
        );

        if (_mounted) {
          state = ProfileState.success(updatedProfile);
        }
      } on DriftWrappedException catch (e) {
        if (_mounted) {
          state = state.copyWith(
            isLoading: false,
            error: 'Database error while adding gems: ${e.message}',
          );
        }
      } catch (error) {
        if (_mounted) {
          state = state.copyWith(
            isLoading: false,
            error: 'Failed to add gems: $error',
          );
        }
      }
    }
  }

  // Spend gems
  Future<bool> spendGems(int amount) async {
    final currentProfile = state.profile;
    if (currentProfile != null && currentProfile.gems >= amount) {
      try {
        // Update gems in database directly
        final newGems = currentProfile.gems - amount;
        final dbProfile = db.PlayerProfile(
          id: int.parse(currentProfile.id),
          nickname: currentProfile.nickname,
          avatarUrlOrProvider: currentProfile.avatarUrlOrProvider,
          gems: newGems,
          hints: currentProfile.hints,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _profileDao.updateProfile(dbProfile);

        // Update local state
        final updatedProfile = PlayerProfile(
          id: currentProfile.id,
          nickname: currentProfile.nickname,
          avatarUrlOrProvider: currentProfile.avatarUrlOrProvider,
          stats: currentProfile.stats,
          gems: newGems,
          hints: currentProfile.hints,
        );

        if (_mounted) {
          state = ProfileState.success(updatedProfile);
        }
        return true;
      } on DriftWrappedException catch (e) {
        if (_mounted) {
          state = state.copyWith(
            isLoading: false,
            error: 'Database error while spending gems: ${e.message}',
          );
        }
        return false;
      } catch (error) {
        if (_mounted) {
          state = state.copyWith(
            isLoading: false,
            error: 'Failed to spend gems: $error',
          );
        }
        return false;
      }
    }
    return false;
  }

  // Add hints
  Future<void> addHints(int amount) async {
    final currentProfile = state.profile;
    if (currentProfile != null) {
      try {
        // Update hints in database directly
        final newHints = currentProfile.hints + amount;
        final dbProfile = db.PlayerProfile(
          id: int.parse(currentProfile.id),
          nickname: currentProfile.nickname,
          avatarUrlOrProvider: currentProfile.avatarUrlOrProvider,
          gems: currentProfile.gems,
          hints: newHints,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _profileDao.updateProfile(dbProfile);

        // Update local state
        final updatedProfile = PlayerProfile(
          id: currentProfile.id,
          nickname: currentProfile.nickname,
          avatarUrlOrProvider: currentProfile.avatarUrlOrProvider,
          stats: currentProfile.stats,
          gems: currentProfile.gems,
          hints: newHints,
        );

        if (_mounted) {
          state = ProfileState.success(updatedProfile);
        }
      } on DriftWrappedException catch (e) {
        if (_mounted) {
          state = state.copyWith(
            isLoading: false,
            error: 'Database error while adding hints: ${e.message}',
          );
        }
      } catch (error) {
        if (_mounted) {
          state = state.copyWith(
            isLoading: false,
            error: 'Failed to add hints: $error',
          );
        }
      }
    }
  }

  // Use hint
  Future<bool> useHint() async {
    final currentProfile = state.profile;
    if (currentProfile != null && currentProfile.hints > 0) {
      try {
        // Update hints in database directly
        final newHints = currentProfile.hints - 1;
        final dbProfile = db.PlayerProfile(
          id: int.parse(currentProfile.id),
          nickname: currentProfile.nickname,
          avatarUrlOrProvider: currentProfile.avatarUrlOrProvider,
          gems: currentProfile.gems,
          hints: newHints,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _profileDao.updateProfile(dbProfile);

        // Update local state
        final updatedProfile = PlayerProfile(
          id: currentProfile.id,
          nickname: currentProfile.nickname,
          avatarUrlOrProvider: currentProfile.avatarUrlOrProvider,
          stats: currentProfile.stats,
          gems: currentProfile.gems,
          hints: newHints,
        );

        if (_mounted) {
          state = ProfileState.success(updatedProfile);
        }
        return true;
      } on DriftWrappedException catch (e) {
        if (_mounted) {
          state = state.copyWith(
            isLoading: false,
            error: 'Database error while using hint: ${e.message}',
          );
        }
        return false;
      } catch (error) {
        if (_mounted) {
          state = state.copyWith(
            isLoading: false,
            error: 'Failed to use hint: $error',
          );
        }
        return false;
      }
    }
    return false;
  }

  // Update game stats
  Future<void> updateGameStats({bool? isWin, bool? isDraw}) async {
    final currentProfile = state.profile;
    if (currentProfile != null) {
      try {
        final currentStats = currentProfile.stats;
        var newWins = currentStats.wins;
        var newLosses = currentStats.losses;
        var newDraws = currentStats.draws;
        var newStreak = currentStats.streak;

        if (isWin ?? false) {
          newWins++;
          newStreak++;
        } else if (isWin == false) {
          newLosses++;
          newStreak = 0;
        } else if (isDraw ?? false) {
          newDraws++;
          newStreak = 0;
        }

        // Update stats in database using transaction for atomicity
        final updatedStats = PlayerStats(
          wins: newWins,
          losses: newLosses,
          draws: newDraws,
          streak: newStreak,
        );

        await _profileDao.updateProfileAndStats(
          db.PlayerProfile(
            id: int.parse(currentProfile.id),
            nickname: currentProfile.nickname,
            avatarUrlOrProvider: currentProfile.avatarUrlOrProvider,
            gems: currentProfile.gems,
            hints: currentProfile.hints,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          db.PlayerStatsCompanion(
            wins: Value(newWins),
            losses: Value(newLosses),
            draws: Value(newDraws),
            streak: Value(newStreak),
            totalGames: Value(newWins + newLosses + newDraws),
          ),
        );

        // Update local state
        final updatedProfile = PlayerProfile(
          id: currentProfile.id,
          nickname: currentProfile.nickname,
          avatarUrlOrProvider: currentProfile.avatarUrlOrProvider,
          stats: updatedStats,
          gems: currentProfile.gems,
          hints: currentProfile.hints,
        );

        if (_mounted) {
          state = ProfileState.success(updatedProfile);
        }
      } on DriftWrappedException catch (e) {
        if (_mounted) {
          state = state.copyWith(
            isLoading: false,
            error: 'Database error while updating game stats: ${e.message}',
          );
        }
      } catch (error) {
        if (_mounted) {
          state = state.copyWith(
            isLoading: false,
            error: 'Failed to update game stats: $error',
          );
        }
      }
    }
  }

  // Reset profile to defaults
  Future<void> resetProfile() async {
    try {
      if (_mounted) {
        state = state.copyWith(isLoading: true);
      }
      final defaultProfile = PlayerProfile.defaultProfile();

      // Delete existing profile and stats, then recreate
      await _profileDao.deleteProfile('default_user');

      // Create new default profile with stats
      await _createDefaultProfile(defaultProfile);

      if (_mounted) {
        state = ProfileState.success(defaultProfile);
      }
    } on DriftWrappedException catch (e) {
      if (_mounted) {
        state = state.copyWith(
          isLoading: false,
          error: 'Database error while resetting profile: ${e.message}',
        );
      }
    } catch (error) {
      if (_mounted) {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to reset profile: $error',
        );
      }
    }
  }

  // Set editing mode
  void setEditing({required bool isEditing}) {
    state = state.copyWith(isEditing: isEditing);
  }

  // Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  // Refresh profile
  Future<void> refreshProfile() async {
    await _loadProfile(isRefresh: true);
  }

  // Get current profile
  PlayerProfile? get currentProfile => state.profile;

  // Check if profile is loaded
  bool get isProfileLoaded => state.profile != null && !state.isLoading;

  // Check if profile is in editing mode
  bool get isEditing => state.isEditing;

  // Get current gems
  int get currentGems => state.profile?.gems ?? 0;

  // Get current hints
  int get currentHints => state.profile?.hints ?? 0;

  // Get current stats
  PlayerStats? get currentStats => state.profile?.stats;

  // Game history management using database with reactive streams
  late final Stream<List<GameHistoryItem>> _gameHistoryStream;

  // Add game to history in database
  Future<void> addGameToHistory(GameHistoryItem game) async {
    try {
      // Convert app model to database model
      // Get profile ID from current state or use default
      final profileIdString = state.profile?.id ?? 'default_user';
      final profileId = profileIdString == 'default_user'
          ? 1
          : int.tryParse(profileIdString) ?? 1;

      final dbGame = db.GameHistoryCompanion.insert(
        profileId: profileId,
        opponent: game.opponent,
        result: _convertGameResultToString(game.result),
        boardSize: game.boardSize,
        durationSeconds: game.duration.inSeconds,
        score: game.score,
        playedAt: game.date,
      );

      await _gameHistoryDao.insertGame(dbGame);

      // Update profile stats if it's a win/loss/draw
      if (game.result != GameResult.win &&
          game.result != GameResult.loss &&
          game.result != GameResult.draw) {
        return; // Don't update stats for other results
      }

      // Update profile stats
      await updateGameStats(
        isWin: game.result == GameResult.win,
        isDraw: game.result == GameResult.draw,
      );
    } on DriftWrappedException catch (e) {
      if (_mounted) {
        state = state.copyWith(
          error: 'Database error while adding game to history: ${e.message}',
        );
      }
    } catch (error) {
      if (_mounted) {
        state = state.copyWith(error: 'Failed to add game to history: $error');
      }
    }
  }

  // Get game history stream for reactive updates
  Stream<List<GameHistoryItem>> get gameHistoryStream => _gameHistoryStream;

  // Get game history (most recent first) - synchronous for compatibility
  Future<List<GameHistoryItem>> get gameHistory async {
    try {
      final games = await _gameHistoryDao.getGamesByProfile(
        'default_user',
        limit: 20,
      );
      return games.map(_convertDatabaseGameToAppGame).toList();
    } catch (error) {
      return [];
    }
  }

  // Get recent games for display (first 3)
  Future<List<GameHistoryItem>> get recentGames async {
    try {
      final games = await _gameHistoryDao.getGamesByProfile(
        'default_user',
        limit: 3,
      );
      return games.map(_convertDatabaseGameToAppGame).toList();
    } catch (error) {
      return [];
    }
  }

  // Helper methods for game history conversion
  String _convertGameResultToString(GameResult result) {
    switch (result) {
      case GameResult.win:
        return 'win';
      case GameResult.loss:
        return 'loss';
      case GameResult.draw:
        return 'draw';
    }
  }

  GameResult _convertStringToGameResult(String result) {
    switch (result) {
      case 'win':
        return GameResult.win;
      case 'loss':
        return GameResult.loss;
      case 'draw':
        return GameResult.draw;
      default:
        return GameResult.draw; // fallback
    }
  }

  GameHistoryItem _convertDatabaseGameToAppGame(dynamic dbGame) {
    return GameHistoryItem(
      opponent: dbGame.opponent,
      result: _convertStringToGameResult(dbGame.result),
      boardSize: dbGame.boardSize,
      date: dbGame.playedAt,
      duration: Duration(seconds: dbGame.durationSeconds),
      score: dbGame.score,
    );
  }
}

// Main profile provider with AutoDispose for better lifecycle management (codegen)

// Individual profile data providers for granular rebuilds
final currentProfileProvider = Provider.autoDispose<PlayerProfile?>(
  (ref) => ref.watch(profileProvider).profile,
);

final profileStatsProvider = Provider.autoDispose<PlayerStats?>(
  (ref) => ref.watch(profileProvider).profile?.stats,
);

final profileGemsProvider = Provider.autoDispose<int>(
  (ref) => ref.watch(profileProvider).profile?.gems ?? 0,
);

final profileHintsProvider = Provider.autoDispose<int>(
  (ref) => ref.watch(profileProvider).profile?.hints ?? 0,
);

final profileNicknameProvider = Provider.autoDispose<String>(
  (ref) => ref.watch(profileProvider).profile?.nickname ?? 'Player',
);

final profileAvatarProvider = Provider.autoDispose<String?>(
  (ref) => ref.watch(profileProvider).profile?.avatarUrlOrProvider,
);

final profileIsLoadingProvider = Provider.autoDispose<bool>(
  (ref) => ref.watch(profileProvider).isLoading,
);

final profileErrorProvider = Provider.autoDispose<String?>(
  (ref) => ref.watch(profileProvider).error,
);

final profileIsEditingProvider = Provider.autoDispose<bool>(
  (ref) => ref.watch(profileProvider).isEditing,
);

// Computed providers using select for better performance
final profileWinRateProvider = Provider.autoDispose<double>((ref) {
  final stats = ref.watch(profileProvider).profile?.stats;
  if (stats != null) {
    return stats.winRate;
  }
  return 0.0;
});

final profileTotalGamesProvider = Provider.autoDispose<int>((ref) {
  final stats = ref.watch(profileProvider).profile?.stats;
  if (stats != null) {
    return stats.totalGames;
  }
  return 0;
});

// Provider for accessing the ProfileNotifier instance
// Note: This is a workaround for Riverpod 3.0 compatibility
final profileNotifierProvider = Provider<ProfileNotifier>((ref) {
  // Access the notifier through the provider's internal mechanism
  final container = ref.container;
  return container.read(profileProvider.notifier);
});

final profileIsProfileLoadedProvider = Provider.autoDispose<bool>((ref) {
  final profileState = ref.watch(profileProvider);
  return profileState.profile != null;
});

// Extension methods for easy access with select-based providers
extension ProfileProviderExtension on WidgetRef {
  // Get profile notifier - workaround for Riverpod 3.0
  ProfileNotifier get profileNotifier {
    try {
      return read(profileNotifierProvider);
    } catch (e) {
      throw StateError('Profile provider not available: $e');
    }
  }

  // Get individual profile data using select for granular rebuilds
  PlayerProfile? get currentProfile => watch(currentProfileProvider);
  PlayerStats? get profileStats => watch(profileStatsProvider);
  int get profileGems => watch(profileGemsProvider);
  int get profileHints => watch(profileHintsProvider);
  String get profileNickname => watch(profileNicknameProvider);
  String? get profileAvatar => watch(profileAvatarProvider);
  bool get profileIsLoading => watch(profileIsLoadingProvider);
  String? get profileError => watch(profileErrorProvider);
  bool get profileIsEditing => watch(profileIsEditingProvider);

  // Get computed profile data
  double get profileWinRate => watch(profileWinRateProvider);
  int get profileTotalGames => watch(profileTotalGamesProvider);
  bool get isProfileLoaded => watch(profileIsProfileLoadedProvider);

  // Get all profile state - Note: Use ref.watch(profileProvider) in widgets instead
  ProfileState get profileState {
    // This is a workaround for Riverpod 3.0 - use ref.watch(profileProvider) directly in widgets
    throw UnimplementedError(
      'Use ref.watch(profileProvider) directly in widgets',
    );
  }
}

// Extension methods for BuildContext with proper error handling
extension ProfileContextExtension on BuildContext {
  // Get profile state from provider with error handling
  ProfileState? get profileState {
    try {
      return ProviderScope.containerOf(this).read(profileProvider);
    } catch (e) {
      debugPrint('Failed to read profile state: $e');
      return null;
    }
  }
}
