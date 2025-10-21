import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';

/// A reusable icon + text combination widget for consistent layouts.
///
/// Consolidates the common pattern of icon + text + spacing used throughout
/// the TicTacToe XO Royale application with responsive sizing and theme integration.
///
/// **Usage:**
/// ```dart
/// IconText(
///   icon: Icons.analytics,
///   text: 'Analytics',
///   iconColor: colorScheme.primary,
///   textStyle: Theme.of(context).textTheme.titleMedium,
/// )
/// ```
class IconText extends StatelessWidget {
  /// The icon to display.
  final IconData icon;

  /// The text to display next to the icon.
  final String text;

  /// Optional custom color for the icon.
  final Color? iconColor;

  /// Optional custom text style.
  final TextStyle? textStyle;

  /// The direction of the layout (horizontal or vertical).
  final Axis direction;

  /// The size preset for the icon.
  final IconTextSize size;

  /// Custom size for the icon.
  final double? iconSize;

  /// Spacing between icon and text.
  final double? spacing;

  /// Alignment of the icon and text.
  final CrossAxisAlignment? crossAxisAlignment;

  /// Main axis alignment.
  final MainAxisAlignment? mainAxisAlignment;

  /// Whether to use responsive sizing.
  final bool useResponsiveSizing;

  /// Whether to use RepaintBoundary for performance optimization.
  final bool useRepaintBoundary;

  const IconText({
    required this.icon,
    required this.text,
    this.iconColor,
    this.textStyle,
    this.direction = Axis.horizontal,
    this.size = IconTextSize.medium,
    this.iconSize,
    this.spacing,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.useResponsiveSizing = true,
    this.useRepaintBoundary = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Build the content
    final content = direction == Axis.horizontal
        ? Row(
            crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
            mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: _getIconSize(context),
                color: iconColor ?? colorScheme.onSurface,
              ),
              SizedBox(width: _getSpacing(context)),
              Flexible(
                child: Text(
                  text,
                  style:
                      textStyle ??
                      theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
            mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: _getIconSize(context),
                color: iconColor ?? colorScheme.onSurface,
              ),
              SizedBox(height: _getSpacing(context)),
              Flexible(
                child: Text(
                  text,
                  style:
                      textStyle ??
                      theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: direction == Axis.vertical ? 2 : 1,
                ),
              ),
            ],
          );

    // Apply RepaintBoundary if requested
    if (useRepaintBoundary) {
      return RepaintBoundary(child: content);
    }

    return content;
  }

  double _getIconSize(BuildContext context) {
    if (iconSize != null) return iconSize!;

    if (!useResponsiveSizing) {
      switch (size) {
        case IconTextSize.small:
          return context.scale(20.0);
        case IconTextSize.medium:
          return context.scale(24.0);
        case IconTextSize.large:
          return context.scale(32.0);
      }
    }

    return context.getResponsiveIconSize(
      phoneSize: _getBaseIconSize(),
      tabletSize: _getBaseIconSize() * 1.2,
    );
  }

  double _getBaseIconSize() {
    switch (size) {
      case IconTextSize.small:
        return 20.0;
      case IconTextSize.medium:
        return 24.0;
      case IconTextSize.large:
        return 32.0;
    }
  }

  double _getSpacing(BuildContext context) {
    if (spacing != null) return spacing!;

    return context.getResponsiveSpacing(
      phoneSpacing: direction == Axis.horizontal ? 8.0 : 6.0,
      tabletSpacing: direction == Axis.horizontal ? 10.0 : 8.0,
    );
  }
}

/// Size presets for icon text combinations.
enum IconTextSize {
  /// Small icon size.
  small,

  /// Medium icon size (default).
  medium,

  /// Large icon size.
  large,
}
