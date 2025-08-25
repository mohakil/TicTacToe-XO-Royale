import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/core/models/game_config.dart';
import 'package:tictactoe_xo_royale/core/services/game_logic.dart';
import 'package:tictactoe_xo_royale/core/services/robot_logic.dart';

void main() {
  group('RobotLogic Tests', () {
    late GameConfig config;
    late GameLogic gameLogic;
    late RobotLogic robotLogic;

    setUp(() {
      config = GameConfig.cpuConfig(difficulty: Difficulty.medium);
      gameLogic = GameLogic(config);
      robotLogic = RobotLogic(config, gameLogic);
    });

    group('Easy AI Tests', () {
      setUp(() {
        config = GameConfig.cpuConfig(difficulty: Difficulty.easy);
        gameLogic = GameLogic(config);
        robotLogic = RobotLogic(config, gameLogic);
      });

      test('Easy AI should make moves', () {
        final move = robotLogic.getNextMove(CellState.X);
        expect(gameLogic.isValidPosition(move), isTrue);
        expect(gameLogic.isCellEmpty(move), isTrue);
      });

      test('Easy AI should prefer center when available', () {
        // Make some moves to create a scenario where center is available
        gameLogic.makeMove(const Position(0, 0), CellState.X);
        gameLogic.makeMove(const Position(0, 1), CellState.O);

        // Run multiple times to test heuristic preference
        int centerMoves = 0;
        const iterations = 100;

        for (int i = 0; i < iterations; i++) {
          gameLogic.resetBoard();
          gameLogic.makeMove(const Position(0, 0), CellState.X);
          gameLogic.makeMove(const Position(0, 1), CellState.O);

          final move = robotLogic.getNextMove(CellState.X);
          if (move == const Position(1, 1)) {
            // Center
            centerMoves++;
          }
        }

        // Should prefer center significantly more than random
        expect(centerMoves, greaterThan(iterations * 0.3));
      });

      test('Easy AI should sometimes make blunders', () {
        // Create a scenario where opponent can win
        // X | O | X
        // O | X | O
        // - | - | -
        gameLogic.makeMove(const Position(0, 0), CellState.X);
        gameLogic.makeMove(const Position(0, 1), CellState.O);
        gameLogic.makeMove(const Position(0, 2), CellState.X);
        gameLogic.makeMove(const Position(1, 0), CellState.O);
        gameLogic.makeMove(const Position(1, 1), CellState.X);
        gameLogic.makeMove(const Position(1, 2), CellState.O);

        // Robot's turn - should sometimes choose the losing move
        int blunderMoves = 0;
        const iterations = 100;

        for (int i = 0; i < iterations; i++) {
          final move = robotLogic.getNextMove(CellState.X);
          if (move == const Position(2, 0) ||
              move == const Position(2, 1) ||
              move == const Position(2, 2)) {
            // These moves let O win
            blunderMoves++;
          }
        }

        // Should make some blunders (around 15% chance)
        expect(blunderMoves, greaterThan(0));
        expect(
          blunderMoves,
          lessThan(iterations * 0.5),
        ); // Not too many blunders
      });
    });

    group('Medium AI Tests', () {
      setUp(() {
        config = GameConfig.cpuConfig(difficulty: Difficulty.medium);
        gameLogic = GameLogic(config);
        robotLogic = RobotLogic(config, gameLogic);
      });

      test('Medium AI should make moves', () {
        final move = robotLogic.getNextMove(CellState.X);
        expect(gameLogic.isValidPosition(move), isTrue);
        expect(gameLogic.isCellEmpty(move), isTrue);
      });

      test('Medium AI should block opponent wins', () {
        // Create a scenario where O can win next move
        // X | O | X
        // O | X | O
        // - | - | -
        gameLogic.makeMove(const Position(0, 0), CellState.X);
        gameLogic.makeMove(const Position(0, 1), CellState.O);
        gameLogic.makeMove(const Position(0, 2), CellState.X);
        gameLogic.makeMove(const Position(1, 0), CellState.O);
        gameLogic.makeMove(const Position(1, 1), CellState.X);
        gameLogic.makeMove(const Position(1, 2), CellState.O);

        // Robot should block O from winning
        final move = robotLogic.getNextMove(CellState.X);
        expect(move, isNot(equals(const Position(2, 0))));
        expect(move, isNot(equals(const Position(2, 1))));
        expect(move, isNot(equals(const Position(2, 2))));
      });

      test('Medium AI should take winning moves', () {
        // Create a scenario where X can win next move
        // X | O | X
        // O | X | O
        // - | - | -
        gameLogic.makeMove(const Position(0, 0), CellState.X);
        gameLogic.makeMove(const Position(0, 1), CellState.O);
        gameLogic.makeMove(const Position(0, 2), CellState.X);
        gameLogic.makeMove(const Position(1, 0), CellState.O);
        gameLogic.makeMove(const Position(1, 1), CellState.X);
        gameLogic.makeMove(const Position(1, 2), CellState.O);

        // Robot should take the winning move
        final move = robotLogic.getNextMove(CellState.X);
        expect(move, equals(const Position(2, 1))); // This creates diagonal win
      });
    });

    group('Hard AI Tests', () {
      setUp(() {
        config = GameConfig.cpuConfig(difficulty: Difficulty.hard);
        gameLogic = GameLogic(config);
        robotLogic = RobotLogic(config, gameLogic);
      });

      test('Hard AI should make moves', () {
        final move = robotLogic.getNextMove(CellState.X);
        expect(gameLogic.isValidPosition(move), isTrue);
        expect(gameLogic.isCellEmpty(move), isTrue);
      });

      test('Hard AI should play optimally in simple scenarios', () {
        // First move should be center (optimal strategy)
        final move = robotLogic.getNextMove(CellState.X);
        expect(move, equals(const Position(1, 1)));
      });

      test('Hard AI should block opponent wins', () {
        // Create a scenario where O can win next move
        // X | O | X
        // O | X | O
        // - | - | -
        gameLogic.makeMove(const Position(0, 0), CellState.X);
        gameLogic.makeMove(const Position(0, 1), CellState.O);
        gameLogic.makeMove(const Position(0, 2), CellState.X);
        gameLogic.makeMove(const Position(1, 0), CellState.O);
        gameLogic.makeMove(const Position(1, 1), CellState.X);
        gameLogic.makeMove(const Position(1, 2), CellState.O);

        // Robot should block O from winning
        final move = robotLogic.getNextMove(CellState.X);
        expect(move, isNot(equals(const Position(2, 0))));
        expect(move, isNot(equals(const Position(2, 1))));
        expect(move, isNot(equals(const Position(2, 2))));
      });

      test('Hard AI should take winning moves', () {
        // Create a scenario where X can win next move
        // X | O | X
        // O | X | O
        // - | - | -
        gameLogic.makeMove(const Position(0, 0), CellState.X);
        gameLogic.makeMove(const Position(0, 1), CellState.O);
        gameLogic.makeMove(const Position(0, 2), CellState.X);
        gameLogic.makeMove(const Position(1, 0), CellState.O);
        gameLogic.makeMove(const Position(1, 1), CellState.X);
        gameLogic.makeMove(const Position(1, 2), CellState.O);

        // Robot should take the winning move
        final move = robotLogic.getNextMove(CellState.X);
        expect(move, equals(const Position(2, 1))); // This creates diagonal win
      });
    });

    group('Hint System Tests', () {
      test('Hint should suggest immediate win when available', () {
        // Create a scenario where X can win next move
        // X | O | X
        // O | X | O
        // - | - | -
        gameLogic.makeMove(const Position(0, 0), CellState.X);
        gameLogic.makeMove(const Position(0, 1), CellState.O);
        gameLogic.makeMove(const Position(0, 2), CellState.X);
        gameLogic.makeMove(const Position(1, 0), CellState.O);
        gameLogic.makeMove(const Position(1, 1), CellState.X);
        gameLogic.makeMove(const Position(1, 2), CellState.O);

        final hint = robotLogic.getHint(CellState.X);
        expect(hint, equals(const Position(2, 1))); // This creates diagonal win
      });

      test(
        'Hint should suggest blocking opponent win when no immediate win',
        () {
          // Create a scenario where O can win next move, but X cannot
          // X | O | X
          // O | X | O
          // - | - | -
          gameLogic.makeMove(const Position(0, 0), CellState.X);
          gameLogic.makeMove(const Position(0, 1), CellState.O);
          gameLogic.makeMove(const Position(0, 2), CellState.X);
          gameLogic.makeMove(const Position(1, 0), CellState.O);
          gameLogic.makeMove(const Position(1, 1), CellState.X);
          gameLogic.makeMove(const Position(1, 2), CellState.O);

          final hint = robotLogic.getHint(CellState.O);
          // Should suggest one of the bottom row positions to win
          expect(hint.row, equals(2));
        },
      );

      test('Hint should prefer center when no immediate win or block', () {
        // Empty board
        final hint = robotLogic.getHint(CellState.X);
        expect(hint, equals(const Position(1, 1))); // Center
      });

      test('Hint should prefer corners when center not available', () {
        // Center is taken
        gameLogic.makeMove(const Position(1, 1), CellState.O);

        final hint = robotLogic.getHint(CellState.X);
        final corners = PositionExtensions.getCorners(3);
        expect(corners, contains(hint));
      });

      test(
        'Hint should prefer edges when center and corners not available',
        () {
          // Center and corners are taken
          gameLogic.makeMove(const Position(1, 1), CellState.O);
          gameLogic.makeMove(const Position(0, 0), CellState.X);
          gameLogic.makeMove(const Position(0, 2), CellState.O);
          gameLogic.makeMove(const Position(2, 0), CellState.X);
          gameLogic.makeMove(const Position(2, 2), CellState.O);

          final hint = robotLogic.getHint(CellState.X);
          final edges = PositionExtensions.getEdges(3);
          expect(edges, contains(hint));
        },
      );

      test('Multiple hints should return different positions', () {
        final hints = robotLogic.getMultipleHints(CellState.X, count: 3);
        expect(hints.length, equals(3));

        // All hints should be unique
        expect(hints.toSet().length, equals(3));

        // All hints should be valid positions
        for (final hint in hints) {
          expect(gameLogic.isValidPosition(hint), isTrue);
          expect(gameLogic.isCellEmpty(hint), isTrue);
        }
      });
    });

    group('Position Evaluation Tests', () {
      test('Empty board should have neutral evaluation', () {
        final score = robotLogic.evaluatePosition(CellState.X);
        expect(score, equals(0));
      });

      test('Winning position should have high positive score', () {
        // Create a win for X
        gameLogic.makeMove(const Position(0, 0), CellState.X);
        gameLogic.makeMove(const Position(0, 1), CellState.X);
        gameLogic.makeMove(const Position(0, 2), CellState.X);

        final score = robotLogic.evaluatePosition(CellState.X);
        expect(score, equals(100));
      });

      test('Losing position should have high negative score', () {
        // Create a win for O
        gameLogic.makeMove(const Position(0, 0), CellState.O);
        gameLogic.makeMove(const Position(0, 1), CellState.O);
        gameLogic.makeMove(const Position(0, 2), CellState.O);

        final score = robotLogic.evaluatePosition(CellState.X);
        expect(score, equals(-100));
      });

      test('Draw position should have neutral score', () {
        // Create a draw
        // X | O | X
        // O | X | O
        // O | X | O
        gameLogic.makeMove(const Position(0, 0), CellState.X);
        gameLogic.makeMove(const Position(0, 1), CellState.O);
        gameLogic.makeMove(const Position(0, 2), CellState.X);
        gameLogic.makeMove(const Position(1, 0), CellState.O);
        gameLogic.makeMove(const Position(1, 1), CellState.X);
        gameLogic.makeMove(const Position(1, 2), CellState.O);
        gameLogic.makeMove(const Position(2, 0), CellState.O);
        gameLogic.makeMove(const Position(2, 1), CellState.X);
        gameLogic.makeMove(const Position(2, 2), CellState.O);

        final score = robotLogic.evaluatePosition(CellState.X);
        expect(score, equals(0));
      });
    });

    group('Large Board Tests', () {
      test('4x4 board with 4-in-a-row should work', () {
        final largeConfig = GameConfig.cpuConfig(
          difficulty: Difficulty.hard,
          boardSize: 4,
          winCondition: 4,
        );
        final largeGameLogic = GameLogic(largeConfig);
        final largeRobotLogic = RobotLogic(largeConfig, largeGameLogic);

        final move = largeRobotLogic.getNextMove(CellState.X);
        expect(largeGameLogic.isValidPosition(move), isTrue);
        expect(largeGameLogic.isCellEmpty(move), isTrue);
      });

      test('5x5 board with 5-in-a-row should work', () {
        final largeConfig = GameConfig.cpuConfig(
          difficulty: Difficulty.hard,
          boardSize: 5,
          winCondition: 5,
        );
        final largeGameLogic = GameLogic(largeConfig);
        final largeRobotLogic = RobotLogic(largeConfig, largeGameLogic);

        final move = largeRobotLogic.getNextMove(CellState.X);
        expect(largeGameLogic.isValidPosition(move), isTrue);
        expect(largeGameLogic.isCellEmpty(move), isTrue);
      });
    });

    group('Edge Case Tests', () {
      test('Robot should handle almost full board', () {
        // Fill most of the board
        gameLogic.makeMove(const Position(0, 0), CellState.X);
        gameLogic.makeMove(const Position(0, 1), CellState.O);
        gameLogic.makeMove(const Position(0, 2), CellState.X);
        gameLogic.makeMove(const Position(1, 0), CellState.O);
        gameLogic.makeMove(const Position(1, 1), CellState.X);
        gameLogic.makeMove(const Position(1, 2), CellState.O);
        gameLogic.makeMove(const Position(2, 0), CellState.X);
        gameLogic.makeMove(const Position(2, 1), CellState.O);

        // Only one position left
        final move = robotLogic.getNextMove(CellState.X);
        expect(move, equals(const Position(2, 2)));
      });

      test('Robot should handle single available move', () {
        // Fill all but one position
        gameLogic.makeMove(const Position(0, 0), CellState.X);
        gameLogic.makeMove(const Position(0, 1), CellState.O);
        gameLogic.makeMove(const Position(0, 2), CellState.X);
        gameLogic.makeMove(const Position(1, 0), CellState.O);
        gameLogic.makeMove(const Position(1, 1), CellState.X);
        gameLogic.makeMove(const Position(1, 2), CellState.O);
        gameLogic.makeMove(const Position(2, 0), CellState.X);
        gameLogic.makeMove(const Position(2, 1), CellState.O);

        final move = robotLogic.getNextMove(CellState.X);
        expect(move, equals(const Position(2, 2)));
      });
    });
  });
}
