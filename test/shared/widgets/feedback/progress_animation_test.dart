import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/shared/widgets/feedback/progress_animation.dart';

void main() {
  group('ProgressAnimation Tests', () {
    testWidgets('renders progress animations correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ProgressAnimation(progress: 0.5))),
      );

      expect(
        find.byType(Container),
        findsAtLeastNWidgets(2),
      ); // Background and progress containers
      expect(
        find.byType(FractionallySizedBox),
        findsOneWidget,
      ); // Progress fill
    });

    testWidgets('handles progress value correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ProgressAnimation(progress: 0.25))),
      );

      // Wait for animation to complete
      await tester.pumpAndSettle();

      final fractionallySizedBox = tester.widget<FractionallySizedBox>(
        find.byType(FractionallySizedBox),
      );
      expect(fractionallySizedBox.widthFactor, 0.25);
    });

    testWidgets('handles zero progress correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ProgressAnimation(progress: 0.0))),
      );

      // Wait for animation to complete
      await tester.pumpAndSettle();

      final fractionallySizedBox = tester.widget<FractionallySizedBox>(
        find.byType(FractionallySizedBox),
      );
      expect(fractionallySizedBox.widthFactor, 0.0);
    });

    testWidgets('handles full progress correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ProgressAnimation(progress: 1.0))),
      );

      // Wait for animation to complete
      await tester.pumpAndSettle();

      final fractionallySizedBox = tester.widget<FractionallySizedBox>(
        find.byType(FractionallySizedBox),
      );
      expect(fractionallySizedBox.widthFactor, 1.0);
    });

    testWidgets('applies custom color correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProgressAnimation(progress: 0.5, color: Colors.red),
          ),
        ),
      );

      // Wait for animation to complete
      await tester.pumpAndSettle();

      final progressContainer = tester.widget<Container>(
        find.byType(Container).last, // Get the progress fill container
      );
      expect(progressContainer.decoration is BoxDecoration, isTrue);
      final decoration = progressContainer.decoration as BoxDecoration;
      expect(decoration.color, Colors.red);
    });

    testWidgets('applies custom background color correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProgressAnimation(
              progress: 0.5,
              backgroundColor: Colors.grey,
            ),
          ),
        ),
      );

      // Wait for animation to complete
      await tester.pumpAndSettle();

      final backgroundContainer = tester.widget<Container>(
        find.byType(Container).first, // Get the background container
      );
      expect(backgroundContainer.decoration is BoxDecoration, isTrue);
      final decoration = backgroundContainer.decoration as BoxDecoration;
      expect(decoration.color, Colors.grey);
    });
  });
}
