import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/core/services/animation_pool.dart';

void main() {
  group('AnimationPool', () {
    setUp(() {
      // Clear all pools before each test
      AnimationPool.disposeAll();
    });

    tearDown(() {
      // Clean up after each test
      AnimationPool.disposeAll();
    });

    test('should have correct default pool sizes', () {
      expect(AnimationPool.getMaxPoolSize('game'), 5);
      expect(AnimationPool.getMaxPoolSize('ui'), 10);
      expect(AnimationPool.getMaxPoolSize('loading'), 3);
      expect(AnimationPool.getMaxPoolSize('home'), 5);
      expect(AnimationPool.getMaxPoolSize('unknown'), 5); // default
    });

    test('should start with empty pools', () {
      expect(AnimationPool.getPoolSize('game'), 0);
      expect(AnimationPool.getPoolSize('ui'), 0);
      expect(AnimationPool.getPoolSize('loading'), 0);
      expect(AnimationPool.getPoolSize('home'), 0);
    });

    test('should handle different pool names independently', () {
      // Test that pools are independent
      AnimationPool.setMaxPoolSize('pool1', 2);
      AnimationPool.setMaxPoolSize('pool2', 3);

      expect(AnimationPool.getMaxPoolSize('pool1'), 2);
      expect(AnimationPool.getMaxPoolSize('pool2'), 3);
      expect(AnimationPool.getMaxPoolSize('pool3'), 5); // default
    });

    test('should provide correct pool statistics', () {
      // Initially all pools should be empty
      final stats = AnimationPool.getPoolStats();
      expect(stats.isEmpty, isTrue);

      // After setting max sizes, stats should still be empty
      AnimationPool.setMaxPoolSize('test1', 2);
      AnimationPool.setMaxPoolSize('test2', 3);

      final statsAfter = AnimationPool.getPoolStats();
      expect(statsAfter.isEmpty, isTrue);
    });

    test('should clear specific pool', () {
      // Set up a pool
      AnimationPool.setMaxPoolSize('test', 5);
      expect(AnimationPool.getMaxPoolSize('test'), 5);

      // Clear the pool
      AnimationPool.clearPool('test');
      expect(AnimationPool.getPoolSize('test'), 0);
    });

    test('should dispose all pools', () {
      // Set up multiple pools
      AnimationPool.setMaxPoolSize('pool1', 2);
      AnimationPool.setMaxPoolSize('pool2', 3);

      expect(AnimationPool.getMaxPoolSize('pool1'), 2);
      expect(AnimationPool.getMaxPoolSize('pool2'), 3);

      // Dispose all
      AnimationPool.disposeAll();

      // All pools should be cleared
      expect(AnimationPool.getPoolSize('pool1'), 0);
      expect(AnimationPool.getPoolSize('pool2'), 0);
    });

    test('should provide debug information', () {
      // Initially no pools should be active
      final debugInfo = AnimationPool.getDebugInfo();

      expect(debugInfo, contains('Animation Pool Debug Info:'));
      expect(debugInfo, contains('No pools currently active'));
    });

    test('should handle pool size changes', () {
      // Set initial size
      AnimationPool.setMaxPoolSize('test', 5);
      expect(AnimationPool.getMaxPoolSize('test'), 5);

      // Change size
      AnimationPool.setMaxPoolSize('test', 10);
      expect(AnimationPool.getMaxPoolSize('test'), 10);

      // Reset to default
      AnimationPool.setMaxPoolSize('test', 5);
      expect(AnimationPool.getMaxPoolSize('test'), 5);
    });

    testWidgets('should work with widget lifecycle', (tester) async {
      final widget = MaterialApp(home: Scaffold(body: _TestWidget()));

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Widget should be created successfully
      expect(find.byType(_TestWidget), findsOneWidget);

      // Pool should be empty initially
      expect(AnimationPool.getPoolSize('test'), 0);
    });
  });
}

/// Test widget that uses AnimationPool
class _TestWidget extends StatefulWidget {
  @override
  State<_TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<_TestWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationPool.getController(
      vsync: this,
      poolName: 'test',
      duration: const Duration(milliseconds: 100),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    AnimationPool.returnController(_controller, 'test');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 100 * _animation.value,
          height: 100,
          color: Colors.blue,
        );
      },
    );
  }
}
