import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/models/game_config.dart';

import 'package:tictactoe_xo_royale/core/services/game_logic.dart';

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
      // Update the state by creating a new GameLogic instance with the same configuration
      // but with the updated board state. Since GameLogic is mutable, we need to trigger
      // a state update to notify listeners.
      state = GameLogic(state.config)..setBoardState(state.getBoardCopy());
    }
  }

  void resetGame() {
    state = GameLogic(state.config);
  }

  GameResult checkGameResult() => state.checkGameState();

  List<Position> getAvailableMoves() => state.getAvailableMoves();
}
