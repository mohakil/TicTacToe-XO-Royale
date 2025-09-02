import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/app/router/route_transitions.dart';

void main() {
  group('Route Transitions Tests', () {
    testWidgets('should create fade transition', (tester) async {
      final page = AppTransitionPage(
        child: const Text('Test'),
        transitionType: PageTransitionType.fade,
      );

      expect(page, isA<Page>());
      expect(page.transitionType, equals(PageTransitionType.fade));
      expect(page.child, isA<Text>());
    });

    testWidgets('should create shared axis horizontal transition', (
      tester,
    ) async {
      final page = AppTransitionPage(
        child: const Text('Test'),
        transitionType: PageTransitionType.sharedAxisHorizontal,
      );

      expect(page, isA<Page>());
      expect(
        page.transitionType,
        equals(PageTransitionType.sharedAxisHorizontal),
      );
      expect(page.child, isA<Text>());
    });

    testWidgets('should create shared axis vertical transition', (
      tester,
    ) async {
      final page = AppTransitionPage(
        child: const Text('Test'),
        transitionType: PageTransitionType.sharedAxisVertical,
      );

      expect(page, isA<Page>());
      expect(
        page.transitionType,
        equals(PageTransitionType.sharedAxisVertical),
      );
      expect(page.child, isA<Text>());
    });

    testWidgets('should create scale transition', (tester) async {
      final page = AppTransitionPage(
        child: const Text('Test'),
        transitionType: PageTransitionType.scale,
      );

      expect(page, isA<Page>());
      expect(page.transitionType, equals(PageTransitionType.scale));
      expect(page.child, isA<Text>());
    });

    testWidgets('should create hero transition', (tester) async {
      final page = AppTransitionPage(
        child: const Text('Test'),
        transitionType: PageTransitionType.hero,
        tag: 'test-tag',
      );

      expect(page, isA<Page>());
      expect(page.transitionType, equals(PageTransitionType.hero));
      expect(page.tag, equals('test-tag'));
      expect(page.child, isA<Text>());
    });

    testWidgets('should create combined transition', (tester) async {
      final page = AppTransitionPage(
        child: const Text('Test'),
        transitionType: PageTransitionType.combined,
      );

      expect(page, isA<Page>());
      expect(page.transitionType, equals(PageTransitionType.combined));
      expect(page.child, isA<Text>());
    });

    testWidgets('should create route from AppTransitionPage', (tester) async {
      final page = AppTransitionPage(
        child: const Text('Test'),
        transitionType: PageTransitionType.fade,
      );

      // Create a mock context for testing
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final route = page.createRoute(context);
              expect(route, isA<PageRouteBuilder>());
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
