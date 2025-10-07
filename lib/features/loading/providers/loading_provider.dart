import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loading_provider.g.dart';

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

@riverpod
class LoadingNotifier extends _$LoadingNotifier {
  @override
  LoadingState build() {
    ref.onDispose(() {
      _mounted = false;
    });
    return const LoadingState();
  }

  // Mounted flag for proper disposal
  bool _mounted = true;

  void startLoading() {
    if (_mounted) {
      state = const LoadingState();
      _simulateLoading();
    }
  }

  Future<void> _simulateLoading() async {
    // Simulate loading progress
    for (var i = 0; i <= 100; i += 2) {
      if (!_mounted || !state.isLoading) {
        break;
      }

      await Future.delayed(const Duration(milliseconds: 50));
      if (_mounted) {
        state = state.copyWith(progress: i / 100);
      }
    }

    // Complete loading
    if (_mounted) {
      state = state.copyWith(isLoading: false, progress: 1);
    }
  }

  void setProgress(double progress) {
    if (_mounted) {
      state = state.copyWith(progress: progress);
    }
  }

  void setError(String error) {
    if (_mounted) {
      state = state.copyWith(error: error, isLoading: false);
    }
  }

  void reset() {
    if (_mounted) {
      state = const LoadingState();
    }
  }
}

// Simplified loading provider (auto-generated)
