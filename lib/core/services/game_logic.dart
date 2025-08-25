
import '../models/game_config.dart';

/// Represents a position on the game board
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
class GameResult {
  final GameState state;
  final CellState? winner;
  final List<Position>? winningLine;
  final List<Position>? availableMoves;

  const GameResult({
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
    _boardSize = config.boardSize;
    _winCondition = config.winCondition;
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
  bool isValidPosition(Position position) {
    return position.row >= 0 &&
        position.row < _boardSize &&
        position.col >= 0 &&
        position.col < _boardSize;
  }

  /// Check if a cell is empty
  bool isCellEmpty(Position position) {
    if (!isValidPosition(position)) return false;
    return _board[position.row][position.col] == CellState.empty;
  }

  /// Get the state of a cell
  CellState getCellState(Position position) {
    if (!isValidPosition(position)) return CellState.empty;
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
    for (int row = 0; row < _boardSize; row++) {
      for (int col = 0; col < _boardSize; col++) {
        if (_board[row][col] == CellState.empty) {
          moves.add(Position(row, col));
        }
      }
    }
    return moves;
  }

  /// Check if the game is over and determine the result
  GameResult checkGameState() {
    // Check for win
    final winResult = _checkForWin();
    if (winResult != null) {
      return GameResult(
        state: GameState.win,
        winner: winResult.winner,
        winningLine: winResult.winningLine,
        availableMoves: [],
      );
    }

    // Check for draw
    if (getAvailableMoves().isEmpty) {
      return GameResult(
        state: GameState.draw,
        winner: null,
        winningLine: null,
        availableMoves: [],
      );
    }

    // Game is still playing
    return GameResult(
      state: GameState.playing,
      winner: null,
      winningLine: null,
      availableMoves: getAvailableMoves(),
    );
  }

  /// Check for a win condition
  _WinCheckResult? _checkForWin() {
    // Check rows
    for (int row = 0; row < _boardSize; row++) {
      final result = _checkLine(
        start: Position(row, 0),
        direction: Position(0, 1),
        length: _winCondition,
      );
      if (result != null) return result;
    }

    // Check columns
    for (int col = 0; col < _boardSize; col++) {
      final result = _checkLine(
        start: Position(0, col),
        direction: Position(1, 0),
        length: _winCondition,
      );
      if (result != null) return result;
    }

    // Check diagonals
    // Main diagonal (top-left to bottom-right)
    if (_boardSize >= _winCondition) {
      final result = _checkLine(
        start: Position(0, 0),
        direction: Position(1, 1),
        length: _winCondition,
      );
      if (result != null) return result;
    }

    // Anti-diagonal (top-right to bottom-left)
    if (_boardSize >= _winCondition) {
      final result = _checkLine(
        start: Position(0, _boardSize - 1),
        direction: Position(1, -1),
        length: _winCondition,
      );
      if (result != null) return result;
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
    if (_boardSize < length) return null;

    // Check all possible starting positions for this line
    for (int i = 0; i <= _boardSize - length; i++) {
      final startPos = Position(
        start.row + i * direction.row,
        start.col + i * direction.col,
      );

      if (!isValidPosition(startPos)) continue;

      final firstCell = getCellState(startPos);
      if (firstCell == CellState.empty) continue;

      // Check if all cells in this line are the same
      bool isWinningLine = true;
      final winningLine = <Position>[];

      for (int j = 0; j < length; j++) {
        final pos = Position(
          startPos.row + j * direction.row,
          startPos.col + j * direction.col,
        );

        if (!isValidPosition(pos) || getCellState(pos) != firstCell) {
          isWinningLine = false;
          break;
        }

        winningLine.add(pos);
      }

      if (isWinningLine) {
        return _WinCheckResult(winner: firstCell, winningLine: winningLine);
      }
    }

    return null;
  }

  /// Get the opponent's cell state
  static CellState getOpponent(CellState player) {
    return player == CellState.X ? CellState.O : CellState.X;
  }

  /// Reset the board to initial state
  void resetBoard() {
    _initializeBoard();
  }

  /// Get a copy of the current board
  List<List<CellState>> getBoardCopy() {
    return _board.map((row) => List<CellState>.from(row)).toList();
  }

  /// Set the board state (for testing or loading saved games)
  void setBoardState(List<List<CellState>> newBoard) {
    if (newBoard.length != _boardSize ||
        newBoard.any((row) => row.length != _boardSize)) {
      throw ArgumentError('Invalid board dimensions');
    }
    _board = newBoard.map((row) => List<CellState>.from(row)).toList();
  }

  /// Get the number of moves made so far
  int get moveCount {
    int count = 0;
    for (int row = 0; row < _boardSize; row++) {
      for (int col = 0; col < _boardSize; col++) {
        if (_board[row][col] != CellState.empty) {
          count++;
        }
      }
    }
    return count;
  }

  /// Check if it's the first move of the game
  bool get isFirstMove => moveCount == 0;

  /// Get the next player based on move count
  CellState getNextPlayer() {
    return moveCount % 2 == 0 ? CellState.X : CellState.O;
  }
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
    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        if (dr == 0 && dc == 0) continue;
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
  static List<Position> getCorners(int boardSize) {
    return [
      Position(0, 0),
      Position(0, boardSize - 1),
      Position(boardSize - 1, 0),
      Position(boardSize - 1, boardSize - 1),
    ];
  }

  /// Get edge positions for a given board size
  static List<Position> getEdges(int boardSize) {
    final edges = <Position>[];
    for (int i = 1; i < boardSize - 1; i++) {
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
