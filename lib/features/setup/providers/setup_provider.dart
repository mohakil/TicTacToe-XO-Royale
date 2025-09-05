import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/models/game_enums.dart';
import 'package:tictactoe_xo_royale/core/models/robot_config.dart';

/// Simplified game setup state
class GameSetup {
  final GameMode mode;
  final String player1Name;
  final String player2Name;
  final FirstMove firstMove;
  final Difficulty difficulty;
  final BoardSize boardSize;
  final WinCondition winCondition;

  const GameSetup({
    this.mode = GameMode.local,
    this.player1Name = 'Player 1',
    this.player2Name = 'Player 2',
    this.firstMove = FirstMove.random,
    this.difficulty = Difficulty.medium,
    this.boardSize = BoardSize.threeByThree,
    this.winCondition = WinCondition.threeInRow,
  });

  GameSetup copyWith({
    GameMode? mode,
    String? player1Name,
    String? player2Name,
    FirstMove? firstMove,
    Difficulty? difficulty,
    BoardSize? boardSize,
    WinCondition? winCondition,
  }) {
    return GameSetup(
      mode: mode ?? this.mode,
      player1Name: player1Name ?? this.player1Name,
      player2Name: player2Name ?? this.player2Name,
      firstMove: firstMove ?? this.firstMove,
      difficulty: difficulty ?? this.difficulty,
      boardSize: boardSize ?? this.boardSize,
      winCondition: winCondition ?? this.winCondition,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameSetup &&
        other.mode == mode &&
        other.player1Name == player1Name &&
        other.player2Name == player2Name &&
        other.firstMove == firstMove &&
        other.difficulty == difficulty &&
        other.boardSize == boardSize &&
        other.winCondition == winCondition;
  }

  @override
  int get hashCode => Object.hash(
    mode,
    player1Name,
    player2Name,
    firstMove,
    difficulty,
    boardSize,
    winCondition,
  );
}

/// Simplified setup notifier without over-engineering
class SetupNotifier extends StateNotifier<GameSetup> {
  SetupNotifier() : super(const GameSetup());

  void setMode(GameMode mode) {
    state = state.copyWith(mode: mode);

    // Auto-update player 2 name based on mode
    if (mode == GameMode.robot) {
      state = state.copyWith(player2Name: 'CPU');
    } else {
      state = state.copyWith(player2Name: 'Player 2');
    }
  }

  void setPlayer1Name(String name) {
    if (name.trim().isNotEmpty) {
      state = state.copyWith(player1Name: name.trim());
    }
  }

  void setPlayer2Name(String name) {
    if (name.trim().isNotEmpty) {
      state = state.copyWith(player2Name: name.trim());
    }
  }

  void setFirstMove(FirstMove firstMove) {
    state = state.copyWith(firstMove: firstMove);
  }

  void setDifficulty(Difficulty difficulty) {
    state = state.copyWith(difficulty: difficulty);
  }

  void setBoardSize(BoardSize boardSize) {
    state = state.copyWith(boardSize: boardSize);

    // Auto-adjust win condition if invalid
    if (!state.winCondition.isValidForBoardSize(boardSize)) {
      final newWinCondition = _getValidWinCondition(boardSize);
      state = state.copyWith(winCondition: newWinCondition);
    }
  }

  void setWinCondition(WinCondition winCondition) {
    if (winCondition.isValidForBoardSize(state.boardSize)) {
      state = state.copyWith(winCondition: winCondition);
    }
  }

  /// Get a valid win condition for the given board size
  WinCondition _getValidWinCondition(BoardSize boardSize) {
    switch (boardSize) {
      case BoardSize.threeByThree:
        return WinCondition.threeInRow;
      case BoardSize.fourByFour:
        return WinCondition.threeInRow;
      case BoardSize.fiveByFive:
        return WinCondition.threeInRow;
    }
  }

  /// Check if the current setup is valid
  bool get isValid {
    if (state.player1Name.trim().isEmpty) return false;
    if (state.mode == GameMode.local && state.player2Name.trim().isEmpty) {
      return false;
    }
    return state.winCondition.isValidForBoardSize(state.boardSize);
  }

  /// Get robot configuration if in robot mode
  RobotConfig? get robotConfig {
    if (state.mode == GameMode.robot) {
      return RobotConfig.forDifficulty(state.difficulty);
    }
    return null;
  }

  /// Reset to default values
  void reset() {
    state = const GameSetup();
  }
}

/// Main setup provider - simple and clean
final setupProvider = StateNotifierProvider<SetupNotifier, GameSetup>((ref) {
  return SetupNotifier();
});

/// Computed provider for validation
final setupIsValidProvider = Provider<bool>((ref) {
  return ref.watch(setupProvider.notifier).isValid;
});

/// Computed provider for robot configuration
final setupRobotConfigProvider = Provider<RobotConfig?>((ref) {
  return ref.watch(setupProvider.notifier).robotConfig;
});

/// Extension for easy access to setup data
extension SetupProviderExtension on WidgetRef {
  SetupNotifier get setupNotifier => read(setupProvider.notifier);
  GameSetup get setupState => watch(setupProvider);
  bool get setupIsValid => watch(setupIsValidProvider);
  RobotConfig? get setupRobotConfig => watch(setupRobotConfigProvider);
}
