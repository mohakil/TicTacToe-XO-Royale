import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/core/models/game_enums.dart';
import 'package:tictactoe_xo_royale/core/models/robot_config.dart';
import 'package:tictactoe_xo_royale/core/services/robot_service.dart';
import 'package:tictactoe_xo_royale/core/services/game_logic.dart';

void main() {
  group('RobotConfig Tests', () {
    test('should create default robot config', () {
      final config = RobotConfig.defaultConfig();

      expect(config.difficulty, Difficulty.medium);
      expect(config.playerName, 'CPU');
      expect(config.isEnabled, true);
      expect(config.isValid, true);
    });

    test('should create robot config for specific difficulty', () {
      final config = RobotConfig.forDifficulty(Difficulty.hard);

      expect(config.difficulty, Difficulty.hard);
      expect(config.playerName, 'CPU');
      expect(config.isEnabled, true);
    });

    test('should create custom robot config', () {
      final config = RobotConfig.custom(
        difficulty: Difficulty.easy,
        playerName: 'AI Player',
      );

      expect(config.difficulty, Difficulty.easy);
      expect(config.playerName, 'AI Player');
      expect(config.isEnabled, true);
    });

    test('should validate robot config correctly', () {
      final validConfig = RobotConfig.defaultConfig();
      expect(validConfig.isValid, true);

      final invalidConfig = RobotConfig.custom(
        difficulty: Difficulty.medium,
        playerName: '', // Empty name should be invalid
      );
      expect(invalidConfig.isValid, false);
    });

    test('should get correct difficulty string values', () {
      final easyConfig = RobotConfig.forDifficulty(Difficulty.easy);
      final mediumConfig = RobotConfig.forDifficulty(Difficulty.medium);
      final hardConfig = RobotConfig.forDifficulty(Difficulty.hard);

      expect(easyConfig.difficultyString, 'easy');
      expect(mediumConfig.difficultyString, 'medium');
      expect(hardConfig.difficultyString, 'hard');
    });

    test('should get correct difficulty display names', () {
      final easyConfig = RobotConfig.forDifficulty(Difficulty.easy);
      final mediumConfig = RobotConfig.forDifficulty(Difficulty.medium);
      final hardConfig = RobotConfig.forDifficulty(Difficulty.hard);

      expect(easyConfig.difficultyDisplayName, 'Easy');
      expect(mediumConfig.difficultyDisplayName, 'Medium');
      expect(hardConfig.difficultyDisplayName, 'Hard');
    });

    test('should copy with new values', () {
      final original = RobotConfig.defaultConfig();
      final updated = original.copyWith(
        difficulty: Difficulty.hard,
        playerName: 'Advanced AI',
      );

      expect(updated.difficulty, Difficulty.hard);
      expect(updated.playerName, 'Advanced AI');
      expect(updated.isEnabled, true); // Should remain unchanged
    });

    test('should support equality and hashCode', () {
      final config1 = RobotConfig.forDifficulty(Difficulty.medium);
      final config2 = RobotConfig.forDifficulty(Difficulty.medium);
      final config3 = RobotConfig.forDifficulty(Difficulty.hard);

      expect(config1, equals(config2));
      expect(config1.hashCode, equals(config2.hashCode));
      expect(config1, isNot(equals(config3)));
    });
  });

  group('Robot Strategy Tests', () {
    test('should create correct strategy for each difficulty', () {
      expect(
        RobotStrategyFactory.createStrategy(Difficulty.easy),
        isA<EasyRobotStrategy>(),
      );
      expect(
        RobotStrategyFactory.createStrategy(Difficulty.medium),
        isA<MediumRobotStrategy>(),
      );
      expect(
        RobotStrategyFactory.createStrategy(Difficulty.hard),
        isA<HardRobotStrategy>(),
      );
    });
  });

  group('Robot Service Tests', () {
    late RobotService robotService;

    setUp(() {
      robotService = RobotService(
        config: RobotConfig.forDifficulty(Difficulty.easy),
      );
    });

    test('should create robot service with config', () {
      expect(robotService.config.difficulty, Difficulty.easy);
    });

    test('should get next move for easy difficulty', () {
      final board = List.generate(
        3,
        (_) => List.generate(3, (_) => CellState.empty),
      );
      final availableMoves = [
        const Position(0, 0),
        const Position(0, 1),
        const Position(1, 1),
      ];

      final move = robotService.getNextMove(
        availableMoves: availableMoves,
        board: board,
        boardSize: 3,
        winCondition: 3,
        robotPlayer: CellState.O,
      );

      expect(availableMoves, contains(move));
    });

    test('should return hint for immediate win', () {
      final board = [
        [CellState.O, CellState.O, CellState.empty],
        [CellState.X, CellState.X, CellState.empty],
        [CellState.empty, CellState.empty, CellState.empty],
      ];
      final availableMoves = [
        const Position(0, 2),
        const Position(1, 2),
        const Position(2, 0),
        const Position(2, 1),
        const Position(2, 2),
      ];

      final hint = robotService.getHint(
        availableMoves: availableMoves,
        board: board,
        boardSize: 3,
        winCondition: 3,
        currentPlayer: CellState.O,
      );

      expect(hint, const Position(0, 2)); // Should suggest winning move
    });

    test('should return hint to block opponent win', () {
      final board = [
        [CellState.X, CellState.X, CellState.empty],
        [CellState.O, CellState.O, CellState.empty],
        [CellState.empty, CellState.empty, CellState.empty],
      ];
      final availableMoves = [
        const Position(0, 2),
        const Position(1, 2),
        const Position(2, 0),
        const Position(2, 1),
        const Position(2, 2),
      ];

      final hint = robotService.getHint(
        availableMoves: availableMoves,
        board: board,
        boardSize: 3,
        winCondition: 3,
        currentPlayer: CellState.O,
      );

      expect(hint, const Position(0, 2)); // Should suggest blocking move
    });

    test('should prefer center position for hint', () {
      final board = List.generate(
        3,
        (_) => List.generate(3, (_) => CellState.empty),
      );
      final availableMoves = [
        const Position(0, 0),
        const Position(1, 1), // Center
        const Position(2, 2),
      ];

      final hint = robotService.getHint(
        availableMoves: availableMoves,
        board: board,
        boardSize: 3,
        winCondition: 3,
        currentPlayer: CellState.O,
      );

      expect(hint, const Position(1, 1)); // Should prefer center
    });

    test('should handle empty available moves', () {
      final board = List.generate(
        3,
        (_) => List.generate(3, (_) => CellState.empty),
      );
      final availableMoves = <Position>[];

      final move = robotService.getNextMove(
        availableMoves: availableMoves,
        board: board,
        boardSize: 3,
        winCondition: 3,
        robotPlayer: CellState.O,
      );

      expect(move, const Position(0, 0)); // Should return default position
    });
  });

  group('Game Enums Tests', () {
    test('should convert GameMode to string and back', () {
      expect(GameMode.local.value, 'local');
      expect(GameMode.robot.value, 'robot');

      expect(GameModeExtension.fromString('local'), GameMode.local);
      expect(GameModeExtension.fromString('robot'), GameMode.robot);
      expect(
        GameModeExtension.fromString('invalid'),
        GameMode.local,
      ); // Default fallback
    });

    test('should convert Difficulty to string and back', () {
      expect(Difficulty.easy.value, 'easy');
      expect(Difficulty.medium.value, 'medium');
      expect(Difficulty.hard.value, 'hard');

      expect(DifficultyExtension.fromString('easy'), Difficulty.easy);
      expect(DifficultyExtension.fromString('medium'), Difficulty.medium);
      expect(DifficultyExtension.fromString('hard'), Difficulty.hard);
      expect(
        DifficultyExtension.fromString('invalid'),
        Difficulty.medium,
      ); // Default fallback
    });

    test('should convert BoardSize to int and back', () {
      expect(BoardSize.threeByThree.value, 3);
      expect(BoardSize.fourByFour.value, 4);
      expect(BoardSize.fiveByFive.value, 5);

      expect(BoardSizeExtension.fromInt(3), BoardSize.threeByThree);
      expect(BoardSizeExtension.fromInt(4), BoardSize.fourByFour);
      expect(BoardSizeExtension.fromInt(5), BoardSize.fiveByFive);
      expect(
        BoardSizeExtension.fromInt(6),
        BoardSize.threeByThree,
      ); // Default fallback
    });

    test('should validate win condition for board size', () {
      // 3x3 board
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

      // 4x4 board
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

      // 5x5 board
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
}
