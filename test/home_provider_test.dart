import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/features/home/providers/home_provider.dart';

void main() {
  group('HomeProvider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('Home State Provider', () {
      test('should provide initial home state', () {
        final homeState = container.read(homeProvider);
        expect(homeState, isA<HomeState>());
        expect(homeState.isLoading, isFalse);
        expect(homeState.lastResult, equals('Win'));
        expect(homeState.streak, equals(3));
        expect(homeState.gemsCount, equals(150));
        expect(homeState.hintCount, equals(5));
      });

      test('should allow updating last result', () {
        final notifier = container.read(homeProvider.notifier);

        notifier.updateLastResult('Loss');

        final homeState = container.read(homeProvider);
        expect(homeState.lastResult, equals('Loss'));
      });

      test('should allow updating streak', () {
        final notifier = container.read(homeProvider.notifier);

        notifier.updateStreak(5);

        final homeState = container.read(homeProvider);
        expect(homeState.streak, equals(5));
      });

      test('should allow updating gems count', () {
        final notifier = container.read(homeProvider.notifier);

        notifier.updateGemsCount(200);

        final homeState = container.read(homeProvider);
        expect(homeState.gemsCount, equals(200));
      });

      test('should allow updating hint count', () {
        final notifier = container.read(homeProvider.notifier);

        notifier.updateHintCount(10);

        final homeState = container.read(homeProvider);
        expect(homeState.hintCount, equals(10));
      });

      test('should allow setting loading state', () {
        final notifier = container.read(homeProvider.notifier);

        notifier.setLoading(true);

        final homeState = container.read(homeProvider);
        expect(homeState.isLoading, isTrue);

        notifier.setLoading(false);

        final updatedState = container.read(homeProvider);
        expect(updatedState.isLoading, isFalse);
      });
    });

    group('Home State Changes', () {
      test('should update multiple properties correctly', () {
        final notifier = container.read(homeProvider.notifier);

        notifier.updateLastResult('Draw');
        notifier.updateStreak(7);
        notifier.updateGemsCount(300);
        notifier.updateHintCount(15);

        final homeState = container.read(homeProvider);
        expect(homeState.lastResult, equals('Draw'));
        expect(homeState.streak, equals(7));
        expect(homeState.gemsCount, equals(300));
        expect(homeState.hintCount, equals(15));
      });

      test('should handle loading state changes', () {
        final notifier = container.read(homeProvider.notifier);

        notifier.setLoading(true);
        expect(container.read(homeProvider).isLoading, isTrue);

        notifier.setLoading(false);
        expect(container.read(homeProvider).isLoading, isFalse);
      });
    });
  });
}
