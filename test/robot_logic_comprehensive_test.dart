import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/core/models/game_config.dart';
import 'package:tictactoe_xo_royale/core/models/game_enums.dart';
import 'package:tictactoe_xo_royale/core/models/robot_config.dart';
import 'package:tictactoe_xo_royale/core/services/game_logic.dart';
import 'package:tictactoe_xo_royale/core/services/robot_service.dart';

void main() {
  group('Robot Logic Comprehensive Tests', () {
    group('Win Detection for All Board Sizes', () {
      test('3x3 board with 3-in-a-row win detection', () {
        final config = GameConfig(
          boardSize: BoardSize.threeByThree,
          winCondition: WinCondition.threeInRow,
          gameMode: GameMode.robot,
          firstMove: FirstMove.player1,
          player1Name: 'Player',
          player2Name: 'Robot',
          robotConfig: RobotConfig.forDifficulty(Difficulty.hard),
        );

        final gameLogic = GameLogic(config);

        // Test horizontal win
        gameLogic.makeMove(const Position(0, 0), CellState.X);
        gameLogic.makeMove(const Position(0, 1), CellState.X);
        gameLogic.makeMove(const Position(0, 2), CellState.X);

        final result = gameLogic.checkGameState();
        expect(result.isWin, true);
        expect(result.winner, CellState.X);
        expect(result.winningLine, [
          const Position(0, 0),
          const Position(0, 1),
          const Position(0, 2),
        ]);
      });

      test('4x4 board with 3-in-a-row win detection', () {
        final config = GameConfig(
          boardSize: BoardSize.fourByFour,
          winCondition: WinCondition.threeInRow,
          gameMode: GameMode.robot,
          firstMove: FirstMove.player1,
          player1Name: 'Player',
          player2Name: 'Robot',
          robotConfig: RobotConfig.forDifficulty(Difficulty.hard),
        );

        final gameLogic = GameLogic(config);

        // Test diagonal win
        gameLogic.makeMove(const Position(0, 0), CellState.O);
        gameLogic.makeMove(const Position(1, 1), CellState.O);
        gameLogic.makeMove(const Position(2, 2), CellState.O);

        final result = gameLogic.checkGameState();
        expect(result.isWin, true);
        expect(result.winner, CellState.O);
        expect(result.winningLine, [
          const Position(0, 0),
          const Position(1, 1),
          const Position(2, 2),
        ]);
      });

      test('4x4 board with 4-in-a-row win detection', () {
        final config = GameConfig(
          boardSize: BoardSize.fourByFour,
          winCondition: WinCondition.fourInRow,
          gameMode: GameMode.robot,
          firstMove: FirstMove.player1,
          player1Name: 'Player',
          player2Name: 'Robot',
          robotConfig: RobotConfig.forDifficulty(Difficulty.hard),
        );

        final gameLogic = GameLogic(config);

        // Test vertical win
        gameLogic.makeMove(const Position(0, 0), CellState.X);
        gameLogic.makeMove(const Position(1, 0), CellState.X);
        gameLogic.makeMove(const Position(2, 0), CellState.X);
        gameLogic.makeMove(const Position(3, 0), CellState.X);

        final result = gameLogic.checkGameState();
        expect(result.isWin, true);
        expect(result.winner, CellState.X);
        expect(result.winningLine, [
          const Position(0, 0),
          const Position(1, 0),
          const Position(2, 0),
          const Position(3, 0),
        ]);
      });

      test('5x5 board with 5-in-a-row win detection', () {
        final config = GameConfig(
          boardSize: BoardSize.fiveByFive,
          winCondition: WinCondition.fiveInRow,
          gameMode: GameMode.robot,
          firstMove: FirstMove.player1,
          player1Name: 'Player',
          player2Name: 'Robot',
          robotConfig: RobotConfig.forDifficulty(Difficulty.hard),
        );

        final gameLogic = GameLogic(config);

        // Test anti-diagonal win
        gameLogic.makeMove(const Position(0, 4), CellState.O);
        gameLogic.makeMove(const Position(1, 3), CellState.O);
        gameLogic.makeMove(const Position(2, 2), CellState.O);
        gameLogic.makeMove(const Position(3, 1), CellState.O);
        gameLogic.makeMove(const Position(4, 0), CellState.O);

        final result = gameLogic.checkGameState();
        expect(result.isWin, true);
        expect(result.winner, CellState.O);
        expect(result.winningLine, [
          const Position(0, 4),
          const Position(1, 3),
          const Position(2, 2),
          const Position(3, 1),
          const Position(4, 0),
        ]);
      });

      test('Multiple diagonal lines detection on 5x5 board', () {
        final config = GameConfig(
          boardSize: BoardSize.fiveByFive,
          winCondition: WinCondition.threeInRow,
          gameMode: GameMode.robot,
          firstMove: FirstMove.player1,
          player1Name: 'Player',
          player2Name: 'Robot',
          robotConfig: RobotConfig.forDifficulty(Difficulty.hard),
        );

        final gameLogic = GameLogic(config);

        // Test secondary diagonal line (not main diagonal)
        gameLogic.makeMove(const Position(1, 1), CellState.X);
        gameLogic.makeMove(const Position(2, 2), CellState.X);
        gameLogic.makeMove(const Position(3, 3), CellState.X);

        final result = gameLogic.checkGameState();
        expect(result.isWin, true);
        expect(result.winner, CellState.X);
        expect(result.winningLine, [
          const Position(1, 1),
          const Position(2, 2),
          const Position(3, 3),
        ]);
      });
    });

    group('Robot AI Strategies', () {
      test('Easy robot makes reasonable moves', () async {
        final config = GameConfig(
          boardSize: BoardSize.threeByThree,
          winCondition: WinCondition.threeInRow,
          gameMode: GameMode.robot,
          firstMove: FirstMove.player1,
          player1Name: 'Player',
          player2Name: 'Robot',
          robotConfig: RobotConfig.forDifficulty(Difficulty.easy),
        );

        final gameLogic = GameLogic(config);
        final robotService = RobotService(config: config.robotConfig!);

        // Make a move and get robot's response
        gameLogic.makeMove(const Position(0, 0), CellState.X);

        final availableMoves = gameLogic.getAvailableMoves();
        final robotMove = await robotService.getNextMove(
          availableMoves: availableMoves,
          board: gameLogic.board,
          boardSize: gameLogic.boardSize,
          winCondition: gameLogic.winCondition,
          robotPlayer: CellState.O,
        );

        expect(availableMoves.contains(robotMove), true);
        expect(gameLogic.isCellEmpty(robotMove), true);
      });

      test('Medium robot blocks immediate wins', () async {
        final config = GameConfig(
          boardSize: BoardSize.threeByThree,
          winCondition: WinCondition.threeInRow,
          gameMode: GameMode.robot,
          firstMove: FirstMove.player1,
          player1Name: 'Player',
          player2Name: 'Robot',
          robotConfig: RobotConfig.forDifficulty(Difficulty.medium),
        );

        final gameLogic = GameLogic(config);
        final robotService = RobotService(config: config.robotConfig!);

        // Set up a situation where player can win next move
        gameLogic.makeMove(const Position(0, 0), CellState.X);
        gameLogic.makeMove(const Position(0, 1), CellState.X);
        // Robot should block at (0, 2)

        final availableMoves = gameLogic.getAvailableMoves();
        final robotMove = await robotService.getNextMove(
          availableMoves: availableMoves,
          board: gameLogic.board,
          boardSize: gameLogic.boardSize,
          winCondition: gameLogic.winCondition,
          robotPlayer: CellState.O,
        );

        expect(robotMove, const Position(0, 2));
      });

      test('Hard robot takes immediate wins', () async {
        final config = GameConfig(
          boardSize: BoardSize.threeByThree,
          winCondition: WinCondition.threeInRow,
          gameMode: GameMode.robot,
          firstMove: FirstMove.player1,
          player1Name: 'Player',
          player2Name: 'Robot',
          robotConfig: RobotConfig.forDifficulty(Difficulty.hard),
        );

        final gameLogic = GameLogic(config);
        final robotService = RobotService(config: config.robotConfig!);

        // Set up a situation where robot can win
        gameLogic.makeMove(const Position(0, 0), CellState.X);
        gameLogic.makeMove(const Position(1, 0), CellState.O);
        gameLogic.makeMove(const Position(2, 0), CellState.X);
        gameLogic.makeMove(const Position(1, 1), CellState.O);
        // Robot should win at (1, 2)

        final availableMoves = gameLogic.getAvailableMoves();
        final robotMove = await robotService.getNextMove(
          availableMoves: availableMoves,
          board: gameLogic.board,
          boardSize: gameLogic.boardSize,
          winCondition: gameLogic.winCondition,
          robotPlayer: CellState.O,
        );

        expect(robotMove, const Position(1, 2));
      });

      test('Robot strategies work on 4x4 board', () async {
        final config = GameConfig(
          boardSize: BoardSize.fourByFour,
          winCondition: WinCondition.threeInRow,
          gameMode: GameMode.robot,
          firstMove: FirstMove.player1,
          player1Name: 'Player',
          player2Name: 'Robot',
          robotConfig: RobotConfig.forDifficulty(Difficulty.medium),
        );

        final gameLogic = GameLogic(config);
        final robotService = RobotService(config: config.robotConfig!);

        // Test that robot can make moves on larger board
        gameLogic.makeMove(const Position(0, 0), CellState.X);

        final availableMoves = gameLogic.getAvailableMoves();
        final robotMove = await robotService.getNextMove(
          availableMoves: availableMoves,
          board: gameLogic.board,
          boardSize: gameLogic.boardSize,
          winCondition: gameLogic.winCondition,
          robotPlayer: CellState.O,
        );

        expect(availableMoves.contains(robotMove), true);
        expect(gameLogic.isCellEmpty(robotMove), true);
      });

      test('Robot strategies work on 5x5 board', () async {
        final config = GameConfig(
          boardSize: BoardSize.fiveByFive,
          winCondition: WinCondition.fourInRow,
          gameMode: GameMode.robot,
          firstMove: FirstMove.player1,
          player1Name: 'Player',
          player2Name: 'Robot',
          robotConfig: RobotConfig.forDifficulty(Difficulty.hard),
        );

        final gameLogic = GameLogic(config);
        final robotService = RobotService(config: config.robotConfig!);

        // Test that robot can make moves on largest board
        gameLogic.makeMove(const Position(0, 0), CellState.X);

        final availableMoves = gameLogic.getAvailableMoves();
        final robotMove = await robotService.getNextMove(
          availableMoves: availableMoves,
          board: gameLogic.board,
          boardSize: gameLogic.boardSize,
          winCondition: gameLogic.winCondition,
          robotPlayer: CellState.O,
        );

        expect(availableMoves.contains(robotMove), true);
        expect(gameLogic.isCellEmpty(robotMove), true);
      });
    });

    group('Win Condition Validation', () {
      test('Win conditions are valid for board sizes', () {
        expect(
          WinCondition.threeInRow.isValidForBoardSize(BoardSize.threeByThree),
          true,
        );
        expect(
          WinCondition.fourInRow.isValidForBoardSize(BoardSize.threeByThree),
          false,
        );
        expect(
          WinCondition.fiveInRow.isValidForBoardSize(BoardSize.threeByThree),
          false,
        );

        expect(
          WinCondition.threeInRow.isValidForBoardSize(BoardSize.fourByFour),
          true,
        );
        expect(
          WinCondition.fourInRow.isValidForBoardSize(BoardSize.fourByFour),
          true,
        );
        expect(
          WinCondition.fiveInRow.isValidForBoardSize(BoardSize.fourByFour),
          false,
        );

        expect(
          WinCondition.threeInRow.isValidForBoardSize(BoardSize.fiveByFive),
          true,
        );
        expect(
          WinCondition.fourInRow.isValidForBoardSize(BoardSize.fiveByFive),
          true,
        );
        expect(
          WinCondition.fiveInRow.isValidForBoardSize(BoardSize.fiveByFive),
          true,
        );
      });
    });

    group('Performance Tests', () {
      test('Robot AI responds quickly on 5x5 board', () async {
        final config = GameConfig(
          boardSize: BoardSize.fiveByFive,
          winCondition: WinCondition.fourInRow,
          gameMode: GameMode.robot,
          firstMove: FirstMove.player1,
          player1Name: 'Player',
          player2Name: 'Robot',
          robotConfig: RobotConfig.forDifficulty(Difficulty.hard),
        );

        final gameLogic = GameLogic(config);
        final robotService = RobotService(config: config.robotConfig!);

        // Fill some cells to make it more complex
        gameLogic.makeMove(const Position(0, 0), CellState.X);
        gameLogic.makeMove(const Position(0, 1), CellState.O);
        gameLogic.makeMove(const Position(1, 0), CellState.X);
        gameLogic.makeMove(const Position(1, 1), CellState.O);
        gameLogic.makeMove(const Position(2, 0), CellState.X);

        final stopwatch = Stopwatch()..start();

        final availableMoves = gameLogic.getAvailableMoves();
        final robotMove = await robotService.getNextMove(
          availableMoves: availableMoves,
          board: gameLogic.board,
          boardSize: gameLogic.boardSize,
          winCondition: gameLogic.winCondition,
          robotPlayer: CellState.O,
        );

        stopwatch.stop();

        expect(availableMoves.contains(robotMove), true);
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(1000),
        ); // Should respond within 1 second
      });
    });
  });
}
