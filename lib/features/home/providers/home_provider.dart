import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/services/memory_manager.dart';

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
  }) => HomeState(
    lastResult: lastResult ?? this.lastResult,
    streak: streak ?? this.streak,
    gemsCount: gemsCount ?? this.gemsCount,
    hintCount: hintCount ?? this.hintCount,
    isLoading: isLoading ?? this.isLoading,
  );
}

/// Home screen provider for managing state with proper disposal
class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());

  // Mounted flag for proper disposal
  bool _mounted = true;

  /// Update the last game result
  void updateLastResult(String result) {
    if (_mounted) {
      state = state.copyWith(lastResult: result);
    }
  }

  /// Update the current streak
  void updateStreak(int streak) {
    if (_mounted) {
      state = state.copyWith(streak: streak);
    }
  }

  /// Update gems count
  void updateGemsCount(int gems) {
    if (_mounted) {
      state = state.copyWith(gemsCount: gems);
    }
  }

  /// Update hint count
  void updateHintCount(int hints) {
    if (_mounted) {
      state = state.copyWith(hintCount: hints);
    }
  }

  /// Set loading state
  void setLoading({required bool loading}) {
    if (_mounted) {
      state = state.copyWith(isLoading: loading);
    }
  }

  /// Reset stats to default values
  void resetStats() {
    if (_mounted) {
      state = const HomeState();
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}

// ✅ OPTIMIZED: Home provider with autoDispose for temporary home data
final homeProvider = StateNotifierProvider.autoDispose<HomeNotifier, HomeState>(
  (ref) {
    ref.trackMemory('home', keepAlive: false);
    return HomeNotifier();
  },
);

// ✅ OPTIMIZED: Use select for granular rebuilds with autoDispose for temporary data
// Individual home data providers for granular rebuilds
final lastResultProvider = Provider.autoDispose<String>((ref) {
  ref.trackMemory('lastResult', keepAlive: false);
  return ref.watch(homeProvider.select((state) => state.lastResult));
});

final streakProvider = Provider.autoDispose<int>((ref) {
  ref.trackMemory('streak', keepAlive: false);
  return ref.watch(homeProvider.select((state) => state.streak));
});

final gemsCountProvider = Provider.autoDispose<int>((ref) {
  ref.trackMemory('gemsCount', keepAlive: false);
  return ref.watch(homeProvider.select((state) => state.gemsCount));
});

final hintCountProvider = Provider.autoDispose<int>((ref) {
  ref.trackMemory('hintCount', keepAlive: false);
  return ref.watch(homeProvider.select((state) => state.hintCount));
});

final homeLoadingProvider = Provider.autoDispose<bool>((ref) {
  ref.trackMemory('homeLoading', keepAlive: false);
  return ref.watch(homeProvider.select((state) => state.isLoading));
});

// ✅ OPTIMIZED: Computed providers using select with autoDispose for temporary data
final homeStatsProvider =
    Provider.autoDispose<
      ({String lastResult, int streak, int gemsCount, int hintCount})
    >((ref) {
      ref.trackMemory('homeStats', keepAlive: false);
      return ref.watch(
        homeProvider.select(
          (state) => (
            lastResult: state.lastResult,
            streak: state.streak,
            gemsCount: state.gemsCount,
            hintCount: state.hintCount,
          ),
        ),
      );
    });

final homeIsLoadingProvider = Provider.autoDispose<bool>((ref) {
  ref.trackMemory('homeIsLoading', keepAlive: false);
  return ref.watch(homeProvider.select((state) => state.isLoading));
});

// ✅ OPTIMIZED: Extension methods for easy access with select-based providers
extension HomeProviderExtension on WidgetRef {
  // Get home notifier
  HomeNotifier get homeNotifier => read(homeProvider.notifier);

  // Get individual home data using select for granular rebuilds
  String get lastResult => watch(lastResultProvider);
  int get streak => watch(streakProvider);
  int get gemsCount => watch(gemsCountProvider);
  int get hintCount => watch(hintCountProvider);
  bool get homeIsLoading => watch(homeLoadingProvider);

  // Get computed home data
  ({String lastResult, int streak, int gemsCount, int hintCount})
  get homeStats => watch(homeStatsProvider);

  // Get all home state
  HomeState get homeState => watch(homeProvider);
}
