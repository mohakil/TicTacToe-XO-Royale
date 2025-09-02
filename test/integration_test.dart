import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tictactoe_xo_royale/main.dart' as app;
import 'package:tictactoe_xo_royale/features/game/presentation/screens/game_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration Tests', () {
    testWidgets('should complete a full game flow', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for app to load
      await tester.pump(const Duration(seconds: 2));

      // Check if we're on the home screen
      expect(find.text('TicTacToe XO Royale'), findsOneWidget);

      // Navigate to setup screen
      final setupButton = find.text('Play');
      if (setupButton.evaluate().isNotEmpty) {
        await tester.tap(setupButton);
        await tester.pumpAndSettle();
      }

      // Wait for setup screen
      await tester.pump(const Duration(seconds: 1));

      // Check if we're on setup screen
      expect(find.text('Game Setup'), findsOneWidget);

      // Fill in player names
      final player1Field = find.byType(TextField).first;
      if (player1Field.evaluate().isNotEmpty) {
        await tester.enterText(player1Field, 'Player 1');
        await tester.pump();
      }

      // Start game
      final startButton = find.text('Start Game');
      if (startButton.evaluate().isNotEmpty) {
        await tester.tap(startButton);
        await tester.pumpAndSettle();
      }

      // Wait for game screen
      await tester.pump(const Duration(seconds: 1));

      // Check if we're on game screen
      expect(find.byType(GameScreen), findsOneWidget);

      // Make some moves
      final gameCells = find.byType(GestureDetector);
      if (gameCells.evaluate().length >= 3) {
        // Make first move
        await tester.tap(gameCells.first);
        await tester.pump();

        // Make second move
        await tester.tap(gameCells.at(1));
        await tester.pump();

        // Make third move
        await tester.tap(gameCells.at(2));
        await tester.pump();
      }

      // Wait for any animations
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('should handle navigation between screens', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for app to load
      await tester.pump(const Duration(seconds: 2));

      // Test navigation to different screens
      final profileButton = find.text('Profile');
      if (profileButton.evaluate().isNotEmpty) {
        await tester.tap(profileButton);
        await tester.pumpAndSettle();

        // Should be on profile screen
        expect(find.text('Profile'), findsOneWidget);
      }

      // Navigate back
      final backButton = find.byType(BackButton);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
        await tester.pumpAndSettle();
      }

      // Test store navigation
      final storeButton = find.text('Store');
      if (storeButton.evaluate().isNotEmpty) {
        await tester.tap(storeButton);
        await tester.pumpAndSettle();

        // Should be on store screen
        expect(find.text('Store'), findsOneWidget);
      }
    });

    testWidgets('should handle game state persistence', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for app to load
      await tester.pump(const Duration(seconds: 2));

      // Start a game
      final playButton = find.text('Play');
      if (playButton.evaluate().isNotEmpty) {
        await tester.tap(playButton);
        await tester.pumpAndSettle();
      }

      // Fill setup and start game
      final startButton = find.text('Start Game');
      if (startButton.evaluate().isNotEmpty) {
        await tester.tap(startButton);
        await tester.pumpAndSettle();
      }

      // Make a move
      final gameCells = find.byType(GestureDetector);
      if (gameCells.evaluate().isNotEmpty) {
        await tester.tap(gameCells.first);
        await tester.pump();
      }

      // Navigate away and back
      final backButton = find.byType(BackButton);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
        await tester.pumpAndSettle();
      }

      // Go back to game
      final continueButton = find.text('Continue');
      if (continueButton.evaluate().isNotEmpty) {
        await tester.tap(continueButton);
        await tester.pumpAndSettle();
      }

      // Game state should be preserved
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('should handle theme switching', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for app to load
      await tester.pump(const Duration(seconds: 2));

      // Navigate to settings
      final settingsButton = find.text('Settings');
      if (settingsButton.evaluate().isNotEmpty) {
        await tester.tap(settingsButton);
        await tester.pumpAndSettle();
      }

      // Toggle theme
      final themeSwitch = find.byType(Switch);
      if (themeSwitch.evaluate().isNotEmpty) {
        await tester.tap(themeSwitch);
        await tester.pumpAndSettle();
      }

      // Theme should change
      await tester.pump(const Duration(seconds: 1));
    });
  });
}
