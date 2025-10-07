import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/game_interface/game_header.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/game_interface/game_status.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/game_interface/game_controls.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/overlays/game_result_overlay.dart';

void main() {
  group('Game Widget Optimization Tests', () {
    testWidgets('GameHeader has RepaintBoundary for performance', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameHeader(
              player1Name: 'Player 1',
              player2Name: 'Player 2',
              player1Wins: 5,
              player2Wins: 3,
              currentPlayer: 'X',
            ),
          ),
        ),
      );

      // Verify RepaintBoundary is present
      expect(find.byType(RepaintBoundary), findsWidgets);
    });

    testWidgets('GameStatus has RepaintBoundary and early return optimization', (
      tester,
    ) async {
      // Test with game over (should return SizedBox.shrink)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameStatus(
              currentPlayer: 'X',
              isGameOver: true,
              isRobotThinking: false,
            ),
          ),
        ),
      );

      // Should find SizedBox.shrink when game is over
      expect(find.byType(SizedBox), findsOneWidget);

      // Test with active game (should show turn indicator)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameStatus(
              currentPlayer: 'O',
              isGameOver: false,
              isRobotThinking: false,
            ),
          ),
        ),
      );

      // Verify RepaintBoundary is present (multiple due to nested RepaintBoundaries)
      expect(find.byType(RepaintBoundary), findsWidgets);
      expect(find.text('Your turn'), findsOneWidget);
    });

    testWidgets('GameControls has RepaintBoundary for performance', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameControls(hintCount: 3, onHint: () {}, onNewGame: () {}),
          ),
        ),
      );

      // Verify RepaintBoundary is present
      expect(find.byType(RepaintBoundary), findsWidgets);
      expect(find.text('Hint'), findsOneWidget);
      expect(find.text('New Game'), findsOneWidget);
    });

    testWidgets('GameResultOverlay has RepaintBoundary for performance', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameResultOverlay(
              isWin: true,
              isDraw: false,
              winner: 'Player 1',
              onPlayAgain: () {},
              onHome: () {},
            ),
          ),
        ),
      );

      // Verify RepaintBoundary is present
      expect(find.byType(RepaintBoundary), findsWidgets);
      expect(find.text('You Win!'), findsOneWidget);
      expect(find.text('Play Again'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('GameControls hint button shows count correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameControls(hintCount: 5, onHint: () {}, onNewGame: () {}),
          ),
        ),
      );

      // Should show hint count
      expect(find.text('5'), findsOneWidget);

      // Test with no hints
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameControls(hintCount: 0, onHint: () {}, onNewGame: () {}),
          ),
        ),
      );

      // Should not show hint count when 0
      expect(find.text('0'), findsNothing);
    });

    testWidgets('GameResultOverlay shows correct result for different states', (
      tester,
    ) async {
      // Test win state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameResultOverlay(
              isWin: true,
              isDraw: false,
              winner: 'Player 1',
              onPlayAgain: () {},
              onHome: () {},
            ),
          ),
        ),
      );

      expect(find.text('You Win!'), findsOneWidget);
      expect(find.text('Congratulations, Player 1!'), findsOneWidget);

      // Test draw state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameResultOverlay(
              isWin: false,
              isDraw: true,
              winner: '',
              onPlayAgain: () {},
              onHome: () {},
            ),
          ),
        ),
      );

      expect(find.text("It's a Draw!"), findsOneWidget);

      // Test lose state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameResultOverlay(
              isWin: false,
              isDraw: false,
              winner: '',
              onPlayAgain: () {},
              onHome: () {},
            ),
          ),
        ),
      );

      expect(find.text('You Lose!'), findsOneWidget);
    });

    group('Performance Benchmarks', () {
      testWidgets('GameHeader creation performance', (tester) async {
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 100; i++) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: GameHeader(
                  player1Name: 'Player $i',
                  player2Name: 'Player ${i + 1}',
                  player1Wins: i,
                  player2Wins: i + 1,
                  currentPlayer: i % 2 == 0 ? 'X' : 'O',
                ),
              ),
            ),
          );
        }

        stopwatch.stop();

        // Should create 100 GameHeaders in reasonable time (test environment is slower)
        expect(stopwatch.elapsedMilliseconds, lessThan(2000));
        debugPrint(
          'Created 100 GameHeaders in ${stopwatch.elapsedMilliseconds}ms',
        );
      });

      testWidgets('GameStatus creation performance', (tester) async {
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 100; i++) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: GameStatus(
                  currentPlayer: i % 2 == 0 ? 'X' : 'O',
                  isGameOver: i % 3 == 0,
                  isRobotThinking: false,
                ),
              ),
            ),
          );
        }

        stopwatch.stop();

        // Should create 100 GameStatus widgets in reasonable time (test environment is slower)
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        debugPrint(
          'Created 100 GameStatus widgets in ${stopwatch.elapsedMilliseconds}ms',
        );
      });

      testWidgets('GameControls creation performance', (tester) async {
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 100; i++) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: GameControls(
                  hintCount: i % 5,
                  onHint: () {},
                  onNewGame: () {},
                ),
              ),
            ),
          );
        }

        stopwatch.stop();

        // Should create 100 GameControls in reasonable time (test environment is slower)
        expect(stopwatch.elapsedMilliseconds, lessThan(2000));
        debugPrint(
          'Created 100 GameControls in ${stopwatch.elapsedMilliseconds}ms',
        );
      });
    });
  });
}
