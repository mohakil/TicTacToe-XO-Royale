import 'package:flutter/material.dart';

/// A reusable currency display component for showing gem balances and other currency values.
///
/// This widget standardizes currency display patterns across all features with
/// consistent styling, animations, and responsive behavior.
///
/// **Usage:**
/// ```dart
/// CurrencyDisplay(
///   amount: 150,
///   icon: Icons.diamond,
///   label: 'Gems',
///   variant: CurrencyVariant.compact,
/// )
/// ```
class CurrencyDisplay extends StatelessWidget {
  /// The currency amount to display.
  final int amount;

  /// Icon to display alongside the amount.
  final IconData? icon;

  /// Label text for the currency type.
  final String? label;

  /// The display variant for different use cases.
  final CurrencyVariant variant;

  /// Custom text style for the amount.
  final TextStyle? amountStyle;

  /// Custom text style for the label.
  final TextStyle? labelStyle;

  /// Custom color for the icon.
  final Color? iconColor;

  /// Custom background color for the display.
  final Color? backgroundColor;

  /// Custom padding for the widget.
  final EdgeInsetsGeometry? padding;

  /// Whether to show an animation when the amount changes.
  final bool animateChanges;

  /// Custom size for the icon.
  final double? iconSize;

  /// Whether to use responsive spacing.
  final bool useResponsiveSpacing;

  /// Callback when the display is tapped.
  final VoidCallback? onTap;

  const CurrencyDisplay({
    super.key,
    required this.amount,
    this.icon,
    this.label,
    this.variant = CurrencyVariant.compact,
    this.amountStyle,
    this.labelStyle,
    this.iconColor,
    this.backgroundColor,
    this.padding,
    this.animateChanges = false,
    this.iconSize,
    this.useResponsiveSpacing = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use responsive padding if enabled
    final effectivePadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);

    // Determine styling based on variant
    final effectiveAmountStyle = amountStyle ?? _getAmountStyle(theme, variant);
    final effectiveLabelStyle = labelStyle ?? _getLabelStyle(theme, variant);
    final effectiveIconSize = iconSize ?? _getIconSize(variant);

    return Material(
      color: backgroundColor ?? _getBackgroundColor(theme, variant),
      borderRadius: BorderRadius.circular(_getBorderRadius(variant)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_getBorderRadius(variant)),
        child: Padding(
          padding: effectivePadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: effectiveIconSize,
                  color: iconColor ?? theme.colorScheme.primary,
                ),
                const SizedBox(width: 8.0),
              ],
              Text(_formatAmount(amount), style: effectiveAmountStyle),
              if (label != null) ...[
                const SizedBox(width: 4.0),
                Text(label!, style: effectiveLabelStyle),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatAmount(int amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toString();
  }

  TextStyle _getAmountStyle(ThemeData theme, CurrencyVariant variant) {
    switch (variant) {
      case CurrencyVariant.compact:
        return theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ) ??
            const TextStyle(fontWeight: FontWeight.w600);
      case CurrencyVariant.prominent:
        return theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ) ??
            const TextStyle(fontWeight: FontWeight.w700);
      case CurrencyVariant.large:
        return theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,
            ) ??
            const TextStyle(fontWeight: FontWeight.w800);
    }
  }

  TextStyle _getLabelStyle(ThemeData theme, CurrencyVariant variant) {
    switch (variant) {
      case CurrencyVariant.compact:
        return theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ) ??
            const TextStyle();
      case CurrencyVariant.prominent:
        return theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ) ??
            const TextStyle();
      case CurrencyVariant.large:
        return theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ) ??
            const TextStyle();
    }
  }

  Color _getBackgroundColor(ThemeData theme, CurrencyVariant variant) {
    switch (variant) {
      case CurrencyVariant.compact:
        return theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
      case CurrencyVariant.prominent:
        return theme.colorScheme.primaryContainer;
      case CurrencyVariant.large:
        return theme.colorScheme.primaryContainer;
    }
  }

  double _getIconSize(CurrencyVariant variant) {
    switch (variant) {
      case CurrencyVariant.compact:
        return 16.0;
      case CurrencyVariant.prominent:
        return 20.0;
      case CurrencyVariant.large:
        return 24.0;
    }
  }

  double _getBorderRadius(CurrencyVariant variant) {
    switch (variant) {
      case CurrencyVariant.compact:
        return 8.0;
      case CurrencyVariant.prominent:
        return 12.0;
      case CurrencyVariant.large:
        return 16.0;
    }
  }
}

/// Variants for currency display styling.
enum CurrencyVariant {
  /// Compact variant for tight spaces and inline use.
  compact,

  /// Prominent variant for headers and featured displays.
  prominent,

  /// Large variant for hero displays and emphasis.
  large,
}
