import 'dart:math';

import '../models/game_config.dart';
import 'game_logic.dart';

/// Robot AI service for different difficulty levels
class RobotLogic {
  final GameConfig config;
  final GameLogic gameLogic;
  final Random _random = Random();

  RobotLogic(this.config, this.gameLogic);

  /// Get the next move for the robot based on difficulty
  Position getNextMove(CellState robotPlayer) {
    switch (config.difficulty) {
      case Difficulty.easy:
        return _getEasyMove(robotPlayer);
      case Difficulty.medium:
        return _getMediumMove(robotPlayer);
      case Difficulty.hard:
        return _getHardMove(robotPlayer);
      default:
        return _getEasyMove(robotPlayer);
    }
  }

  /// Easy AI: Random with light heuristics and 10-20% intentional blunders
  Position _getEasyMove(CellState robotPlayer) {
    final availableMoves = gameLogic.getAvailableMoves();
    if (availableMoves.isEmpty) return const Position(0, 0);

    // 15% chance to make an intentional blunder
    if (_random.nextDouble() < 0.15) {
      return _getBlunderMove(robotPlayer, availableMoves);
    }

    // 85% chance to use light heuristics
    return _getHeuristicMove(robotPlayer, availableMoves);
  }

  /// Get a blunder move (intentionally bad)
  Position _getBlunderMove(
    CellState robotPlayer,
    List<Position> availableMoves,
  ) {
    // Find moves that would let the opponent win
    final opponent = GameLogic.getOpponent(robotPlayer);
    final opponentWinningMoves = <Position>[];

    for (final move in availableMoves) {
      gameLogic.makeMove(move, robotPlayer);
      final result = gameLogic.checkGameState();
      gameLogic.undoMove(move);

      if (result.isWin && result.winner == opponent) {
        opponentWinningMoves.add(move);
      }
    }

    // If there are opponent winning moves, choose one randomly
    if (opponentWinningMoves.isNotEmpty) {
      return opponentWinningMoves[_random.nextInt(opponentWinningMoves.length)];
    }

    // Otherwise, just pick a random move
    return availableMoves[_random.nextInt(availableMoves.length)];
  }

  /// Get a heuristic-based move for easy AI
  Position _getHeuristicMove(
    CellState robotPlayer,
    List<Position> availableMoves,
  ) {
    // Priority: center > corners > edges > random
    final center = PositionExtensions.getCenter(gameLogic.boardSize);
    if (availableMoves.contains(center)) {
      return center;
    }

    final corners = PositionExtensions.getCorners(gameLogic.boardSize);
    final availableCorners = availableMoves
        .where((move) => corners.contains(move))
        .toList();
    if (availableCorners.isNotEmpty) {
      return availableCorners[_random.nextInt(availableCorners.length)];
    }

    final edges = PositionExtensions.getEdges(gameLogic.boardSize);
    final availableEdges = availableMoves
        .where((move) => edges.contains(move))
        .toList();
    if (availableEdges.isNotEmpty) {
      return availableEdges[_random.nextInt(availableEdges.length)];
    }

    // Fallback to random
    return availableMoves[_random.nextInt(availableMoves.length)];
  }

  /// Medium AI: Minimax with limited depth, avoid obvious traps
  Position _getMediumMove(CellState robotPlayer) {
    final availableMoves = gameLogic.getAvailableMoves();
    if (availableMoves.isEmpty) return const Position(0, 0);

    // Use minimax with limited depth (3-4 moves ahead)
    final maxDepth = min(4, availableMoves.length);
    Position? bestMove;
    int bestScore = -1000;

    for (final move in availableMoves) {
      gameLogic.makeMove(move, robotPlayer);
      final score = _minimax(
        GameLogic.getOpponent(robotPlayer),
        maxDepth - 1,
        false,
        -1000,
        1000,
      );
      gameLogic.undoMove(move);

      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }

    return bestMove ?? availableMoves[0];
  }

  /// Hard AI: Full optimal strategy with alpha-beta pruning
  Position _getHardMove(CellState robotPlayer) {
    final availableMoves = gameLogic.getAvailableMoves();
    if (availableMoves.isEmpty) return const Position(0, 0);

    // Use minimax with alpha-beta pruning for optimal play
    final maxDepth = availableMoves.length; // Look ahead as far as possible
    Position? bestMove;
    int bestScore = -1000;
    int alpha = -1000;
    const int beta = 1000;

    for (final move in availableMoves) {
      gameLogic.makeMove(move, robotPlayer);
      final score = _minimax(
        GameLogic.getOpponent(robotPlayer),
        maxDepth - 1,
        false,
        alpha,
        beta,
      );
      gameLogic.undoMove(move);

      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }

      alpha = max(alpha, score);
      if (alpha >= beta) break; // Alpha-beta pruning
    }

    return bestMove ?? availableMoves[0];
  }

  /// Minimax algorithm with alpha-beta pruning
  int _minimax(
    CellState player,
    int depth,
    bool isMaximizing,
    int alpha,
    int beta,
  ) {
    final result = gameLogic.checkGameState();

    // Terminal conditions
    if (result.isWin) {
      if (result.winner == player) {
        return 10 + depth; // Win (prefer faster wins)
      } else {
        return -10 - depth; // Loss (prefer slower losses)
      }
    }

    if (result.isDraw || depth == 0) {
      return 0; // Draw or depth limit reached
    }

    final availableMoves = gameLogic.getAvailableMoves();

    if (isMaximizing) {
      int maxScore = -1000;
      for (final move in availableMoves) {
        gameLogic.makeMove(move, player);
        final score = _minimax(
          GameLogic.getOpponent(player),
          depth - 1,
          false,
          alpha,
          beta,
        );
        gameLogic.undoMove(move);

        maxScore = max(maxScore, score);
        alpha = max(alpha, score);
        if (alpha >= beta) break; // Alpha-beta pruning
      }
      return maxScore;
    } else {
      int minScore = 1000;
      for (final move in availableMoves) {
        gameLogic.makeMove(move, player);
        final score = _minimax(
          GameLogic.getOpponent(player),
          depth - 1,
          true,
          alpha,
          beta,
        );
        gameLogic.undoMove(move);

        minScore = min(minScore, score);
        beta = min(beta, score);
        if (alpha >= beta) break; // Alpha-beta pruning
      }
      return minScore;
    }
  }

  /// Get hint for the current player (immediate win > block opponent > center > corners > edges)
  Position getHint(CellState currentPlayer) {
    final availableMoves = gameLogic.getAvailableMoves();
    if (availableMoves.isEmpty) return const Position(0, 0);

    // 1. Check for immediate win
    for (final move in availableMoves) {
      gameLogic.makeMove(move, currentPlayer);
      final result = gameLogic.checkGameState();
      gameLogic.undoMove(move);

      if (result.isWin && result.winner == currentPlayer) {
        return move; // Immediate win found
      }
    }

    // 2. Check for opponent's winning move (block)
    final opponent = GameLogic.getOpponent(currentPlayer);
    for (final move in availableMoves) {
      gameLogic.makeMove(move, opponent);
      final result = gameLogic.checkGameState();
      gameLogic.undoMove(move);

      if (result.isWin && result.winner == opponent) {
        return move; // Block opponent's win
      }
    }

    // 3. Prefer center
    final center = PositionExtensions.getCenter(gameLogic.boardSize);
    if (availableMoves.contains(center)) {
      return center;
    }

    // 4. Prefer corners
    final corners = PositionExtensions.getCorners(gameLogic.boardSize);
    final availableCorners = availableMoves
        .where((move) => corners.contains(move))
        .toList();
    if (availableCorners.isNotEmpty) {
      return availableCorners[0]; // Return first available corner
    }

    // 5. Prefer edges
    final edges = PositionExtensions.getEdges(gameLogic.boardSize);
    final availableEdges = availableMoves
        .where((move) => edges.contains(move))
        .toList();
    if (availableEdges.isNotEmpty) {
      return availableEdges[0]; // Return first available edge
    }

    // 6. Fallback to first available move
    return availableMoves[0];
  }

  /// Get multiple hints (useful for showing multiple good moves)
  List<Position> getMultipleHints(CellState currentPlayer, {int count = 3}) {
    final hints = <Position>[];
    final availableMoves = gameLogic.getAvailableMoves();

    if (availableMoves.isEmpty) return hints;

    // Get the best hint first
    final bestHint = getHint(currentPlayer);
    hints.add(bestHint);

    // If we need more hints, add strategic positions
    if (hints.length < count) {
      final remainingMoves = availableMoves
          .where((move) => !hints.contains(move))
          .toList();

      // Add center if available
      final center = PositionExtensions.getCenter(gameLogic.boardSize);
      if (remainingMoves.contains(center) && hints.length < count) {
        hints.add(center);
        remainingMoves.remove(center);
      }

      // Add corners if available
      final corners = PositionExtensions.getCorners(gameLogic.boardSize);
      for (final corner in corners) {
        if (remainingMoves.contains(corner) && hints.length < count) {
          hints.add(corner);
          remainingMoves.remove(corner);
        }
      }

      // Fill remaining slots with random moves
      while (hints.length < count && remainingMoves.isNotEmpty) {
        final randomIndex = _random.nextInt(remainingMoves.length);
        hints.add(remainingMoves[randomIndex]);
        remainingMoves.removeAt(randomIndex);
      }
    }

    return hints;
  }

  /// Evaluate the current board position for a given player
  int evaluatePosition(CellState player) {
    final result = gameLogic.checkGameState();

    if (result.isWin) {
      return result.winner == player ? 100 : -100;
    }

    if (result.isDraw) {
      return 0;
    }

    // Heuristic evaluation for non-terminal positions
    int score = 0;
    final opponent = GameLogic.getOpponent(player);

    // Evaluate rows, columns, and diagonals
    score += _evaluateLines(player, opponent);

    return score;
  }

  /// Evaluate all lines (rows, columns, diagonals) for scoring
  int _evaluateLines(CellState player, CellState opponent) {
    int score = 0;
    final boardSize = gameLogic.boardSize;
    final winCondition = gameLogic.winCondition;

    // Evaluate rows
    for (int row = 0; row < boardSize; row++) {
      score += _evaluateLine(
        start: Position(row, 0),
        direction: const Position(0, 1),
        length: winCondition,
        player: player,
        opponent: opponent,
      );
    }

    // Evaluate columns
    for (int col = 0; col < boardSize; col++) {
      score += _evaluateLine(
        start: Position(0, col),
        direction: const Position(1, 0),
        length: winCondition,
        player: player,
        opponent: opponent,
      );
    }

    // Evaluate diagonals
    if (boardSize >= winCondition) {
      // Main diagonal
      score += _evaluateLine(
        start: const Position(0, 0),
        direction: const Position(1, 1),
        length: winCondition,
        player: player,
        opponent: opponent,
      );

      // Anti-diagonal
      score += _evaluateLine(
        start: Position(0, boardSize - 1),
        direction: const Position(1, -1),
        length: winCondition,
        player: player,
        opponent: opponent,
      );
    }

    return score;
  }

  /// Evaluate a single line for scoring
  int _evaluateLine({
    required Position start,
    required Position direction,
    required int length,
    required CellState player,
    required CellState opponent,
  }) {
    final boardSize = gameLogic.boardSize;
    int score = 0;

    // Check all possible starting positions for this line
    for (int i = 0; i <= boardSize - length; i++) {
      final startPos = Position(
        start.row + i * direction.row,
        start.col + i * direction.col,
      );

      if (!gameLogic.isValidPosition(startPos)) continue;

      int playerCount = 0;
      int opponentCount = 0;

      // Count pieces in this line
      for (int j = 0; j < length; j++) {
        final pos = Position(
          startPos.row + j * direction.row,
          startPos.col + j * direction.col,
        );

        if (!gameLogic.isValidPosition(pos)) continue;

        final cellState = gameLogic.getCellState(pos);
        switch (cellState) {
          case CellState.X:
            if (player == CellState.X) {
              playerCount++;
            } else {
              opponentCount++;
            }
            break;
          case CellState.O:
            if (player == CellState.O) {
              playerCount++;
            } else {
              opponentCount++;
            }
            break;
          case CellState.empty:
            // Empty cells don't affect scoring
            break;
        }
      }

      // Score this line
      if (opponentCount == 0 && playerCount > 0) {
        // Player has pieces, opponent doesn't
        score += playerCount * playerCount;
      } else if (playerCount == 0 && opponentCount > 0) {
        // Opponent has pieces, player doesn't
        score -= opponentCount * opponentCount;
      }
    }

    return score;
  }
}
