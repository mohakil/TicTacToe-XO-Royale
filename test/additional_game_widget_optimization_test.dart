import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/core/services/game_logic.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/overlays/exit_confirmation_overlay.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/overlays/game_settings_overlay.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/game_board/board_cell.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/game_board/board_grid.dart';

void main() {
  group('Additional Game Widget Optimization Tests', () {
    testWidgets('ExitConfirmationOverlay has RepaintBoundary for performance', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExitConfirmationOverlay(onContinue: () {}, onExit: () {}),
          ),
        ),
      );

      // Verify RepaintBoundary is present
      expect(find.byType(RepaintBoundary), findsWidgets);
      expect(find.text('Quit current game?'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
      expect(find.text('Exit'), findsOneWidget);
    });

    testWidgets('GameSettingsOverlay has RepaintBoundary for performance', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: GameSettingsOverlay(onClose: () {})),
        ),
      );

      // Verify RepaintBoundary is present
      expect(find.byType(RepaintBoundary), findsWidgets);
      expect(find.text('Game Settings'), findsOneWidget);
      expect(find.text('Sound Effects'), findsOneWidget);
      expect(find.text('Background Music'), findsOneWidget);
      expect(find.text('Haptic Feedback'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('BoardCell has RepaintBoundary for performance', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BoardCell(
              row: 0,
              col: 0,
              cellState: CellState.X,
              onTap: (_, _) {},
              cellSize: 100.0,
              isWinningCell: false,
              isHintCell: false,
              isHovered: false,
            ),
          ),
        ),
      );

      // Verify RepaintBoundary is present
      expect(find.byType(RepaintBoundary), findsWidgets);
      expect(find.text('X'), findsOneWidget);
    });

    testWidgets('BoardGrid has RepaintBoundary for performance', (
      tester,
    ) async {
      final boardState = List.generate(
        3,
        (i) => List.generate(3, (j) => CellState.empty),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BoardGrid(
              boardSize: 3,
              boardState: boardState,
              onCellTap: (_, _) {},
              isGameOver: false,
              showHints: false,
              isInteractive: true,
            ),
          ),
        ),
      );

      // Verify RepaintBoundary is present
      expect(find.byType(RepaintBoundary), findsWidgets);
      expect(find.byType(BoardCell), findsNWidgets(9)); // 3x3 grid
    });

    testWidgets('BoardCell shows correct states', (tester) async {
      // Test X cell
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BoardCell(
              row: 0,
              col: 0,
              cellState: CellState.X,
              onTap: (_, _) {},
              cellSize: 100.0,
            ),
          ),
        ),
      );

      expect(find.text('X'), findsOneWidget);

      // Test O cell
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BoardCell(
              row: 0,
              col: 0,
              cellState: CellState.O,
              onTap: (_, _) {},
              cellSize: 100.0,
            ),
          ),
        ),
      );

      expect(find.text('O'), findsOneWidget);

      // Test empty cell
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BoardCell(
              row: 0,
              col: 0,
              cellState: null,
              onTap: (_, _) {},
              cellSize: 100.0,
            ),
          ),
        ),
      );

      expect(find.text('X'), findsNothing);
      expect(find.text('O'), findsNothing);
    });

    testWidgets('BoardGrid creates correct number of cells', (tester) async {
      // Test 3x3 grid
      final boardState3x3 = List.generate(
        3,
        (i) => List.generate(3, (j) => CellState.empty),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BoardGrid(
              boardSize: 3,
              boardState: boardState3x3,
              onCellTap: (_, _) {},
            ),
          ),
        ),
      );

      expect(find.byType(BoardCell), findsNWidgets(9));

      // Test 4x4 grid
      final boardState4x4 = List.generate(
        4,
        (i) => List.generate(4, (j) => CellState.empty),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BoardGrid(
              boardSize: 4,
              boardState: boardState4x4,
              onCellTap: (_, _) {},
            ),
          ),
        ),
      );

      expect(find.byType(BoardCell), findsNWidgets(16));
    });

    group('Performance Benchmarks', () {
      testWidgets('ExitConfirmationOverlay creation performance', (
        tester,
      ) async {
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 50; i++) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ExitConfirmationOverlay(onContinue: () {}, onExit: () {}),
              ),
            ),
          );
        }

        stopwatch.stop();

        // Should create 50 ExitConfirmationOverlays in reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        debugPrint(
          'Created 50 ExitConfirmationOverlays in ${stopwatch.elapsedMilliseconds}ms',
        );
      });

      testWidgets('GameSettingsOverlay creation performance', (tester) async {
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 50; i++) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: GameSettingsOverlay(onClose: () {})),
            ),
          );
        }

        stopwatch.stop();

        // Should create 50 GameSettingsOverlays in reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        debugPrint(
          'Created 50 GameSettingsOverlays in ${stopwatch.elapsedMilliseconds}ms',
        );
      });

      testWidgets('BoardCell creation performance', (tester) async {
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 100; i++) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: BoardCell(
                  row: i % 3,
                  col: i % 3,
                  cellState: i % 3 == 0
                      ? CellState.X
                      : (i % 3 == 1 ? CellState.O : null),
                  onTap: (_, _) {},
                  cellSize: 100.0,
                  isWinningCell: i % 5 == 0,
                  isHintCell: i % 7 == 0,
                  isHovered: i % 11 == 0,
                ),
              ),
            ),
          );
        }

        stopwatch.stop();

        // Should create 100 BoardCells in reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(1500));
        debugPrint(
          'Created 100 BoardCells in ${stopwatch.elapsedMilliseconds}ms',
        );
      });

      testWidgets('BoardGrid creation performance', (tester) async {
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 20; i++) {
          final boardSize = 3 + (i % 3); // 3x3, 4x4, 5x5
          final boardState = List.generate(
            boardSize,
            (row) => List.generate(
              boardSize,
              (col) => (row + col) % 3 == 0
                  ? CellState.X
                  : (row + col) % 3 == 1
                  ? CellState.O
                  : CellState.empty,
            ),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: BoardGrid(
                  boardSize: boardSize,
                  boardState: boardState,
                  onCellTap: (_, _) {},
                  isGameOver: i % 2 == 0,
                  showHints: i % 3 == 0,
                ),
              ),
            ),
          );
        }

        stopwatch.stop();

        // Should create 20 BoardGrids in reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(2000));
        debugPrint(
          'Created 20 BoardGrids in ${stopwatch.elapsedMilliseconds}ms',
        );
      });
    });
  });
}
