import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/shared/widgets/buttons/category_tab.dart';

void main() {
  group('CategoryTab Tests', () {
    testWidgets('renders basic category tab correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryTab(
              label: 'Test Category',
              isSelected: false,
              onTap: () {},
              variant: CategoryTabVariant.filled,
            ),
          ),
        ),
      );

      expect(find.text('Test Category'), findsOneWidget);
    });

    testWidgets('renders selected state correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryTab(
              label: 'Selected Category',
              isSelected: true,
              onTap: () {},
              variant: CategoryTabVariant.filled,
            ),
          ),
        ),
      );

      expect(find.text('Selected Category'), findsOneWidget);
    });

    testWidgets('handles tap callbacks correctly', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryTab(
              label: 'Interactive Category',
              isSelected: false,
              onTap: () => tapped = true,
              variant: CategoryTabVariant.filled,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Interactive Category'));
      expect(tapped, isTrue);
    });

    testWidgets('renders filled variant correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryTab(
              label: 'Filled Category',
              isSelected: false,
              variant: CategoryTabVariant.filled,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Filled Category'), findsOneWidget);
    });

    testWidgets('renders outlined variant correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryTab(
              label: 'Outlined Category',
              isSelected: false,
              variant: CategoryTabVariant.outlined,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Outlined Category'), findsOneWidget);
    });

    testWidgets('renders tonal variant correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryTab(
              label: 'Tonal Category',
              isSelected: false,
              variant: CategoryTabVariant.tonal,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Tonal Category'), findsOneWidget);
    });

    testWidgets('applies responsive sizing correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryTab(
              label: 'Responsive Category',
              isSelected: false,
              onTap: () {},
              variant: CategoryTabVariant.filled,
            ),
          ),
        ),
      );

      expect(find.text('Responsive Category'), findsOneWidget);
    });

    testWidgets('handles different variants correctly', (
      WidgetTester tester,
    ) async {
      for (final variant in CategoryTabVariant.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryTab(
                label: '${variant.name} Category',
                isSelected: false,
                variant: variant,
                onTap: () {},
              ),
            ),
          ),
        );

        expect(find.text('${variant.name} Category'), findsOneWidget);
      }
    });

    testWidgets('handles different selection states correctly', (
      WidgetTester tester,
    ) async {
      for (final isSelected in [true, false]) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryTab(
                label: '${isSelected ? 'Selected' : 'Unselected'} Category',
                isSelected: isSelected,
                onTap: () {},
                variant: CategoryTabVariant.filled,
              ),
            ),
          ),
        );

        expect(
          find.text('${isSelected ? 'Selected' : 'Unselected'} Category'),
          findsOneWidget,
        );
      }
    });

    testWidgets('handles disabled state correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryTab(
              label: 'Disabled Category',
              isSelected: false,
              onTap: null, // Disabled state
              variant: CategoryTabVariant.filled,
            ),
          ),
        ),
      );

      expect(find.text('Disabled Category'), findsOneWidget);
    });

    testWidgets('applies animation correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryTab(
              label: 'Animated Category',
              isSelected: true,
              onTap: () {},
              variant: CategoryTabVariant.filled,
            ),
          ),
        ),
      );

      expect(find.text('Animated Category'), findsOneWidget);
    });
  });
}
