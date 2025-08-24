import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/game_config.dart';
import '../models/game_state.dart';

// Position class for board coordinates
class Position {
  const Position({required this.row, required this.col});

  final int row;
  final int col;

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
  String toString() => 'Position(row: $row, col: $col)';
}

// Game state class
class GameState {
  const GameState({
    required this.config,
    required this.board,
    required this.currentPlayer,
    required this.gameStatus,
    required this.winner,
    required this.winningLine,
    required this.moveCount,
    required this.isLoading,
    required this.error,
    required this.hintAvailable,
    required this.lastMoveTime,
  });

  final GameConfig? config;
  final List<List<PlayerMark>> board;
  final PlayerMark currentPlayer;
  final GameStatus gameStatus;
  final PlayerMark? winner;
  final List<Position>? winningLine;
  final int moveCount;
  final bool isLoading;
  final String? error;
  final bool hintAvailable;
  final DateTime? lastMoveTime;

  // Copy with method for immutable updates
  GameState copyWith({
    GameConfig? config,
    List<List<PlayerMark>>? board,
    PlayerMark? currentPlayer,
    GameStatus? gameStatus,
    PlayerMark? winner,
    List<Position>? winningLine,
    int? moveCount,
    bool? isLoading,
    String? error,
    bool? hintAvailable,
    DateTime? lastMoveTime,
    bool clearError = false,
    bool clearWinningLine = false,
  }) {
    return GameState(
      config: config ?? this.config,
      board: board ?? this.board,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      gameStatus: gameStatus ?? this.gameStatus,
      winner: winner ?? this.winner,
      winningLine: clearWinningLine ? null : (winningLine ?? this.winningLine),
      moveCount: moveCount ?? this.moveCount,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      hintAvailable: hintAvailable ?? this.hintAvailable,
      lastMoveTime: lastMoveTime ?? this.lastMoveTime,
    );
  }

  // Initial state
  factory GameState.initial() => const GameState(
    config: null,
    board: [],
    currentPlayer: PlayerMark.X,
    gameStatus: GameStatus.waiting,
    winner: null,
    winningLine: null,
    moveCount: 0,
    isLoading: false,
    error: null,
    hintAvailable: false,
    lastMoveTime: null,
  );

  // New game state
  factory GameState.newGame(GameConfig config) {
    final boardSize = config.boardSize;
    final board = List.generate(
      boardSize,
      (i) => List.generate(boardSize, (j) => PlayerMark.none),
    );

    return GameState(
      config: config,
      board: board,
      currentPlayer: config.firstMove == FirstMove.random
          ? (DateTime.now().millisecondsSinceEpoch % 2 == 0
                ? PlayerMark.X
                : PlayerMark.O)
          : (config.firstMove == FirstMove.X ? PlayerMark.X : PlayerMark.O),
      gameStatus: GameStatus.playing,
      winner: null,
      winningLine: null,
      moveCount: 0,
      isLoading: false,
      error: null,
      hintAvailable: true,
      lastMoveTime: DateTime.now(),
    );
  }

  // Success state
  factory GameState.success(GameState state) =>
      state.copyWith(isLoading: false, error: null);

  // Error state
  factory GameState.error(String error) => GameState(
    config: null,
    board: [],
    currentPlayer: PlayerMark.X,
    gameStatus: GameStatus.waiting,
    winner: null,
    winningLine: null,
    moveCount: 0,
    isLoading: false,
    error: error,
    hintAvailable: false,
    lastMoveTime: null,
  );

  // Loading state
  factory GameState.loading() => const GameState(
    config: null,
    board: [],
    currentPlayer: PlayerMark.X,
    gameStatus: GameStatus.waiting,
    winner: null,
    winningLine: null,
    moveCount: 0,
    isLoading: true,
    error: null,
    hintAvailable: false,
    lastMoveTime: null,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameState &&
          runtimeType == other.runtimeType &&
          config == other.config &&
          board == other.board &&
          currentPlayer == other.currentPlayer &&
          gameStatus == other.gameStatus &&
          winner == other.winner &&
          winningLine == other.winningLine &&
          moveCount == other.moveCount &&
          isLoading == other.isLoading &&
          error == other.error &&
          hintAvailable == other.hintAvailable &&
          lastMoveTime == other.lastMoveTime;

  @override
  int get hashCode => Object.hash(
    runtimeType,
    config,
    board,
    currentPlayer,
    gameStatus,
    winner,
    winningLine,
    moveCount,
    isLoading,
    error,
    hintAvailable,
    lastMoveTime,
  );

  @override
  String toString() =>
      'GameState(config: $config, board: ${board.length}x${board.isNotEmpty ? board[0].length : 0}, '
      'currentPlayer: $currentPlayer, gameStatus: $gameStatus, winner: $winner, '
      'winningLine: $winningLine, moveCount: $moveCount, isLoading: $isLoading, '
      'error: $error, hintAvailable: $hintAvailable, lastMoveTime: $lastMoveTime)';
}

// Game notifier
class GameNotifier extends StateNotifier<GameState> {
  GameNotifier() : super(GameState.initial()) {
    _loadGameState();
  }

  static const String _storageKey = 'current_game_state';

  // Load game state from storage
  Future<void> _loadGameState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final gameStateJson = prefs.getString(_storageKey);

      if (gameStateJson != null) {
        final gameStateMap = Map<String, dynamic>.from(
          json.decode(gameStateJson) as Map,
        );
        // For now, we'll just load the config and create a new game
        // In a full implementation, you'd want to restore the full game state
        final config = GameConfig.fromJson(
          gameStateMap['config'] as Map<String, dynamic>,
        );
        state = GameState.newGame(config);
      }
    } catch (e) {
      // If loading fails, keep initial state
      debugPrint('Failed to load game state: $e');
    }
  }

  // Save game state to storage
  Future<void> _saveGameState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (state.config != null) {
        final gameStateMap = {
          'config': state.config!.toJson(),
          'lastMoveTime': state.lastMoveTime?.millisecondsSinceEpoch,
        };
        final gameStateJson = json.encode(gameStateMap);
        await prefs.setString(_storageKey, gameStateJson);
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to save game state: $e');
    }
  }

  // Start new game
  Future<void> startNewGame(GameConfig config) async {
    try {
      state = GameState.loading();
      final newGameState = GameState.newGame(config);
      state = newGameState;
      await _saveGameState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to start new game: $e',
      );
    }
  }

  // Make a move
  Future<bool> makeMove(int row, int col) async {
    try {
      if (state.gameStatus != GameStatus.playing) {
        return false; // Game is not active
      }

      if (row < 0 ||
          row >= state.board.length ||
          col < 0 ||
          col >= state.board[0].length) {
        return false; // Invalid position
      }

      if (state.board[row][col] != PlayerMark.none) {
        return false; // Position already occupied
      }

      // Create new board with the move
      final newBoard = List.generate(
        state.board.length,
        (i) => List.generate(
          state.board[i].length,
          (j) => i == row && j == col ? state.currentPlayer : state.board[i][j],
        ),
      );

      // Check for win
      final winningLine = _checkWin(newBoard, row, col, state.currentPlayer);
      final hasWinner = winningLine.isNotEmpty;
      final isDraw = !hasWinner && _isBoardFull(newBoard);

      // Update state
      state = state.copyWith(
        board: newBoard,
        currentPlayer: state.currentPlayer == PlayerMark.X
            ? PlayerMark.O
            : PlayerMark.X,
        moveCount: state.moveCount + 1,
        lastMoveTime: DateTime.now(),
        winningLine: hasWinner ? winningLine : null,
        winner: hasWinner ? state.currentPlayer : null,
        gameStatus: hasWinner
            ? GameStatus.finished
            : (isDraw ? GameStatus.finished : GameStatus.playing),
        error: null, // Clear any previous errors
      );

      // Save game state
      await _saveGameState();

      return true;
    } catch (e) {
      state = state.copyWith(error: 'Failed to make move: $e');
      return false;
    }
  }

  // Reset game
  Future<void> resetGame() async {
    try {
      if (state.config != null) {
        state = GameState.newGame(state.config!);
        await _saveGameState();
      } else {
        state = GameState.initial();
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to reset game: $e');
    }
  }

  // Get hint
  Future<Position?> getHint() async {
    try {
      if (!state.hintAvailable || state.gameStatus != GameStatus.playing) {
        return null;
      }

      // Simple hint logic: find the best move
      final hint = _findBestMove(state.board, state.currentPlayer);

      if (hint != null) {
        // Mark hint as used
        state = state.copyWith(hintAvailable: false);
        await _saveGameState();
      }

      return hint;
    } catch (e) {
      state = state.copyWith(error: 'Failed to get hint: $e');
      return null;
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  // Get available moves
  List<Position> getAvailableMoves() {
    final moves = <Position>[];
    for (int i = 0; i < state.board.length; i++) {
      for (int j = 0; j < state.board[i].length; j++) {
        if (state.board[i][j] == PlayerMark.none) {
          moves.add(Position(row: i, col: j));
        }
      }
    }
    return moves;
  }

  // Check if position is valid
  bool isValidPosition(int row, int col) {
    return row >= 0 &&
        row < state.board.length &&
        col >= 0 &&
        col < state.board[0].length;
  }

  // Check if position is empty
  bool isPositionEmpty(int row, int col) {
    if (!isValidPosition(row, col)) return false;
    return state.board[row][col] == PlayerMark.none;
  }

  // Check if game is over
  bool get isGameOver {
    return state.gameStatus == GameStatus.finished;
  }

  // Check if game is active
  bool get isGameActive {
    return state.gameStatus == GameStatus.playing;
  }

  // Check if current player is X
  bool get isCurrentPlayerX {
    return state.currentPlayer == PlayerMark.X;
  }

  // Check if current player is O
  bool get isCurrentPlayerO {
    return state.currentPlayer == PlayerMark.O;
  }

  // Get board size
  int get boardSize {
    return state.board.length;
  }

  // Private methods
  List<Position> _checkWin(
    List<List<PlayerMark>> board,
    int row,
    int col,
    PlayerMark player,
  ) {
    final size = board.length;
    final directions = [
      [1, 0], // Horizontal
      [0, 1], // Vertical
      [1, 1], // Diagonal
      [1, -1], // Anti-diagonal
    ];

    for (final direction in directions) {
      final dx = direction[0];
      final dy = direction[1];
      final line = <Position>[];

      // Check in both directions
      for (int i = -size + 1; i < size; i++) {
        final newRow = row + i * dx;
        final newCol = col + i * dy;

        if (newRow >= 0 &&
            newRow < size &&
            newCol >= 0 &&
            newCol < size &&
            board[newRow][newCol] == player) {
          line.add(Position(row: newRow, col: newCol));
        } else {
          if (line.length >= 3) break;
          line.clear();
        }
      }

      if (line.length >= 3) {
        return line;
      }
    }

    return [];
  }

  bool _isBoardFull(List<List<PlayerMark>> board) {
    for (final row in board) {
      for (final cell in row) {
        if (cell == PlayerMark.none) return false;
      }
    }
    return true;
  }

  Position? _findBestMove(List<List<PlayerMark>> board, PlayerMark player) {
    final size = board.length;
    final center = size ~/ 2;

    // Try center first
    if (board[center][center] == PlayerMark.none) {
      return Position(row: center, col: center);
    }

    // Try corners
    final corners = [
      Position(row: 0, col: 0),
      Position(row: 0, col: size - 1),
      Position(row: size - 1, col: 0),
      Position(row: size - 1, col: size - 1),
    ];
    for (final corner in corners) {
      if (board[corner.row][corner.col] == PlayerMark.none) {
        return corner;
      }
    }

    // Try edges
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (board[i][j] == PlayerMark.none) {
          return Position(row: i, col: j);
        }
      }
    }

    return null;
  }
}

// ✅ OPTIMIZED: Main game provider with AutoDispose for better lifecycle management
final gameProvider = StateNotifierProvider.autoDispose<GameNotifier, GameState>(
  (ref) => GameNotifier(),
);

// ✅ OPTIMIZED: Use select for granular rebuilds instead of individual providers
// This reduces the number of providers and improves performance

// Game configuration provider
final gameConfigProvider = Provider.autoDispose<GameConfig?>((ref) {
  return ref.watch(gameProvider.select((state) => state.config));
});

// Game board provider
final gameBoardProvider = Provider.autoDispose<List<List<PlayerMark>>>((ref) {
  return ref.watch(gameProvider.select((state) => state.board));
});

// Current player provider
final gameCurrentPlayerProvider = Provider.autoDispose<PlayerMark>((ref) {
  return ref.watch(gameProvider.select((state) => state.currentPlayer));
});

// Game status provider
final gameStatusProvider = Provider.autoDispose<GameStatus>((ref) {
  return ref.watch(gameProvider.select((state) => state.gameStatus));
});

// Winner provider
final gameWinnerProvider = Provider.autoDispose<PlayerMark?>((ref) {
  return ref.watch(gameProvider.select((state) => state.winner));
});

// Winning line provider
final gameWinningLineProvider = Provider.autoDispose<List<Position>?>((ref) {
  return ref.watch(gameProvider.select((state) => state.winningLine));
});

// Move count provider
final gameMoveCountProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(gameProvider.select((state) => state.moveCount));
});

// Loading state provider
final gameIsLoadingProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(gameProvider.select((state) => state.isLoading));
});

// Error provider
final gameErrorProvider = Provider.autoDispose<String?>((ref) {
  return ref.watch(gameProvider.select((state) => state.error));
});

// Hint availability provider
final gameHintAvailableProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(gameProvider.select((state) => state.hintAvailable));
});

// Last move time provider
final gameLastMoveTimeProvider = Provider.autoDispose<DateTime?>((ref) {
  return ref.watch(gameProvider.select((state) => state.lastMoveTime));
});

// ✅ OPTIMIZED: Computed providers using select for better performance
final gameIsGameOverProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(
    gameProvider.select((state) => state.gameStatus == GameStatus.finished),
  );
});

final gameIsGameActiveProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(
    gameProvider.select((state) => state.gameStatus == GameStatus.playing),
  );
});

final gameIsCurrentPlayerXProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(
    gameProvider.select((state) => state.currentPlayer == PlayerMark.X),
  );
});

final gameIsCurrentPlayerOProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(
    gameProvider.select((state) => state.currentPlayer == PlayerMark.O),
  );
});

final gameBoardSizeProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(gameProvider.select((state) => state.board.length));
});

// ✅ OPTIMIZED: Computed provider that only rebuilds when board changes
final gameAvailableMovesProvider = Provider.autoDispose<List<Position>>((ref) {
  final board = ref.watch(gameProvider.select((state) => state.board));
  final moves = <Position>[];
  for (int i = 0; i < board.length; i++) {
    for (int j = 0; j < board[i].length; j++) {
      if (board[i][j] == PlayerMark.none) {
        moves.add(Position(row: i, col: j));
      }
    }
  }
  return moves;
});

// ✅ OPTIMIZED: Extension methods for easy access with select-based providers
extension GameProviderExtension on WidgetRef {
  // Get game notifier
  GameNotifier get gameNotifier => read(gameProvider.notifier);

  // Get individual game data using select for granular rebuilds
  GameConfig? get gameConfig => watch(gameConfigProvider);
  List<List<PlayerMark>> get gameBoard => watch(gameBoardProvider);
  PlayerMark get gameCurrentPlayer => watch(gameCurrentPlayerProvider);
  GameStatus get gameStatus => watch(gameStatusProvider);
  PlayerMark? get gameWinner => watch(gameWinnerProvider);
  List<Position>? get gameWinningLine => watch(gameWinningLineProvider);
  int get gameMoveCount => watch(gameMoveCountProvider);
  bool get gameIsLoading => watch(gameIsLoadingProvider);
  String? get gameError => watch(gameErrorProvider);
  bool get gameHintAvailable => watch(gameHintAvailableProvider);
  DateTime? get gameLastMoveTime => watch(gameLastMoveTimeProvider);

  // Get computed game data
  bool get gameIsGameOver => watch(gameIsGameOverProvider);
  bool get gameIsGameActive => watch(gameIsGameActiveProvider);
  bool get gameIsCurrentPlayerX => watch(gameIsCurrentPlayerXProvider);
  bool get gameIsCurrentPlayerO => watch(gameIsCurrentPlayerOProvider);
  int get gameBoardSize => watch(gameBoardSizeProvider);
  List<Position> get gameAvailableMoves => watch(gameAvailableMovesProvider);

  // Get all game state
  GameState get gameState => watch(gameProvider);
}

// ✅ OPTIMIZED: Extension methods for BuildContext with proper error handling
extension GameContextExtension on BuildContext {
  // Get game state from provider with error handling
  GameState? get gameState {
    try {
      return ProviderScope.containerOf(this).read(gameProvider);
    } catch (e) {
      debugPrint('Failed to read game state: $e');
      return null;
    }
  }
}
