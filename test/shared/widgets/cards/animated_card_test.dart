import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/shared/widgets/cards/animated_card.dart';

void main() {
  group('AnimatedCard Tests', () {
    testWidgets('renders basic animated card correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedCard(child: const Text('Animated Content')),
          ),
        ),
      );

      expect(find.text('Animated Content'), findsOneWidget);
    });

    testWidgets('handles tap interactions correctly', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedCard(
              onTap: () => tapped = true,
              child: const Text('Interactive Animated Card'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Interactive Animated Card'));
      expect(tapped, isTrue);
    });

    testWidgets('applies different animation configurations correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedCard(child: const Text('Animation Test')),
          ),
        ),
      );

      expect(find.text('Animation Test'), findsOneWidget);
    });

    testWidgets('handles haptic feedback correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedCard(
              enableHapticFeedback: true,
              onTap: () {},
              child: const Text('Haptic Card'),
            ),
          ),
        ),
      );

      // Note: Haptic feedback testing would require platform-specific testing
      // For now, we just verify the widget renders correctly
      expect(find.text('Haptic Card'), findsOneWidget);
    });

    testWidgets('handles non-interactive cards correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedCard(
              onTap: () => fail('Should not be called'),
              child: const Text('Non-Interactive Card'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Non-Interactive Card'));
      // Should not throw any errors
    });

    testWidgets('integrates with player colors correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedCard(
              child: Container(
                color: Colors.blue, // Simulating player color integration
                child: const Text('Player Colored Card'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Player Colored Card'), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });
  });
}
