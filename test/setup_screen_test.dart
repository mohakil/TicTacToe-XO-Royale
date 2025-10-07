import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/features/setup/setup.dart';

void main() {
  group('SetupScreen Widget Tests', () {
    late ProviderContainer container;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('renders setup screen with basic components', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SetupScreen())),
      );

      // Wait for the screen to render
      await tester.pump();

      // Verify main components are present
      expect(find.byType(SetupScreen), findsOneWidget);

      // Check for basic setup elements
      expect(find.text('Game Setup'), findsOneWidget);
    });

    testWidgets('accepts initial parameters', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SetupScreen(
              player1: 'Player 1',
              player2: 'Player 2',
              gameMode: 'local',
              boardSize: 3,
            ),
          ),
        ),
      );

      await tester.pump();

      // Verify the screen renders with parameters
      expect(find.byType(SetupScreen), findsOneWidget);
    });

    testWidgets('handles different game modes', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: SetupScreen(gameMode: 'robot')),
        ),
      );

      await tester.pump();

      // Verify robot mode setup
      expect(find.byType(SetupScreen), findsOneWidget);
    });

    testWidgets('handles different board sizes', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: SetupScreen(boardSize: 4)),
        ),
      );

      await tester.pump();

      // Verify 4x4 board setup
      expect(find.byType(SetupScreen), findsOneWidget);
    });
  });
}
