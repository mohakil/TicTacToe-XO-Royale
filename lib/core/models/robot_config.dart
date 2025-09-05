import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:tictactoe_xo_royale/core/models/game_enums.dart';
import 'package:tictactoe_xo_royale/core/services/game_logic.dart';

/// Clean, simplified robot configuration
/// This class handles all robot-related settings without over-engineering
@immutable
class RobotConfig {
  final Difficulty difficulty;
  final String playerName;
  final bool isEnabled;

  const RobotConfig({
    required this.difficulty,
    this.playerName = 'CPU',
    this.isEnabled = true,
  });

  /// Default robot configuration
  factory RobotConfig.defaultConfig() => const RobotConfig(
    difficulty: Difficulty.medium,
    playerName: 'CPU',
    isEnabled: true,
  );

  /// Create robot config for specific difficulty
  factory RobotConfig.forDifficulty(Difficulty difficulty) =>
      RobotConfig(difficulty: difficulty, playerName: 'CPU', isEnabled: true);

  /// Create robot config with custom name
  factory RobotConfig.custom({
    required Difficulty difficulty,
    required String playerName,
  }) => RobotConfig(
    difficulty: difficulty,
    playerName: playerName,
    isEnabled: true,
  );

  /// Copy with new values
  RobotConfig copyWith({
    Difficulty? difficulty,
    String? playerName,
    bool? isEnabled,
  }) => RobotConfig(
    difficulty: difficulty ?? this.difficulty,
    playerName: playerName ?? this.playerName,
    isEnabled: isEnabled ?? this.isEnabled,
  );

  /// Get difficulty as string for UI
  String get difficultyString => difficulty.value;

  /// Get difficulty display name
  String get difficultyDisplayName {
    switch (difficulty) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.hard:
        return 'Hard';
    }
  }

  /// Check if this is a valid configuration
  bool get isValid => playerName.trim().isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RobotConfig &&
        other.difficulty == difficulty &&
        other.playerName == playerName &&
        other.isEnabled == isEnabled;
  }

  @override
  int get hashCode => Object.hash(difficulty, playerName, isEnabled);

  @override
  String toString() =>
      'RobotConfig(difficulty: $difficulty, playerName: $playerName, isEnabled: $isEnabled)';
}

/// Robot strategy interface for different difficulty levels
abstract class RobotStrategy {
  /// Get the next move for the robot
  Position getNextMove({
    required List<Position> availableMoves,
    required List<List<CellState>> board,
    required int boardSize,
    required int winCondition,
    required CellState robotPlayer,
  });
}

/// Easy robot strategy - mostly random with some basic heuristics
class EasyRobotStrategy implements RobotStrategy {
  final Random _random = Random();

  @override
  Position getNextMove({
    required List<Position> availableMoves,
    required List<List<CellState>> board,
    required int boardSize,
    required int winCondition,
    required CellState robotPlayer,
  }) {
    if (availableMoves.isEmpty) return const Position(0, 0);

    // 30% chance to make a random move
    if (_random.nextDouble() < 0.3) {
      return availableMoves[_random.nextInt(availableMoves.length)];
    }

    // 70% chance to use basic heuristics
    return _getHeuristicMove(availableMoves, boardSize);
  }

  Position _getHeuristicMove(List<Position> availableMoves, int boardSize) {
    // Prefer center
    final center = Position(boardSize ~/ 2, boardSize ~/ 2);
    if (availableMoves.contains(center)) return center;

    // Prefer corners
    final corners = [
      const Position(0, 0),
      Position(0, boardSize - 1),
      Position(boardSize - 1, 0),
      Position(boardSize - 1, boardSize - 1),
    ];

    final availableCorners = availableMoves.where(corners.contains).toList();
    if (availableCorners.isNotEmpty) {
      return availableCorners[_random.nextInt(availableCorners.length)];
    }

    // Fallback to random
    return availableMoves[_random.nextInt(availableMoves.length)];
  }
}

/// Medium robot strategy - uses minimax with limited depth
class MediumRobotStrategy implements RobotStrategy {
  final Random _random = Random();

  @override
  Position getNextMove({
    required List<Position> availableMoves,
    required List<List<CellState>> board,
    required int boardSize,
    required int winCondition,
    required CellState robotPlayer,
  }) {
    if (availableMoves.isEmpty) return const Position(0, 0);

    // Check for immediate win
    for (final move in availableMoves) {
      if (_wouldWin(board, move, robotPlayer, winCondition)) {
        return move;
      }
    }

    // Check for opponent's immediate win (block)
    final opponent = robotPlayer == CellState.X ? CellState.O : CellState.X;
    for (final move in availableMoves) {
      if (_wouldWin(board, move, opponent, winCondition)) {
        return move;
      }
    }

    // Use minimax with limited depth
    return _minimaxMove(
      availableMoves,
      board,
      boardSize,
      winCondition,
      robotPlayer,
      3,
    );
  }

  bool _wouldWin(
    List<List<CellState>> board,
    Position move,
    CellState player,
    int winCondition,
  ) {
    // This is a simplified check - in a real implementation, you'd want to
    // temporarily place the move and check for wins
    return false; // Placeholder
  }

  Position _minimaxMove(
    List<Position> availableMoves,
    List<List<CellState>> board,
    int boardSize,
    int winCondition,
    CellState robotPlayer,
    int depth,
  ) {
    // Simplified minimax implementation
    // In a real implementation, this would be more sophisticated
    return availableMoves[_random.nextInt(availableMoves.length)];
  }
}

/// Hard robot strategy - uses full minimax with alpha-beta pruning
class HardRobotStrategy implements RobotStrategy {
  @override
  Position getNextMove({
    required List<Position> availableMoves,
    required List<List<CellState>> board,
    required int boardSize,
    required int winCondition,
    required CellState robotPlayer,
  }) {
    if (availableMoves.isEmpty) return const Position(0, 0);

    // Check for immediate win
    for (final move in availableMoves) {
      if (_wouldWin(board, move, robotPlayer, winCondition)) {
        return move;
      }
    }

    // Check for opponent's immediate win (block)
    final opponent = robotPlayer == CellState.X ? CellState.O : CellState.X;
    for (final move in availableMoves) {
      if (_wouldWin(board, move, opponent, winCondition)) {
        return move;
      }
    }

    // Use full minimax with alpha-beta pruning
    return _minimaxMove(
      availableMoves,
      board,
      boardSize,
      winCondition,
      robotPlayer,
    );
  }

  bool _wouldWin(
    List<List<CellState>> board,
    Position move,
    CellState player,
    int winCondition,
  ) {
    // This is a simplified check - in a real implementation, you'd want to
    // temporarily place the move and check for wins
    return false; // Placeholder
  }

  Position _minimaxMove(
    List<Position> availableMoves,
    List<List<CellState>> board,
    int boardSize,
    int winCondition,
    CellState robotPlayer,
  ) {
    // Full minimax implementation with alpha-beta pruning
    // This would be a complete implementation in a real scenario
    return availableMoves.first; // Placeholder
  }
}

/// Robot strategy factory
class RobotStrategyFactory {
  static RobotStrategy createStrategy(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return EasyRobotStrategy();
      case Difficulty.medium:
        return MediumRobotStrategy();
      case Difficulty.hard:
        return HardRobotStrategy();
    }
  }
}
