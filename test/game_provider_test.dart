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
