import 'package:flutter/material.dart';

/// A reusable animated category tab component for pill-shaped selectors.
///
/// This widget standardizes animated tab selection across all features with
/// smooth animations, consistent styling, and responsive behavior.
///
/// **Usage:**
/// ```dart
/// CategoryTab(
///   label: 'Beginner',
///   isSelected: selectedCategory == 'beginner',
///   onTap: () => setCategory('beginner'),
///   variant: CategoryTabVariant.filled,
/// )
/// ```
class CategoryTab extends StatelessWidget {
  /// The label text for the tab.
  final String label;

  /// Whether this tab is currently selected.
  final bool isSelected;

  /// Callback when the tab is tapped.
  final VoidCallback? onTap;

  /// The visual variant of the tab.
  final CategoryTabVariant variant;

  /// Custom text style for the label.
  final TextStyle? textStyle;

  /// Custom background color when selected.
  final Color? selectedBackgroundColor;

  /// Custom background color when unselected.
  final Color? unselectedBackgroundColor;

  /// Custom text color when selected.
  final Color? selectedTextColor;

  /// Custom text color when unselected.
  final Color? unselectedTextColor;

  /// Custom padding for the tab.
  final EdgeInsetsGeometry? padding;

  /// Custom border radius for the tab.
  final double? borderRadius;

  /// Animation duration for state changes.
  final Duration animationDuration;

  /// Whether to use responsive spacing.
  final bool useResponsiveSpacing;

  /// Optional icon to display before the label.
  final IconData? icon;

  /// Custom size for the icon.
  final double? iconSize;

  /// Spacing between icon and label.
  final double? iconSpacing;

  const CategoryTab({
    super.key,
    required this.label,
    required this.isSelected,
    this.onTap,
    this.variant = CategoryTabVariant.filled,
    this.textStyle,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.padding,
    this.borderRadius,
    this.animationDuration = const Duration(milliseconds: 200),
    this.useResponsiveSpacing = true,
    this.icon,
    this.iconSize,
    this.iconSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use responsive padding if enabled
    final effectivePadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

    final effectiveBorderRadius = borderRadius ?? 20.0;

    final effectiveIconSize = iconSize ?? 16.0;

    final effectiveIconSpacing = iconSpacing ?? 8.0;

    return AnimatedContainer(
      duration: animationDuration,
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected
            ? selectedBackgroundColor ??
                  _getSelectedBackgroundColor(theme, variant)
            : unselectedBackgroundColor ??
                  _getUnselectedBackgroundColor(theme, variant),
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: _getBorder(theme, variant),
        boxShadow: _getBoxShadow(theme, variant, isSelected),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          child: Padding(
            padding: effectivePadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: effectiveIconSize,
                    color: isSelected
                        ? selectedTextColor ??
                              _getSelectedTextColor(theme, variant)
                        : unselectedTextColor ??
                              _getUnselectedTextColor(theme, variant),
                  ),
                  SizedBox(width: effectiveIconSpacing),
                ],
                Text(
                  label,
                  style:
                      textStyle ??
                      (isSelected
                          ? _getSelectedTextStyle(theme, variant)
                          : _getUnselectedTextStyle(theme, variant)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getSelectedBackgroundColor(
    ThemeData theme,
    CategoryTabVariant variant,
  ) {
    switch (variant) {
      case CategoryTabVariant.filled:
        return theme.colorScheme.primary;
      case CategoryTabVariant.outlined:
        return theme.colorScheme.primaryContainer;
      case CategoryTabVariant.tonal:
        return theme.colorScheme.secondaryContainer;
    }
  }

  Color _getUnselectedBackgroundColor(
    ThemeData theme,
    CategoryTabVariant variant,
  ) {
    switch (variant) {
      case CategoryTabVariant.filled:
        return theme.colorScheme.surfaceContainerHighest;
      case CategoryTabVariant.outlined:
        return Colors.transparent;
      case CategoryTabVariant.tonal:
        return theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
    }
  }

  Color _getSelectedTextColor(ThemeData theme, CategoryTabVariant variant) {
    switch (variant) {
      case CategoryTabVariant.filled:
        return theme.colorScheme.onPrimary;
      case CategoryTabVariant.outlined:
        return theme.colorScheme.primary;
      case CategoryTabVariant.tonal:
        return theme.colorScheme.onSecondaryContainer;
    }
  }

  Color _getUnselectedTextColor(ThemeData theme, CategoryTabVariant variant) {
    switch (variant) {
      case CategoryTabVariant.filled:
        return theme.colorScheme.onSurfaceVariant;
      case CategoryTabVariant.outlined:
        return theme.colorScheme.onSurfaceVariant;
      case CategoryTabVariant.tonal:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  TextStyle _getSelectedTextStyle(ThemeData theme, CategoryTabVariant variant) {
    final baseStyle = theme.textTheme.bodyMedium ?? const TextStyle();
    switch (variant) {
      case CategoryTabVariant.filled:
        return baseStyle.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onPrimary,
        );
      case CategoryTabVariant.outlined:
        return baseStyle.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.primary,
        );
      case CategoryTabVariant.tonal:
        return baseStyle.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSecondaryContainer,
        );
    }
  }

  TextStyle _getUnselectedTextStyle(
    ThemeData theme,
    CategoryTabVariant variant,
  ) {
    final baseStyle = theme.textTheme.bodyMedium ?? const TextStyle();
    switch (variant) {
      case CategoryTabVariant.filled:
        return baseStyle.copyWith(color: theme.colorScheme.onSurfaceVariant);
      case CategoryTabVariant.outlined:
        return baseStyle.copyWith(color: theme.colorScheme.onSurfaceVariant);
      case CategoryTabVariant.tonal:
        return baseStyle.copyWith(color: theme.colorScheme.onSurfaceVariant);
    }
  }

  BoxBorder? _getBorder(ThemeData theme, CategoryTabVariant variant) {
    switch (variant) {
      case CategoryTabVariant.filled:
        return null;
      case CategoryTabVariant.outlined:
        return Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outline,
          width: 1.5,
        );
      case CategoryTabVariant.tonal:
        return null;
    }
  }

  List<BoxShadow>? _getBoxShadow(
    ThemeData theme,
    CategoryTabVariant variant,
    bool isSelected,
  ) {
    if (!isSelected) return null;

    switch (variant) {
      case CategoryTabVariant.filled:
        return [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ];
      case CategoryTabVariant.outlined:
        return [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ];
      case CategoryTabVariant.tonal:
        return [
          BoxShadow(
            color: theme.colorScheme.secondary.withValues(alpha: 0.2),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ];
    }
  }
}

/// Variants for category tab styling.
enum CategoryTabVariant {
  /// Filled variant with solid background color.
  filled,

  /// Outlined variant with border and transparent background.
  outlined,

  /// Tonal variant with subtle background and secondary colors.
  tonal,
}
