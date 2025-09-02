import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/features/home/presentation/screens/home_screen.dart';
import 'package:tictactoe_xo_royale/features/setup/presentation/screens/setup_screen.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/screens/game_screen.dart';

void main() {
  group('Simple Widget Tests', () {
    testWidgets('should render home screen', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: HomeScreen())),
      );

      // Wait for initial build
      await tester.pump();

      // Check if home screen renders without crashing
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('should render setup screen', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SetupScreen())),
      );

      // Wait for initial build
      await tester.pump();

      // Check if setup screen renders without crashing
      expect(find.byType(SetupScreen), findsOneWidget);
    });

    testWidgets('should render game screen', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: GameScreen())),
      );

      // Wait for initial build
      await tester.pump();

      // Check if game screen renders without crashing
      expect(find.byType(GameScreen), findsOneWidget);
    });

    testWidgets('should handle button taps', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: HomeScreen())),
      );

      // Wait for initial build
      await tester.pump();

      // Look for any button and tap it
      final buttons = find.byType(ElevatedButton);
      if (buttons.evaluate().isNotEmpty) {
        await tester.tap(buttons.first);
        await tester.pump();

        // Should not crash
        expect(find.byType(HomeScreen), findsOneWidget);
      }
    });

    testWidgets('should handle text input', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SetupScreen())),
      );

      // Wait for initial build
      await tester.pump();

      // Look for text fields
      final textFields = find.byType(TextField);
      if (textFields.evaluate().isNotEmpty) {
        await tester.enterText(textFields.first, 'Test Player');
        await tester.pump();

        // Should not crash
        expect(find.byType(SetupScreen), findsOneWidget);
      }
    });
  });
}
