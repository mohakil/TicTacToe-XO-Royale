import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/features/loading/presentation/widgets/logo_animation.dart';
import 'package:tictactoe_xo_royale/features/loading/presentation/widgets/progress_bar.dart';
import 'package:tictactoe_xo_royale/features/loading/presentation/widgets/tips_carousel.dart';

void main() {
  group('Loading Components Tests', () {
    testWidgets('LogoAnimation displays XO text', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LogoAnimation()));

      // Verify logo text is displayed
      expect(find.text('XO'), findsOneWidget);

      // Just pump once to avoid animation timeouts
      await tester.pump();
    });

    testWidgets('ProgressBar displays progress indicator', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: ProgressBar(progress: 0.5)),
      );

      // Verify progress indicator is present
      expect(find.byType(LinearProgressIndicator), findsOneWidget);

      // Just pump once to avoid animation timeouts
      await tester.pump();
    });

    testWidgets('TipsCarousel displays tips', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TipsCarousel()));

      // Wait for initial frame
      await tester.pump();

      // Verify tips are displayed
      expect(find.textContaining('Tip:'), findsOneWidget);

      // Verify page indicator dots are present
      expect(find.byType(AnimatedContainer), findsWidgets);

      // Just pump once more to avoid animation timeouts
      await tester.pump();
    });
  });
}
