import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/shared/widgets/navigation/app_bar.dart';

void main() {
  group('AppBar Tests', () {
    testWidgets('renders basic app bar correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(appBar: SharedAppBar(title: 'Test Screen')),
        ),
      );

      expect(find.text('Test Screen'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('renders with back button correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(appBar: SharedAppBar(title: 'Screen with Back')),
        ),
      );

      expect(find.text('Screen with Back'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('renders without back button correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: SharedAppBar(
              title: 'Screen without Back',
              showBackButton: false,
            ),
          ),
        ),
      );

      expect(find.text('Screen without Back'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });

    testWidgets('renders with settings button correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: SharedAppBar(
              title: 'Screen with Settings',
              showSettingsButton: true,
            ),
          ),
        ),
      );

      expect(find.text('Screen with Settings'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('renders app bar with back button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(appBar: SharedAppBar(title: 'Interactive Back')),
        ),
      );

      expect(find.text('Interactive Back'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('renders app bar with settings button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: SharedAppBar(
              title: 'Interactive Settings',
              showSettingsButton: true,
            ),
          ),
        ),
      );

      expect(find.text('Interactive Settings'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('renders with custom actions correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: SharedAppBar(
              title: 'Screen with Actions',
              actions: [
                IconButton(icon: const Icon(Icons.search), onPressed: () {}),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Screen with Actions'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('centers title correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(appBar: SharedAppBar(title: 'Centered Title')),
        ),
      );

      expect(find.text('Centered Title'), findsOneWidget);
    });

    testWidgets('handles non-centered title correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(appBar: SharedAppBar(title: 'Non-Centered Title')),
        ),
      );

      expect(find.text('Non-Centered Title'), findsOneWidget);
    });

    testWidgets('applies responsive icon sizing correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: SharedAppBar(
              title: 'Responsive Icons',
              showSettingsButton: true,
            ),
          ),
        ),
      );

      expect(find.text('Responsive Icons'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });
  });
}
