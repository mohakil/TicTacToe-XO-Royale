import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tictactoe_xo_royale/core/providers/profile_provider.dart';
import 'package:tictactoe_xo_royale/core/database/database_providers.dart';
import 'package:tictactoe_xo_royale/core/database/app_database.dart' as db;

part 'home_provider.g.dart';

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
@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeState build() {
    ref.onDispose(() {
      _mounted = false;
    });
    return const HomeState();
  }

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
}

// Computed providers for real home stats data

// Provider for last game result
final lastGameResultProvider = FutureProvider.autoDispose<String?>((ref) async {
  try {
    final gameHistoryDao = ref.watch(gameHistoryDaoProvider);
    final lastGame = await gameHistoryDao.getLastGame('default_user');

    if (lastGame != null) {
      switch (lastGame.result) {
        case db.GameResult.win:
          return 'Win';
        case db.GameResult.loss:
          return 'Loss';
        case db.GameResult.draw:
          return 'Draw';
      }
    }
    return 'Win'; // Default if no games played
  } catch (e) {
    return 'Win'; // Fallback default
  }
});

// Provider for current streak
final homeStreakProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(profileStatsProvider.select((stats) => stats?.streak ?? 0));
});

// Provider for current gems
final homeGemsProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(profileGemsProvider);
});

// Provider for current hints
final homeHintsProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(profileHintsProvider);
});

// Combined home stats provider that watches all the above
final homeStatsProvider = Provider.autoDispose<HomeStats>((ref) {
  final lastResultAsync = ref.watch(lastGameResultProvider);
  final streak = ref.watch(homeStreakProvider);
  final gems = ref.watch(homeGemsProvider);
  final hints = ref.watch(homeHintsProvider);

  final lastResult = lastResultAsync.when(
    data: (result) => result ?? 'Win',
    loading: () => 'Win',
    error: (_, _) => 'Win',
  );

  return HomeStats(
    lastResult: lastResult,
    streak: streak,
    gemsCount: gems,
    hintCount: hints,
  );
});

// Data class for home stats
class HomeStats {
  const HomeStats({
    required this.lastResult,
    required this.streak,
    required this.gemsCount,
    required this.hintCount,
  });

  final String lastResult;
  final int streak;
  final int gemsCount;
  final int hintCount;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeStats &&
        other.lastResult == lastResult &&
        other.streak == streak &&
        other.gemsCount == gemsCount &&
        other.hintCount == hintCount;
  }

  @override
  int get hashCode => Object.hash(lastResult, streak, gemsCount, hintCount);
}

// Simplified home provider (auto-generated)

// Extension for easy access to home data
extension HomeProviderExtension on WidgetRef {
  HomeNotifier get homeNotifier => read(homeProvider.notifier);
  HomeState get homeState => watch(homeProvider);

  // Access to real home stats
  HomeStats get homeStats => watch(homeStatsProvider);
  String get lastGameResult => watch(lastGameResultProvider).when(
    data: (result) => result ?? 'Win',
    loading: () => 'Win',
    error: (_, _) => 'Win',
  );
  int get homeStreak => watch(homeStreakProvider);
  int get homeGems => watch(homeGemsProvider);
  int get homeHints => watch(homeHintsProvider);
}
