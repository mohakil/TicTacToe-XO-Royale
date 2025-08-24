import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home screen state data
class HomeState {
  const HomeState({
    this.lastResult = 'Win',
    this.streak = 3,
    this.gemsCount = 150,
    this.hintCount = 5,
    this.isLoading = false,
  });

  final String lastResult;
  final int streak;
  final int gemsCount;
  final int hintCount;
  final bool isLoading;

  HomeState copyWith({
    String? lastResult,
    int? streak,
    int? gemsCount,
    int? hintCount,
    bool? isLoading,
  }) {
    return HomeState(
      lastResult: lastResult ?? this.lastResult,
      streak: streak ?? this.streak,
      gemsCount: gemsCount ?? this.gemsCount,
      hintCount: hintCount ?? this.hintCount,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Home screen provider for managing state
class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());

  /// Update the last game result
  void updateLastResult(String result) {
    state = state.copyWith(lastResult: result);
  }

  /// Update the current streak
  void updateStreak(int streak) {
    state = state.copyWith(streak: streak);
  }

  /// Update gems count
  void updateGemsCount(int gems) {
    state = state.copyWith(gemsCount: gems);
  }

  /// Update hint count
  void updateHintCount(int hints) {
    state = state.copyWith(hintCount: hints);
  }

  /// Set loading state
  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  /// Reset stats to default values
  void resetStats() {
    state = const HomeState();
  }
}

/// Provider for home screen state
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});

/// Provider for last result
final lastResultProvider = Provider<String>((ref) {
  return ref.watch(homeProvider).lastResult;
});

/// Provider for streak
final streakProvider = Provider<int>((ref) {
  return ref.watch(homeProvider).streak;
});

/// Provider for gems count
final gemsCountProvider = Provider<int>((ref) {
  return ref.watch(homeProvider).gemsCount;
});

/// Provider for hint count
final hintCountProvider = Provider<int>((ref) {
  return ref.watch(homeProvider).hintCount;
});

/// Provider for loading state
final homeLoadingProvider = Provider<bool>((ref) {
  return ref.watch(homeProvider).isLoading;
});
