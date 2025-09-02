import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'setup_provider.freezed.dart';
part 'setup_provider.g.dart';

@freezed
abstract class GameSetup with _$GameSetup {
  const factory GameSetup({
    @Default(GameMode.local) GameMode mode,
    @Default('Player 1') String player1Name,
    @Default('Player 2') String player2Name,
    @Default(FirstMove.random) FirstMove firstMove,
    @Default(Difficulty.medium) Difficulty difficulty,
    @Default(BoardSize.threeByThree) BoardSize boardSize,
    @Default(WinCondition.threeInRow) WinCondition winCondition,
  }) = _GameSetup;

  factory GameSetup.fromJson(Map<String, dynamic> json) =>
      _$GameSetupFromJson(json);
}

enum GameMode { local, robot }

enum FirstMove { player1, player2, random }

enum Difficulty { easy, medium, hard }

enum BoardSize { threeByThree, fourByFour, fiveByFive }

enum WinCondition { threeInRow, fourInRow, fiveInRow }

class SetupNotifier extends StateNotifier<GameSetup> {
  SetupNotifier() : super(const GameSetup());

  // Mounted flag for proper disposal
  bool _mounted = true;

  void setMode(GameMode mode) {
    if (_mounted) {
      state = state.copyWith(mode: mode);
      // Reset player 2 name for robot mode
      if (mode == GameMode.robot) {
        state = state.copyWith(player2Name: 'CPU');
      } else {
        state = state.copyWith(player2Name: 'Player 2');
      }
    }
  }

  void setPlayer1Name(String name) {
    if (_mounted) {
      state = state.copyWith(player1Name: name);
    }
  }

  void setPlayer2Name(String name) {
    if (_mounted) {
      state = state.copyWith(player2Name: name);
    }
  }

  void setFirstMove(FirstMove firstMove) {
    if (_mounted) {
      state = state.copyWith(firstMove: firstMove);
    }
  }

  void setDifficulty(Difficulty difficulty) {
    if (_mounted) {
      state = state.copyWith(difficulty: difficulty);
    }
  }

  void setBoardSize(BoardSize boardSize) {
    // Don't update if the board size is the same or not mounted
    if (!_mounted || state.boardSize == boardSize) return;

    // Update board size first
    state = state.copyWith(boardSize: boardSize);

    // Automatically adjust win condition to be valid for the new board size
    WinCondition newWinCondition = state.winCondition;
    bool winConditionChanged = false;

    switch (boardSize) {
      case BoardSize.threeByThree:
        // 3x3 board can only have 3-in-row win condition
        if (newWinCondition != WinCondition.threeInRow) {
          newWinCondition = WinCondition.threeInRow;
          winConditionChanged = true;
        }
        break;
      case BoardSize.fourByFour:
        // 4x4 board can have 3-in-row or 4-in-row
        if (newWinCondition == WinCondition.fiveInRow) {
          newWinCondition = WinCondition.fourInRow;
          winConditionChanged = true;
        }
        break;
      case BoardSize.fiveByFive:
        // 5x5 board can have 3-in-row, 4-in-row, or 5-in-row
        // No adjustment needed, all win conditions are valid
        break;
    }

    // Update the win condition if it changed
    if (winConditionChanged && _mounted) {
      state = state.copyWith(winCondition: newWinCondition);
    }
  }

  void setWinCondition(WinCondition winCondition) {
    // Validate win condition against current board size
    bool isValidCombination = _isValidBoardWinCombination(
      state.boardSize,
      winCondition,
    );

    if (isValidCombination && _mounted) {
      state = state.copyWith(winCondition: winCondition);
    }
  }

  /// Check if a board size and win condition combination is valid
  bool _isValidBoardWinCombination(
    BoardSize boardSize,
    WinCondition winCondition,
  ) {
    switch (boardSize) {
      case BoardSize.threeByThree:
        return winCondition == WinCondition.threeInRow;
      case BoardSize.fourByFour:
        return winCondition == WinCondition.threeInRow ||
            winCondition == WinCondition.fourInRow;
      case BoardSize.fiveByFive:
        return winCondition == WinCondition.threeInRow ||
            winCondition == WinCondition.fourInRow ||
            winCondition == WinCondition.fiveInRow;
    }
  }

  bool get isValid {
    if (state.player1Name.trim().isEmpty) {
      return false;
    }
    if (state.mode == GameMode.local && state.player2Name.trim().isEmpty) {
      return false;
    }
    return true;
  }

  // Helper methods to convert enums to values for navigation
  int get boardSizeValue {
    switch (state.boardSize) {
      case BoardSize.threeByThree:
        return 3;
      case BoardSize.fourByFour:
        return 4;
      case BoardSize.fiveByFive:
        return 5;
    }
  }

  int get winConditionValue {
    switch (state.winCondition) {
      case WinCondition.threeInRow:
        return 3;
      case WinCondition.fourInRow:
        return 4;
      case WinCondition.fiveInRow:
        return 5;
    }
  }

  String get gameModeValue => state.mode == GameMode.robot ? 'robot' : 'local';

  String get difficultyValue {
    switch (state.difficulty) {
      case Difficulty.easy:
        return 'easy';
      case Difficulty.medium:
        return 'medium';
      case Difficulty.hard:
        return 'hard';
    }
  }

  String get firstMoveValue {
    switch (state.firstMove) {
      case FirstMove.player1:
        return 'player1';
      case FirstMove.player2:
        return 'player2';
      case FirstMove.random:
        return 'random';
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}

final setupProvider = StateNotifierProvider<SetupNotifier, GameSetup>(
  (ref) => SetupNotifier(),
);

// ✅ OPTIMIZED: Use select for granular rebuilds instead of individual providers
// Individual setup data providers for granular rebuilds
final setupModeProvider = Provider<GameMode>(
  (ref) => ref.watch(setupProvider.select((state) => state.mode)),
);

final setupPlayer1NameProvider = Provider<String>(
  (ref) => ref.watch(setupProvider.select((state) => state.player1Name)),
);

final setupPlayer2NameProvider = Provider<String>(
  (ref) => ref.watch(setupProvider.select((state) => state.player2Name)),
);

final setupFirstMoveProvider = Provider<FirstMove>(
  (ref) => ref.watch(setupProvider.select((state) => state.firstMove)),
);

final setupDifficultyProvider = Provider<Difficulty>(
  (ref) => ref.watch(setupProvider.select((state) => state.difficulty)),
);

final setupBoardSizeProvider = Provider<BoardSize>(
  (ref) => ref.watch(setupProvider.select((state) => state.boardSize)),
);

final setupWinConditionProvider = Provider<WinCondition>(
  (ref) => ref.watch(setupProvider.select((state) => state.winCondition)),
);

// ✅ OPTIMIZED: Computed providers using select for better performance
final setupIsValidProvider = Provider<bool>(
  (ref) => ref.watch(
    setupProvider.select((state) {
      if (state.player1Name.trim().isEmpty) {
        return false;
      }
      if (state.mode == GameMode.local && state.player2Name.trim().isEmpty) {
        return false;
      }
      return true;
    }),
  ),
);

final setupGameConfigProvider =
    Provider<
      ({
        int boardSize,
        int winCondition,
        String gameMode,
        String difficulty,
        String firstMove,
      })
    >(
      (ref) => ref.watch(
        setupProvider.select((state) {
          final notifier = ref.read(setupProvider.notifier);
          return (
            boardSize: notifier.boardSizeValue,
            winCondition: notifier.winConditionValue,
            gameMode: notifier.gameModeValue,
            difficulty: notifier.difficultyValue,
            firstMove: notifier.firstMoveValue,
          );
        }),
      ),
    );

// ✅ OPTIMIZED: Extension methods for easy access with select-based providers
extension SetupProviderExtension on WidgetRef {
  // Get setup notifier
  SetupNotifier get setupNotifier => read(setupProvider.notifier);

  // Get individual setup data using select for granular rebuilds
  GameMode get setupMode => watch(setupModeProvider);
  String get setupPlayer1Name => watch(setupPlayer1NameProvider);
  String get setupPlayer2Name => watch(setupPlayer2NameProvider);
  FirstMove get setupFirstMove => watch(setupFirstMoveProvider);
  Difficulty get setupDifficulty => watch(setupDifficultyProvider);
  BoardSize get setupBoardSize => watch(setupBoardSizeProvider);
  WinCondition get setupWinCondition => watch(setupWinConditionProvider);

  // Get computed setup data
  bool get setupIsValid => watch(setupIsValidProvider);
  ({
    int boardSize,
    int winCondition,
    String gameMode,
    String difficulty,
    String firstMove,
  })
  get setupGameConfig => watch(setupGameConfigProvider);

  // Get all setup state
  GameSetup get setupState => watch(setupProvider);
}
