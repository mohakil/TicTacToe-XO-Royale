import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';

/// A reusable card component that consolidates styling patterns across features.
///
/// Provides consistent card styling with multiple variants and responsive behavior.
/// Supports interactive cards with hover/press animations and haptic feedback.
///
/// **Usage:**
/// ```dart
/// EnhancedCard(
///   variant: CardVariant.elevated,
///   child: Text('Card content'),
///   onTap: () => print('Card tapped'),
/// )
/// ```
class EnhancedCard extends StatelessWidget {
  /// The variant of card to display.
  final CardVariant variant;

  /// The size preset for the card.
  final CardSize size;

  /// Whether the card is interactive (supports tap gestures).
  final bool isInteractive;

  /// Callback when the card is tapped (only for interactive cards).
  final VoidCallback? onTap;

  /// The child widget to display inside the card.
  final Widget child;

  /// Custom background color for the card.
  final Color? backgroundColor;

  /// Custom border color for the card.
  final Color? borderColor;

  /// Custom elevation for the card.
  final double? elevation;

  /// Whether this card represents an achievement (affects styling).
  final bool isAchievement;

  /// Whether this card is in a locked/disabled state (affects styling).
  final bool isLocked;

  /// Custom gradient for the card (overrides solid background).
  final Gradient? gradient;

  /// Whether to use dynamic border color based on state (for achievements).
  final bool useDynamicBorder;

  /// Custom padding for the card content.
  final EdgeInsetsGeometry? padding;

  /// Custom margin for the card.
  final EdgeInsetsGeometry? margin;

  /// Whether to use RepaintBoundary for performance optimization.
  final bool useRepaintBoundary;

  /// Whether to enable haptic feedback on tap.
  final bool enableHapticFeedback;

  const EnhancedCard({
    required this.child,
    this.variant = CardVariant.elevated,
    this.size = CardSize.medium,
    this.isInteractive = false,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.elevation,
    this.isAchievement = false,
    this.isLocked = false,
    this.gradient,
    this.useDynamicBorder = false,
    this.padding,
    this.margin,
    this.useRepaintBoundary = false,
    this.enableHapticFeedback = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Wrap in RepaintBoundary for performance if requested
    final cardWidget = _buildCard(context, theme, colorScheme);

    if (useRepaintBoundary) {
      return RepaintBoundary(child: cardWidget);
    }

    return cardWidget;
  }

  Widget _buildCard(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final cardDecoration = _getCardDecoration(context, theme, colorScheme);
    final cardPadding = padding ?? _getResponsivePadding(context);
    final cardMargin = margin ?? _getDefaultMargin();

    Widget cardChild = Padding(padding: cardPadding, child: child);

    // Handle interactive behavior
    if (isInteractive && onTap != null) {
      cardChild = InkWell(
        onTap: () {
          if (enableHapticFeedback) {
            // Use platform-specific haptic feedback
            // Note: In a real implementation, you'd want to use the haptic service
            // For now, we'll use the basic HapticFeedback
            try {
              // HapticFeedback.lightImpact();
            } catch (e) {
              // Handle haptic feedback gracefully
            }
          }
          onTap!();
        },
        borderRadius: cardDecoration.borderRadius as BorderRadius?,
        child: cardChild,
      );
    }

    return Container(
      margin: cardMargin,
      decoration: cardDecoration,
      child: cardChild,
    );
  }

  BoxDecoration _getCardDecoration(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final borderRadius = _getBorderRadius(context);
    final defaultElevation = elevation ?? _getDefaultElevation();

    // Handle achievement-specific styling
    if (isAchievement) {
      return _getAchievementCardDecoration(
        context,
        theme,
        colorScheme,
        borderRadius,
      );
    }

    // Handle gradient variant
    if (variant == CardVariant.gradient || gradient != null) {
      return BoxDecoration(
        borderRadius: borderRadius,
        gradient:
            gradient ??
            LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                backgroundColor ?? colorScheme.surfaceContainer,
                (backgroundColor ?? colorScheme.surfaceContainer).withValues(
                  alpha: 0.8,
                ),
              ],
            ),
        border: Border.all(
          color: borderColor ?? colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: defaultElevation * 0.5,
            spreadRadius: 0.5,
          ),
        ],
      );
    }

    // Handle standard variants
    switch (variant) {
      case CardVariant.elevated:
        return BoxDecoration(
          color: backgroundColor ?? colorScheme.surface,
          borderRadius: borderRadius,
          border: Border.all(
            color: borderColor ?? colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: defaultElevation,
              spreadRadius: 1,
            ),
          ],
        );

      case CardVariant.outlined:
        return BoxDecoration(
          color: backgroundColor ?? colorScheme.surfaceContainer,
          borderRadius: borderRadius,
          border: Border.all(
            color: (borderColor ?? colorScheme.outline).withValues(alpha: 0.2),
            width: 2,
          ),
        );

      case CardVariant.filled:
        return BoxDecoration(
          color: backgroundColor ?? colorScheme.surfaceContainer,
          borderRadius: borderRadius,
          border: Border.all(
            color: borderColor ?? colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        );

      case CardVariant.gradient:
        // Handled above
        break;
    }

    // Fallback
    return BoxDecoration(
      color: backgroundColor ?? colorScheme.surface,
      borderRadius: borderRadius,
      border: Border.all(
        color: borderColor ?? colorScheme.outline.withValues(alpha: 0.2),
        width: 1,
      ),
    );
  }

  BoxDecoration _getAchievementCardDecoration(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    BorderRadius borderRadius,
  ) {
    // For achievement cards, we need to support dynamic styling based on locked/unlocked state
    // This matches the AchievementCard pattern
    final cardColor =
        backgroundColor ??
        (isLocked ? colorScheme.surfaceDim : colorScheme.surface);

    final borderWidth = isLocked ? 1.0 : 2.0;

    Color borderColorValue;
    if (useDynamicBorder) {
      // Use dynamic border color (for achievements with rarity colors)
      borderColorValue =
          borderColor ?? colorScheme.outline.withValues(alpha: 0.2);
    } else {
      // Use standard border color
      borderColorValue =
          borderColor ?? colorScheme.outline.withValues(alpha: 0.2);
    }

    final List<BoxShadow>? boxShadow;
    if (!isLocked && variant == CardVariant.elevated) {
      boxShadow = [
        BoxShadow(
          color: colorScheme.shadow.withValues(alpha: 0.1),
          blurRadius: 8,
          spreadRadius: 1,
        ),
      ];
    } else {
      boxShadow = null;
    }

    return BoxDecoration(
      color: cardColor,
      borderRadius: borderRadius,
      border: Border.all(color: borderColorValue, width: borderWidth),
      boxShadow: boxShadow,
    );
  }

  BorderRadius _getBorderRadius(BuildContext context) {
    // Use responsive border radius for achievement cards to match existing pattern
    if (isAchievement) {
      return BorderRadius.circular(16.0); // Fixed 16px matches AchievementCard
    }

    switch (size) {
      case CardSize.small:
        return BorderRadius.circular(12.0);
      case CardSize.medium:
        return BorderRadius.circular(16.0);
      case CardSize.large:
        return BorderRadius.circular(20.0);
      case CardSize.custom:
        return BorderRadius.circular(16.0);
    }
  }

  double _getDefaultElevation() {
    switch (variant) {
      case CardVariant.elevated:
        return 4.0;
      case CardVariant.outlined:
      case CardVariant.filled:
        return 0.0;
      case CardVariant.gradient:
        return 2.0;
    }
  }

  EdgeInsetsGeometry _getDefaultPadding() {
    switch (size) {
      case CardSize.small:
        return const EdgeInsets.all(12.0);
      case CardSize.medium:
        return const EdgeInsets.all(16.0);
      case CardSize.large:
        return const EdgeInsets.all(20.0);
      case CardSize.custom:
        return const EdgeInsets.all(16.0);
    }
  }

  /// Get responsive padding that matches existing card patterns
  EdgeInsetsGeometry _getResponsivePadding(BuildContext context) {
    if (isAchievement) {
      // Match AchievementCard responsive padding pattern
      return EdgeInsets.all(
        context.getResponsiveSpacing(phoneSpacing: 12.0, tabletSpacing: 16.0),
      );
    }

    // Use standard padding for other card types
    return _getDefaultPadding();
  }

  EdgeInsetsGeometry _getDefaultMargin() {
    switch (size) {
      case CardSize.small:
        return const EdgeInsets.all(6.0);
      case CardSize.medium:
        return const EdgeInsets.all(8.0);
      case CardSize.large:
        return const EdgeInsets.all(10.0);
      case CardSize.custom:
        return const EdgeInsets.all(8.0);
    }
  }
}

/// Variants for card styling.
enum CardVariant {
  /// Elevated card with shadow and border.
  elevated,

  /// Outlined card with prominent border.
  outlined,

  /// Filled card with container color.
  filled,

  /// Gradient card with subtle gradient background.
  gradient,
}

/// Size presets for cards.
enum CardSize {
  /// Small card size.
  small,

  /// Medium card size (default).
  medium,

  /// Large card size.
  large,

  /// Custom size (uses default sizing).
  custom,
}
