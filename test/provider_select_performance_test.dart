import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/features/home/providers/home_provider.dart';
import 'package:tictactoe_xo_royale/core/providers/settings_provider.dart';

/// Test widget that uses provider select for granular rebuilds
class OptimizedHomeWidget extends ConsumerWidget {
  const OptimizedHomeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Use select for granular rebuilds
        Text(
          'Last Result: ${ref.watch(homeProvider.select((state) => state.lastResult))}',
        ),
        Text(
          'Streak: ${ref.watch(homeProvider.select((state) => state.streak))}',
        ),
        Text(
          'Gems: ${ref.watch(homeProvider.select((state) => state.gemsCount))}',
        ),
        Text(
          'Hints: ${ref.watch(homeProvider.select((state) => state.hintCount))}',
        ),
      ],
    );
  }
}

/// Test widget that uses the old approach (watching entire state)
class UnoptimizedHomeWidget extends ConsumerWidget {
  const UnoptimizedHomeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    return Column(
      children: [
        Text('Last Result: ${homeState.lastResult}'),
        Text('Streak: ${homeState.streak}'),
        Text('Gems: ${homeState.gemsCount}'),
        Text('Hints: ${homeState.hintCount}'),
      ],
    );
  }
}

/// Test widget that uses provider select for settings
class OptimizedSettingsWidget extends ConsumerWidget {
  const OptimizedSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Text(
          'Sound: ${ref.watch(settingsProvider.select((state) => state.soundEnabled))}',
        ),
        Text(
          'Music: ${ref.watch(settingsProvider.select((state) => state.musicEnabled))}',
        ),
        Text(
          'Vibration: ${ref.watch(settingsProvider.select((state) => state.vibrationEnabled))}',
        ),
      ],
    );
  }
}

/// Test widget that uses the old approach for settings
class UnoptimizedSettingsWidget extends ConsumerWidget {
  const UnoptimizedSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return Column(
      children: [
        Text('Sound: ${settings.soundEnabled}'),
        Text('Music: ${settings.musicEnabled}'),
        Text('Vibration: ${settings.vibrationEnabled}'),
      ],
    );
  }
}

void main() {
  group('Provider Select Performance Tests', () {
    testWidgets('Home provider select maintains correct values', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: Scaffold(body: const OptimizedHomeWidget())),
        ),
      );

      await tester.pump();

      // Verify that the values are displayed correctly
      expect(find.text('Last Result: Win'), findsOneWidget);
      expect(find.text('Streak: 3'), findsOneWidget);
      expect(find.text('Gems: 150'), findsOneWidget);
      expect(find.text('Hints: 5'), findsOneWidget);

      // Update values and verify they change
      final container = ProviderScope.containerOf(
        tester.element(find.byType(OptimizedHomeWidget)),
      );
      container.read(homeProvider.notifier).updateLastResult('Loss');
      container.read(homeProvider.notifier).updateStreak(5);
      container.read(homeProvider.notifier).updateGemsCount(200);

      await tester.pump();

      expect(find.text('Last Result: Loss'), findsOneWidget);
      expect(find.text('Streak: 5'), findsOneWidget);
      expect(find.text('Gems: 200'), findsOneWidget);
      expect(find.text('Hints: 5'), findsOneWidget);
    });

    testWidgets('Settings provider select maintains correct values', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: const OptimizedSettingsWidget()),
          ),
        ),
      );

      await tester.pump();

      // Verify that the values are displayed correctly
      expect(find.text('Sound: true'), findsOneWidget);
      expect(find.text('Music: true'), findsOneWidget);
      expect(find.text('Vibration: true'), findsOneWidget);

      // Update values and verify they change
      final container = ProviderScope.containerOf(
        tester.element(find.byType(OptimizedSettingsWidget)),
      );
      await container
          .read(settingsProvider.notifier)
          .setSoundEnabled(enabled: false);
      await container
          .read(settingsProvider.notifier)
          .setMusicEnabled(enabled: false);

      await tester.pump();

      expect(find.text('Sound: false'), findsOneWidget);
      expect(find.text('Music: false'), findsOneWidget);
      expect(find.text('Vibration: true'), findsOneWidget);
    });

    testWidgets('Extension methods work correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  // Test extension methods
                  final homeState = ref.homeState;
                  final lastResult = homeState.lastResult;
                  final streak = homeState.streak;
                  final gemsCount = homeState.gemsCount;
                  final hintCount = homeState.hintCount;

                  return Column(
                    children: [
                      Text('Extension - Last Result: $lastResult'),
                      Text('Extension - Streak: $streak'),
                      Text('Extension - Gems: $gemsCount'),
                      Text('Extension - Hints: $hintCount'),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // Verify that extension methods work correctly
      expect(find.text('Extension - Last Result: Win'), findsOneWidget);
      expect(find.text('Extension - Streak: 3'), findsOneWidget);
      expect(find.text('Extension - Gems: 150'), findsOneWidget);
      expect(find.text('Extension - Hints: 5'), findsOneWidget);
    });

    testWidgets('Computed providers work correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final homeState = ref.homeState;
                  final homeStats = (
                    lastResult: homeState.lastResult,
                    streak: homeState.streak,
                    gemsCount: homeState.gemsCount,
                    hintCount: homeState.hintCount,
                  );
                  return Column(
                    children: [
                      Text('Stats - Last Result: ${homeStats.lastResult}'),
                      Text('Stats - Streak: ${homeStats.streak}'),
                      Text('Stats - Gems: ${homeStats.gemsCount}'),
                      Text('Stats - Hints: ${homeStats.hintCount}'),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // Verify that computed providers work correctly
      expect(find.text('Stats - Last Result: Win'), findsOneWidget);
      expect(find.text('Stats - Streak: 3'), findsOneWidget);
      expect(find.text('Stats - Gems: 150'), findsOneWidget);
      expect(find.text('Stats - Hints: 5'), findsOneWidget);
    });
  });
}
