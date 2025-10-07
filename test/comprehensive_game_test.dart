import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/core/models/game_config.dart';
import 'package:tictactoe_xo_royale/core/models/game_enums.dart';
import 'package:tictactoe_xo_royale/core/services/game_logic.dart';

void main() {
  group('Comprehensive Game Logic Tests', () {
    testWidgets('Test 3x3 board with 3 in a row win condition', (tester) async {
      final config = GameConfig(
        boardSize: BoardSize.threeByThree,
        winCondition: WinCondition.threeInRow,
        gameMode: GameMode.local,
        firstMove: FirstMove.player1,
        player1Name: 'Player 1',
        player2Name: 'Player 2',
      );

      final gameLogic = GameLogic(config);

      // Test row win
      gameLogic.makeMove(Position(0, 0), CellState.X);
      gameLogic.makeMove(Position(1, 0), CellState.O);
      gameLogic.makeMove(Position(0, 1), CellState.X);
      gameLogic.makeMove(Position(1, 1), CellState.O);
      gameLogic.makeMove(Position(0, 2), CellState.X);

      final result = gameLogic.checkGameState();
      expect(result.isWin, true);
      expect(result.winner, CellState.X);
      expect(result.winningLine, isNotNull);
      expect(result.winningLine!.length, 3);
    });

    testWidgets('Test 4x4 board with 4 in a row win condition', (tester) async {
      final config = GameConfig(
        boardSize: BoardSize.fourByFour,
        winCondition: WinCondition.fourInRow,
        gameMode: GameMode.local,
        firstMove: FirstMove.player1,
        player1Name: 'Player 1',
        player2Name: 'Player 2',
      );

      final gameLogic = GameLogic(config);

      // Test column win
      gameLogic.makeMove(Position(0, 0), CellState.X);
      gameLogic.makeMove(Position(0, 1), CellState.O);
      gameLogic.makeMove(Position(1, 0), CellState.X);
      gameLogic.makeMove(Position(1, 1), CellState.O);
      gameLogic.makeMove(Position(2, 0), CellState.X);
      gameLogic.makeMove(Position(2, 1), CellState.O);
      gameLogic.makeMove(Position(3, 0), CellState.X);

      final result = gameLogic.checkGameState();
      expect(result.isWin, true);
      expect(result.winner, CellState.X);
      expect(result.winningLine, isNotNull);
      expect(result.winningLine!.length, 4);
    });

    testWidgets('Test 5x5 board with 5 in a row win condition', (tester) async {
      final config = GameConfig(
        boardSize: BoardSize.fiveByFive,
        winCondition: WinCondition.fiveInRow,
        gameMode: GameMode.local,
        firstMove: FirstMove.player1,
        player1Name: 'Player 1',
        player2Name: 'Player 2',
      );

      final gameLogic = GameLogic(config);

      // Test diagonal win
      gameLogic.makeMove(Position(0, 0), CellState.X);
      gameLogic.makeMove(Position(0, 1), CellState.O);
      gameLogic.makeMove(Position(1, 1), CellState.X);
      gameLogic.makeMove(Position(0, 2), CellState.O);
      gameLogic.makeMove(Position(2, 2), CellState.X);
      gameLogic.makeMove(Position(0, 3), CellState.O);
      gameLogic.makeMove(Position(3, 3), CellState.X);
      gameLogic.makeMove(Position(0, 4), CellState.O);
      gameLogic.makeMove(Position(4, 4), CellState.X);

      final result = gameLogic.checkGameState();
      expect(result.isWin, true);
      expect(result.winner, CellState.X);
      expect(result.winningLine, isNotNull);
      expect(result.winningLine!.length, 5);
    });

    testWidgets('Test 4x4 board with 3 in a row win condition', (tester) async {
      final config = GameConfig(
        boardSize: BoardSize.fourByFour,
        winCondition: WinCondition.threeInRow,
        gameMode: GameMode.local,
        firstMove: FirstMove.player1,
        player1Name: 'Player 1',
        player2Name: 'Player 2',
      );

      final gameLogic = GameLogic(config);

      // Test anti-diagonal win
      gameLogic.makeMove(Position(0, 3), CellState.X);
      gameLogic.makeMove(Position(0, 2), CellState.O);
      gameLogic.makeMove(Position(1, 2), CellState.X);
      gameLogic.makeMove(Position(0, 1), CellState.O);
      gameLogic.makeMove(Position(2, 1), CellState.X);

      final result = gameLogic.checkGameState();
      expect(result.isWin, true);
      expect(result.winner, CellState.X);
      expect(result.winningLine, isNotNull);
      expect(result.winningLine!.length, 3);
    });

    testWidgets('Test draw condition on 3x3 board', (tester) async {
      final config = GameConfig(
        boardSize: BoardSize.threeByThree,
        winCondition: WinCondition.threeInRow,
        gameMode: GameMode.local,
        firstMove: FirstMove.player1,
        player1Name: 'Player 1',
        player2Name: 'Player 2',
      );

      final gameLogic = GameLogic(config);

      // Fill board without winner (proper draw scenario)
      gameLogic.makeMove(Position(0, 0), CellState.X);
      gameLogic.makeMove(Position(0, 1), CellState.O);
      gameLogic.makeMove(Position(0, 2), CellState.X);
      gameLogic.makeMove(Position(1, 0), CellState.O);
      gameLogic.makeMove(Position(1, 1), CellState.X);
      gameLogic.makeMove(Position(1, 2), CellState.O);
      gameLogic.makeMove(Position(2, 0), CellState.O);
      gameLogic.makeMove(Position(2, 1), CellState.X);
      gameLogic.makeMove(Position(2, 2), CellState.O);

      final result = gameLogic.checkGameState();
      expect(result.isDraw, true);
      expect(result.winner, isNull);
      expect(result.winningLine, isNull);
    });

    testWidgets('Test invalid moves are rejected', (tester) async {
      final config = GameConfig(
        boardSize: BoardSize.threeByThree,
        winCondition: WinCondition.threeInRow,
        gameMode: GameMode.local,
        firstMove: FirstMove.player1,
        player1Name: 'Player 1',
        player2Name: 'Player 2',
      );

      final gameLogic = GameLogic(config);

      // Test invalid position
      expect(gameLogic.makeMove(Position(-1, 0), CellState.X), false);
      expect(gameLogic.makeMove(Position(0, -1), CellState.X), false);
      expect(gameLogic.makeMove(Position(3, 0), CellState.X), false);
      expect(gameLogic.makeMove(Position(0, 3), CellState.X), false);

      // Test occupied cell
      gameLogic.makeMove(Position(0, 0), CellState.X);
      expect(gameLogic.makeMove(Position(0, 0), CellState.O), false);
    });

    testWidgets('Test available moves calculation', (tester) async {
      final config = GameConfig(
        boardSize: BoardSize.threeByThree,
        winCondition: WinCondition.threeInRow,
        gameMode: GameMode.local,
        firstMove: FirstMove.player1,
        player1Name: 'Player 1',
        player2Name: 'Player 2',
      );

      final gameLogic = GameLogic(config);

      // Initially all 9 cells should be available
      expect(gameLogic.getAvailableMoves().length, 9);

      // After one move, 8 should be available
      gameLogic.makeMove(Position(0, 0), CellState.X);
      expect(gameLogic.getAvailableMoves().length, 8);

      // After two moves, 7 should be available
      gameLogic.makeMove(Position(0, 1), CellState.O);
      expect(gameLogic.getAvailableMoves().length, 7);
    });

    testWidgets('Test cell state validation', (tester) async {
      final config = GameConfig(
        boardSize: BoardSize.threeByThree,
        winCondition: WinCondition.threeInRow,
        gameMode: GameMode.local,
        firstMove: FirstMove.player1,
        player1Name: 'Player 1',
        player2Name: 'Player 2',
      );

      final gameLogic = GameLogic(config);

      // Test empty cell
      expect(gameLogic.getCellState(Position(0, 0)), CellState.empty);
      expect(gameLogic.isCellEmpty(Position(0, 0)), true);

      // Test occupied cell
      gameLogic.makeMove(Position(0, 0), CellState.X);
      expect(gameLogic.getCellState(Position(0, 0)), CellState.X);
      expect(gameLogic.isCellEmpty(Position(0, 0)), false);

      // Test invalid position
      expect(gameLogic.getCellState(Position(-1, 0)), CellState.empty);
      expect(gameLogic.isCellEmpty(Position(-1, 0)), false);
    });
  });
}
