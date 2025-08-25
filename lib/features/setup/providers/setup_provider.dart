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

enum FirstMove { x, o, random }

enum Difficulty { easy, medium, hard }

enum BoardSize { threeByThree, fourByFour, fiveByFive }

enum WinCondition { threeInRow, fourInRow, fiveInRow }

class SetupNotifier extends StateNotifier<GameSetup> {
  SetupNotifier() : super(const GameSetup());

  void setMode(GameMode mode) {
    state = state.copyWith(mode: mode);
    // Reset player 2 name for robot mode
    if (mode == GameMode.robot) {
      state = state.copyWith(player2Name: 'CPU');
    } else {
      state = state.copyWith(player2Name: 'Player 2');
    }
  }

  void setPlayer1Name(String name) {
    state = state.copyWith(player1Name: name);
  }

  void setPlayer2Name(String name) {
    state = state.copyWith(player2Name: name);
  }

  void setFirstMove(FirstMove firstMove) {
    state = state.copyWith(firstMove: firstMove);
  }

  void setDifficulty(Difficulty difficulty) {
    state = state.copyWith(difficulty: difficulty);
  }

  void setBoardSize(BoardSize boardSize) {
    state = state.copyWith(boardSize: boardSize);
    // Adjust win condition if needed
    if (boardSize == BoardSize.threeByThree &&
        state.winCondition == WinCondition.fourInRow) {
      state = state.copyWith(winCondition: WinCondition.threeInRow);
    } else if (boardSize == BoardSize.fourByFour &&
        state.winCondition == WinCondition.fiveInRow) {
      state = state.copyWith(winCondition: WinCondition.fourInRow);
    }
  }

  void setWinCondition(WinCondition winCondition) {
    // Validate win condition against board size
    if (state.boardSize == BoardSize.threeByThree &&
        winCondition != WinCondition.threeInRow) {
      return; // Invalid combination
    }
    if (state.boardSize == BoardSize.fourByFour &&
        winCondition == WinCondition.fiveInRow) {
      return; // Invalid combination
    }
    state = state.copyWith(winCondition: winCondition);
  }

  bool get isValid {
    if (state.player1Name.trim().isEmpty) return false;
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

  String get gameModeValue {
    return state.mode == GameMode.robot ? 'robot' : 'local';
  }

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
      case FirstMove.x:
        return 'x';
      case FirstMove.o:
        return 'o';
      case FirstMove.random:
        return 'random';
    }
  }
}

final setupProvider = StateNotifierProvider<SetupNotifier, GameSetup>((ref) {
  return SetupNotifier();
});
