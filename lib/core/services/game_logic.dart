import 'package:flutter/foundation.dart';
import 'package:tictactoe_xo_royale/core/models/game_config.dart';
import 'package:tictactoe_xo_royale/core/models/game_enums.dart';

/// Represents a position on the game board
@immutable
class Position {
  final int row;
  final int col;

  const Position(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Position &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          col == other.col;

  @override
  int get hashCode => Object.hash(runtimeType, row, col);

  @override
  String toString() => 'Position($row, $col)';
}

/// Represents the state of a single cell on the board
enum CellState { empty, X, O }

/// Represents the current game state
enum GameState { playing, win, draw }

/// Represents the result of a game
@immutable
class GameLogicResult {
  final GameState state;
  final CellState? winner;
  final List<Position>? winningLine;
  final List<Position>? availableMoves;

  const GameLogicResult({
    required this.state,
    this.winner,
    this.winningLine,
    this.availableMoves,
  });

  bool get isGameOver => state != GameState.playing;
  bool get isWin => state == GameState.win;
  bool get isDraw => state == GameState.draw;
}

/// Core game logic service for Tic Tac Toe
class GameLogic {
  final GameConfig config;
  late List<List<CellState>> _board;
  late final int _boardSize;
  late final int _winCondition;

  GameLogic(this.config) {
    _boardSize = config.boardSizeValue;
    _winCondition = config.winConditionValue;
    _initializeBoard();
  }

  /// Initialize an empty board
  void _initializeBoard() {
    _board = List.generate(
      _boardSize,
      (_) => List.filled(_boardSize, CellState.empty),
    );
  }

  /// Get the current board state
  List<List<CellState>> get board => _board;

  /// Get the board size
  int get boardSize => _boardSize;

  /// Get the win condition
  int get winCondition => _winCondition;

  /// Check if a position is valid on the board
  bool isValidPosition(Position position) =>
      position.row >= 0 &&
      position.row < _boardSize &&
      position.col >= 0 &&
      position.col < _boardSize;

  /// Check if a cell is empty
  bool isCellEmpty(Position position) {
    if (!isValidPosition(position)) {
      return false;
    }
    return _board[position.row][position.col] == CellState.empty;
  }

  /// Get the state of a cell
  CellState getCellState(Position position) {
    if (!isValidPosition(position)) {
      return CellState.empty;
    }
    return _board[position.row][position.col];
  }

  /// Make a move on the board
  bool makeMove(Position position, CellState player) {
    if (!isValidPosition(position) || !isCellEmpty(position)) {
      return false;
    }

    _board[position.row][position.col] = player;
    return true;
  }

  /// Undo a move (for AI calculations)
  void undoMove(Position position) {
    if (isValidPosition(position)) {
      _board[position.row][position.col] = CellState.empty;
    }
  }

  /// Get all available moves on the board
  List<Position> getAvailableMoves() {
    final moves = <Position>[];
    for (var row = 0; row < _boardSize; row++) {
      for (var col = 0; col < _boardSize; col++) {
        if (_board[row][col] == CellState.empty) {
          moves.add(Position(row, col));
        }
      }
    }
    return moves;
  }

  /// Check if the game is over and determine the result
  GameLogicResult checkGameState() {
    // Check for win
    final winResult = _checkForWin();
    if (winResult != null) {
      return GameLogicResult(
        state: GameState.win,
        winner: winResult.winner,
        winningLine: winResult.winningLine,
        availableMoves: const [],
      );
    }

    // Check for draw
    if (getAvailableMoves().isEmpty) {
      return const GameLogicResult(state: GameState.draw, availableMoves: []);
    }

    // Game is still playing
    return GameLogicResult(
      state: GameState.playing,
      availableMoves: getAvailableMoves(),
    );
  }

  /// Check for a win condition
  _WinCheckResult? _checkForWin() {
    // Check rows
    for (var row = 0; row < _boardSize; row++) {
      final result = _checkLine(
        start: Position(row, 0),
        direction: const Position(0, 1),
        length: _winCondition,
      );
      if (result != null) {
        return result;
      }
    }

    // Check columns
    for (var col = 0; col < _boardSize; col++) {
      final result = _checkLine(
        start: Position(0, col),
        direction: const Position(1, 0),
        length: _winCondition,
      );
      if (result != null) {
        return result;
      }
    }

    // Check main diagonals (top-left to bottom-right)
    for (var startRow = 0; startRow <= _boardSize - _winCondition; startRow++) {
      for (
        var startCol = 0;
        startCol <= _boardSize - _winCondition;
        startCol++
      ) {
        final result = _checkLine(
          start: Position(startRow, startCol),
          direction: const Position(1, 1),
          length: _winCondition,
        );
        if (result != null) {
          return result;
        }
      }
    }

    // Check anti-diagonals (top-right to bottom-left)
    for (var startRow = 0; startRow <= _boardSize - _winCondition; startRow++) {
      for (
        var startCol = _winCondition - 1;
        startCol < _boardSize;
        startCol++
      ) {
        final result = _checkLine(
          start: Position(startRow, startCol),
          direction: const Position(1, -1),
          length: _winCondition,
        );
        if (result != null) {
          return result;
        }
      }
    }

    return null;
  }

  /// Check a line for win condition
  _WinCheckResult? _checkLine({
    required Position start,
    required Position direction,
    required int length,
  }) {
    // Check if we can fit the win condition in this line
    if (_boardSize < length || length <= 0) {
      return null;
    }

    // Check all possible starting positions for this line
    for (var i = 0; i <= _boardSize - length; i++) {
      final startPos = Position(
        start.row + i * direction.row,
        start.col + i * direction.col,
      );

      if (!isValidPosition(startPos)) {
        continue;
      }

      final firstCell = getCellState(startPos);
      if (firstCell == CellState.empty) {
        continue;
      }

      // Check if all cells in this line are the same
      var isWinningLine = true;
      final winningLine = <Position>[];

      for (var j = 0; j < length; j++) {
        final pos = Position(
          startPos.row + j * direction.row,
          startPos.col + j * direction.col,
        );

        if (!isValidPosition(pos)) {
          isWinningLine = false;
          break;
        }

        final cellState = getCellState(pos);
        if (cellState != firstCell) {
          isWinningLine = false;
          break;
        }

        winningLine.add(pos);
      }

      if (isWinningLine && winningLine.length == length) {
        return _WinCheckResult(winner: firstCell, winningLine: winningLine);
      }
    }

    return null;
  }

  /// Get the opponent's cell state
  static CellState getOpponent(CellState player) =>
      player == CellState.X ? CellState.O : CellState.X;

  /// Reset the board to initial state
  void resetBoard() {
    _initializeBoard();
  }

  /// Get a copy of the current board
  List<List<CellState>> getBoardCopy() =>
      _board.map(List<CellState>.from).toList();

  /// Set the board state (for testing or loading saved games)
  void setBoardState(List<List<CellState>> newBoard) {
    if (newBoard.length != _boardSize ||
        newBoard.any((row) => row.length != _boardSize)) {
      throw ArgumentError('Invalid board dimensions');
    }
    _board = newBoard.map(List<CellState>.from).toList();
  }

  /// Get the number of moves made so far
  int get moveCount {
    var count = 0;
    for (var row = 0; row < _boardSize; row++) {
      for (var col = 0; col < _boardSize; col++) {
        if (_board[row][col] != CellState.empty) {
          count++;
        }
      }
    }
    return count;
  }

  /// Check if it's the first move of the game
  bool get isFirstMove => moveCount == 0;

  /// Get the next player based on move count and first move configuration
  CellState getNextPlayer() {
    if (moveCount == 0) {
      // First move of the game
      switch (config.firstMove) {
        case FirstMove.player1:
          return CellState.X;
        case FirstMove.player2:
          return CellState.O;
        case FirstMove.random:
          // This should never happen in practice since random is resolved during initialization
          // But if it does, default to X for consistency
          return CellState.X;
      }
    } else {
      // After first move, alternate based on who went first
      final firstPlayer = _getFirstPlayer();
      return moveCount.isEven ? firstPlayer : _getOpponent(firstPlayer);
    }
  }

  /// Get the first player based on configuration
  CellState _getFirstPlayer() {
    switch (config.firstMove) {
      case FirstMove.player1:
        return CellState.X;
      case FirstMove.player2:
        return CellState.O;
      case FirstMove.random:
        // This should never happen in practice since random is resolved during initialization
        // But if it does, default to X for consistency
        return CellState.X;
    }
  }

  /// Get the opponent of the given player
  CellState _getOpponent(CellState player) =>
      player == CellState.X ? CellState.O : CellState.X;
}

/// Internal class for win check results
class _WinCheckResult {
  final CellState winner;
  final List<Position> winningLine;

  _WinCheckResult({required this.winner, required this.winningLine});
}

/// Extension methods for Position
extension PositionExtensions on Position {
  /// Get all adjacent positions
  List<Position> getAdjacent(int boardSize) {
    final adjacent = <Position>[];
    for (var dr = -1; dr <= 1; dr++) {
      for (var dc = -1; dc <= 1; dc++) {
        if (dr == 0 && dc == 0) {
          continue;
        }
        final newRow = row + dr;
        final newCol = col + dc;
        if (newRow >= 0 &&
            newRow < boardSize &&
            newCol >= 0 &&
            newCol < boardSize) {
          adjacent.add(Position(newRow, newCol));
        }
      }
    }
    return adjacent;
  }

  /// Get the center position for a given board size
  static Position getCenter(int boardSize) {
    final center = boardSize ~/ 2;
    return Position(center, center);
  }

  /// Get corner positions for a given board size
  static List<Position> getCorners(int boardSize) => [
    const Position(0, 0),
    Position(0, boardSize - 1),
    Position(boardSize - 1, 0),
    Position(boardSize - 1, boardSize - 1),
  ];

  /// Get edge positions for a given board size
  static List<Position> getEdges(int boardSize) {
    final edges = <Position>[];
    for (var i = 1; i < boardSize - 1; i++) {
      edges.addAll([
        Position(0, i), // Top edge
        Position(boardSize - 1, i), // Bottom edge
        Position(i, 0), // Left edge
        Position(i, boardSize - 1), // Right edge
      ]);
    }
    return edges;
  }
}
