import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/core/models/game_config.dart';
import 'package:tictactoe_xo_royale/core/models/game_enums.dart';
import 'package:tictactoe_xo_royale/core/services/game_logic.dart';

void main() {
  group('GameLogic Tests', () {
    late GameConfig config;
    late GameLogic gameLogic;

    setUp(() {
      config = GameConfig.defaultConfig();
      gameLogic = GameLogic(config);
    });

    group('Position Tests', () {
      test('Position equality and hashCode', () {
        const pos1 = Position(1, 2);
        const pos2 = Position(1, 2);
        const pos3 = Position(2, 1);

        expect(pos1, equals(pos2));
        expect(pos1.hashCode, equals(pos2.hashCode));
        expect(pos1, isNot(equals(pos3)));
      });

      test('Position toString', () {
        const pos = Position(1, 2);
        expect(pos.toString(), equals('Position(1, 2)'));
      });
    });

    group('Board Initialization Tests', () {
      test('Board should be empty initially', () {
        expect(gameLogic.board.length, equals(3));
        expect(gameLogic.board[0].length, equals(3));
        expect(
          gameLogic.board.every(
            (row) => row.every((cell) => cell == CellState.empty),
          ),
          isTrue,
        );
      });

      test('Board size should match config', () {
        expect(gameLogic.boardSize, equals(3));
        expect(gameLogic.winCondition, equals(3));
      });

      test('Move count should be 0 initially', () {
        expect(gameLogic.moveCount, equals(0));
        expect(gameLogic.isFirstMove, isTrue);
      });
    });

    group('Position Validation Tests', () {
      test('Valid positions should be accepted', () {
        expect(gameLogic.isValidPosition(const Position(0, 0)), isTrue);
        expect(gameLogic.isValidPosition(const Position(2, 2)), isTrue);
        expect(gameLogic.isValidPosition(const Position(1, 1)), isTrue);
      });

      test('Invalid positions should be rejected', () {
        expect(gameLogic.isValidPosition(const Position(-1, 0)), isFalse);
        expect(gameLogic.isValidPosition(const Position(0, -1)), isFalse);
        expect(gameLogic.isValidPosition(const Position(3, 0)), isFalse);
        expect(gameLogic.isValidPosition(const Position(0, 3)), isFalse);
      });
    });

    group('Move Validation Tests', () {
      test('Empty cells should accept moves', () {
        expect(gameLogic.isCellEmpty(const Position(0, 0)), isTrue);
        expect(gameLogic.makeMove(const Position(0, 0), CellState.X), isTrue);
        expect(gameLogic.isCellEmpty(const Position(0, 0)), isFalse);
      });

      test('Occupied cells should reject moves', () {
        gameLogic.makeMove(const Position(0, 0), CellState.X);
        expect(gameLogic.makeMove(const Position(0, 0), CellState.O), isFalse);
      });

      test('Invalid positions should reject moves', () {
        expect(gameLogic.makeMove(const Position(-1, 0), CellState.X), isFalse);
        expect(gameLogic.makeMove(const Position(0, 3), CellState.O), isFalse);
      });
    });

    group('Game State Tests', () {
      test('Game should be playing initially', () {
        final result = gameLogic.checkGameState();
        expect(result.state, equals(GameState.playing));
        expect(result.isGameOver, isFalse);
        expect(result.availableMoves?.length, equals(9));
      });

      test('Game should detect horizontal win', () {
        // X | X | X
        // O | O | -
        // - | - | -
        gameLogic
          ..makeMove(const Position(0, 0), CellState.X)
          ..makeMove(const Position(1, 0), CellState.O)
          ..makeMove(const Position(0, 1), CellState.X)
          ..makeMove(const Position(1, 1), CellState.O)
          ..makeMove(const Position(0, 2), CellState.X);

        final result = gameLogic.checkGameState();
        expect(result.state, equals(GameState.win));
        expect(result.winner, equals(CellState.X));
        expect(result.winningLine?.length, equals(3));
        expect(result.winningLine, contains(const Position(0, 0)));
        expect(result.winningLine, contains(const Position(0, 1)));
        expect(result.winningLine, contains(const Position(0, 2)));
      });

      test('Game should detect vertical win', () {
        // X | O | -
        // X | O | -
        // X | - | -
        gameLogic
          ..makeMove(const Position(0, 0), CellState.X)
          ..makeMove(const Position(0, 1), CellState.O)
          ..makeMove(const Position(1, 0), CellState.X)
          ..makeMove(const Position(1, 1), CellState.O)
          ..makeMove(const Position(2, 0), CellState.X);

        final result = gameLogic.checkGameState();
        expect(result.state, equals(GameState.win));
        expect(result.winner, equals(CellState.X));
        expect(result.winningLine?.length, equals(3));
        expect(result.winningLine, contains(const Position(0, 0)));
        expect(result.winningLine, contains(const Position(1, 0)));
        expect(result.winningLine, contains(const Position(2, 0)));
      });

      test('Game should detect diagonal win', () {
        // X | O | -
        // O | X | -
        // - | - | X
        gameLogic
          ..makeMove(const Position(0, 0), CellState.X)
          ..makeMove(const Position(0, 1), CellState.O)
          ..makeMove(const Position(1, 1), CellState.X)
          ..makeMove(const Position(1, 0), CellState.O)
          ..makeMove(const Position(2, 2), CellState.X);

        final result = gameLogic.checkGameState();
        expect(result.state, equals(GameState.win));
        expect(result.winner, equals(CellState.X));
        expect(result.winningLine?.length, equals(3));
        expect(result.winningLine, contains(const Position(0, 0)));
        expect(result.winningLine, contains(const Position(1, 1)));
        expect(result.winningLine, contains(const Position(2, 2)));
      });

      test('Game should detect draw', () {
        // X | O | X
        // O | X | O
        // X | O | X
        // O | X | O
        // O | X | O
        gameLogic
          ..makeMove(const Position(0, 0), CellState.X)
          ..makeMove(const Position(0, 1), CellState.O)
          ..makeMove(const Position(0, 2), CellState.X)
          ..makeMove(const Position(1, 0), CellState.O)
          ..makeMove(const Position(1, 1), CellState.X)
          ..makeMove(const Position(1, 2), CellState.O)
          ..makeMove(const Position(2, 0), CellState.O)
          ..makeMove(const Position(2, 1), CellState.X)
          ..makeMove(const Position(2, 2), CellState.O);

        final result = gameLogic.checkGameState();
        expect(result.state, equals(GameState.draw));
        expect(result.winner, isNull);
        expect(result.winningLine, isNull);
        expect(result.availableMoves?.isEmpty, isTrue);
      });
    });

    group('Move Count Tests', () {
      test('Move count should increment with moves', () {
        expect(gameLogic.moveCount, equals(0));
        gameLogic.makeMove(const Position(0, 0), CellState.X);
        expect(gameLogic.moveCount, equals(1));
        gameLogic.makeMove(const Position(0, 1), CellState.O);
        expect(gameLogic.moveCount, equals(2));
      });

      test('Next player should alternate', () {
        expect(gameLogic.getNextPlayer(), equals(CellState.X));
        gameLogic.makeMove(const Position(0, 0), CellState.X);
        expect(gameLogic.getNextPlayer(), equals(CellState.O));
        gameLogic.makeMove(const Position(0, 1), CellState.O);
        expect(gameLogic.getNextPlayer(), equals(CellState.X));
      });
    });

    group('Board State Management Tests', () {
      test('Board copy should be independent', () {
        gameLogic.makeMove(const Position(0, 0), CellState.X);
        final boardCopy = gameLogic.getBoardCopy();

        // Modify the copy
        boardCopy[0][0] = CellState.O;

        // Original should be unchanged
        expect(
          gameLogic.getCellState(const Position(0, 0)),
          equals(CellState.X),
        );
        expect(boardCopy[0][0], equals(CellState.O));
      });

      test('Board reset should clear all moves', () {
        gameLogic
          ..makeMove(const Position(0, 0), CellState.X)
          ..makeMove(const Position(1, 1), CellState.O);
        expect(gameLogic.moveCount, equals(2));

        gameLogic.resetBoard();
        expect(gameLogic.moveCount, equals(0));
        expect(
          gameLogic.board.every(
            (row) => row.every((cell) => cell == CellState.empty),
          ),
          isTrue,
        );
      });

      test('Set board state should validate dimensions', () {
        final invalidBoard = [
          [CellState.X, CellState.O],
          [CellState.O, CellState.X, CellState.empty], // Wrong length
        ];

        expect(
          () => gameLogic.setBoardState(invalidBoard),
          throwsArgumentError,
        );
      });
    });

    group('Position Extensions Tests', () {
      test('Center position for 3x3 board', () {
        final center = PositionExtensions.getCenter(3);
        expect(center, equals(const Position(1, 1)));
      });

      test('Center position for 4x4 board', () {
        final center = PositionExtensions.getCenter(4);
        expect(center, equals(const Position(2, 2)));
      });

      test('Corner positions for 3x3 board', () {
        final corners = PositionExtensions.getCorners(3);
        expect(corners.length, equals(4));
        expect(corners, contains(const Position(0, 0)));
        expect(corners, contains(const Position(0, 2)));
        expect(corners, contains(const Position(2, 0)));
        expect(corners, contains(const Position(2, 2)));
      });

      test('Edge positions for 3x3 board', () {
        final edges = PositionExtensions.getEdges(3);
        expect(edges.length, equals(4));
        expect(edges, contains(const Position(0, 1)));
        expect(edges, contains(const Position(1, 0)));
        expect(edges, contains(const Position(1, 2)));
        expect(edges, contains(const Position(2, 1)));
      });

      test('Adjacent positions', () {
        const pos = Position(1, 1);
        final adjacent = pos.getAdjacent(3);
        expect(adjacent.length, equals(8));
        expect(adjacent, contains(const Position(0, 0)));
        expect(adjacent, contains(const Position(0, 1)));
        expect(adjacent, contains(const Position(0, 2)));
        expect(adjacent, contains(const Position(1, 0)));
        expect(adjacent, contains(const Position(1, 2)));
        expect(adjacent, contains(const Position(2, 0)));
        expect(adjacent, contains(const Position(2, 1)));
        expect(adjacent, contains(const Position(2, 2)));
      });
    });

    group('Large Board Tests', () {
      test('4x4 board with 4-in-a-row win condition', () {
        const largeConfig = GameConfig(
          boardSize: BoardSize.fourByFour,
          winCondition: WinCondition.fourInRow,
          gameMode: GameMode.local,
          firstMove: FirstMove.player1,
          player1Name: 'Player 1',
          player2Name: 'Player 2',
        );
        final largeGameLogic = GameLogic(largeConfig);

        expect(largeGameLogic.boardSize, equals(4));
        expect(largeGameLogic.winCondition, equals(4));
        expect(largeGameLogic.board.length, equals(4));
        expect(largeGameLogic.board[0].length, equals(4));
      });

      test('5x5 board with 5-in-a-row win condition', () {
        const largeConfig = GameConfig(
          boardSize: BoardSize.fiveByFive,
          winCondition: WinCondition.fiveInRow,
          gameMode: GameMode.local,
          firstMove: FirstMove.player1,
          player1Name: 'Player 1',
          player2Name: 'Player 2',
        );
        final largeGameLogic = GameLogic(largeConfig);

        expect(largeGameLogic.boardSize, equals(5));
        expect(largeGameLogic.winCondition, equals(5));
        expect(largeGameLogic.board.length, equals(5));
        expect(largeGameLogic.board[0].length, equals(5));
      });
    });

    group('Edge Case Tests', () {
      test('Empty board should have no winner', () {
        final result = gameLogic.checkGameState();
        expect(result.state, equals(GameState.playing));
        expect(result.winner, isNull);
        expect(result.winningLine, isNull);
      });

      test('Single move should not end game', () {
        gameLogic.makeMove(const Position(0, 0), CellState.X);
        final result = gameLogic.checkGameState();
        expect(result.state, equals(GameState.playing));
        expect(result.winner, isNull);
        expect(result.winningLine, isNull);
      });

      test('Undo move should restore board state', () {
        gameLogic.makeMove(const Position(0, 0), CellState.X);
        expect(
          gameLogic.getCellState(const Position(0, 0)),
          equals(CellState.X),
        );
        expect(gameLogic.moveCount, equals(1));

        gameLogic.undoMove(const Position(0, 0));
        expect(
          gameLogic.getCellState(const Position(0, 0)),
          equals(CellState.empty),
        );
        expect(gameLogic.moveCount, equals(0));
      });
    });
  });
}
