import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingState {
  final double progress;
  final bool isLoading;
  final String? error;

  const LoadingState({this.progress = 0.0, this.isLoading = true, this.error});

  LoadingState copyWith({double? progress, bool? isLoading, String? error}) =>
      LoadingState(
        progress: progress ?? this.progress,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );
}

class LoadingNotifier extends StateNotifier<LoadingState> {
  LoadingNotifier() : super(const LoadingState());

  void startLoading() {
    state = const LoadingState();
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    // Simulate loading progress
    for (var i = 0; i <= 100; i += 2) {
      if (!state.isLoading) {
        break;
      }

      await Future.delayed(const Duration(milliseconds: 50));
      state = state.copyWith(progress: i / 100);
    }

    // Complete loading
    state = state.copyWith(isLoading: false, progress: 1);
  }

  void setProgress(double progress) {
    state = state.copyWith(progress: progress);
  }

  void setError(String error) {
    state = state.copyWith(error: error, isLoading: false);
  }

  void reset() {
    state = const LoadingState();
  }
}

final loadingProvider = StateNotifierProvider<LoadingNotifier, LoadingState>(
  (ref) => LoadingNotifier(),
);
