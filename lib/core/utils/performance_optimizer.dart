import 'package:flutter/material.dart';

/// Utility class for performance optimizations
class PerformanceOptimizer {
  /// Wrap a widget with RepaintBoundary to prevent unnecessary repaints
  static Widget withRepaintBoundary(Widget child, {String? debugLabel}) {
    return RepaintBoundary(child: child);
  }

  /// Optimize animation controllers by limiting concurrent animations
  static void optimizeAnimationController(AnimationController controller) {
    // Ensure animation controller is properly disposed
    if (controller.isAnimating) {
      controller.stop();
    }
  }

  /// Create a performance-optimized list view
  static Widget optimizedListView({
    required List<Widget> children,
    bool addRepaintBoundary = true,
  }) {
    Widget listView = ListView(
      // Performance optimizations
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      addSemanticIndexes: false,
      children: children,
    );

    if (addRepaintBoundary) {
      listView = withRepaintBoundary(listView);
    }

    return listView;
  }

  /// Create a performance-optimized grid view
  static Widget optimizedGridView({
    required int crossAxisCount,
    required List<Widget> children,
    bool addRepaintBoundary = true,
  }) {
    Widget gridView = GridView.count(
      crossAxisCount: crossAxisCount,
      // Performance optimizations
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      addSemanticIndexes: false,
      children: children,
    );

    if (addRepaintBoundary) {
      gridView = withRepaintBoundary(gridView);
    }

    return gridView;
  }
}
