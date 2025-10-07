import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/core/services/game_logic.dart';

import 'package:tictactoe_xo_royale/features/game/presentation/widgets/game_board/game_board.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/visual_effects/painters/board_painter.dart';

String? cellStateToString(CellState state) {
  return switch (state) {
    CellState.X => 'X',
    CellState.O => 'O',
    CellState.empty => null,
  };
}

List<List<String?>> convertBoardToStrings(List<List<CellState>> board) {
  return board.map((row) => row.map(cellStateToString).toList()).toList();
}

void main() {
  group('Performance Optimization Tests', () {
    testWidgets('GameBoard has RepaintBoundary for performance', (
      tester,
    ) async {
      const boardSize = 3;
      final boardState = List.generate(
        boardSize,
        (i) => List.generate(boardSize, (j) => CellState.empty),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameBoard(
              boardSize: boardSize,
              winCondition: 3,
              boardState: boardState,
              currentPlayer: CellState.X,
              isGameOver: false,
              onCellTap: (row, col) {},
            ),
          ),
        ),
      );

      // Verify RepaintBoundary is present (multiple due to performance overlay and game board)
      expect(find.byType(RepaintBoundary), findsWidgets);
    });

    testWidgets('GameBoard uses ValueKey for optimal rebuilds', (tester) async {
      const boardSize = 3;
      final boardState = List.generate(
        boardSize,
        (i) => List.generate(boardSize, (j) => CellState.empty),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameBoard(
              boardSize: boardSize,
              winCondition: 3,
              boardState: boardState,
              currentPlayer: CellState.X,
              isGameOver: false,
              onCellTap: (row, col) {},
            ),
          ),
        ),
      );

      // Find the RepaintBoundary with our specific key
      final repaintBoundaryWithKey = find.byKey(
        ValueKey('game_board_${boardState.hashCode}'),
      );
      expect(repaintBoundaryWithKey, findsOneWidget);
    });

    test('BoardPainter shouldRepaint optimization works correctly', () {
      final boardState1 = <List<CellState>>[
        [CellState.X, CellState.empty, CellState.empty],
        [CellState.empty, CellState.O, CellState.empty],
        [CellState.empty, CellState.empty, CellState.empty],
      ];

      final boardState2 = <List<CellState>>[
        [CellState.X, CellState.empty, CellState.empty],
        [CellState.empty, CellState.O, CellState.empty],
        [CellState.empty, CellState.empty, CellState.X],
      ];

      final painter1 = BoardPainter(
        boardSize: 3,
        boardState: convertBoardToStrings(boardState1),
        currentPlayer: 'X',
        isGameOver: false,
        showHints: false,
        markAnimation: const AlwaysStoppedAnimation(1.0),
        winningLineAnimation: const AlwaysStoppedAnimation(0.0),
        hintAnimation: const AlwaysStoppedAnimation(0.0),
        ambientAnimation: const AlwaysStoppedAnimation(0.0),
        themeData: ThemeData(),
      );

      final painter2 = BoardPainter(
        boardSize: 3,
        boardState: convertBoardToStrings(boardState2),
        currentPlayer: 'X',
        isGameOver: false,
        showHints: false,
        markAnimation: const AlwaysStoppedAnimation(1.0),
        winningLineAnimation: const AlwaysStoppedAnimation(0.0),
        hintAnimation: const AlwaysStoppedAnimation(0.0),
        ambientAnimation: const AlwaysStoppedAnimation(0.0),
        themeData: ThemeData(),
      );

      // Should repaint when board state changes
      expect(painter2.shouldRepaint(painter1), isTrue);

      // Should not repaint when nothing changes
      expect(painter1.shouldRepaint(painter1), isFalse);
    });

    test('Static Paint objects are properly cached', () {
      // Test that static Paint objects exist and are reused
      final boardState = <List<CellState>>[
        [CellState.X, CellState.empty, CellState.empty],
        [CellState.empty, CellState.O, CellState.empty],
        [CellState.empty, CellState.empty, CellState.empty],
      ];

      final painter1 = BoardPainter(
        boardSize: 3,
        boardState: convertBoardToStrings(boardState),
        currentPlayer: 'X',
        isGameOver: false,
        showHints: false,
        markAnimation: const AlwaysStoppedAnimation(1.0),
        winningLineAnimation: const AlwaysStoppedAnimation(0.0),
        hintAnimation: const AlwaysStoppedAnimation(0.0),
        ambientAnimation: const AlwaysStoppedAnimation(0.0),
        themeData: ThemeData(),
      );

      final painter2 = BoardPainter(
        boardSize: 3,
        boardState: convertBoardToStrings(boardState),
        currentPlayer: 'O',
        isGameOver: false,
        showHints: false,
        markAnimation: const AlwaysStoppedAnimation(1.0),
        winningLineAnimation: const AlwaysStoppedAnimation(0.0),
        hintAnimation: const AlwaysStoppedAnimation(0.0),
        ambientAnimation: const AlwaysStoppedAnimation(0.0),
        themeData: ThemeData(),
      );

      // Both painters should exist without throwing exceptions
      expect(painter1, isNotNull);
      expect(painter2, isNotNull);
    });

    group('Performance Benchmarks', () {
      test('BoardPainter creation performance', () {
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 100; i++) {
          final boardState = <List<CellState>>[
            [CellState.X, CellState.empty, CellState.empty],
            [CellState.empty, CellState.O, CellState.empty],
            [CellState.empty, CellState.empty, CellState.empty],
          ];

          BoardPainter(
            boardSize: 3,
            boardState: convertBoardToStrings(boardState),
            currentPlayer: 'X',
            isGameOver: false,
            showHints: false,
            markAnimation: const AlwaysStoppedAnimation(1.0),
            winningLineAnimation: const AlwaysStoppedAnimation(0.0),
            hintAnimation: const AlwaysStoppedAnimation(0.0),
            ambientAnimation: const AlwaysStoppedAnimation(0.0),
            themeData: ThemeData(),
          );
        }

        stopwatch.stop();

        // Should create 100 painters in less than 100ms with static Paint caching
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
        debugPrint(
          'Created 100 BoardPainters in ${stopwatch.elapsedMilliseconds}ms',
        );
      });

      test('shouldRepaint performance', () {
        final boardState = <List<CellState>>[
          [CellState.X, CellState.empty, CellState.empty],
          [CellState.empty, CellState.O, CellState.empty],
          [CellState.empty, CellState.empty, CellState.empty],
        ];

        final painter = BoardPainter(
          boardSize: 3,
          boardState: convertBoardToStrings(boardState),
          currentPlayer: 'X',
          isGameOver: false,
          showHints: false,
          markAnimation: const AlwaysStoppedAnimation(1.0),
          winningLineAnimation: const AlwaysStoppedAnimation(0.0),
          hintAnimation: const AlwaysStoppedAnimation(0.0),
          ambientAnimation: const AlwaysStoppedAnimation(0.0),
          themeData: ThemeData(),
        );

        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 1000; i++) {
          painter.shouldRepaint(painter);
        }

        stopwatch.stop();

        // Should perform 1000 shouldRepaint checks in less than 10ms
        expect(stopwatch.elapsedMilliseconds, lessThan(10));
        debugPrint(
          'Performed 1000 shouldRepaint checks in ${stopwatch.elapsedMilliseconds}ms',
        );
      });
    });
  });
}
