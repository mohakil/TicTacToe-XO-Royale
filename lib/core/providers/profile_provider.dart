import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictactoe_xo_royale/core/models/player_profile.dart';

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
class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier({PlayerProfile? initialProfile})
    : super(
        ProfileState.success(initialProfile ?? PlayerProfile.defaultProfile()),
      ) {
    // Always start with default profile, then load from storage
    if (initialProfile == null) {
      _loadProfile();
    }
  }

  bool _mounted = true;
  static const String _storageKey = 'user_profile';

  // Load profile from storage
  Future<void> _loadProfile() async {
    try {
      state = ProfileState.loading();

      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_storageKey);

      if (profileJson != null) {
        final profileMap = Map<String, dynamic>.from(
          json.decode(profileJson) as Map,
        );
        final profile = PlayerProfile.fromJson(profileMap);
        if (_mounted) {
          state = ProfileState.success(profile);
        }
      } else {
        // Create default profile if none exists
        final defaultProfile = PlayerProfile.defaultProfile();
        await _saveProfile(defaultProfile);
        if (_mounted) {
          state = ProfileState.success(defaultProfile);
        }
      }
    } on Exception catch (e) {
      if (_mounted) {
        state = ProfileState.error('Failed to load profile: $e');
      }
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  // Save profile to storage with mounted checks
  Future<void> _saveProfile(PlayerProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = json.encode(profile.toJson());
      await prefs.setString(_storageKey, profileJson);
    } on Exception catch (e) {
      if (_mounted) {
        state = state.copyWith(error: 'Failed to save profile: $e');
      }
    }
  }

  // Update profile
  Future<void> updateProfile(PlayerProfile updatedProfile) async {
    try {
      if (_mounted) {
        state = state.copyWith(isLoading: true);
      }
      await _saveProfile(updatedProfile);
      if (_mounted) {
        state = ProfileState.success(updatedProfile);
      }
    } on Exception catch (e) {
      if (_mounted) {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to update profile: $e',
        );
      }
    }
  }

  // Update nickname
  Future<void> updateNickname(String newNickname) async {
    final currentProfile = state.profile;
    if (currentProfile != null) {
      final updatedProfile = PlayerProfile(
        id: currentProfile.id,
        nickname: newNickname,
        avatarUrlOrProvider: currentProfile.avatarUrlOrProvider,
        stats: currentProfile.stats,
        gems: currentProfile.gems,
        hints: currentProfile.hints,
      );
      await updateProfile(updatedProfile);
    }
  }

  // Update avatar
  Future<void> updateAvatar(String? avatarUrlOrProvider) async {
    final currentProfile = state.profile;
    if (currentProfile != null) {
      final updatedProfile = PlayerProfile(
        id: currentProfile.id,
        nickname: currentProfile.nickname,
        avatarUrlOrProvider: avatarUrlOrProvider,
        stats: currentProfile.stats,
        gems: currentProfile.gems,
        hints: currentProfile.hints,
      );
      await updateProfile(updatedProfile);
    }
  }

  // Add gems
  Future<void> addGems(int amount) async {
    final currentProfile = state.profile;
    if (currentProfile != null) {
      final updatedProfile = PlayerProfile(
        id: currentProfile.id,
        nickname: currentProfile.nickname,
        avatarUrlOrProvider: currentProfile.avatarUrlOrProvider,
        stats: currentProfile.stats,
        gems: currentProfile.gems + amount,
        hints: currentProfile.hints,
      );
      await updateProfile(updatedProfile);
    }
  }

  // Spend gems
  Future<bool> spendGems(int amount) async {
    final currentProfile = state.profile;
    if (currentProfile != null && currentProfile.gems >= amount) {
      final updatedProfile = PlayerProfile(
        id: currentProfile.id,
        nickname: currentProfile.nickname,
        avatarUrlOrProvider: currentProfile.avatarUrlOrProvider,
        stats: currentProfile.stats,
        gems: currentProfile.gems - amount,
        hints: currentProfile.hints,
      );
      await updateProfile(updatedProfile);
      return true;
    }
    return false;
  }

  // Add hints
  Future<void> addHints(int amount) async {
    final currentProfile = state.profile;
    if (currentProfile != null) {
      final updatedProfile = PlayerProfile(
        id: currentProfile.id,
        nickname: currentProfile.nickname,
        avatarUrlOrProvider: currentProfile.avatarUrlOrProvider,
        stats: currentProfile.stats,
        gems: currentProfile.gems,
        hints: currentProfile.hints + amount,
      );
      await updateProfile(updatedProfile);
    }
  }

  // Use hint
  Future<bool> useHint() async {
    final currentProfile = state.profile;
    if (currentProfile != null && currentProfile.hints > 0) {
      final updatedProfile = PlayerProfile(
        id: currentProfile.id,
        nickname: currentProfile.nickname,
        avatarUrlOrProvider: currentProfile.avatarUrlOrProvider,
        stats: currentProfile.stats,
        gems: currentProfile.gems,
        hints: currentProfile.hints - 1,
      );
      await updateProfile(updatedProfile);
      return true;
    }
    return false;
  }

  // Update game stats
  Future<void> updateGameStats({bool? isWin, bool? isDraw}) async {
    final currentProfile = state.profile;
    if (currentProfile != null) {
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

      final updatedStats = PlayerStats(
        wins: newWins,
        losses: newLosses,
        draws: newDraws,
        streak: newStreak,
      );

      final updatedProfile = PlayerProfile(
        id: currentProfile.id,
        nickname: currentProfile.nickname,
        avatarUrlOrProvider: currentProfile.avatarUrlOrProvider,
        stats: updatedStats,
        gems: currentProfile.gems,
        hints: currentProfile.hints,
      );

      await updateProfile(updatedProfile);
    }
  }

  // Reset profile to defaults
  Future<void> resetProfile() async {
    try {
      if (_mounted) {
        state = ProfileState.loading();
      }
      final defaultProfile = PlayerProfile.defaultProfile();
      await _saveProfile(defaultProfile);
      if (_mounted) {
        state = ProfileState.success(defaultProfile);
      }
    } on Exception catch (e) {
      if (_mounted) {
        state = ProfileState.error('Failed to reset profile: $e');
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
    await _loadProfile();
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
}

// ✅ OPTIMIZED: Main profile provider with AutoDispose for better lifecycle management
final profileProvider =
    StateNotifierProvider.autoDispose<ProfileNotifier, ProfileState>(
      (ref) => ProfileNotifier(),
    );

// ✅ OPTIMIZED: Use select for granular rebuilds instead of individual providers
// Individual profile data providers for granular rebuilds
final currentProfileProvider = Provider.autoDispose<PlayerProfile?>(
  (ref) => ref.watch(profileProvider.select((state) => state.profile)),
);

final profileStatsProvider = Provider.autoDispose<PlayerStats?>(
  (ref) => ref.watch(profileProvider.select((state) => state.profile?.stats)),
);

final profileGemsProvider = Provider.autoDispose<int>(
  (ref) =>
      ref.watch(profileProvider.select((state) => state.profile?.gems ?? 0)),
);

final profileHintsProvider = Provider.autoDispose<int>(
  (ref) =>
      ref.watch(profileProvider.select((state) => state.profile?.hints ?? 0)),
);

final profileNicknameProvider = Provider.autoDispose<String>(
  (ref) => ref.watch(
    profileProvider.select((state) => state.profile?.nickname ?? 'Player'),
  ),
);

final profileAvatarProvider = Provider.autoDispose<String?>(
  (ref) => ref.watch(
    profileProvider.select((state) => state.profile?.avatarUrlOrProvider),
  ),
);

final profileIsLoadingProvider = Provider.autoDispose<bool>(
  (ref) => ref.watch(profileProvider.select((state) => state.isLoading)),
);

final profileErrorProvider = Provider.autoDispose<String?>(
  (ref) => ref.watch(profileProvider.select((state) => state.error)),
);

final profileIsEditingProvider = Provider.autoDispose<bool>(
  (ref) => ref.watch(profileProvider.select((state) => state.isEditing)),
);

// ✅ OPTIMIZED: Computed providers using select for better performance
final profileWinRateProvider = Provider.autoDispose<double>(
  (ref) => ref.watch(
    profileProvider.select((state) {
      final stats = state.profile?.stats;
      if (stats != null) {
        return stats.winRate;
      }
      return 0.0;
    }),
  ),
);

final profileTotalGamesProvider = Provider.autoDispose<int>(
  (ref) => ref.watch(
    profileProvider.select((state) {
      final stats = state.profile?.stats;
      if (stats != null) {
        return stats.totalGames;
      }
      return 0;
    }),
  ),
);

final profileIsProfileLoadedProvider = Provider.autoDispose<bool>(
  (ref) => ref.watch(
    profileProvider.select(
      (state) => state.profile != null && !state.isLoading,
    ),
  ),
);

// ✅ OPTIMIZED: Extension methods for easy access with select-based providers
extension ProfileProviderExtension on WidgetRef {
  // Get profile notifier
  ProfileNotifier get profileNotifier => read(profileProvider.notifier);

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

  // Get all profile state
  ProfileState get profileState => watch(profileProvider);
}

// ✅ OPTIMIZED: Extension methods for BuildContext with proper error handling
extension ProfileContextExtension on BuildContext {
  // Get profile state from provider with error handling
  ProfileState? get profileState {
    try {
      return ProviderScope.containerOf(this).read(profileProvider);
    } on Exception catch (e) {
      debugPrint('Failed to read profile state: $e');
      return null;
    }
  }
}
