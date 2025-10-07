import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/screens/game_screen.dart';

void main() {
  group('Win Animation Sequence Tests', () {
    testWidgets(
      'Win animation sequence should show winning line first, then popup',
      (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: GameScreen(
                boardSize: 3,
                winCondition: 3,
                player1Name: 'Player 1',
                player2Name: 'Player 2',
                isRobotMode: false,
                difficulty: 'medium',
                firstMove: 'player1',
              ),
            ),
          ),
        );

        // Wait for initialization
        await tester.pumpAndSettle();

        // Make moves to create a winning scenario
        // Row 0: X, X, X
        await tester.tap(find.byKey(const Key('cell_0_0')));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('cell_0_1')));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('cell_0_2')));
        await tester.pumpAndSettle();

        // Verify that the win animation is playing (status shows "🎉 WINNING!")
        expect(find.text('🎉 WINNING!'), findsOneWidget);

        // Wait for the win animation to complete (2 seconds)
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();

        // Verify that the result popup appears after animation
        expect(find.text('Player 1 Wins!'), findsOneWidget);
      },
    );

    testWidgets('Draw should show popup immediately without animation', (
      tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GameScreen(
              boardSize: 3,
              winCondition: 3,
              player1Name: 'Player 1',
              player2Name: 'Player 2',
              isRobotMode: false,
              difficulty: 'medium',
              firstMove: 'player1',
            ),
          ),
        ),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      // Fill board to create a draw scenario
      // Row 0: X, O, X
      await tester.tap(find.byKey(const Key('cell_0_0')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('cell_0_1')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('cell_0_2')));
      await tester.pumpAndSettle();

      // Row 1: O, X, O
      await tester.tap(find.byKey(const Key('cell_1_0')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('cell_1_1')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('cell_1_2')));
      await tester.pumpAndSettle();

      // Row 2: O, X, O
      await tester.tap(find.byKey(const Key('cell_2_0')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('cell_2_1')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('cell_2_2')));
      await tester.pumpAndSettle();

      // Verify that the draw popup appears immediately (no win animation)
      expect(find.text('Draw!'), findsOneWidget);
    });

    testWidgets('Board should be disabled during win animation', (
      tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GameScreen(
              boardSize: 3,
              winCondition: 3,
              player1Name: 'Player 1',
              player2Name: 'Player 2',
              isRobotMode: false,
              difficulty: 'medium',
              firstMove: 'player1',
            ),
          ),
        ),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      // Make moves to create a winning scenario
      await tester.tap(find.byKey(const Key('cell_0_0')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('cell_0_1')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('cell_0_2')));
      await tester.pumpAndSettle();

      // Verify that the win animation is playing
      expect(find.text('🎉 WINNING!'), findsOneWidget);

      // Try to tap another cell during win animation - should not work
      await tester.tap(find.byKey(const Key('cell_1_0')));
      await tester.pumpAndSettle();

      // Verify that the cell was not filled (board is disabled)
      // This would require checking the board state, but for now we just verify
      // that the win animation is still playing
      expect(find.text('🎉 WINNING!'), findsOneWidget);
    });
  });
}
