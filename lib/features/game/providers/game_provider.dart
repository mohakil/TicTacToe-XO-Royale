import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/models/game_config.dart';
import 'package:tictactoe_xo_royale/core/services/game_logic.dart';
import 'package:tictactoe_xo_royale/core/services/robot_logic.dart';

// Provider for game configuration
final gameConfigProvider = StateProvider<GameConfig>(
  (ref) => GameConfig.defaultConfig(),
);

// Provider for game logic service
final gameLogicProvider = Provider<GameLogic>((ref) {
  final config = ref.watch(gameConfigProvider);
  return GameLogic(config);
});

// Provider for current game state
final gameStateProvider = StateNotifierProvider<GameNotifier, GameLogic>((ref) {
  final gameLogic = ref.watch(gameLogicProvider);
  return GameNotifier(gameLogic);
});

class GameNotifier extends StateNotifier<GameLogic> {
  GameNotifier(super.gameLogic);

  void initializeGame({
    required int boardSize,
    required int winCondition,
    required String player1Name,
    required String player2Name,
    required bool isRobotMode,
    required String difficulty,
    required String firstMove,
  }) {
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
    if (state.checkGameState().isGameOver) {
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
    state = GameLogic(state.config);
  }

  GameResult checkGameResult() => state.checkGameState();

  List<Position> getAvailableMoves() => state.getAvailableMoves();

  void _makeRobotMove(GameLogic gameLogic) {
    if (!gameLogic.config.isRobotMode) return;

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
}
