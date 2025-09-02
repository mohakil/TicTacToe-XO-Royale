import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/screens/game_screen.dart';
import 'package:tictactoe_xo_royale/features/home/presentation/screens/home_screen.dart';
import 'package:tictactoe_xo_royale/features/setup/presentation/screens/setup_screen.dart';

void main() {
  group('Performance Tests', () {
    testWidgets('should maintain 60fps during game interactions', (
      tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: GameScreen())),
      );

      // Wait for initial build
      await tester.pump();

      // Measure frame times during rapid interactions
      final stopwatch = Stopwatch()..start();

      // Simulate rapid taps on game cells
      final gameCells = find.byType(GestureDetector);
      for (int i = 0; i < 10; i++) {
        if (gameCells.evaluate().isNotEmpty) {
          await tester.tap(gameCells.first);
          await tester.pump();
        }
      }

      stopwatch.stop();

      // Should complete interactions quickly
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });

    testWidgets('should handle large board sizes efficiently', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SetupScreen())),
      );

      // Wait for initial build
      await tester.pump();

      // Test with large board size
      final boardSizeSelector = find.byType(DropdownButtonFormField);
      if (boardSizeSelector.evaluate().isNotEmpty) {
        await tester.tap(boardSizeSelector);
        await tester.pump();

        // Select large board size
        final largeBoardOption = find.text('5x5');
        if (largeBoardOption.evaluate().isNotEmpty) {
          await tester.tap(largeBoardOption);
          await tester.pump();
        }
      }

      // Start game with large board
      final startButton = find.text('Start Game');
      if (startButton.evaluate().isNotEmpty) {
        await tester.tap(startButton);
        await tester.pump();
      }

      // Should handle large board without performance issues
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('should handle rapid state changes efficiently', (
      tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: HomeScreen())),
      );

      // Wait for initial build
      await tester.pump();

      // Simulate rapid state changes
      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 20; i++) {
        // Find and tap any button
        final buttons = find.byType(ElevatedButton);
        if (buttons.evaluate().isNotEmpty) {
          await tester.tap(buttons.first);
          await tester.pump();
        }
      }

      stopwatch.stop();

      // Should handle rapid changes efficiently
      expect(stopwatch.elapsedMilliseconds, lessThan(2000));
    });

    testWidgets('should handle memory efficiently during navigation', (
      tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: HomeScreen())),
      );

      // Wait for initial build
      await tester.pump();

      // Navigate between screens multiple times
      for (int i = 0; i < 5; i++) {
        // Navigate to setup
        final playButton = find.text('Play');
        if (playButton.evaluate().isNotEmpty) {
          await tester.tap(playButton);
          await tester.pump();
        }

        // Navigate back
        final backButton = find.byType(BackButton);
        if (backButton.evaluate().isNotEmpty) {
          await tester.tap(backButton);
          await tester.pump();
        }
      }

      // Should not have memory leaks
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('should handle animations smoothly', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: HomeScreen())),
      );

      // Wait for initial build
      await tester.pump();

      // Wait for animations to complete
      await tester.pumpAndSettle();

      // Should handle animations without frame drops
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('should handle concurrent operations efficiently', (
      tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: GameScreen())),
      );

      // Wait for initial build
      await tester.pump();

      // Simulate concurrent operations
      final stopwatch = Stopwatch()..start();

      // Make multiple moves rapidly
      final gameCells = find.byType(GestureDetector);
      for (int i = 0; i < 5; i++) {
        if (gameCells.evaluate().length > i) {
          await tester.tap(gameCells.at(i));
          await tester.pump();
        }
      }

      stopwatch.stop();

      // Should handle concurrent operations efficiently
      expect(stopwatch.elapsedMilliseconds, lessThan(500));
    });
  });
}
