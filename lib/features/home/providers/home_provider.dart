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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeState &&
        other.lastResult == lastResult &&
        other.streak == streak &&
        other.gemsCount == gemsCount &&
        other.hintCount == hintCount &&
        other.isLoading == isLoading;
  }

  @override
  int get hashCode =>
      Object.hash(lastResult, streak, gemsCount, hintCount, isLoading);
}

/// Home screen state notifier
class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());

  bool _mounted = true;

  void updateLastResult(String result) {
    if (_mounted) {
      state = state.copyWith(lastResult: result);
    }
  }

  void updateStreak(int streak) {
    if (_mounted) {
      state = state.copyWith(streak: streak);
    }
  }

  void updateGemsCount(int gems) {
    if (_mounted) {
      state = state.copyWith(gemsCount: gems);
    }
  }

  void updateHintCount(int hints) {
    if (_mounted) {
      state = state.copyWith(hintCount: hints);
    }
  }

  void setLoading(bool loading) {
    if (_mounted) {
      state = state.copyWith(isLoading: loading);
    }
  }

  void reset() {
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

// Simplified home provider
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});

// Extension for easy access to home data
extension HomeProviderExtension on WidgetRef {
  HomeNotifier get homeNotifier => read(homeProvider.notifier);
  HomeState get homeState => watch(homeProvider);
}
