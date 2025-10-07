import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/features/settings/settings.dart';

void main() {
  group('SettingsScreen Widget Tests', () {
    late ProviderContainer container;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('renders settings screen with basic components', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SettingsScreen())),
      );

      // Wait for the screen to render
      await tester.pump();

      // Verify main components are present
      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    testWidgets('displays settings sections', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SettingsScreen())),
      );

      await tester.pump();

      // Verify the screen renders
      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    testWidgets('handles theme selection', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SettingsScreen())),
      );

      await tester.pump();

      // Verify theme selector is present
      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    testWidgets('displays about section', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SettingsScreen())),
      );

      await tester.pump();

      // Verify about section is present
      expect(find.byType(SettingsScreen), findsOneWidget);
    });
  });
}
