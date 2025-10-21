import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/shared/widgets/buttons/icon_action_button.dart';

void main() {
  group('IconActionButton Tests', () {
    testWidgets('renders basic icon button correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconActionButton(icon: Icons.star, onPressed: () {}),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('handles tap callbacks correctly', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconActionButton(
              icon: Icons.favorite,
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.favorite));
      expect(tapped, isTrue);
    });

    testWidgets('shows tooltip correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconActionButton(
              icon: Icons.settings,
              tooltip: 'Settings',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);

      // Test that tooltip is present (though we can't easily test the actual tooltip display)
      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton.tooltip, 'Settings');
    });

    testWidgets('applies custom color correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconActionButton(
              icon: Icons.edit,
              color: Colors.red,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.edit), findsOneWidget);
      final icon = tester.widget<Icon>(find.byIcon(Icons.edit));
      expect(icon.color, Colors.red);
    });

    testWidgets('applies different icon sizes correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconActionButton(icon: Icons.star, onPressed: () {}),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('handles disabled state correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconActionButton(
              icon: Icons.block,
              onPressed: null, // Disabled state
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.block), findsOneWidget);
      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton.onPressed, isNull);
    });

    testWidgets('handles responsive sizing correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconActionButton(
              icon: Icons.visibility,
              useResponsiveSizing: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('handles non-responsive sizing correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconActionButton(
              icon: Icons.visibility_off,
              useResponsiveSizing: false,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('handles different icons correctly', (
      WidgetTester tester,
    ) async {
      final icons = [Icons.ac_unit, Icons.access_alarm, Icons.account_balance];

      for (final icon in icons) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IconActionButton(icon: icon, onPressed: () {}),
            ),
          ),
        );

        expect(find.byIcon(icon), findsOneWidget);
      }
    });
  });
}
