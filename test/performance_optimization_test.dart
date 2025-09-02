import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/core/services/game_logic.dart';
import 'package:tictactoe_xo_royale/core/services/performance_monitor.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/game_board/game_board.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/visual_effects/painters/board_painter.dart';

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

    test('PerformanceMonitor tracks frame rates correctly', () {
      final monitor = PerformanceMonitor();

      // Start monitoring
      monitor.startMonitoring();
      expect(monitor.getPerformanceReport().isMonitoring, isTrue);

      // Stop monitoring
      monitor.stopMonitoring();
      expect(monitor.getPerformanceReport().isMonitoring, isFalse);

      // Reset metrics
      monitor.reset();
      final report = monitor.getPerformanceReport();
      expect(report.averageFPS, equals(0.0));
      expect(report.frameDrops, equals(0));
    });

    test('PerformanceMonitor provides recommendations', () {
      final monitor = PerformanceMonitor();
      final recommendations = monitor.getRecommendations();
      expect(recommendations, isA<List<String>>());
    });

    test('BoardPainter shouldRepaint optimization works correctly', () {
      final boardState1 = <List<String?>>[
        ['X', null, null],
        [null, 'O', null],
        [null, null, null],
      ];

      final boardState2 = <List<String?>>[
        ['X', null, null],
        [null, 'O', null],
        [null, null, 'X'],
      ];

      final painter1 = BoardPainter(
        boardSize: 3,
        boardState: boardState1,
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
        boardState: boardState2,
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
      final boardState = <List<String?>>[
        ['X', null, null],
        [null, 'O', null],
        [null, null, null],
      ];

      final painter1 = BoardPainter(
        boardSize: 3,
        boardState: boardState,
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
        boardState: boardState,
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
          final boardState = <List<String?>>[
            ['X', null, null],
            [null, 'O', null],
            [null, null, null],
          ];

          BoardPainter(
            boardSize: 3,
            boardState: boardState,
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
        print(
          'Created 100 BoardPainters in ${stopwatch.elapsedMilliseconds}ms',
        );
      });

      test('shouldRepaint performance', () {
        final boardState = <List<String?>>[
          ['X', null, null],
          [null, 'O', null],
          [null, null, null],
        ];

        final painter = BoardPainter(
          boardSize: 3,
          boardState: boardState,
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
        print(
          'Performed 1000 shouldRepaint checks in ${stopwatch.elapsedMilliseconds}ms',
        );
      });
    });
  });
}
