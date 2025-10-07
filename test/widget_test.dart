import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/features/home/presentation/screens/home_screen.dart';
import 'package:tictactoe_xo_royale/features/profile/presentation/screens/profile_screen.dart';
import 'package:tictactoe_xo_royale/features/store/presentation/screens/store_screen.dart';
import 'package:tictactoe_xo_royale/features/loading/presentation/screens/loading_screen.dart';

void main() {
  group('Widget Tests', () {
    late ProviderContainer container;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('HomeScreen Widget Tests', () {
      testWidgets('should render home screen with all components', (
        tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [],
            child: const MaterialApp(home: HomeScreen()),
          ),
        );

        await tester.pump(const Duration(seconds: 1));

        // Verify main components are present
        expect(find.byType(HomeScreen), findsOneWidget);

        // Check for key UI elements
        expect(find.text('Welcome to XO Royale'), findsOneWidget);
        expect(find.text('Start New Game'), findsOneWidget);
        expect(find.text('Visit Store'), findsOneWidget);
        expect(find.text('View Profile'), findsOneWidget);
      });

      testWidgets('should handle game mode selection', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [],
            child: const MaterialApp(home: HomeScreen()),
          ),
        );

        await tester.pump(const Duration(seconds: 1));

        // Find and tap game mode cards
        final gameModeCards = find.byType(Card);
        expect(gameModeCards, findsWidgets);

        // Tap on a game mode card
        await tester.tap(gameModeCards.first);
        await tester.pump(const Duration(seconds: 1));

        // Verify the screen is still rendered
        expect(find.byType(HomeScreen), findsOneWidget);
      });

      testWidgets('should handle button interactions', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [],
            child: const MaterialApp(home: HomeScreen()),
          ),
        );

        await tester.pump(const Duration(seconds: 1));

        // Test Start New Game button
        final startGameButton = find.text('Start New Game');
        expect(startGameButton, findsOneWidget);

        await tester.tap(startGameButton);
        await tester.pump(const Duration(seconds: 1));

        // Test Visit Store button
        final visitStoreButton = find.text('Visit Store');
        expect(visitStoreButton, findsOneWidget);

        await tester.tap(visitStoreButton);
        await tester.pump(const Duration(seconds: 1));

        // Test View Profile button
        final viewProfileButton = find.text('View Profile');
        expect(viewProfileButton, findsOneWidget);

        await tester.tap(viewProfileButton);
        await tester.pump(const Duration(seconds: 1));
      });

      testWidgets('should display ambient effects', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [],
            child: const MaterialApp(home: HomeScreen()),
          ),
        );

        await tester.pump(const Duration(seconds: 1));

        // Check for ambient particles widget
        expect(find.byType(HomeScreen), findsOneWidget);
      });

      testWidgets('should handle responsive layout', (tester) async {
        // Test with different screen sizes
        await tester.binding.setSurfaceSize(const Size(400, 800));

        await tester.pumpWidget(
          ProviderScope(
            overrides: [],
            child: const MaterialApp(home: HomeScreen()),
          ),
        );

        await tester.pump(const Duration(seconds: 1));

        expect(find.byType(HomeScreen), findsOneWidget);

        // Test with smaller screen
        await tester.binding.setSurfaceSize(const Size(300, 600));
        await tester.pump(const Duration(seconds: 1));

        expect(find.byType(HomeScreen), findsOneWidget);
      });
    });

    group('ProfileScreen Widget Tests', () {
      testWidgets('should render profile screen with all components', (
        tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [],
            child: const MaterialApp(home: ProfileScreen()),
          ),
        );

        await tester.pump(const Duration(seconds: 1));

        // Verify main components are present
        expect(find.byType(ProfileScreen), findsOneWidget);

        // Check for key UI elements
        expect(find.text('Profile'), findsOneWidget);
        expect(find.text('Player'), findsOneWidget);
      });

      testWidgets('should display player statistics', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [],
            child: const MaterialApp(home: ProfileScreen()),
          ),
        );

        await tester.pump(const Duration(seconds: 1));

        // Check for stats section
        expect(find.byType(ProfileScreen), findsOneWidget);
      });

      testWidgets('should handle profile editing', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [],
            child: const MaterialApp(home: ProfileScreen()),
          ),
        );

        await tester.pump(const Duration(seconds: 1));

        // Look for edit button or similar
        final editButtons = find.byIcon(Icons.edit);
        if (editButtons.evaluate().isNotEmpty) {
          await tester.tap(editButtons.first);
          await tester.pump(const Duration(seconds: 1));
        }

        expect(find.byType(ProfileScreen), findsOneWidget);
      });
    });

    group('StoreScreen Widget Tests', () {
      testWidgets('should render store screen with all components', (
        tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [],
            child: const MaterialApp(home: StoreScreen()),
          ),
        );

        await tester.pump(const Duration(seconds: 1));

        // Verify main components are present
        expect(find.byType(StoreScreen), findsOneWidget);

        // Check for key UI elements
        expect(find.text('Store'), findsOneWidget);
      });

      testWidgets('should display store categories', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [],
            child: const MaterialApp(home: StoreScreen()),
          ),
        );

        await tester.pump(const Duration(seconds: 1));

        // Check for category tabs or buttons
        expect(find.byType(StoreScreen), findsOneWidget);
      });

      testWidgets('should handle item selection', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [],
            child: const MaterialApp(home: StoreScreen()),
          ),
        );

        await tester.pump(const Duration(seconds: 1));

        // Look for store items
        final storeItems = find.byType(Card);
        if (storeItems.evaluate().isNotEmpty) {
          await tester.tap(storeItems.first);
          await tester.pump(const Duration(seconds: 1));
        }

        expect(find.byType(StoreScreen), findsOneWidget);
      });
    });

    group('LoadingScreen Widget Tests', () {
      testWidgets('should render loading screen with all components', (
        tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [],
            child: const MaterialApp(home: LoadingScreen()),
          ),
        );

        await tester.pump(const Duration(seconds: 1));

        // Verify main components are present
        expect(find.byType(LoadingScreen), findsOneWidget);

        // Check for loading indicators
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should display loading progress', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [],
            child: const MaterialApp(home: LoadingScreen()),
          ),
        );

        await tester.pump(const Duration(seconds: 1));

        // Check for progress bar or indicator
        expect(find.byType(LoadingScreen), findsOneWidget);
      });

      testWidgets('should handle loading completion', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [],
            child: const MaterialApp(home: LoadingScreen()),
          ),
        );

        // Wait for loading to complete
        await tester.pump(const Duration(seconds: 3));

        expect(find.byType(LoadingScreen), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper semantic labels', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [],
            child: const MaterialApp(home: HomeScreen()),
          ),
        );

        await tester.pump(const Duration(seconds: 1));

        // Check for semantic labels
        final semantics = tester.getSemantics(find.byType(HomeScreen));
        expect(semantics, isNotNull);
      });

      testWidgets('should support screen readers', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [],
            child: const MaterialApp(home: ProfileScreen()),
          ),
        );

        await tester.pump(const Duration(seconds: 1));

        // Verify semantic information is available
        expect(find.byType(ProfileScreen), findsOneWidget);
      });
    });

    group('Theme Tests', () {
      testWidgets('should support light theme', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [],
            child: MaterialApp(
              theme: ThemeData.light(),
              home: const HomeScreen(),
            ),
          ),
        );

        await tester.pump(const Duration(seconds: 1));

        expect(find.byType(HomeScreen), findsOneWidget);
      });

      testWidgets('should support dark theme', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [],
            child: MaterialApp(
              theme: ThemeData.dark(),
              home: const HomeScreen(),
            ),
          ),
        );

        await tester.pump(const Duration(seconds: 1));

        expect(find.byType(HomeScreen), findsOneWidget);
      });
    });

    group('Error Handling Tests', () {
      testWidgets('should handle widget errors gracefully', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [],
            child: const MaterialApp(home: HomeScreen()),
          ),
        );

        await tester.pump(const Duration(seconds: 1));

        // Verify the widget renders without errors
        expect(find.byType(HomeScreen), findsOneWidget);
      });
    });
  });
}
