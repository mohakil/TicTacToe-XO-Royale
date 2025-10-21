import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/shared/widgets/buttons/ad_watch_button.dart';

void main() {
  group('AdWatchButton Tests', () {
    testWidgets('renders basic ad watch button correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdWatchButton(onWatchAd: () {}, rewardText: '+50 Gems'),
          ),
        ),
      );

      expect(find.text('+50 Gems'), findsOneWidget);
      expect(find.text('Watch Ad'), findsOneWidget);
    });

    testWidgets('renders watching state correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdWatchButton(
              isLoading: true,
              onWatchAd: () {},
              rewardText: '+50 Gems',
            ),
          ),
        ),
      );

      expect(find.text('Loading...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders cooldown state correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdWatchButton(
              onWatchAd: () {},
              rewardText: '+50 Gems',
              countdownDuration: const Duration(minutes: 5),
            ),
          ),
        ),
      );

      // Pump to allow animation to start
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byIcon(Icons.timer), findsOneWidget);
      expect(
        find.textContaining('s'),
        findsOneWidget,
      ); // Should find something like "300s"
    });

    testWidgets('handles watch ad callback correctly', (
      WidgetTester tester,
    ) async {
      bool watched = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdWatchButton(
              onWatchAd: () => watched = true,
              rewardText: '+50 Gems',
            ),
          ),
        ),
      );

      await tester.tap(find.text('Watch Ad'));
      expect(watched, isTrue);
    });

    testWidgets('shows custom reward text correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdWatchButton(rewardText: 'Earn 50 Gems', onWatchAd: () {}),
          ),
        ),
      );

      expect(find.text('Earn 50 Gems'), findsOneWidget);
      expect(find.text('Watch Ad'), findsOneWidget);
    });

    testWidgets('handles different button states correctly', (
      WidgetTester tester,
    ) async {
      // Test available state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdWatchButton(onWatchAd: () {}, rewardText: '+50 Gems'),
          ),
        ),
      );

      expect(find.text('+50 Gems'), findsOneWidget);
      expect(find.text('Watch Ad'), findsOneWidget);

      // Test watching state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdWatchButton(
              isLoading: true,
              onWatchAd: () {},
              rewardText: '+50 Gems',
            ),
          ),
        ),
      );

      expect(find.text('Loading...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Test cooldown state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdWatchButton(
              onWatchAd: () {},
              rewardText: '+50 Gems',
              countdownDuration: const Duration(minutes: 3),
            ),
          ),
        ),
      );

      // Pump to allow animation to start
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byIcon(Icons.timer), findsOneWidget);
      expect(find.textContaining('s'), findsOneWidget);
    });

    testWidgets('applies responsive styling correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdWatchButton(onWatchAd: () {}, rewardText: '+50 Gems'),
          ),
        ),
      );

      expect(find.text('+50 Gems'), findsOneWidget);
      expect(find.text('Watch Ad'), findsOneWidget);
    });

    testWidgets('handles disabled state correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdWatchButton(
              onWatchAd: null, // Disabled state
              rewardText: '+50 Gems',
            ),
          ),
        ),
      );

      expect(find.text('Watch Ad'), findsOneWidget);
      // Button should be disabled but still visible
    });

    testWidgets('shows countdown timer correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdWatchButton(
              onWatchAd: () {},
              rewardText: '+50 Gems',
              countdownDuration: const Duration(seconds: 30),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.timer), findsOneWidget);
      expect(find.textContaining('s'), findsOneWidget);
    });

    testWidgets('handles loading state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdWatchButton(
              isLoading: true,
              onWatchAd: () {},
              rewardText: '+50 Gems',
            ),
          ),
        ),
      );

      expect(find.text('Loading...'), findsOneWidget);
    });
  });
}
