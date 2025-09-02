import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/features/loading/providers/loading_provider.dart';

void main() {
  group('LoadingProvider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('Loading State Provider', () {
      test('should provide initial loading state', () {
        final loadingState = container.read(loadingProvider);
        expect(loadingState, isA<LoadingState>());
        expect(loadingState.progress, equals(0.0));
        expect(loadingState.isLoading, isTrue);
        expect(loadingState.error, isNull);
      });

      test('should allow setting progress', () {
        final notifier = container.read(loadingProvider.notifier);

        notifier.setProgress(0.5);

        final loadingState = container.read(loadingProvider);
        expect(loadingState.progress, equals(0.5));
        expect(loadingState.isLoading, isTrue);
      });

      test('should allow setting error', () {
        final notifier = container.read(loadingProvider.notifier);

        notifier.setError('Loading failed');

        final loadingState = container.read(loadingProvider);
        expect(loadingState.error, equals('Loading failed'));
        expect(loadingState.isLoading, isFalse);
      });

      test('should allow resetting state', () {
        final notifier = container.read(loadingProvider.notifier);

        // Change state
        notifier.setProgress(0.8);
        notifier.setError('Test error');

        // Reset
        notifier.reset();

        final loadingState = container.read(loadingProvider);
        expect(loadingState.progress, equals(0.0));
        expect(loadingState.isLoading, isTrue);
        expect(loadingState.error, isNull);
      });
    });

    group('Loading Simulation', () {
      test('should start loading simulation', () {
        final notifier = container.read(loadingProvider.notifier);

        notifier.startLoading();

        final loadingState = container.read(loadingProvider);
        expect(loadingState.isLoading, isTrue);
        expect(loadingState.progress, equals(0.0));
      });
    });

    group('Progress Validation', () {
      test('should set progress correctly', () {
        final notifier = container.read(loadingProvider.notifier);

        // Test valid progress
        notifier.setProgress(0.7);
        final validState = container.read(loadingProvider);
        expect(validState.progress, equals(0.7));
      });
    });

    group('Error Handling', () {
      test('should handle error state correctly', () {
        final notifier = container.read(loadingProvider.notifier);

        notifier.setError('Network timeout');

        final loadingState = container.read(loadingProvider);
        expect(loadingState.error, equals('Network timeout'));
        expect(loadingState.isLoading, isFalse);
        expect(loadingState.progress, equals(0.0));
      });

      test('should clear error when resetting', () {
        final notifier = container.read(loadingProvider.notifier);

        notifier.setError('Test error');
        notifier.reset();

        final loadingState = container.read(loadingProvider);
        expect(loadingState.error, isNull);
        expect(loadingState.isLoading, isTrue);
      });
    });

    group('Loading State Computed Properties', () {
      test('should provide progress percentage', () {
        final notifier = container.read(loadingProvider.notifier);

        notifier.setProgress(0.75);

        final progressPercentage = container.read(
          loadingProvider.select((state) => (state.progress * 100).round()),
        );
        expect(progressPercentage, equals(75));
      });

      test('should provide loading status text', () {
        final notifier = container.read(loadingProvider.notifier);

        notifier.setProgress(0.5);

        final statusText = container.read(
          loadingProvider.select(
            (state) => state.isLoading ? 'Loading...' : 'Complete',
          ),
        );
        expect(statusText, equals('Loading...'));
      });
    });

    group('Loading State Transitions', () {
      test('should transition from loading to complete', () {
        final notifier = container.read(loadingProvider.notifier);

        notifier.setProgress(0.0);
        notifier.setProgress(1.0);

        final loadingState = container.read(loadingProvider);
        expect(loadingState.progress, equals(1.0));
        expect(loadingState.error, isNull);
        // Note: isLoading remains true unless explicitly set to false
        expect(loadingState.isLoading, isTrue);
      });

      test('should transition from loading to error', () {
        final notifier = container.read(loadingProvider.notifier);

        notifier.setProgress(0.5);
        notifier.setError('Loading failed');

        final loadingState = container.read(loadingProvider);
        expect(loadingState.isLoading, isFalse);
        expect(loadingState.error, equals('Loading failed'));
      });
    });

    group('Memory Management', () {
      test('should handle disposal correctly', () {
        final notifier = container.read(loadingProvider.notifier);

        // Set progress
        notifier.setProgress(0.5);

        // Dispose container
        container.dispose();

        // Should not throw when accessing disposed notifier
        expect(() => notifier.setProgress(0.8), returnsNormally);
      });
    });
  });
}
