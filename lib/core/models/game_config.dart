import 'package:flutter/foundation.dart';
import 'package:tictactoe_xo_royale/core/models/game_enums.dart';
import 'package:tictactoe_xo_royale/core/models/robot_config.dart';

@immutable
class GameConfig {
  final BoardSize boardSize;
  final WinCondition winCondition;
  final GameMode gameMode;
  final FirstMove firstMove;
  final String player1Name;
  final String player2Name;
  final RobotConfig? robotConfig;

  const GameConfig({
    required this.boardSize,
    required this.winCondition,
    required this.gameMode,
    required this.firstMove,
    required this.player1Name,
    required this.player2Name,
    this.robotConfig,
  });

  /// Get robot configuration, returns null if not in robot mode
  RobotConfig? get robot => gameMode == GameMode.robot ? robotConfig : null;

  /// Check if this is robot mode
  bool get isRobotMode => gameMode == GameMode.robot;

  /// Get difficulty level (for backward compatibility)
  Difficulty get difficulty => robotConfig?.difficulty ?? Difficulty.medium;

  factory GameConfig.defaultConfig() => const GameConfig(
    boardSize: BoardSize.threeByThree,
    winCondition: WinCondition.threeInRow,
    gameMode: GameMode.local,
    firstMove: FirstMove.player1,
    player1Name: 'Player 1',
    player2Name: 'Player 2',
  );

  factory GameConfig.robotConfig({
    required Difficulty difficulty,
    BoardSize boardSize = BoardSize.threeByThree,
    WinCondition winCondition = WinCondition.threeInRow,
    String player1Name = 'You',
    String player2Name = 'CPU',
    FirstMove firstMove = FirstMove.player1,
  }) => GameConfig(
    boardSize: boardSize,
    winCondition: winCondition,
    gameMode: GameMode.robot,
    firstMove: firstMove,
    player1Name: player1Name,
    player2Name: player2Name,
    robotConfig: RobotConfig.forDifficulty(difficulty),
  );

  /// Legacy method for backward compatibility
  factory GameConfig.cpuConfig({
    required Difficulty difficulty,
    BoardSize boardSize = BoardSize.threeByThree,
    WinCondition winCondition = WinCondition.threeInRow,
    String player1Name = 'You',
    String player2Name = 'CPU',
    FirstMove firstMove = FirstMove.player1,
  }) => GameConfig.robotConfig(
    difficulty: difficulty,
    boardSize: boardSize,
    winCondition: winCondition,
    player1Name: player1Name,
    player2Name: player2Name,
    firstMove: firstMove,
  );

  GameConfig copyWith({
    BoardSize? boardSize,
    WinCondition? winCondition,
    GameMode? gameMode,
    FirstMove? firstMove,
    String? player1Name,
    String? player2Name,
    RobotConfig? robotConfig,
  }) => GameConfig(
    boardSize: boardSize ?? this.boardSize,
    winCondition: winCondition ?? this.winCondition,
    gameMode: gameMode ?? this.gameMode,
    firstMove: firstMove ?? this.firstMove,
    player1Name: player1Name ?? this.player1Name,
    player2Name: player2Name ?? this.player2Name,
    robotConfig: robotConfig ?? this.robotConfig,
  );

  // Helper methods using extension methods
  int get boardSizeValue => boardSize.value;
  int get winConditionValue => winCondition.value;

  // Validation methods
  bool get isValid {
    if (player1Name.trim().isEmpty) return false;
    if (gameMode == GameMode.local && player2Name.trim().isEmpty) return false;
    if (gameMode == GameMode.robot && robotConfig == null) return false;
    if (gameMode == GameMode.robot && !robotConfig!.isValid) return false;
    return winCondition.isValidForBoardSize(boardSize);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameConfig &&
        other.boardSize == boardSize &&
        other.winCondition == winCondition &&
        other.gameMode == gameMode &&
        other.firstMove == firstMove &&
        other.player1Name == player1Name &&
        other.player2Name == player2Name &&
        other.robotConfig == robotConfig;
  }

  @override
  int get hashCode => Object.hash(
    boardSize,
    winCondition,
    gameMode,
    firstMove,
    player1Name,
    player2Name,
    robotConfig,
  );

  @override
  String toString() =>
      'GameConfig('
      'boardSize: $boardSize, '
      'winCondition: $winCondition, '
      'gameMode: $gameMode, '
      'firstMove: $firstMove, '
      'player1Name: $player1Name, '
      'player2Name: $player2Name, '
      'robotConfig: $robotConfig'
      ')';
}
