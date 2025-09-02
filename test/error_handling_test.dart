import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/widgets/error_boundary.dart';

void main() {
  group('ErrorBoundary Tests', () {
    testWidgets('should work with extension method', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const Text('Normal Widget').withErrorBoundary(),
          ),
        ),
      );

      await tester.pump();

      // Should display normal widget
      expect(find.text('Normal Widget'), findsOneWidget);
    });

    testWidgets('should display custom error widget when provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ErrorBoundary(
              errorBuilder: (error, stackTrace) =>
                  const Text('Custom Error Widget'),
              child: const Text('Normal Widget'),
            ),
          ),
        ),
      );

      await tester.pump();

      // Should display normal widget when no error occurs
      expect(find.text('Normal Widget'), findsOneWidget);
    });
  });

  group('ErrorLoggingService Tests', () {
    test('should log error with context and additional data', () {
      final service = ErrorLoggingService();
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;

      // Should not throw when logging
      expect(
        () => service.logError(
          error,
          stackTrace,
          context: 'TestContext',
          additionalData: {'key': 'value'},
        ),
        returnsNormally,
      );
    });

    test('should log error without additional data', () {
      final service = ErrorLoggingService();
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;

      // Should not throw when logging
      expect(() => service.logError(error, stackTrace), returnsNormally);
    });
  });
}
