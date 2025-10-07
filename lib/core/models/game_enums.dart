/// Game mode types
enum GameMode { local, robot }

/// First move options
enum FirstMove { player1, player2, random }

/// Robot difficulty levels
enum Difficulty { easy, medium, hard }

/// Board size options
enum BoardSize { threeByThree, fourByFour, fiveByFive }

/// Win condition options
enum WinCondition { threeInRow, fourInRow, fiveInRow }

/// Extension methods for enum conversions and utilities
extension GameModeExtension on GameMode {
  String get value {
    switch (this) {
      case GameMode.local:
        return 'local';
      case GameMode.robot:
        return 'robot';
    }
  }

  static GameMode fromString(String value) {
    switch (value.toLowerCase()) {
      case 'local':
        return GameMode.local;
      case 'robot':
        return GameMode.robot;
      default:
        return GameMode.local;
    }
  }
}

extension FirstMoveExtension on FirstMove {
  String get value {
    switch (this) {
      case FirstMove.player1:
        return 'player1';
      case FirstMove.player2:
        return 'player2';
      case FirstMove.random:
        return 'random';
    }
  }

  static FirstMove fromString(String value) {
    switch (value.toLowerCase()) {
      case 'player1':
        return FirstMove.player1;
      case 'player2':
        return FirstMove.player2;
      case 'random':
        return FirstMove.random;
      default:
        return FirstMove.random;
    }
  }
}

extension DifficultyExtension on Difficulty {
  String get value {
    switch (this) {
      case Difficulty.easy:
        return 'easy';
      case Difficulty.medium:
        return 'medium';
      case Difficulty.hard:
        return 'hard';
    }
  }

  static Difficulty fromString(String value) {
    switch (value.toLowerCase()) {
      case 'easy':
        return Difficulty.easy;
      case 'medium':
        return Difficulty.medium;
      case 'hard':
        return Difficulty.hard;
      default:
        return Difficulty.medium;
    }
  }
}

extension BoardSizeExtension on BoardSize {
  int get value {
    switch (this) {
      case BoardSize.threeByThree:
        return 3;
      case BoardSize.fourByFour:
        return 4;
      case BoardSize.fiveByFive:
        return 5;
    }
  }

  static BoardSize fromInt(int value) {
    switch (value) {
      case 3:
        return BoardSize.threeByThree;
      case 4:
        return BoardSize.fourByFour;
      case 5:
        return BoardSize.fiveByFive;
      default:
        return BoardSize.threeByThree;
    }
  }
}

extension WinConditionExtension on WinCondition {
  int get value {
    switch (this) {
      case WinCondition.threeInRow:
        return 3;
      case WinCondition.fourInRow:
        return 4;
      case WinCondition.fiveInRow:
        return 5;
    }
  }

  static WinCondition fromInt(int value) {
    switch (value) {
      case 3:
        return WinCondition.threeInRow;
      case 4:
        return WinCondition.fourInRow;
      case 5:
        return WinCondition.fiveInRow;
      default:
        return WinCondition.threeInRow;
    }
  }

  /// Check if this win condition is valid for the given board size
  bool isValidForBoardSize(BoardSize boardSize) {
    switch (boardSize) {
      case BoardSize.threeByThree:
        return this == WinCondition.threeInRow;
      case BoardSize.fourByFour:
        return this == WinCondition.threeInRow ||
            this == WinCondition.fourInRow;
      case BoardSize.fiveByFive:
        return true; // All win conditions are valid for 5x5
    }
  }
}
