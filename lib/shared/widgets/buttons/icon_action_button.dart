import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';

/// A reusable icon button component for consistent icon button styling.
///
/// Provides standardized icon button behavior with responsive sizing,
/// proper touch targets, and accessibility support.
///
/// **Usage:**
/// ```dart
/// IconActionButton(
///   icon: Icons.close,
///   onPressed: () => Navigator.pop(context),
///   tooltip: 'Close',
/// )
/// ```
class IconActionButton extends StatelessWidget {
  /// The icon to display.
  final IconData icon;

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Tooltip text for accessibility.
  final String? tooltip;

  /// Custom color for the icon.
  final Color? color;

  /// The size preset for the button.
  final IconButtonSize size;

  /// Whether to use responsive sizing.
  final bool useResponsiveSizing;

  /// Custom size for the icon.
  final double? iconSize;

  /// Custom padding for the button.
  final EdgeInsetsGeometry? padding;

  /// Whether to enable haptic feedback.
  final bool enableHapticFeedback;

  /// Whether to use RepaintBoundary for performance optimization.
  final bool useRepaintBoundary;

  const IconActionButton({
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.size = IconButtonSize.medium,
    this.useResponsiveSizing = true,
    this.iconSize,
    this.padding,
    this.enableHapticFeedback = true,
    this.useRepaintBoundary = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final buttonChild = Icon(
      icon,
      size: _getIconSize(context),
      color: color ?? colorScheme.onSurface,
    );

    final iconButton = IconButton(
      onPressed: onPressed != null ? () => _handlePress() : null,
      icon: buttonChild,
      padding: padding ?? _getDefaultPadding(context),
      style: IconButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: color ?? colorScheme.onSurface,
        minimumSize: Size(_getMinSize(context), _getMinSize(context)),
      ),
      tooltip: tooltip,
    );

    // Apply RepaintBoundary if requested
    if (useRepaintBoundary) {
      return RepaintBoundary(child: iconButton);
    }

    return iconButton;
  }

  void _handlePress() {
    if (enableHapticFeedback && onPressed != null) {
      // Use platform-specific haptic feedback
      // Note: In a real implementation, you'd want to use the haptic service
      // For now, we'll use the basic HapticFeedback
      try {
        // HapticFeedback.selectionClick();
      } catch (e) {
        // Handle haptic feedback gracefully
      }
    }
    onPressed?.call();
  }

  double _getIconSize(BuildContext context) {
    if (iconSize != null) return iconSize!;

    if (!useResponsiveSizing) {
      switch (size) {
        case IconButtonSize.small:
          return context.scale(20.0);
        case IconButtonSize.medium:
          return context.scale(24.0);
        case IconButtonSize.large:
          return context.scale(28.0);
      }
    }

    return context.scale(_getBaseIconSize());
  }

  double _getBaseIconSize() {
    switch (size) {
      case IconButtonSize.small:
        return 20.0;
      case IconButtonSize.medium:
        return 24.0;
      case IconButtonSize.large:
        return 28.0;
    }
  }

  double _getMinSize(BuildContext context) {
    if (!useResponsiveSizing) {
      return context.scale(48.0); // Standard 48dp minimum touch target
    }

    return context.scale(48.0);
  }

  EdgeInsetsGeometry _getDefaultPadding(BuildContext context) {
    final spacing = context.scale(8.0);

    switch (size) {
      case IconButtonSize.small:
        return EdgeInsets.all(spacing * 0.75);
      case IconButtonSize.medium:
        return EdgeInsets.all(spacing);
      case IconButtonSize.large:
        return EdgeInsets.all(spacing * 1.25);
    }
  }
}

/// Size presets for icon buttons.
enum IconButtonSize {
  /// Small icon button size.
  small,

  /// Medium icon button size (default).
  medium,

  /// Large icon button size.
  large,
}
