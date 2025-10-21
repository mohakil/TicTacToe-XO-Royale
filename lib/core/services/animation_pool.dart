import 'package:flutter/material.dart';

/// Animation controller pooling service for efficient memory management
///
/// This service provides a pool system to reuse AnimationController objects
/// instead of creating new ones each time, which helps prevent memory leaks
/// and improves performance by reducing garbage collection pressure.
///
/// Usage:
/// ```dart
/// // Get a controller from the pool
/// final controller = AnimationPool.getController(
///   vsync: this,
///   poolName: 'game',
///   duration: Duration(milliseconds: 400),
/// );
///
/// // Return the controller to the pool when done
/// AnimationPool.returnController(controller, 'game');
/// ```
class AnimationPool {
  static final Map<String, List<AnimationController>> _pools = {};
  static final Map<String, int> _maxPoolSize = {
    'game': 5, // Game board animations (mark, winning line, hint, ambient)
    'ui': 10, // UI animations (typewriter, progress, cards, etc.)
    'loading': 3, // Loading screen animations (logo, progress)
    'home': 5, // Home screen animations (hero, content, particles)
  };

  /// Get an AnimationController from the specified pool
  ///
  /// If a controller is available in the pool, it will be reused.
  /// Otherwise, a new controller will be created.
  ///
  /// Parameters:
  /// - [vsync]: The TickerProvider for the animation
  /// - [poolName]: The name of the pool to get the controller from
  /// - [duration]: The duration for the animation (can be changed later)
  ///
  /// Returns: An AnimationController ready to use
  static AnimationController getController({
    required TickerProvider vsync,
    required String poolName,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    final pool = _pools[poolName] ??= [];

    if (pool.isNotEmpty) {
      final controller = pool.removeLast();
      // Reset and configure the controller for reuse
      controller.reset();
      controller.duration = duration;
      return controller;
    }

    // Create a new controller if none available in pool
    return AnimationController(duration: duration, vsync: vsync);
  }

  /// Return an AnimationController to the specified pool
  ///
  /// The controller will be reset and added back to the pool for reuse.
  /// If the pool is full or the controller is disposed, it will be disposed.
  ///
  /// Parameters:
  /// - [controller]: The AnimationController to return
  /// - [poolName]: The name of the pool to return the controller to
  static void returnController(
    AnimationController controller,
    String poolName,
  ) {
    final pool = _pools[poolName] ??= [];
    final maxSize = _maxPoolSize[poolName] ?? 5;

    // Only return to pool if pool not full
    if (pool.length < maxSize) {
      try {
        // Stop any ongoing animations before resetting
        if (controller.isAnimating) {
          controller.stop();
        }
        controller.reset();
        pool.add(controller);
      } catch (e) {
        // Controller is disposed, dispose it properly
        try {
          controller.dispose();
        } catch (e) {
          // Already disposed, ignore
        }
      }
    } else {
      // Dispose if pool is full
      try {
        if (controller.isAnimating) {
          controller.stop();
        }
        controller.dispose();
      } catch (e) {
        // Already disposed, ignore
      }
    }
  }

  /// Get the current size of a specific pool
  ///
  /// Parameters:
  /// - [poolName]: The name of the pool to check
  ///
  /// Returns: The number of controllers currently in the pool
  static int getPoolSize(String poolName) {
    return _pools[poolName]?.length ?? 0;
  }

  /// Get the maximum size of a specific pool
  ///
  /// Parameters:
  /// - [poolName]: The name of the pool to check
  ///
  /// Returns: The maximum number of controllers allowed in the pool
  static int getMaxPoolSize(String poolName) {
    return _maxPoolSize[poolName] ?? 5;
  }

  /// Get statistics about all pools
  ///
  /// Returns: A map with pool names as keys and their current sizes as values
  static Map<String, int> getPoolStats() {
    final stats = <String, int>{};
    for (final entry in _pools.entries) {
      stats[entry.key] = entry.value.length;
    }
    return stats;
  }

  /// Clear a specific pool, disposing all controllers
  ///
  /// Parameters:
  /// - [poolName]: The name of the pool to clear
  static void clearPool(String poolName) {
    final pool = _pools[poolName];
    if (pool != null) {
      for (final controller in pool) {
        try {
          controller.dispose();
        } catch (e) {
          // Controller already disposed, ignore
        }
      }
      pool.clear();
    }
  }

  /// Dispose all controllers in all pools
  ///
  /// This should be called when the app is shutting down to ensure
  /// proper cleanup of all pooled controllers.
  static void disposeAll() {
    for (final pool in _pools.values) {
      for (final controller in pool) {
        try {
          controller.dispose();
        } catch (e) {
          // Controller already disposed, ignore
        }
      }
      pool.clear();
    }
    _pools.clear();
  }

  /// Force reset a specific pool by clearing all controllers
  ///
  /// This is useful for handling rapid navigation scenarios where
  /// controllers might be in an inconsistent state.
  ///
  /// Parameters:
  /// - [poolName]: The name of the pool to force reset
  static void forceResetPool(String poolName) {
    final pool = _pools[poolName];
    if (pool != null) {
      for (final controller in pool) {
        try {
          if (controller.isAnimating) {
            controller.stop();
          }
          controller.dispose();
        } catch (e) {
          // Controller already disposed, ignore
        }
      }
      pool.clear();
    }
  }

  /// Get a fresh controller from the pool, ensuring it's properly reset
  ///
  /// This method is more aggressive about ensuring a clean controller state,
  /// useful for handling rapid navigation scenarios.
  ///
  /// Parameters:
  /// - [vsync]: The TickerProvider for the animation
  /// - [poolName]: The name of the pool to get the controller from
  /// - [duration]: The duration for the animation (can be changed later)
  ///
  /// Returns: A fresh AnimationController ready to use
  static AnimationController getFreshController({
    required TickerProvider vsync,
    required String poolName,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    // Force reset the pool to ensure clean state
    forceResetPool(poolName);

    // Get a new controller
    return getController(vsync: vsync, poolName: poolName, duration: duration);
  }

  /// Set the maximum pool size for a specific pool
  ///
  /// Parameters:
  /// - [poolName]: The name of the pool to configure
  /// - [maxSize]: The maximum number of controllers allowed in the pool
  static void setMaxPoolSize(String poolName, int maxSize) {
    _maxPoolSize[poolName] = maxSize;

    // Trim the pool if it exceeds the new maximum
    final pool = _pools[poolName];
    if (pool != null && pool.length > maxSize) {
      final excess = pool.length - maxSize;
      for (int i = 0; i < excess; i++) {
        final controller = pool.removeLast();
        try {
          controller.dispose();
        } catch (e) {
          // Controller already disposed, ignore
        }
      }
    }
  }

  /// Get debug information about the animation pool
  ///
  /// Returns: A formatted string with pool statistics
  static String getDebugInfo() {
    final buffer = StringBuffer();
    buffer.writeln('Animation Pool Debug Info:');
    buffer.writeln('========================');

    for (final entry in _pools.entries) {
      final poolName = entry.key;
      final currentSize = entry.value.length;
      final maxSize = _maxPoolSize[poolName] ?? 5;
      buffer.writeln('$poolName: $currentSize/$maxSize controllers');
    }

    if (_pools.isEmpty) {
      buffer.writeln('No pools currently active');
    }

    return buffer.toString();
  }
}
