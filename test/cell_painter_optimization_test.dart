import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/visual_effects/painters/cell_painter.dart';

void main() {
  group('Cell Painter Optimization Tests', () {
    testWidgets('Cell painter functions work correctly', (tester) async {
      // Create a custom painter to test the cell painting functions
      final customPainter = _TestCellPainter();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: customPainter,
              size: const Size(300, 300),
            ),
          ),
        ),
      );

      // Verify the widget renders without errors
      expect(find.byType(CustomPaint), findsWidgets);
    });

    group('Performance Benchmarks', () {
      testWidgets('Cell painter performance benchmark', (tester) async {
        final stopwatch = Stopwatch()..start();

        // Test creating multiple custom painters with cell painting
        for (int i = 0; i < 50; i++) {
          final customPainter = _TestCellPainter();

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: CustomPaint(
                  painter: customPainter,
                  size: const Size(100, 100),
                ),
              ),
            ),
          );
        }

        stopwatch.stop();

        // Should create 50 custom painters in reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        debugPrint(
          'Created 50 cell painters in ${stopwatch.elapsedMilliseconds}ms',
        );
      });
    });
  });
}

/// Test custom painter to verify cell painting functions work correctly
class _TestCellPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cellRect = Rect.fromLTWH(50, 50, 100, 100);

    // Test all cell painting functions
    paintEmpty(canvas, cellRect, null);

    // Test hover effect
    paintHover(
      canvas,
      cellRect,
      Paint()..color = Colors.blue,
      null,
      0.5, // 50% animation
    );

    // Test pressed effect
    paintPressed(
      canvas,
      cellRect,
      null,
      0.3, // 30% animation
    );

    // Test shake effect
    paintShake(
      canvas,
      cellRect,
      0.7, // 70% animation
      null,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
