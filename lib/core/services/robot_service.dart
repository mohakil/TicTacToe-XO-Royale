import 'package:flutter/foundation.dart';
import 'package:tictactoe_xo_royale/core/models/game_enums.dart';
import 'package:tictactoe_xo_royale/core/models/robot_config.dart';
import 'package:tictactoe_xo_royale/core/services/game_logic.dart';

/// Simplified robot service that handles AI moves
/// Uses strategy pattern for different difficulty levels
class RobotService {
  final RobotConfig config;

  RobotService({required this.config});

  /// Get the next move for the robot
  Future<Position> getNextMove({
    required List<Position> availableMoves,
    required List<List<CellState>> board,
    required int boardSize,
    required int winCondition,
    required CellState robotPlayer,
  }) async {
    if (availableMoves.isEmpty) return const Position(0, 0);

    final strategy = RobotStrategyFactory.createStrategy(config.difficulty);
    // Offload to isolate if heavy (e.g., for Hard)
    if (config.difficulty == Difficulty.hard) {
      try {
        return await compute(_computeMove, {
          'strategyType': 'hard',
          'availableMoves': availableMoves
              .map((p) => {'row': p.row, 'col': p.col})
              .toList(),
          'board': board
              .map((row) => row.map((state) => state.index).toList())
              .toList(),
          'boardSize': boardSize,
          'winCondition': winCondition,
          'robotPlayer': robotPlayer.index,
        }).timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            if (kDebugMode) {
              print('AI timeout - falling back to random move');
            }
            return availableMoves.isNotEmpty
                ? availableMoves.first
                : const Position(0, 0);
          },
        );
      } catch (e) {
        if (kDebugMode) {
          print('AI computation error: $e - falling back to random move');
        }
        return availableMoves.isNotEmpty
            ? availableMoves.first
            : const Position(0, 0);
      }
    }
    return strategy.getNextMove(
      availableMoves: availableMoves,
      board: board,
      boardSize: boardSize,
      winCondition: winCondition,
      robotPlayer: robotPlayer,
    );
  }

  static Position _computeMove(Map<String, dynamic> params) {
    // Reconstruct params
    final availableMoves = (params['availableMoves'] as List)
        .map((m) => Position(m['row'] as int, m['col'] as int))
        .toList();
    final boardSize = params['boardSize'] as int;
    final winCondition = params['winCondition'] as int;
    final robotPlayerIndex = params['robotPlayer'] as int;
    final robotPlayer = CellState.values[robotPlayerIndex];
    final boardJson = params['board'] as List;
    final board = boardJson
        .map(
          (rowJson) => (rowJson as List)
              .map((stateIndex) => CellState.values[stateIndex as int])
              .toList(),
        )
        .toList();

    // Create strategy
    final strategy = RobotStrategyFactory.createStrategy(Difficulty.hard);
    return strategy.getNextMove(
      availableMoves: availableMoves,
      board: board,
      boardSize: boardSize,
      winCondition: winCondition,
      robotPlayer: robotPlayer,
    );
  }

  /// Get a hint for the current player
  Position getHint({
    required List<Position> availableMoves,
    required List<List<CellState>> board,
    required int boardSize,
    required int winCondition,
    required CellState currentPlayer,
  }) {
    if (availableMoves.isEmpty) return const Position(0, 0);

    // 1. Check for immediate win
    for (final move in availableMoves) {
      if (_wouldWin(board, move, currentPlayer, winCondition)) {
        return move;
      }
    }

    // 2. Check for opponent's immediate win (block)
    final opponent = currentPlayer == CellState.X ? CellState.O : CellState.X;
    for (final move in availableMoves) {
      if (_wouldWin(board, move, opponent, winCondition)) {
        return move;
      }
    }

    // 3. Prefer center
    final center = Position(boardSize ~/ 2, boardSize ~/ 2);
    if (availableMoves.contains(center)) return center;

    // 4. Prefer corners
    final corners = _getCorners(boardSize);
    final availableCorners = availableMoves.where(corners.contains).toList();
    if (availableCorners.isNotEmpty) return availableCorners.first;

    // 5. Fallback to first available move
    return availableMoves.first;
  }

  /// Check if placing a piece at the given position would result in a win
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

  /// Get corner positions for the given board size
  List<Position> _getCorners(int boardSize) {
    return [
      const Position(0, 0),
      Position(0, boardSize - 1),
      Position(boardSize - 1, 0),
      Position(boardSize - 1, boardSize - 1),
    ];
  }

  /// Create a deep copy of the board
  List<List<CellState>> _copyBoard(List<List<CellState>> board) {
    return board.map((row) => List<CellState>.from(row)).toList();
  }
}

/// Factory for creating robot services
class RobotServiceFactory {
  static RobotService createService(RobotConfig config) {
    return RobotService(config: config);
  }
}
