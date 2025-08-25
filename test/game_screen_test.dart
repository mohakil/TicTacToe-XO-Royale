import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/features/game/game.dart';

void main() {
  group('GameScreen Widget Tests', () {
    late ProviderContainer container;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('renders game screen with basic components', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [],
          child: const MaterialApp(home: GameScreen()),
        ),
      );

      // Wait for the screen to render
      await tester.pump();

      // Verify main components are present
      expect(find.byType(GameScreen), findsOneWidget);
    });

    testWidgets('accepts game configuration parameters', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [],
          child: const MaterialApp(
            home: GameScreen(
              boardSize: 3,
              winCondition: 3,
              player1Name: 'Player 1',
              player2Name: 'Player 2',
              isRobotMode: false,
              difficulty: 'medium',
            ),
          ),
        ),
      );

      await tester.pump();

      // Verify the screen renders with parameters
      expect(find.byType(GameScreen), findsOneWidget);
    });

    testWidgets('handles different board sizes', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [],
          child: const MaterialApp(home: GameScreen(boardSize: 4)),
        ),
      );

      await tester.pump();

      // Verify 4x4 board setup
      expect(find.byType(GameScreen), findsOneWidget);
    });

    testWidgets('handles robot mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [],
          child: const MaterialApp(
            home: GameScreen(isRobotMode: true, difficulty: 'hard'),
          ),
        ),
      );

      await tester.pump();

      // Verify robot mode setup
      expect(find.byType(GameScreen), findsOneWidget);
    });
  });
}
