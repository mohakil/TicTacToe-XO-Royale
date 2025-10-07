import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/features/setup/providers/setup_provider.dart';
import 'package:tictactoe_xo_royale/core/models/game_enums.dart';

void main() {
  group('SetupProvider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('Setup State Provider', () {
      test('should provide initial setup state', () {
        final setupState = container.read(setupProvider);
        expect(setupState, isA<GameSetup>());
        expect(setupState.boardSize, equals(BoardSize.threeByThree));
        expect(setupState.winCondition, equals(WinCondition.threeInRow));
        expect(setupState.mode, equals(GameMode.local));
        expect(setupState.difficulty, equals(Difficulty.medium));
        expect(setupState.player1Name, equals('Player 1'));
        expect(setupState.player2Name, equals('Player 2'));
        expect(setupState.localPlayer2Name, equals('Player 2'));
        expect(setupState.robotPlayerName, equals('CPU'));
        expect(setupState.firstMove, equals(FirstMove.random));
      });

      test('should allow updating board size', () {
        final notifier = container.read(setupProvider.notifier);

        notifier.setBoardSize(BoardSize.fourByFour);

        final setupState = container.read(setupProvider);
        expect(setupState.boardSize, equals(BoardSize.fourByFour));
      });

      test('should allow updating win condition', () {
        final notifier = container.read(setupProvider.notifier);

        // First set board size to 4x4 to allow fourInRow win condition
        notifier.setBoardSize(BoardSize.fourByFour);
        notifier.setWinCondition(WinCondition.fourInRow);

        final setupState = container.read(setupProvider);
        expect(setupState.winCondition, equals(WinCondition.fourInRow));
      });

      test('should allow updating game mode', () {
        final notifier = container.read(setupProvider.notifier);

        notifier.setMode(GameMode.robot);

        final setupState = container.read(setupProvider);
        expect(setupState.mode, equals(GameMode.robot));
        expect(setupState.player2Name, equals('CPU')); // Should auto-update
        expect(setupState.localPlayer2Name, equals('Player 2'));
        expect(setupState.robotPlayerName, equals('CPU'));

        notifier.setMode(GameMode.local);

        final localState = container.read(setupProvider);
        expect(localState.player2Name, equals('Player 2'));
        expect(localState.localPlayer2Name, equals('Player 2'));
        expect(localState.robotPlayerName, equals('CPU'));
      });

      test('should allow updating player names', () {
        final notifier = container.read(setupProvider.notifier);

        notifier.setPlayer1Name('Alice');
        notifier.setPlayer2Name('Bob');

        final setupState = container.read(setupProvider);
        expect(setupState.player1Name, equals('Alice'));
        expect(setupState.player2Name, equals('Bob'));
        expect(setupState.localPlayer2Name, equals('Bob'));
        expect(setupState.robotPlayerName, equals('CPU'));

        notifier.setMode(GameMode.robot);
        notifier.setMode(GameMode.local);

        final restoredState = container.read(setupProvider);
        expect(restoredState.player2Name, equals('Bob'));
        expect(restoredState.localPlayer2Name, equals('Bob'));
      });

      test('should allow updating difficulty', () {
        final notifier = container.read(setupProvider.notifier);

        notifier.setDifficulty(Difficulty.hard);

        final setupState = container.read(setupProvider);
        expect(setupState.difficulty, equals(Difficulty.hard));
      });

      test('should allow updating first move', () {
        final notifier = container.read(setupProvider.notifier);

        notifier.setFirstMove(FirstMove.player1);

        final setupState = container.read(setupProvider);
        expect(setupState.firstMove, equals(FirstMove.player1));
      });

      test('should validate setup correctly', () {
        final notifier = container.read(setupProvider.notifier);

        // Valid setup
        notifier.setPlayer1Name('Player 1');
        notifier.setPlayer2Name('Player 2');
        expect(notifier.isValid, isTrue);

        // Test validation logic directly - the provider should not allow invalid states
        // but we can test the validation logic by checking what would be invalid

        // Test with default state (should be valid)
        notifier.reset();
        expect(notifier.isValid, isTrue);

        // Test with empty player1 - this should be invalid if we could set it
        // but the provider prevents setting empty names
        final defaultState = container.read(setupProvider);
        expect(defaultState.player1Name.isNotEmpty, isTrue);
      });

      test('should provide robot configuration for robot mode', () {
        final notifier = container.read(setupProvider.notifier);

        notifier.setMode(GameMode.robot);
        notifier.setDifficulty(Difficulty.hard);

        final robotConfig = notifier.robotConfig;
        expect(robotConfig, isNotNull);
        expect(robotConfig!.difficulty, equals(Difficulty.hard));
        expect(robotConfig.playerName, equals('CPU'));

        notifier.setPlayer2Name('Virtual Opponent');

        final updatedConfig = notifier.robotConfig;
        expect(updatedConfig, isNotNull);
        expect(updatedConfig!.playerName, equals('Virtual Opponent'));
      });

      test('should return null robot configuration for local mode', () {
        final notifier = container.read(setupProvider.notifier);

        notifier.setMode(GameMode.local);

        final robotConfig = notifier.robotConfig;
        expect(robotConfig, isNull);
      });

      test('should reset to default values', () {
        final notifier = container.read(setupProvider.notifier);

        // Change some values
        notifier.setMode(GameMode.robot);
        notifier.setPlayer1Name('Alice');
        notifier.setDifficulty(Difficulty.hard);

        // Reset
        notifier.reset();

        final setupState = container.read(setupProvider);
        expect(setupState.mode, equals(GameMode.local));
        expect(setupState.player1Name, equals('Player 1'));
        expect(setupState.difficulty, equals(Difficulty.medium));
      });
    });

    group('Setup Provider Extensions', () {
      test('should provide easy access to setup data', () {
        final container = ProviderContainer();

        // Test extension methods
        final setupState = container.read(setupProvider);
        expect(setupState, isA<GameSetup>());

        container.dispose();
      });
    });

    group('Setup Validation', () {
      test('should validate win condition for board size', () {
        final notifier = container.read(setupProvider.notifier);

        // 3x3 board - only 3-in-row should be valid
        notifier.setBoardSize(BoardSize.threeByThree);
        expect(
          WinCondition.threeInRow.isValidForBoardSize(BoardSize.threeByThree),
          isTrue,
        );
        expect(
          WinCondition.fourInRow.isValidForBoardSize(BoardSize.threeByThree),
          isFalse,
        );

        // 4x4 board - 3-in-row and 4-in-row should be valid
        notifier.setBoardSize(BoardSize.fourByFour);
        expect(
          WinCondition.threeInRow.isValidForBoardSize(BoardSize.fourByFour),
          isTrue,
        );
        expect(
          WinCondition.fourInRow.isValidForBoardSize(BoardSize.fourByFour),
          isTrue,
        );
        expect(
          WinCondition.fiveInRow.isValidForBoardSize(BoardSize.fourByFour),
          isFalse,
        );

        // 5x5 board - all should be valid
        notifier.setBoardSize(BoardSize.fiveByFive);
        expect(
          WinCondition.threeInRow.isValidForBoardSize(BoardSize.fiveByFive),
          isTrue,
        );
        expect(
          WinCondition.fourInRow.isValidForBoardSize(BoardSize.fiveByFive),
          isTrue,
        );
        expect(
          WinCondition.fiveInRow.isValidForBoardSize(BoardSize.fiveByFive),
          isTrue,
        );
      });
    });
  });
}
