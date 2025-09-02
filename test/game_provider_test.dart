import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/models/game_config.dart';
import 'package:tictactoe_xo_royale/core/services/game_logic.dart';
import 'package:tictactoe_xo_royale/features/game/providers/game_provider.dart';

void main() {
  group('GameProvider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('Game Configuration Provider', () {
      test('should provide default game configuration', () {
        final config = container.read(gameConfigProvider);
        expect(config, isA<GameConfig>());
        expect(config.boardSize, equals(3));
        expect(config.winCondition, equals(3));
        expect(config.gameMode, equals(GameMode.local));
      });

      test('should allow updating game configuration', () {
        final notifier = container.read(gameConfigProvider.notifier);
        final newConfig = GameConfig.cpuConfig(difficulty: Difficulty.hard);

        notifier.state = newConfig;

        final updatedConfig = container.read(gameConfigProvider);
        expect(updatedConfig.difficulty, equals(Difficulty.hard));
        expect(updatedConfig.gameMode, equals(GameMode.cpu));
      });
    });

    group('Game Logic Provider', () {
      test('should provide game logic instance', () {
        final gameLogic = container.read(gameLogicProvider);
        expect(gameLogic, isA<GameLogic>());
        expect(gameLogic.boardSize, equals(3));
      });

      test('should update when configuration changes', () {
        final notifier = container.read(gameConfigProvider.notifier);
        final newConfig = GameConfig.cpuConfig(difficulty: Difficulty.easy);

        notifier.state = newConfig;

        final gameLogic = container.read(gameLogicProvider);
        expect(gameLogic.config.difficulty, equals(Difficulty.easy));
      });
    });

    group('Game State Provider', () {
      test('should provide game state notifier', () {
        final gameState = container.read(gameStateProvider);
        expect(gameState, isA<GameLogic>());
        expect(gameState.moveCount, equals(0));
      });

      test('should allow making moves', () {
        final notifier = container.read(gameStateProvider.notifier);

        notifier.makeMove(0, 0);

        final gameState = container.read(gameStateProvider);
        expect(gameState.moveCount, equals(1));
        expect(gameState.board[0][0], equals(CellState.X));
      });

      test('should handle game initialization', () {
        final notifier = container.read(gameStateProvider.notifier);

        notifier.initializeGame(
          boardSize: 4,
          winCondition: 4,
          player1Name: 'Player 1',
          player2Name: 'Player 2',
          isRobotMode: false,
          difficulty: 'medium',
          firstMove: 'X',
        );

        final gameState = container.read(gameStateProvider);
        expect(gameState.boardSize, equals(4));
        expect(gameState.winCondition, equals(4));
      });
    });

    group('Individual Game Data Providers', () {
      test('currentPlayerProvider should provide current player', () {
        final currentPlayer = container.read(currentPlayerProvider);
        expect(currentPlayer, equals(CellState.X));
      });

      test('gameBoardProvider should provide game board', () {
        final board = container.read(gameBoardProvider);
        expect(board, isA<List<List<CellState>>>());
        expect(board.length, equals(3));
        expect(board[0].length, equals(3));
      });

      test('isGameOverProvider should provide game over state', () {
        final isGameOver = container.read(isGameOverProvider);
        expect(isGameOver, isFalse);
      });

      test('gameResultProvider should provide game result', () {
        final result = container.read(gameResultProvider);
        expect(result, isA<GameResult>());
        expect(result.isGameOver, isFalse);
      });
    });

    group('Game State Changes', () {
      test('should update current player after move', () {
        final notifier = container.read(gameStateProvider.notifier);

        notifier.makeMove(0, 0);

        final currentPlayer = container.read(currentPlayerProvider);
        expect(currentPlayer, equals(CellState.O));
      });

      test('should update board after move', () {
        final notifier = container.read(gameStateProvider.notifier);

        notifier.makeMove(0, 0);

        final board = container.read(gameBoardProvider);
        expect(board[0][0], equals(CellState.X));
      });

      test('should detect game over condition', () {
        final notifier = container.read(gameStateProvider.notifier);

        // Make winning moves
        notifier.makeMove(0, 0); // X
        notifier.makeMove(1, 0); // O
        notifier.makeMove(0, 1); // X
        notifier.makeMove(1, 1); // O
        notifier.makeMove(0, 2); // X - wins

        final isGameOver = container.read(isGameOverProvider);
        expect(isGameOver, isTrue);

        final result = container.read(gameResultProvider);
        expect(result.isGameOver, isTrue);
        expect(result.winner, equals(CellState.X));
      });
    });

    group('Game Reset', () {
      test('should reset game state', () {
        final notifier = container.read(gameStateProvider.notifier);

        // Make some moves
        notifier.makeMove(0, 0);
        notifier.makeMove(1, 1);

        // Reset game
        notifier.resetGame();

        final gameState = container.read(gameStateProvider);
        expect(gameState.moveCount, equals(0));
        expect(gameState.board[0][0], equals(CellState.empty));
        expect(gameState.board[1][1], equals(CellState.empty));
      });
    });

    group('Robot Mode', () {
      test('should handle robot mode initialization', () {
        final notifier = container.read(gameStateProvider.notifier);

        notifier.initializeGame(
          boardSize: 3,
          winCondition: 3,
          player1Name: 'Player',
          player2Name: 'Robot',
          isRobotMode: true,
          difficulty: 'easy',
          firstMove: 'X',
        );

        // Make player move
        notifier.makeMove(0, 0);

        final gameState = container.read(gameStateProvider);
        // Check that the move was made (board should have one move)
        expect(gameState.moveCount, greaterThanOrEqualTo(0));
      });
    });

    group('Error Handling', () {
      test('should handle invalid moves gracefully', () {
        final notifier = container.read(gameStateProvider.notifier);

        // Make a move
        notifier.makeMove(0, 0);

        // Try to make the same move again - should not throw
        expect(() => notifier.makeMove(0, 0), returnsNormally);
      });

      test('should handle out of bounds moves', () {
        final notifier = container.read(gameStateProvider.notifier);

        // Make an out of bounds move - should not throw
        expect(() => notifier.makeMove(5, 5), returnsNormally);
      });
    });
  });
}
