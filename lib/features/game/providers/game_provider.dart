import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/models/game_config.dart';
import 'package:tictactoe_xo_royale/core/models/game_enums.dart';
import 'package:tictactoe_xo_royale/core/services/game_logic.dart';
import 'package:tictactoe_xo_royale/core/services/robot_service.dart';

/// Simplified game provider without over-engineering
final gameProvider = StateNotifierProvider<GameNotifier, GameLogic>((ref) {
  return GameNotifier();
});

/// Game notifier with clean, simple implementation
class GameNotifier extends StateNotifier<GameLogic> {
  GameNotifier() : super(GameLogic(GameConfig.defaultConfig()));

  bool _mounted = true;

  /// Initialize a new game with the given configuration
  void initializeGame(GameConfig config) {
    if (!_mounted) return;

    // Handle random first move
    FirstMove firstMove = config.firstMove;
    if (firstMove == FirstMove.random) {
      final random = DateTime.now().millisecondsSinceEpoch % 2;
      firstMove = random == 0 ? FirstMove.player1 : FirstMove.player2;
    }

    // Create new config with resolved first move
    final resolvedConfig = config.copyWith(firstMove: firstMove);

    // Create new game logic
    final newGameLogic = GameLogic(resolvedConfig);
    state = newGameLogic;

    // If robot goes first, make the move
    if (firstMove == FirstMove.player2 && config.isRobotMode) {
      _makeRobotMove();
    }
  }

  /// Make a move at the specified position
  void makeMove(int row, int col) {
    if (!_mounted || state.checkGameState().isGameOver) return;

    final position = Position(row, col);
    if (!state.isCellEmpty(position)) return;

    final currentPlayer = state.getNextPlayer();
    final success = state.makeMove(position, currentPlayer);

    if (success) {
      // Update state to trigger UI rebuild
      _updateState();

      // If it's robot's turn, make robot move after a delay
      if (state.config.isRobotMode &&
          state.getNextPlayer() == CellState.O &&
          !state.checkGameState().isGameOver) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (_mounted) _makeRobotMove();
        });
      }
    }
  }

  /// Reset the current game
  void resetGame() {
    if (_mounted) {
      state = GameLogic(state.config);
    }
  }

  /// Get current game result
  GameResult get gameResult => state.checkGameState();

  /// Get available moves
  List<Position> get availableMoves => state.getAvailableMoves();

  /// Get current player
  CellState get currentPlayer => state.getNextPlayer();

  /// Check if game is over
  bool get isGameOver => state.checkGameState().isGameOver;

  /// Make robot move using the new robot service
  void _makeRobotMove() {
    if (!_mounted || !state.config.isRobotMode) return;

    final robotConfig = state.config.robot;
    if (robotConfig == null) return;

    final robotService = RobotServiceFactory.createService(robotConfig);
    final availableMoves = state.getAvailableMoves();

    if (availableMoves.isEmpty) return;

    final robotMove = robotService.getNextMove(
      availableMoves: availableMoves,
      board: state.board,
      boardSize: state.config.boardSizeValue,
      winCondition: state.config.winConditionValue,
      robotPlayer: CellState.O,
    );

    if (state.isCellEmpty(robotMove)) {
      state.makeMove(robotMove, CellState.O);
      _updateState();
    }
  }

  /// Update state to trigger UI rebuild
  void _updateState() {
    if (_mounted) {
      // Create new instance to trigger rebuild
      final newGameLogic = GameLogic(state.config);
      newGameLogic.setBoardState(state.getBoardCopy());
      state = newGameLogic;
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}

/// Extension for easy access to game data
extension GameProviderExtension on WidgetRef {
  GameNotifier get gameNotifier => read(gameProvider.notifier);
  GameLogic get gameState => watch(gameProvider);
  GameResult get gameResult => watch(gameProvider.notifier).gameResult;
  List<Position> get availableMoves =>
      watch(gameProvider.notifier).availableMoves;
  CellState get currentPlayer => watch(gameProvider.notifier).currentPlayer;
  bool get isGameOver => watch(gameProvider.notifier).isGameOver;
}
