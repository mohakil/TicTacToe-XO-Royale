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

/// Provider for home screen state
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(),
);

// ✅ OPTIMIZED: Use select for granular rebuilds instead of individual providers
// Individual home data providers for granular rebuilds
final lastResultProvider = Provider<String>(
  (ref) => ref.watch(homeProvider.select((state) => state.lastResult)),
);

final streakProvider = Provider<int>(
  (ref) => ref.watch(homeProvider.select((state) => state.streak)),
);

final gemsCountProvider = Provider<int>(
  (ref) => ref.watch(homeProvider.select((state) => state.gemsCount)),
);

final hintCountProvider = Provider<int>(
  (ref) => ref.watch(homeProvider.select((state) => state.hintCount)),
);

final homeLoadingProvider = Provider<bool>(
  (ref) => ref.watch(homeProvider.select((state) => state.isLoading)),
);

// ✅ OPTIMIZED: Computed providers using select for better performance
final homeStatsProvider =
    Provider<({String lastResult, int streak, int gemsCount, int hintCount})>(
      (ref) => ref.watch(
        homeProvider.select(
          (state) => (
            lastResult: state.lastResult,
            streak: state.streak,
            gemsCount: state.gemsCount,
            hintCount: state.hintCount,
          ),
        ),
      ),
    );

final homeIsLoadingProvider = Provider<bool>(
  (ref) => ref.watch(homeProvider.select((state) => state.isLoading)),
);

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
