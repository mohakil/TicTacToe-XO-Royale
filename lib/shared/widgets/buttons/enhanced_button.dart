import 'package:flutter/material.dart';

/// A reusable button component that standardizes button styling and behavior.
///
/// Provides consistent button styling across all features with multiple variants,
/// responsive sizing, loading states, and accessibility support.
///
/// **Usage:**
/// ```dart
/// EnhancedButton(
///   text: 'Click me',
///   variant: ButtonVariant.primary,
///   onPressed: () => print('Button pressed'),
/// )
/// ```
class EnhancedButton extends StatelessWidget {
  /// The text to display on the button.
  final String text;

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// The variant of button styling to use.
  final ButtonVariant variant;

  /// The size preset for the button.
  final ButtonSize size;

  /// Optional icon to display before the text.
  final IconData? icon;

  /// Whether the button is in a loading state.
  final bool isLoading;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// Custom tooltip for the button.
  final String? tooltip;

  /// Whether to use haptic feedback when pressed.
  final bool enableHapticFeedback;

  /// Custom background color for the button.
  final Color? backgroundColor;

  /// Custom foreground color for the button.
  final Color? foregroundColor;

  /// Custom padding for the button.
  final EdgeInsetsGeometry? padding;

  /// Custom margin for the button.
  final EdgeInsetsGeometry? margin;

  /// Whether to use RepaintBoundary for performance optimization.
  final bool useRepaintBoundary;

  const EnhancedButton({
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.tooltip,
    this.enableHapticFeedback = true,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.margin,
    this.useRepaintBoundary = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine final state
    final isEnabled = !isDisabled && !isLoading && onPressed != null;
    final buttonChild = _buildButtonChild(context, theme, colorScheme);

    // Apply RepaintBoundary if requested
    final buttonWidget = _buildButtonWidget(
      context,
      theme,
      colorScheme,
      buttonChild,
      isEnabled,
    );

    if (useRepaintBoundary) {
      return RepaintBoundary(child: buttonWidget);
    }

    return buttonWidget;
  }

  Widget _buildButtonChild(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final buttonText = Text(
      text,
      style: _getTextStyle(theme, colorScheme),
      textAlign: TextAlign.center,
    );

    // Show loading indicator if loading
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: _getIconSize(),
            height: _getIconSize(),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getForegroundColor(theme, colorScheme),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          buttonText,
        ],
      );
    }

    // Show icon + text if icon is provided
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: _getIconSize(),
            color: _getForegroundColor(theme, colorScheme),
          ),
          const SizedBox(width: 8.0),
          buttonText,
        ],
      );
    }

    // Just text
    return buttonText;
  }

  Widget _buildButtonWidget(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    Widget buttonChild,
    bool isEnabled,
  ) {
    final buttonStyle = _getButtonStyle(theme, colorScheme);
    final buttonMargin = margin ?? _getDefaultMargin();

    Widget button;

    switch (variant) {
      case ButtonVariant.primary:
        button = ElevatedButton(
          onPressed: isEnabled ? () => _handlePress() : null,
          style: buttonStyle,
          child: buttonChild,
        );
        break;

      case ButtonVariant.secondary:
        button = FilledButton(
          onPressed: isEnabled ? () => _handlePress() : null,
          style: buttonStyle,
          child: buttonChild,
        );
        break;

      case ButtonVariant.outline:
        button = OutlinedButton(
          onPressed: isEnabled ? () => _handlePress() : null,
          style: buttonStyle,
          child: buttonChild,
        );
        break;

      case ButtonVariant.ghost:
        button = TextButton(
          onPressed: isEnabled ? () => _handlePress() : null,
          style: buttonStyle,
          child: buttonChild,
        );
        break;
    }

    return Container(
      margin: buttonMargin,
      child: tooltip != null && tooltip!.isNotEmpty
          ? Tooltip(message: tooltip, child: button)
          : button,
    );
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

  ButtonStyle _getButtonStyle(ThemeData theme, ColorScheme colorScheme) {
    final baseStyle = _getBaseButtonStyle(theme, colorScheme);

    return baseStyle.copyWith(
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (!states.contains(WidgetState.disabled)) {
          return _getBackgroundColor(theme, colorScheme);
        }
        return null; // Use default disabled color
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (!states.contains(WidgetState.disabled)) {
          return _getForegroundColor(theme, colorScheme);
        }
        return null; // Use default disabled color
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          final color = _getForegroundColor(theme, colorScheme);
          return color.withValues(alpha: 0.1);
        }
        return null;
      }),
    );
  }

  ButtonStyle _getBaseButtonStyle(ThemeData theme, ColorScheme colorScheme) {
    return ElevatedButton.styleFrom(
      elevation: _getElevation(),
      padding: _getDefaultPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_getBorderRadius()),
      ),
      minimumSize: Size(_getMinWidth(), _getMinHeight()),
    );
  }

  TextStyle _getTextStyle(ThemeData theme, ColorScheme colorScheme) {
    return theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: _getForegroundColor(theme, colorScheme),
        ) ??
        const TextStyle(fontWeight: FontWeight.w500);
  }

  Color _getBackgroundColor(ThemeData theme, ColorScheme colorScheme) {
    if (backgroundColor != null) return backgroundColor!;

    switch (variant) {
      case ButtonVariant.primary:
        return colorScheme.primary;
      case ButtonVariant.secondary:
        return colorScheme.secondaryContainer;
      case ButtonVariant.outline:
      case ButtonVariant.ghost:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor(ThemeData theme, ColorScheme colorScheme) {
    if (foregroundColor != null) return foregroundColor!;

    switch (variant) {
      case ButtonVariant.primary:
        return colorScheme.onPrimary;
      case ButtonVariant.secondary:
        return colorScheme.onSecondaryContainer;
      case ButtonVariant.outline:
        return colorScheme.primary;
      case ButtonVariant.ghost:
        return colorScheme.onSurfaceVariant;
    }
  }

  double _getElevation() {
    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
        return 0;
      case ButtonVariant.outline:
      case ButtonVariant.ghost:
        return 0;
    }
  }

  double _getBorderRadius() {
    return 8.0;
  }

  double _getMinWidth() {
    switch (size) {
      case ButtonSize.small:
        return 80.0;
      case ButtonSize.medium:
        return 120.0;
      case ButtonSize.large:
        return 160.0;
    }
  }

  double _getMinHeight() {
    switch (size) {
      case ButtonSize.small:
        return 36.0;
      case ButtonSize.medium:
        return 44.0;
      case ButtonSize.large:
        return 52.0;
    }
  }

  EdgeInsetsGeometry _getDefaultPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0);
    }
  }

  EdgeInsetsGeometry _getDefaultMargin() {
    return EdgeInsets
        .zero; // No default margin, use explicit margin prop if needed
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16.0;
      case ButtonSize.medium:
        return 18.0;
      case ButtonSize.large:
        return 20.0;
    }
  }
}

/// Variants for button styling.
enum ButtonVariant {
  /// Primary button with filled background.
  primary,

  /// Secondary button with alternative styling.
  secondary,

  /// Outlined button with border only.
  outline,

  /// Ghost button with minimal styling.
  ghost,
}

/// Size presets for buttons.
enum ButtonSize {
  /// Small button size.
  small,

  /// Medium button size (default).
  medium,

  /// Large button size.
  large,
}
