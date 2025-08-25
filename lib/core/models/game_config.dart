import 'package:flutter/foundation.dart';

enum GameMode { local, cpu, online }

enum FirstMove { player1, player2, random }

enum Difficulty { easy, medium, hard, impossible }

@immutable
class GameConfig {
  final int boardSize;
  final int winCondition;
  final GameMode gameMode;
  final FirstMove firstMove;
  final Difficulty difficulty;
  final String player1Name;
  final String player2Name;
  final bool isRobotMode;

  const GameConfig({
    required this.boardSize,
    required this.winCondition,
    required this.gameMode,
    required this.firstMove,
    required this.difficulty,
    required this.player1Name,
    required this.player2Name,
    required this.isRobotMode,
  });

  factory GameConfig.defaultConfig() {
    return const GameConfig(
      boardSize: 3,
      winCondition: 3,
      gameMode: GameMode.local,
      firstMove: FirstMove.player1,
      difficulty: Difficulty.medium,
      player1Name: 'Player 1',
      player2Name: 'Player 2',
      isRobotMode: false,
    );
  }

  factory GameConfig.cpuConfig({
    required Difficulty difficulty,
    int boardSize = 3,
    int winCondition = 3,
    String player1Name = 'You',
    String player2Name = 'CPU',
  }) {
    return GameConfig(
      boardSize: boardSize,
      winCondition: winCondition,
      gameMode: GameMode.cpu,
      firstMove: FirstMove.player1,
      difficulty: difficulty,
      player1Name: player1Name,
      player2Name: player2Name,
      isRobotMode: true,
    );
  }

  GameConfig copyWith({
    int? boardSize,
    int? winCondition,
    GameMode? gameMode,
    FirstMove? firstMove,
    Difficulty? difficulty,
    String? player1Name,
    String? player2Name,
    bool? isRobotMode,
  }) {
    return GameConfig(
      boardSize: boardSize ?? this.boardSize,
      winCondition: winCondition ?? this.winCondition,
      gameMode: gameMode ?? this.gameMode,
      firstMove: firstMove ?? this.firstMove,
      difficulty: difficulty ?? this.difficulty,
      player1Name: player1Name ?? this.player1Name,
      player2Name: player2Name ?? this.player2Name,
      isRobotMode: isRobotMode ?? this.isRobotMode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameConfig &&
        other.boardSize == boardSize &&
        other.winCondition == winCondition &&
        other.gameMode == gameMode &&
        other.firstMove == firstMove &&
        other.difficulty == difficulty &&
        other.player1Name == player1Name &&
        other.player2Name == player2Name &&
        other.isRobotMode == isRobotMode;
  }

  @override
  int get hashCode {
    return Object.hash(
      boardSize,
      winCondition,
      gameMode,
      firstMove,
      difficulty,
      player1Name,
      player2Name,
      isRobotMode,
    );
  }

  @override
  String toString() {
    return 'GameConfig(boardSize: $boardSize, winCondition: $winCondition, gameMode: $gameMode, firstMove: $firstMove, difficulty: $difficulty, player1Name: $player1Name, player2Name: $player2Name, isRobotMode: $isRobotMode)';
  }
}
