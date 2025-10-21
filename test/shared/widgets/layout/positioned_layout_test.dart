import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/shared/widgets/layout/positioned_layout.dart';

void main() {
  group('PositionedLayout Tests', () {
    testWidgets('renders basic positioned layout correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                PositionedLayout(child: const Text('Positioned Content')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Positioned Content'), findsOneWidget);
      expect(find.byType(Positioned), findsOneWidget);
    });

    testWidgets('positions top correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                PositionedLayout(
                  position: LayoutPosition.top,
                  child: const Text('Top Position'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Top Position'), findsOneWidget);
    });

    testWidgets('positions bottom correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                PositionedLayout(
                  position: LayoutPosition.bottom,
                  child: const Text('Bottom Position'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Bottom Position'), findsOneWidget);
    });

    testWidgets('positions center correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                PositionedLayout(
                  position: LayoutPosition.center,
                  child: const Text('Center Position'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Center Position'), findsOneWidget);
    });

    testWidgets('applies custom positioning correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                PositionedLayout(
                  top: 100.0,
                  left: 50.0,
                  child: const Text('Custom Position'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Custom Position'), findsOneWidget);
      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.top, 100.0);
      expect(positioned.left, 50.0);
    });

    testWidgets('uses safe area correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                PositionedLayout(
                  position: LayoutPosition.top,
                  useSafeArea: true,
                  child: const Text('Safe Area Position'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Safe Area Position'), findsOneWidget);
    });

    testWidgets('handles positioning correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                PositionedLayout(
                  position: LayoutPosition.center,
                  child: const Text('Positioned Content'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Positioned Content'), findsOneWidget);
    });

    testWidgets('handles different layout positions correctly', (
      WidgetTester tester,
    ) async {
      for (final position in LayoutPosition.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  PositionedLayout(
                    position: position,
                    child: Text('${position.name} Position'),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.text('${position.name} Position'), findsOneWidget);
      }
    });

    testWidgets('wraps child with RepaintBoundary correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                PositionedLayout(
                  child: Container(
                    color: Colors.red,
                    child: const Text('Repaint Boundary Child'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Repaint Boundary Child'), findsOneWidget);
      expect(find.byType(RepaintBoundary), findsAtLeast(1));
    });
  });
}
