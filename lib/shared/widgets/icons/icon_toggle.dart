import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';

/// A toggleable icon widget for switching between two states.
///
/// Perfect for theme toggles, boolean settings, and state switches with smooth
/// animations and responsive sizing.
///
/// **Usage:**
/// ```dart
/// IconToggle(
///   icon: Icons.light_mode,
///   selectedIcon: Icons.dark_mode,
///   isSelected: isDarkMode,
///   onToggle: (selected) => toggleTheme(),
///   tooltip: 'Toggle theme',
/// )
/// ```
class IconToggle extends StatefulWidget {
  /// The icon to display when not selected.
  final IconData icon;

  /// The icon to display when selected.
  final IconData selectedIcon;

  /// The current selection state.
  final bool isSelected;

  /// Callback when the toggle state changes.
  final ValueChanged<bool>? onToggle;

  /// Tooltip text for accessibility.
  final String? tooltip;

  /// Color for the icon when not selected.
  final Color? color;

  /// Color for the icon when selected.
  final Color? selectedColor;

  /// Size preset for the icon.
  final IconToggleSize size;

  /// Custom size for the icon.
  final double? iconSize;

  /// Animation duration for state transitions.
  final Duration? animationDuration;

  /// Animation curve for state transitions.
  final Curve? animationCurve;

  /// Whether to enable haptic feedback on toggle.
  final bool enableHapticFeedback;

  /// Whether to use responsive sizing.
  final bool useResponsiveSizing;

  /// Whether to use RepaintBoundary for performance optimization.
  final bool useRepaintBoundary;

  const IconToggle({
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    this.onToggle,
    this.tooltip,
    this.color,
    this.selectedColor,
    this.size = IconToggleSize.medium,
    this.iconSize,
    this.animationDuration,
    this.animationCurve,
    this.enableHapticFeedback = true,
    this.useResponsiveSizing = true,
    this.useRepaintBoundary = false,
    super.key,
  });

  @override
  State<IconToggle> createState() => _IconToggleState();
}

class _IconToggleState extends State<IconToggle> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  @override
  void didUpdateWidget(IconToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      _animationController.animateTo(
        widget.isSelected ? 1.0 : 0.0,
        duration: widget.animationDuration ?? const Duration(milliseconds: 200),
        curve: widget.animationCurve ?? Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration ?? const Duration(milliseconds: 200),
      value: widget.isSelected ? 1.0 : 0.0,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve ?? Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final content = AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return IconButton(
          onPressed: widget.onToggle != null ? _handleToggle : null,
          icon: Icon(
            _animation.value < 0.5 ? widget.icon : widget.selectedIcon,
            size: _getIconSize(context),
            color: Color.lerp(
              widget.color ?? colorScheme.onSurface,
              widget.selectedColor ?? colorScheme.primary,
              _animation.value,
            ),
          ),
          tooltip: widget.tooltip,
          padding: _getPadding(context),
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Color.lerp(
              widget.color ?? colorScheme.onSurface,
              widget.selectedColor ?? colorScheme.primary,
              _animation.value,
            ),
            minimumSize: Size(_getMinSize(context), _getMinSize(context)),
          ),
        );
      },
    );

    // Apply RepaintBoundary if requested
    if (widget.useRepaintBoundary) {
      return RepaintBoundary(child: content);
    }

    return content;
  }

  void _handleToggle() {
    if (widget.enableHapticFeedback) {
      // Use platform-specific haptic feedback
      try {
        // HapticFeedback.selectionClick();
      } catch (e) {
        // Handle haptic feedback gracefully
      }
    }
    widget.onToggle?.call(!widget.isSelected);
  }

  double _getIconSize(BuildContext context) {
    if (widget.iconSize != null) return widget.iconSize!;

    if (!widget.useResponsiveSizing) {
      switch (widget.size) {
        case IconToggleSize.small:
          return context.scale(20.0);
        case IconToggleSize.medium:
          return context.scale(24.0);
        case IconToggleSize.large:
          return context.scale(28.0);
      }
    }

    return context.getResponsiveIconSize(
      phoneSize: _getBaseIconSize(),
      tabletSize: _getBaseIconSize() * 1.1,
    );
  }

  double _getBaseIconSize() {
    switch (widget.size) {
      case IconToggleSize.small:
        return 20.0;
      case IconToggleSize.medium:
        return 24.0;
      case IconToggleSize.large:
        return 28.0;
    }
  }

  double _getMinSize(BuildContext context) {
    if (!widget.useResponsiveSizing) {
      return context.scale(48.0); // Standard 48dp minimum touch target
    }
    return context.scale(48.0);
  }

  EdgeInsetsGeometry _getPadding(BuildContext context) {
    final spacing = context.scale(8.0);

    switch (widget.size) {
      case IconToggleSize.small:
        return EdgeInsets.all(spacing * 0.75);
      case IconToggleSize.medium:
        return EdgeInsets.all(spacing);
      case IconToggleSize.large:
        return EdgeInsets.all(spacing * 1.25);
    }
  }
}

/// Size presets for icon toggles.
enum IconToggleSize {
  /// Small icon size.
  small,

  /// Medium icon size (default).
  medium,

  /// Large icon size.
  large,
}
