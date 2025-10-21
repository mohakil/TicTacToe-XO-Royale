import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/shared/widgets/cards/enhanced_card.dart';

void main() {
  group('EnhancedCard Tests', () {
    testWidgets('renders basic card correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: EnhancedCard(child: const Text('Test Content'))),
        ),
      );

      expect(find.text('Test Content'), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('renders elevated variant correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedCard(
              variant: CardVariant.elevated,
              child: const Text('Elevated Card'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.decoration, isNotNull);
    });

    testWidgets('renders outlined variant correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedCard(
              variant: CardVariant.outlined,
              child: const Text('Outlined Card'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.decoration, isNotNull);
    });

    testWidgets('renders filled variant correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedCard(
              variant: CardVariant.filled,
              child: const Text('Filled Card'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.decoration, isNotNull);
    });

    testWidgets('renders gradient variant correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedCard(
              variant: CardVariant.gradient,
              child: const Text('Gradient Card'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.decoration, isNotNull);
    });

    testWidgets('handles tap callbacks correctly', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedCard(
              isInteractive: true,
              onTap: () => tapped = true,
              child: const Text('Interactive Card'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Interactive Card'));
      expect(tapped, isTrue);
    });

    testWidgets('applies custom styling correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedCard(
              backgroundColor: Colors.red,
              borderColor: Colors.blue,
              elevation: 5.0,
              child: const Text('Styled Card'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.decoration, isNotNull);
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, Colors.red);
    });

    testWidgets('applies responsive sizing correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedCard(
              size: CardSize.large,
              child: const Text('Large Card'),
            ),
          ),
        ),
      );

      // Test that the card renders with large size
      expect(find.byType(Container), findsOneWidget);
      expect(find.text('Large Card'), findsOneWidget);
    });

    testWidgets('handles non-interactive cards correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedCard(
              isInteractive: false,
              onTap: () => fail('Should not be called'),
              child: const Text('Non-Interactive Card'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Non-Interactive Card'));
      // Should not throw any errors
    });
  });
}
