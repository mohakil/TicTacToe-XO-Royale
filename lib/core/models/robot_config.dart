import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:tictactoe_xo_royale/core/models/game_enums.dart';
import 'package:tictactoe_xo_royale/core/services/game_logic.dart';

/// Clean, simplified robot configuration
/// This class handles all robot-related settings without over-engineering
@immutable
class RobotConfig {
  static const String defaultPlayerName = 'Robot';

  final Difficulty difficulty;
  final String playerName;
  final bool isEnabled;

  const RobotConfig({
    required this.difficulty,
    this.playerName = defaultPlayerName,
    this.isEnabled = true,
  });

  /// Default robot configuration
  factory RobotConfig.defaultConfig() => const RobotConfig(
    difficulty: Difficulty.medium,
    playerName: defaultPlayerName,
    isEnabled: true,
  );

  /// Create robot config for specific difficulty
  factory RobotConfig.forDifficulty(Difficulty difficulty) => RobotConfig(
    difficulty: difficulty,
    playerName: defaultPlayerName,
    isEnabled: true,
  );

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
    // Create a temporary board with the move
    final tempBoard = _copyBoard(board);
    tempBoard[move.row][move.col] = player;

    // Check all directions for a win
    return _checkWin(tempBoard, move, player, winCondition);
  }

  /// Check if there's a win at the given position
  bool _checkWin(
    List<List<CellState>> board,
    Position move,
    CellState player,
    int winCondition,
  ) {
    final boardSize = board.length;

    // Check horizontal line
    if (_countInDirection(
          board,
          move,
          const Position(0, 1),
          player,
          boardSize,
        ) >=
        winCondition) {
      return true;
    }

    // Check vertical line
    if (_countInDirection(
          board,
          move,
          const Position(1, 0),
          player,
          boardSize,
        ) >=
        winCondition) {
      return true;
    }

    // Check main diagonal (top-left to bottom-right)
    if (_countInDirection(
          board,
          move,
          const Position(1, 1),
          player,
          boardSize,
        ) >=
        winCondition) {
      return true;
    }

    // Check anti-diagonal (top-right to bottom-left)
    if (_countInDirection(
          board,
          move,
          const Position(1, -1),
          player,
          boardSize,
        ) >=
        winCondition) {
      return true;
    }

    return false;
  }

  Position _minimaxMove(
    List<Position> availableMoves,
    List<List<CellState>> board,
    int boardSize,
    int winCondition,
    CellState robotPlayer,
    int depth,
  ) {
    // Simplified minimax implementation with basic heuristics
    var bestMove = availableMoves.first;
    var bestScore = -1000;

    for (final move in availableMoves) {
      final score = _evaluateMove(
        board,
        move,
        robotPlayer,
        winCondition,
        boardSize,
      );
      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }

    return bestMove;
  }

  /// Evaluate a move based on strategic value
  int _evaluateMove(
    List<List<CellState>> board,
    Position move,
    CellState player,
    int winCondition,
    int boardSize,
  ) {
    var score = 0;

    // Prefer center positions
    final center = Position(boardSize ~/ 2, boardSize ~/ 2);
    if (move == center) score += 10;

    // Prefer corner positions
    final corners = [
      const Position(0, 0),
      Position(0, boardSize - 1),
      Position(boardSize - 1, 0),
      Position(boardSize - 1, boardSize - 1),
    ];
    if (corners.contains(move)) score += 5;

    // Check for potential wins
    if (_wouldWin(board, move, player, winCondition)) {
      score += 100;
    }

    // Check for opponent's potential wins (blocking)
    final opponent = player == CellState.X ? CellState.O : CellState.X;
    if (_wouldWin(board, move, opponent, winCondition)) {
      score += 50;
    }

    return score;
  }

  /// Count consecutive pieces in a direction
  int _countInDirection(
    List<List<CellState>> board,
    Position start,
    Position direction,
    CellState player,
    int boardSize,
  ) {
    var count = 1; // Count the starting position

    // Count in positive direction
    var pos = Position(start.row + direction.row, start.col + direction.col);
    while (_isValidPosition(pos, boardSize) &&
        board[pos.row][pos.col] == player) {
      count++;
      pos = Position(pos.row + direction.row, pos.col + direction.col);
    }

    // Count in negative direction
    pos = Position(start.row - direction.row, start.col - direction.col);
    while (_isValidPosition(pos, boardSize) &&
        board[pos.row][pos.col] == player) {
      count++;
      pos = Position(pos.row - direction.row, pos.col - direction.col);
    }

    return count;
  }

  /// Check if position is valid
  bool _isValidPosition(Position pos, int boardSize) {
    return pos.row >= 0 &&
        pos.row < boardSize &&
        pos.col >= 0 &&
        pos.col < boardSize;
  }

  /// Create a deep copy of the board
  List<List<CellState>> _copyBoard(List<List<CellState>> board) {
    return board.map((row) => List<CellState>.from(row)).toList();
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
    // Create a temporary board with the move
    final tempBoard = _copyBoard(board);
    tempBoard[move.row][move.col] = player;

    // Check all directions for a win
    return _checkWin(tempBoard, move, player, winCondition);
  }

  /// Check if there's a win at the given position
  bool _checkWin(
    List<List<CellState>> board,
    Position move,
    CellState player,
    int winCondition,
  ) {
    final boardSize = board.length;

    // Check horizontal line
    if (_countInDirection(
          board,
          move,
          const Position(0, 1),
          player,
          boardSize,
        ) >=
        winCondition) {
      return true;
    }

    // Check vertical line
    if (_countInDirection(
          board,
          move,
          const Position(1, 0),
          player,
          boardSize,
        ) >=
        winCondition) {
      return true;
    }

    // Check main diagonal (top-left to bottom-right)
    if (_countInDirection(
          board,
          move,
          const Position(1, 1),
          player,
          boardSize,
        ) >=
        winCondition) {
      return true;
    }

    // Check anti-diagonal (top-right to bottom-left)
    if (_countInDirection(
          board,
          move,
          const Position(1, -1),
          player,
          boardSize,
        ) >=
        winCondition) {
      return true;
    }

    return false;
  }

  Position _minimaxMove(
    List<Position> availableMoves,
    List<List<CellState>> board,
    int boardSize,
    int winCondition,
    CellState robotPlayer,
  ) {
    // Full minimax implementation with alpha-beta pruning
    var bestMove = availableMoves.first;
    var bestScore = -1000;

    for (final move in availableMoves) {
      final tempBoard = _copyBoard(board);
      tempBoard[move.row][move.col] = robotPlayer;

      final score = _minimax(
        tempBoard,
        boardSize,
        winCondition,
        robotPlayer,
        false,
        -1000,
        1000,
        0,
      );

      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }

    return bestMove;
  }

  /// Minimax algorithm with alpha-beta pruning
  int _minimax(
    List<List<CellState>> board,
    int boardSize,
    int winCondition,
    CellState player,
    bool isMaximizing,
    int alpha,
    int beta,
    int depth,
  ) {
    // Check for terminal states
    final gameResult = _checkGameState(board, boardSize, winCondition);
    if (gameResult != null) {
      return gameResult;
    }

    // Limit depth to prevent excessive computation
    if (depth >= 6) {
      return _evaluateBoard(board, boardSize, winCondition, player);
    }

    final availableMoves = _getAvailableMoves(board, boardSize);
    if (availableMoves.isEmpty) {
      return 0; // Draw
    }

    if (isMaximizing) {
      var maxEval = -1000;
      for (final move in availableMoves) {
        final tempBoard = _copyBoard(board);
        tempBoard[move.row][move.col] = player;

        final eval = _minimax(
          tempBoard,
          boardSize,
          winCondition,
          player,
          false,
          alpha,
          beta,
          depth + 1,
        );

        maxEval = maxEval > eval ? maxEval : eval;
        alpha = alpha > eval ? alpha : eval;

        if (beta <= alpha) break; // Alpha-beta pruning
      }
      return maxEval;
    } else {
      var minEval = 1000;
      final opponent = player == CellState.X ? CellState.O : CellState.X;

      for (final move in availableMoves) {
        final tempBoard = _copyBoard(board);
        tempBoard[move.row][move.col] = opponent;

        final eval = _minimax(
          tempBoard,
          boardSize,
          winCondition,
          player,
          true,
          alpha,
          beta,
          depth + 1,
        );

        minEval = minEval < eval ? minEval : eval;
        beta = beta < eval ? beta : eval;

        if (beta <= alpha) break; // Alpha-beta pruning
      }
      return minEval;
    }
  }

  /// Check game state for terminal conditions
  int? _checkGameState(
    List<List<CellState>> board,
    int boardSize,
    int winCondition,
  ) {
    // Check for wins
    for (var row = 0; row < boardSize; row++) {
      for (var col = 0; col < boardSize; col++) {
        if (board[row][col] != CellState.empty) {
          if (_checkWin(
            board,
            Position(row, col),
            board[row][col],
            winCondition,
          )) {
            return board[row][col] == CellState.X ? 100 : -100;
          }
        }
      }
    }
    return null;
  }

  /// Evaluate board position
  int _evaluateBoard(
    List<List<CellState>> board,
    int boardSize,
    int winCondition,
    CellState player,
  ) {
    var score = 0;

    // Evaluate based on potential wins and strategic positions
    for (var row = 0; row < boardSize; row++) {
      for (var col = 0; col < boardSize; col++) {
        if (board[row][col] != CellState.empty) {
          final position = Position(row, col);
          final cellPlayer = board[row][col];
          final multiplier = cellPlayer == player ? 1 : -1;

          // Count potential in all directions
          final directions = [
            const Position(0, 1), // Horizontal
            const Position(1, 0), // Vertical
            const Position(1, 1), // Diagonal \
            const Position(1, -1), // Diagonal /
          ];

          for (final direction in directions) {
            final count = _countInDirection(
              board,
              position,
              direction,
              cellPlayer,
              boardSize,
            );
            score += count * multiplier;
          }
        }
      }
    }

    return score;
  }

  /// Get available moves
  List<Position> _getAvailableMoves(
    List<List<CellState>> board,
    int boardSize,
  ) {
    final moves = <Position>[];
    for (var row = 0; row < boardSize; row++) {
      for (var col = 0; col < boardSize; col++) {
        if (board[row][col] == CellState.empty) {
          moves.add(Position(row, col));
        }
      }
    }
    return moves;
  }

  /// Count consecutive pieces in a direction
  int _countInDirection(
    List<List<CellState>> board,
    Position start,
    Position direction,
    CellState player,
    int boardSize,
  ) {
    var count = 1; // Count the starting position

    // Count in positive direction
    var pos = Position(start.row + direction.row, start.col + direction.col);
    while (_isValidPosition(pos, boardSize) &&
        board[pos.row][pos.col] == player) {
      count++;
      pos = Position(pos.row + direction.row, pos.col + direction.col);
    }

    // Count in negative direction
    pos = Position(start.row - direction.row, start.col - direction.col);
    while (_isValidPosition(pos, boardSize) &&
        board[pos.row][pos.col] == player) {
      count++;
      pos = Position(pos.row - direction.row, pos.col - direction.col);
    }

    return count;
  }

  /// Check if position is valid
  bool _isValidPosition(Position pos, int boardSize) {
    return pos.row >= 0 &&
        pos.row < boardSize &&
        pos.col >= 0 &&
        pos.col < boardSize;
  }

  /// Create a deep copy of the board
  List<List<CellState>> _copyBoard(List<List<CellState>> board) {
    return board.map((row) => List<CellState>.from(row)).toList();
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
