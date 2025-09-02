import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/models/game_config.dart';
import 'package:tictactoe_xo_royale/core/services/game_logic.dart';
import 'package:tictactoe_xo_royale/core/services/robot_logic.dart';
import 'package:tictactoe_xo_royale/core/services/memory_manager.dart';

// ✅ OPTIMIZED: Game configuration provider with autoDispose for temporary data
final gameConfigProvider = StateProvider.autoDispose<GameConfig>((ref) {
  ref.trackMemory('gameConfig', keepAlive: false);
  return GameConfig.defaultConfig();
});

// ✅ OPTIMIZED: Game logic service provider with autoDispose
final gameLogicProvider = Provider.autoDispose<GameLogic>((ref) {
  ref.trackMemory('gameLogic', keepAlive: false);
  final config = ref.watch(gameConfigProvider);
  return GameLogic(config);
});

// ✅ OPTIMIZED: Game state provider with autoDispose for temporary game sessions
final gameStateProvider =
    StateNotifierProvider.autoDispose<GameNotifier, GameLogic>((ref) {
      ref.trackMemory('gameState', keepAlive: false);
      final gameLogic = ref.watch(gameLogicProvider);
      return GameNotifier(gameLogic);
    });

// ✅ OPTIMIZED: Use select for granular rebuilds with autoDispose for temporary data
// Individual game data providers for granular rebuilds
final currentPlayerProvider = Provider.autoDispose<CellState>((ref) {
  ref.trackMemory('currentPlayer', keepAlive: false);
  return ref.watch(gameStateProvider.select((state) => state.getNextPlayer()));
});

final gameBoardProvider = Provider.autoDispose<List<List<CellState>>>((ref) {
  ref.trackMemory('gameBoard', keepAlive: false);
  return ref.watch(gameStateProvider.select((state) => state.board));
});

final isGameOverProvider = Provider.autoDispose<bool>((ref) {
  ref.trackMemory('isGameOver', keepAlive: false);
  return ref.watch(
    gameStateProvider.select((state) => state.checkGameState().isGameOver),
  );
});

final gameResultProvider = Provider.autoDispose<GameResult>((ref) {
  ref.trackMemory('gameResult', keepAlive: false);
  return ref.watch(gameStateProvider.select((state) => state.checkGameState()));
});

final availableMovesProvider = Provider.autoDispose<List<Position>>((ref) {
  ref.trackMemory('availableMoves', keepAlive: false);
  return ref.watch(
    gameStateProvider.select((state) => state.getAvailableMoves()),
  );
});

final gameConfigFromStateProvider = Provider.autoDispose<GameConfig>((ref) {
  ref.trackMemory('gameConfigFromState', keepAlive: false);
  return ref.watch(gameStateProvider.select((state) => state.config));
});

// ✅ OPTIMIZED: Computed providers using select with autoDispose for temporary data
final gameStatusProvider =
    Provider.autoDispose<
      ({CellState currentPlayer, bool isGameOver, GameResult result})
    >((ref) {
      ref.trackMemory('gameStatus', keepAlive: false);
      return ref.watch(
        gameStateProvider.select((state) {
          final currentPlayer = state.getNextPlayer();
          final result = state.checkGameState();
          return (
            currentPlayer: currentPlayer,
            isGameOver: result.isGameOver,
            result: result,
          );
        }),
      );
    });

final gameBoardStateProvider =
    Provider.autoDispose<
      ({List<List<CellState>> board, List<Position> availableMoves})
    >((ref) {
      ref.trackMemory('gameBoardState', keepAlive: false);
      return ref.watch(
        gameStateProvider.select(
          (state) =>
              (board: state.board, availableMoves: state.getAvailableMoves()),
        ),
      );
    });

// ✅ OPTIMIZED: Extension methods for easy access with select-based providers
extension GameProviderExtension on WidgetRef {
  // Get game notifier
  GameNotifier get gameNotifier => read(gameStateProvider.notifier);

  // Get individual game data using select for granular rebuilds
  CellState get currentPlayer => watch(currentPlayerProvider);
  List<List<CellState>> get gameBoard => watch(gameBoardProvider);
  bool get isGameOver => watch(isGameOverProvider);
  GameResult get gameResult => watch(gameResultProvider);
  List<Position> get availableMoves => watch(availableMovesProvider);
  GameConfig get gameConfig => watch(gameConfigFromStateProvider);

  // Get computed game data
  ({CellState currentPlayer, bool isGameOver, GameResult result})
  get gameStatus => watch(gameStatusProvider);
  ({List<List<CellState>> board, List<Position> availableMoves})
  get gameBoardState => watch(gameBoardStateProvider);

  // Get all game state
  GameLogic get gameState => watch(gameStateProvider);
}

class GameNotifier extends StateNotifier<GameLogic> {
  GameNotifier(super.gameLogic);

  // Mounted flag for proper disposal
  bool _mounted = true;

  void initializeGame({
    required int boardSize,
    required int winCondition,
    required String player1Name,
    required String player2Name,
    required bool isRobotMode,
    required String difficulty,
    required String firstMove,
  }) {
    if (!_mounted) return;
    // Convert string values to proper enums
    final gameMode = isRobotMode ? GameMode.cpu : GameMode.local;

    final difficultyEnum = switch (difficulty) {
      'easy' => Difficulty.easy,
      'medium' => Difficulty.medium,
      'hard' => Difficulty.hard,
      _ => Difficulty.medium,
    };

    FirstMove firstMoveEnum = switch (firstMove) {
      'player1' => FirstMove.player1,
      'player2' => FirstMove.player2,
      'random' => FirstMove.random,
      _ => FirstMove.random,
    };

    // Handle random first move by determining who goes first
    if (firstMoveEnum == FirstMove.random) {
      final random = DateTime.now().millisecondsSinceEpoch % 2;
      firstMoveEnum = random == 0 ? FirstMove.player1 : FirstMove.player2;
    }

    // Create new game configuration
    final newConfig = GameConfig(
      boardSize: boardSize,
      winCondition: winCondition,
      gameMode: gameMode,
      firstMove: firstMoveEnum,
      difficulty: difficultyEnum,
      player1Name: player1Name,
      player2Name: player2Name,
      isRobotMode: isRobotMode,
    );

    // Create new game logic with the configuration
    final newGameLogic = GameLogic(newConfig);

    // Handle first move logic for robot mode
    if (firstMoveEnum == FirstMove.player2 && isRobotMode) {
      // Robot goes first
      _makeRobotMove(newGameLogic);
    }

    state = newGameLogic;
  }

  void makeMove(int row, int col) {
    if (!_mounted || state.checkGameState().isGameOver) {
      return;
    }

    final position = Position(row, col);
    if (!state.isCellEmpty(position)) {
      return;
    }

    final currentPlayer = state.getNextPlayer();
    final success = state.makeMove(position, currentPlayer);

    if (success) {
      // Get the updated board state BEFORE creating new instance
      final updatedBoard = state.getBoardCopy();

      // Create a new GameLogic instance with the updated board state
      // This ensures the UI rebuilds when the state changes
      final newGameLogic = GameLogic(state.config);
      newGameLogic.setBoardState(updatedBoard);
      state = newGameLogic;

      // If it's robot mode and robot's turn, make robot move
      if (state.config.isRobotMode && state.getNextPlayer() == CellState.O) {
        // Add delay for better UX
        Future.delayed(const Duration(milliseconds: 500), () {
          _makeRobotMove(state);
        });
      }
    }
  }

  void resetGame() {
    if (_mounted) {
      state = GameLogic(state.config);
    }
  }

  GameResult checkGameResult() => state.checkGameState();

  List<Position> getAvailableMoves() => state.getAvailableMoves();

  void _makeRobotMove(GameLogic gameLogic) {
    if (!_mounted || !gameLogic.config.isRobotMode) return;

    // Get robot logic service with current game state
    final robotLogic = RobotLogic(gameLogic.config, gameLogic);

    // Get the robot's next move
    final robotMove = robotLogic.getNextMove(CellState.O);

    // Make the robot's move
    if (gameLogic.isCellEmpty(robotMove)) {
      gameLogic.makeMove(robotMove, CellState.O);

      // Update the state with the new board
      final updatedBoard = gameLogic.getBoardCopy();
      final newGameLogic = GameLogic(gameLogic.config);
      newGameLogic.setBoardState(updatedBoard);
      state = newGameLogic;
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}
