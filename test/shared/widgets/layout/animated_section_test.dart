import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/shared/widgets/layout/animated_section.dart';

void main() {
  group('AnimatedSection Tests', () {
    testWidgets('renders basic animated section correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedSection(child: const Text('Animated Content')),
          ),
        ),
      );

      expect(find.text('Animated Content'), findsOneWidget);
    });

    testWidgets('applies fade in animation correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedSection(
              animationType: AnimationType.fadeIn,
              child: const Text('Fade In Animation'),
            ),
          ),
        ),
      );

      expect(find.text('Fade In Animation'), findsOneWidget);
    });

    testWidgets('applies slide in animation correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedSection(
              animationType: AnimationType.slideIn,
              child: const Text('Slide In Animation'),
            ),
          ),
        ),
      );

      expect(find.text('Slide In Animation'), findsOneWidget);
    });

    testWidgets('applies scale in animation correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedSection(
              animationType: AnimationType.scaleIn,
              child: const Text('Scale In Animation'),
            ),
          ),
        ),
      );

      expect(find.text('Scale In Animation'), findsOneWidget);
    });

    testWidgets('applies fade slide animation correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedSection(
              animationType: AnimationType.fadeSlide,
              child: const Text('Fade Slide Animation'),
            ),
          ),
        ),
      );

      expect(find.text('Fade Slide Animation'), findsOneWidget);
    });

    testWidgets('handles vertical slide direction correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedSection(
              animationType: AnimationType.slideIn,
              slideDirection: Axis.vertical,
              child: const Text('Vertical Slide'),
            ),
          ),
        ),
      );

      expect(find.text('Vertical Slide'), findsOneWidget);
    });

    testWidgets('handles horizontal slide direction correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedSection(
              animationType: AnimationType.slideIn,
              slideDirection: Axis.horizontal,
              child: const Text('Horizontal Slide'),
            ),
          ),
        ),
      );

      expect(find.text('Horizontal Slide'), findsOneWidget);
    });

    testWidgets('applies custom duration correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedSection(
              duration: const Duration(milliseconds: 500),
              child: const Text('Custom Duration'),
            ),
          ),
        ),
      );

      expect(find.text('Custom Duration'), findsOneWidget);
    });

    testWidgets('applies custom delay correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedSection(
              delay: const Duration(milliseconds: 200),
              child: const Text('Custom Delay'),
            ),
          ),
        ),
      );

      expect(find.text('Custom Delay'), findsOneWidget);
    });

    testWidgets('handles different animation types correctly', (
      WidgetTester tester,
    ) async {
      for (final animationType in AnimationType.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedSection(
                animationType: animationType,
                child: Text('${animationType.name} Animation'),
              ),
            ),
          ),
        );

        expect(find.text('${animationType.name} Animation'), findsOneWidget);
      }
    });
  });
}
