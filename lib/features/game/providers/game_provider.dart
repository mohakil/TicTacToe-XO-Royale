import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tictactoe_xo_royale/core/models/game_config.dart';
import 'package:tictactoe_xo_royale/core/models/game_enums.dart';
import 'package:tictactoe_xo_royale/core/services/game_logic.dart';
import 'package:tictactoe_xo_royale/core/services/robot_service.dart';

part 'game_provider.g.dart';

/// Simplified game provider without over-engineering (auto-generated)

/// Game notifier with clean, simple implementation
@riverpod
class GameNotifier extends _$GameNotifier {
  @override
  GameLogic build() {
    ref.onDispose(() {
      _mounted = false;
      _isRobotThinking = false; // Reset thinking state on dispose
    });
    return GameLogic(GameConfig.defaultConfig());
  }

  @override
  bool updateShouldNotify(GameLogic previous, GameLogic next) {
    // Compare only relevant fields for optimization
    return previous.getBoardCopy() != next.getBoardCopy() ||
        previous.config.firstMove != next.config.firstMove ||
        previous.checkGameState() != next.checkGameState();
  }

  bool _mounted = true;
  bool _isRobotThinking = false;

  /// Get robot thinking state
  bool get isRobotThinking => _isRobotThinking;

  /// Set robot thinking state
  void _setRobotThinking(bool thinking) {
    if (_mounted && _isRobotThinking != thinking) {
      _isRobotThinking = thinking;
      // Trigger rebuild by creating a new state instance
      final newState = GameLogic(state.config);
      newState.setBoardState(state.getBoardCopy());
      state = newState;
    }
  }

  /// Initialize a new game with the given configuration
  Future<void> initializeGame(GameConfig config) async {
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

    // If robot goes first, show thinking animation and make the move
    if (firstMove == FirstMove.player2 && config.isRobotMode) {
      // Start thinking animation
      _setRobotThinking(true);

      // Small delay to allow UI to update and show animation
      await Future.delayed(const Duration(milliseconds: 100));

      // Make robot move
      await _makeRobotMove();

      // Stop thinking animation after robot move
      _setRobotThinking(false);
    }
  }

  /// Make a move at the specified position
  bool makeMove(int row, int col) {
    if (!_mounted || state.checkGameState().isGameOver) return false;

    // Check if it's currently the robot's turn in robot mode
    if (state.config.isRobotMode && state.getNextPlayer() == CellState.O) {
      // Don't allow player moves when it's robot's turn
      return false;
    }

    final position = Position(row, col);
    if (!state.isCellEmpty(position)) return false;

    final currentPlayer = state.getNextPlayer();
    final success = state.makeMove(position, currentPlayer);

    if (success) {
      // Update state to trigger UI rebuild
      _updateState();

      // If it's robot's turn, show thinking animation and make robot move after a delay
      if (state.config.isRobotMode &&
          state.getNextPlayer() == CellState.O &&
          !state.checkGameState().isGameOver) {
        // Start thinking animation
        _setRobotThinking(true);

        Future.delayed(const Duration(milliseconds: 800), () async {
          if (_mounted) {
            await _makeRobotMove();
            // Stop thinking animation after robot move
            _setRobotThinking(false);
          }
        });
      }
    }

    return success;
  }

  /// Reset the current game
  void resetGame() {
    if (_mounted) {
      _setRobotThinking(false); // Reset thinking state

      // Create new game state with same config
      final newGameLogic = GameLogic(state.config);
      state = newGameLogic;

      // If robot should go first after reset, trigger robot move with thinking animation
      if (state.config.isRobotMode && state.getNextPlayer() == CellState.O) {
        // Small delay to allow UI to update after reset
        Future.delayed(const Duration(milliseconds: 100), () async {
          if (_mounted) {
            // Start thinking animation
            _setRobotThinking(true);

            await Future.delayed(const Duration(milliseconds: 800), () async {
              if (_mounted) {
                await _makeRobotMove();
                // Stop thinking animation after robot move
                _setRobotThinking(false);
              }
            });
          }
        });
      }
    }
  }

  /// Get current game result
  GameLogicResult get gameResult => state.checkGameState();

  /// Get available moves
  List<Position> get availableMoves => state.getAvailableMoves();

  /// Get current player
  CellState get currentPlayer => state.getNextPlayer();

  /// Check if game is over
  bool get isGameOver => state.checkGameState().isGameOver;

  /// Make robot move using the new robot service
  Future<void> _makeRobotMove() async {
    if (!_mounted || !state.config.isRobotMode) return;

    final robotConfig = state.config.robot;
    if (robotConfig == null) return;

    final robotService = RobotServiceFactory.createService(robotConfig);
    final availableMoves = state.getAvailableMoves();

    if (availableMoves.isEmpty) return;

    final robotMove = await robotService.getNextMove(
      availableMoves: availableMoves,
      board: state.board,
      boardSize: state.config.boardSizeValue,
      winCondition: state.config.winConditionValue,
      robotPlayer: CellState.O,
    );

    if (state.isCellEmpty(robotMove)) {
      state.makeMove(robotMove, CellState.O);
      // Update state once after the move is made
      _updateState();
    }
  }

  /// Update state to trigger UI rebuild
  void _updateState() {
    if (_mounted) {
      // Create new instance to trigger rebuild
      final newGameLogic = GameLogic(state.config);
      newGameLogic.setBoardState(state.getBoardCopy());
      // Force state change to trigger UI rebuild
      state = newGameLogic;
    }
  }
}

/// Extension for easy access to game data
extension GameProviderExtension on WidgetRef {
  GameNotifier get gameNotifier => read(gameProvider.notifier);
  GameLogic get gameState => watch(gameProvider);
  GameLogicResult get gameResult =>
      watch(gameProvider.select((state) => state.checkGameState()));
  List<Position> get availableMoves =>
      watch(gameProvider.select((state) => state.getAvailableMoves()));
  CellState get currentPlayer =>
      watch(gameProvider.select((state) => state.getNextPlayer()));
  bool get isGameOver =>
      watch(gameProvider.select((state) => state.checkGameState().isGameOver));
  bool get isRobotThinking => watch(
    gameProvider.notifier.select((notifier) => notifier.isRobotThinking),
  );
}
