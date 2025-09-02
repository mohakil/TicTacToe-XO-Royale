import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/visual_effects/effects/ambient_painter.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/visual_effects/effects/confetti_painter.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/visual_effects/effects/hint_sparkle_painter.dart';

void main() {
  group('Effects Optimization Tests', () {
    testWidgets('Ambient painter functions work correctly', (tester) async {
      // Create a custom painter to test the ambient painting function
      final customPainter = _TestAmbientPainter();

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

    testWidgets('Confetti painter functions work correctly', (tester) async {
      // Create a custom painter to test the confetti painting function
      final customPainter = _TestConfettiPainter();

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

    testWidgets('Hint sparkle painter functions work correctly', (
      tester,
    ) async {
      // Create a custom painter to test the hint sparkle painting function
      final customPainter = _TestHintSparklePainter();

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
      testWidgets('Ambient painter performance benchmark', (tester) async {
        final stopwatch = Stopwatch()..start();

        // Test creating multiple custom painters with ambient painting
        for (int i = 0; i < 50; i++) {
          final customPainter = _TestAmbientPainter();

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: CustomPaint(
                  painter: customPainter,
                  size: const Size(200, 200),
                ),
              ),
            ),
          );
        }

        stopwatch.stop();

        // Should create 50 ambient painters in reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        debugPrint(
          'Created 50 ambient painters in ${stopwatch.elapsedMilliseconds}ms',
        );
      });

      testWidgets('Confetti painter performance benchmark', (tester) async {
        final stopwatch = Stopwatch()..start();

        // Test creating multiple custom painters with confetti painting
        for (int i = 0; i < 50; i++) {
          final customPainter = _TestConfettiPainter();

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: CustomPaint(
                  painter: customPainter,
                  size: const Size(200, 200),
                ),
              ),
            ),
          );
        }

        stopwatch.stop();

        // Should create 50 confetti painters in reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        debugPrint(
          'Created 50 confetti painters in ${stopwatch.elapsedMilliseconds}ms',
        );
      });

      testWidgets('Hint sparkle painter performance benchmark', (tester) async {
        final stopwatch = Stopwatch()..start();

        // Test creating multiple custom painters with hint sparkle painting
        for (int i = 0; i < 50; i++) {
          final customPainter = _TestHintSparklePainter();

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: CustomPaint(
                  painter: customPainter,
                  size: const Size(200, 200),
                ),
              ),
            ),
          );
        }

        stopwatch.stop();

        // Should create 50 hint sparkle painters in reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        debugPrint(
          'Created 50 hint sparkle painters in ${stopwatch.elapsedMilliseconds}ms',
        );
      });
    });
  });
}

/// Test custom painter to verify ambient painting function works correctly
class _TestAmbientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Test ambient painting function
    paintAmbient(canvas, size, 0.5, null);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Test custom painter to verify confetti painting function works correctly
class _TestConfettiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Test confetti painting function
    paintConfetti(canvas, size, null);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Test custom painter to verify hint sparkle painting function works correctly
class _TestHintSparklePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Test hint sparkle painting function
    final cellRect = Rect.fromLTWH(50, 50, 100, 100);
    paintHintSparkle(canvas, cellRect, 0.5, null);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
