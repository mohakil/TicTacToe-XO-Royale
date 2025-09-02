import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/features/setup/providers/setup_provider.dart';

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
      });

      test('should allow updating difficulty', () {
        final notifier = container.read(setupProvider.notifier);

        notifier.setDifficulty(Difficulty.hard);

        final setupState = container.read(setupProvider);
        expect(setupState.difficulty, equals(Difficulty.hard));
      });

      test('should allow updating player names', () {
        final notifier = container.read(setupProvider.notifier);

        notifier.setPlayer1Name('Alice');
        notifier.setPlayer2Name('Bob');

        final setupState = container.read(setupProvider);
        expect(setupState.player1Name, equals('Alice'));
        expect(setupState.player2Name, equals('Bob'));
      });

      test('should allow updating first move', () {
        final notifier = container.read(setupProvider.notifier);

        notifier.setFirstMove(FirstMove.player1);

        final setupState = container.read(setupProvider);
        expect(setupState.firstMove, equals(FirstMove.player1));
      });
    });

    group('Individual Setup Providers', () {
      test('setupBoardSizeProvider should provide board size', () {
        final boardSize = container.read(setupBoardSizeProvider);
        expect(boardSize, equals(BoardSize.threeByThree));
      });

      test('setupWinConditionProvider should provide win condition', () {
        final winCondition = container.read(setupWinConditionProvider);
        expect(winCondition, equals(WinCondition.threeInRow));
      });

      test('setupModeProvider should provide game mode', () {
        final gameMode = container.read(setupModeProvider);
        expect(gameMode, equals(GameMode.local));
      });

      test('setupDifficultyProvider should provide difficulty', () {
        final difficulty = container.read(setupDifficultyProvider);
        expect(difficulty, equals(Difficulty.medium));
      });

      test('setupPlayer1NameProvider should provide player 1 name', () {
        final player1Name = container.read(setupPlayer1NameProvider);
        expect(player1Name, equals('Player 1'));
      });

      test('setupPlayer2NameProvider should provide player 2 name', () {
        final player2Name = container.read(setupPlayer2NameProvider);
        expect(player2Name, equals('Player 2'));
      });

      test('setupFirstMoveProvider should provide first move', () {
        final firstMove = container.read(setupFirstMoveProvider);
        expect(firstMove, equals(FirstMove.random));
      });
    });

    group('Setup State Changes', () {
      test('should update mode correctly', () {
        final notifier = container.read(setupProvider.notifier);

        notifier.setMode(GameMode.robot);
        final setupState = container.read(setupProvider);
        expect(setupState.mode, equals(GameMode.robot));
        expect(setupState.player2Name, equals('CPU'));

        notifier.setMode(GameMode.local);
        final updatedState = container.read(setupProvider);
        expect(updatedState.mode, equals(GameMode.local));
        expect(updatedState.player2Name, equals('Player 2'));
      });

      test('should update board size correctly', () {
        final notifier = container.read(setupProvider.notifier);

        notifier.setBoardSize(BoardSize.fourByFour);
        final setupState = container.read(setupProvider);
        expect(setupState.boardSize, equals(BoardSize.fourByFour));
      });

      test('should update win condition correctly', () {
        final notifier = container.read(setupProvider.notifier);

        // First set board size to 4x4 to allow fourInRow win condition
        notifier.setBoardSize(BoardSize.fourByFour);
        notifier.setWinCondition(WinCondition.fourInRow);
        final setupState = container.read(setupProvider);
        expect(setupState.winCondition, equals(WinCondition.fourInRow));
      });
    });
  });
}
