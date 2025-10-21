import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/shared/widgets/feedback/currency_display.dart';

void main() {
  group('CurrencyDisplay Tests', () {
    testWidgets('renders currency display correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyDisplay(amount: 100, icon: Icons.diamond),
          ),
        ),
      );

      expect(find.text('100'), findsOneWidget);
      expect(find.byIcon(Icons.diamond), findsOneWidget);
    });

    testWidgets('handles different amounts correctly', (
      WidgetTester tester,
    ) async {
      final amounts = [0, 50, 250, 1000, 1500000];

      for (final amount in amounts) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CurrencyDisplay(amount: amount, icon: Icons.diamond),
            ),
          ),
        );

        final expectedText = amount >= 1000000
            ? '${(amount / 1000000).toStringAsFixed(1)}M'
            : amount >= 1000
            ? '${(amount / 1000).toStringAsFixed(1)}K'
            : amount.toString();
        expect(find.text(expectedText), findsOneWidget);
        expect(find.byIcon(Icons.diamond), findsOneWidget);
      }
    });

    testWidgets('handles negative amounts correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyDisplay(amount: -50, icon: Icons.diamond),
          ),
        ),
      );

      expect(find.text('-50'), findsOneWidget);
      expect(find.byIcon(Icons.diamond), findsOneWidget);
    });

    testWidgets('handles tap callbacks correctly', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyDisplay(
              amount: 300,
              icon: Icons.diamond,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('300'));
      expect(tapped, isTrue);
    });
  });
}
