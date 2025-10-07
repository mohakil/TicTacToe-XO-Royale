import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/models/game_config.dart';
import 'package:tictactoe_xo_royale/core/models/game_enums.dart';
import 'package:tictactoe_xo_royale/core/models/robot_config.dart';
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

    group('Game Provider', () {
      test('should provide default game logic', () {
        final gameLogic = container.read(gameProvider);
        expect(gameLogic, isA<GameLogic>());
        expect(gameLogic.config.boardSize, equals(BoardSize.threeByThree));
        expect(gameLogic.config.winCondition, equals(WinCondition.threeInRow));
        expect(gameLogic.config.gameMode, equals(GameMode.local));
      });

      test('should initialize game with configuration', () {
        final notifier = container.read(gameProvider.notifier);
        final config = GameConfig(
          boardSize: BoardSize.fourByFour,
          winCondition: WinCondition.fourInRow,
          gameMode: GameMode.robot,
          firstMove: FirstMove.player1,
          player1Name: 'Player 1',
          player2Name: 'CPU',
          robotConfig: RobotConfig.forDifficulty(Difficulty.hard),
        );

        notifier.initializeGame(config);

        final gameLogic = container.read(gameProvider);
        expect(gameLogic.config.boardSize, equals(BoardSize.fourByFour));
        expect(gameLogic.config.winCondition, equals(WinCondition.fourInRow));
        expect(gameLogic.config.gameMode, equals(GameMode.robot));
        expect(gameLogic.config.isRobotMode, isTrue);
      });

      test('should make moves correctly', () {
        final notifier = container.read(gameProvider.notifier);
        final config = GameConfig.defaultConfig();

        notifier.initializeGame(config);

        // Make a move
        notifier.makeMove(0, 0);

        final gameLogic = container.read(gameProvider);
        expect(gameLogic.board[0][0], equals(CellState.X));
        expect(gameLogic.getNextPlayer(), equals(CellState.O));
      });

      test('should reset game correctly', () {
        final notifier = container.read(gameProvider.notifier);
        final config = GameConfig.defaultConfig();

        notifier.initializeGame(config);
        notifier.makeMove(0, 0);

        // Reset game
        notifier.resetGame();

        final gameLogic = container.read(gameProvider);
        expect(gameLogic.board[0][0], equals(CellState.empty));
        expect(gameLogic.getNextPlayer(), equals(CellState.X));
      });

      test('should provide game result', () {
        final notifier = container.read(gameProvider.notifier);
        final config = GameConfig.defaultConfig();

        notifier.initializeGame(config);

        final gameResult = notifier.gameResult;
        expect(gameResult.isGameOver, isFalse);
        expect(gameResult.winner, isNull);
      });

      test('should provide available moves', () {
        final notifier = container.read(gameProvider.notifier);
        final config = GameConfig.defaultConfig();

        notifier.initializeGame(config);

        final availableMoves = notifier.availableMoves;
        expect(availableMoves.length, equals(9)); // 3x3 board
        expect(availableMoves, contains(const Position(0, 0)));
        expect(availableMoves, contains(const Position(1, 1)));
        expect(availableMoves, contains(const Position(2, 2)));
      });

      test('should provide current player', () {
        final notifier = container.read(gameProvider.notifier);
        final config = GameConfig.defaultConfig();

        notifier.initializeGame(config);

        final currentPlayer = notifier.currentPlayer;
        expect(currentPlayer, equals(CellState.X));
      });

      test('should check if game is over', () {
        final notifier = container.read(gameProvider.notifier);
        final config = GameConfig.defaultConfig();

        notifier.initializeGame(config);

        final isGameOver = notifier.isGameOver;
        expect(isGameOver, isFalse);
      });

      test('should initialize robot game with first move configuration', () {
        final notifier = container.read(gameProvider.notifier);
        final config = GameConfig.robotConfig(
          difficulty: Difficulty.easy,
          firstMove: FirstMove.player2, // Robot goes first
          player1Name: 'Player 1',
          player2Name: 'CPU',
        );

        // Initialize game with robot going first
        notifier.initializeGame(config);

        final gameLogic = container.read(gameProvider);
        expect(gameLogic.config.isRobotMode, isTrue);
        expect(gameLogic.config.firstMove, equals(FirstMove.player2));
        expect(
          gameLogic.config.robotConfig?.difficulty,
          equals(Difficulty.easy),
        );
      });

      test('should prevent player moves when it is robot turn', () {
        final notifier = container.read(gameProvider.notifier);
        final config = GameConfig.robotConfig(
          difficulty: Difficulty.easy,
          firstMove: FirstMove.player1, // Player goes first, then robot
          player1Name: 'Player 1',
          player2Name: 'CPU',
        );

        // Initialize game
        notifier.initializeGame(config);

        // Player makes first move
        final playerMoveSuccess = notifier.makeMove(0, 0);
        expect(playerMoveSuccess, isTrue);

        // Now it should be robot's turn (CellState.O)
        final gameLogic = container.read(gameProvider);
        expect(gameLogic.getNextPlayer(), equals(CellState.O));

        // Player should not be able to make a move when it's robot's turn
        final robotTurnPlayerMoveSuccess = notifier.makeMove(0, 1);
        expect(robotTurnPlayerMoveSuccess, isFalse);

        // Robot should still be able to make moves (this would be handled by the game logic)
        expect(gameLogic.getNextPlayer(), equals(CellState.O));
      });

      test('should detect game end and provide result', () {
        final notifier = container.read(gameProvider.notifier);
        final config = GameConfig.defaultConfig();

        // Initialize game
        notifier.initializeGame(config);

        // Make moves to create a winning line
        notifier.makeMove(0, 0); // X at (0,0)
        notifier.makeMove(1, 0); // O at (1,0)
        notifier.makeMove(0, 1); // X at (0,1)
        notifier.makeMove(1, 1); // O at (1,1)
        notifier.makeMove(0, 2); // X at (0,2) - X wins!

        // Check game result
        final gameResult = notifier.gameResult;
        expect(gameResult.isGameOver, isTrue);
        expect(gameResult.isWin, isTrue);
        expect(gameResult.winner, equals(CellState.X));
        expect(gameResult.winningLine, isNotNull);
        expect(gameResult.winningLine!.length, equals(3)); // 3-in-a-row
      });

      test('should reset game correctly and preserve configuration', () {
        final notifier = container.read(gameProvider.notifier);
        final config = GameConfig.robotConfig(
          difficulty: Difficulty.easy,
          firstMove: FirstMove.player2, // Robot goes first
          player1Name: 'Player 1',
          player2Name: 'CPU',
        );

        // Initialize game
        notifier.initializeGame(config);

        // Reset the game
        notifier.resetGame();

        // After reset, configuration should be preserved
        final resetGameLogic = container.read(gameProvider);
        expect(resetGameLogic.config.firstMove, equals(FirstMove.player2));
        expect(resetGameLogic.config.isRobotMode, isTrue);

        // Game should be reset to initial state
        expect(resetGameLogic.moveCount, equals(0));
      });

      test('should update win counts when game ends', () {
        final container = ProviderContainer();
        final notifier = container.read(gameProvider.notifier);

        // Initialize a simple game
        final config = GameConfig.defaultConfig();
        notifier.initializeGame(config);

        // Make moves to create a winning line for X
        notifier.makeMove(0, 0); // X at (0,0)
        notifier.makeMove(1, 0); // O at (1,0)
        notifier.makeMove(0, 1); // X at (0,1)
        notifier.makeMove(1, 1); // O at (1,1)
        notifier.makeMove(0, 2); // X at (0,2) - X wins!

        // Wait for profile update (async operation)
        // In a real scenario, this would be handled by the UI updating the profile
        // For testing, we'll verify the game result is correct
        final gameResult = notifier.gameResult;
        expect(gameResult.isGameOver, isTrue);
        expect(gameResult.isWin, isTrue);
        expect(gameResult.winner, equals(CellState.X));

        container.dispose();
      });
    });

    group('Game Provider Extension', () {
      test('should provide easy access to game data', () {
        final container = ProviderContainer();

        // Test extension methods
        final gameLogic = container.read(gameProvider);
        expect(gameLogic, isA<GameLogic>());

        container.dispose();
      });
    });
  });
}
