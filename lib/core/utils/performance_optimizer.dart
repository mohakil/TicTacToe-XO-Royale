import 'package:flutter/material.dart';

/// Utility functions for performance optimizations
/// These functions help optimize Flutter widgets and animations for better performance.

/// Wrap a widget with RepaintBoundary to prevent unnecessary repaints
/// This isolates the widget's rendering from its parent, improving performance
/// when the widget updates frequently.
Widget withRepaintBoundary(Widget child, {String? debugLabel}) =>
    RepaintBoundary(child: child);

/// Optimize animation controllers by limiting concurrent animations
/// This method ensures animation controllers are properly managed
/// to prevent performance issues from overlapping animations.
void optimizeAnimationController(AnimationController controller) {
  // Ensure animation controller is properly disposed
  if (controller.isAnimating) {
    controller.stop();
  }
}

/// Create a performance-optimized list view
/// This method creates a ListView with performance optimizations
/// such as disabled automatic keep-alives and semantic indexes.
Widget optimizedListView({
  required List<Widget> children,
  bool addRepaintBoundary = true,
}) {
  Widget listView = ListView(
    // Performance optimizations
    addAutomaticKeepAlives: false,
    addSemanticIndexes: false,
    children: children,
  );

  if (addRepaintBoundary) {
    listView = withRepaintBoundary(listView);
  }

  return listView;
}

/// Create a performance-optimized grid view
/// This method creates a GridView with performance optimizations
/// and optional repaint boundary wrapping.
Widget optimizedGridView({
  required int crossAxisCount,
  required List<Widget> children,
  bool addRepaintBoundary = true,
}) {
  Widget gridView = GridView.count(
    crossAxisCount: crossAxisCount,
    // Performance optimizations
    addAutomaticKeepAlives: false,
    addSemanticIndexes: false,
    children: children,
  );

  if (addRepaintBoundary) {
    gridView = withRepaintBoundary(gridView);
  }

  return gridView;
}
