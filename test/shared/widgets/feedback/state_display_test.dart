import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/shared/widgets/feedback/state_display.dart';

void main() {
  group('StateDisplay Tests', () {
    testWidgets('renders loading state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StateDisplay(
              state: DisplayState.loading,
              title: 'Loading...',
            ),
          ),
        ),
      );

      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('renders empty state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StateDisplay(
              state: DisplayState.empty,
              title: 'No items found',
              subtitle: 'Add some items to get started',
              icon: Icons.inbox,
            ),
          ),
        ),
      );

      expect(find.text('No items found'), findsOneWidget);
      expect(find.text('Add some items to get started'), findsOneWidget);
      expect(find.byIcon(Icons.inbox), findsOneWidget);
    });

    testWidgets('renders error state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StateDisplay(
              state: DisplayState.error,
              title: 'Something went wrong',
              subtitle: 'Please try again later',
              icon: Icons.error,
              action: const Text('Retry'),
            ),
          ),
        ),
      );

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Please try again later'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('applies custom icon size correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StateDisplay(
              state: DisplayState.empty,
              title: 'Custom Icon Size',
              icon: Icons.star,
              iconSize: 48.0,
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(icon.size, 48.0);
    });

    testWidgets('handles responsive sizing correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StateDisplay(
              state: DisplayState.loading,
              title: 'Responsive Loading',
            ),
          ),
        ),
      );

      expect(find.text('Responsive Loading'), findsOneWidget);
    });

    testWidgets('renders action button correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StateDisplay(
              state: DisplayState.error,
              title: 'Error State',
              action: ElevatedButton(
                onPressed: () {},
                child: const Text('Retry'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Error State'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Retry'), findsOneWidget);
    });

    testWidgets('handles different display states correctly', (
      WidgetTester tester,
    ) async {
      for (final state in DisplayState.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StateDisplay(state: state, title: '${state.name} State'),
            ),
          ),
        );

        expect(find.text('${state.name} State'), findsOneWidget);
      }
    });
  });
}
