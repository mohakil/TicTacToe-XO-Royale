import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';

/// An icon widget with a badge overlay for notifications or counts.
///
/// Perfect for showing unread counts, progress indicators, or status badges
/// on icons with responsive sizing and theme integration.
///
/// **Usage:**
/// ```dart
/// IconBadge(
///   icon: Icons.notifications,
///   badgeText: '3',
///   badgeColor: Colors.red,
///   onTap: () => openNotifications(),
/// )
/// ```
class IconBadge extends StatelessWidget {
  /// The main icon to display.
  final IconData icon;

  /// The text to display in the badge.
  final String? badgeText;

  /// The number to display in the badge (alternative to badgeText).
  final int? badgeNumber;

  /// Custom color for the badge background.
  final Color? badgeColor;

  /// Custom color for the badge text.
  final Color? badgeTextColor;

  /// Position of the badge relative to the icon.
  final BadgePosition position;

  /// Size of the badge.
  final BadgeSize size;

  /// Callback when the icon is tapped.
  final VoidCallback? onTap;

  /// Tooltip text for accessibility.
  final String? tooltip;

  /// Color for the main icon.
  final Color? iconColor;

  /// Size preset for the icon.
  final IconBadgeIconSize iconSize;

  /// Custom size for the icon.
  final double? customIconSize;

  /// Whether to show the badge even when badgeText is null or badgeNumber is 0.
  final bool alwaysShowBadge;

  /// Whether to use responsive sizing.
  final bool useResponsiveSizing;

  /// Whether to use RepaintBoundary for performance optimization.
  final bool useRepaintBoundary;

  const IconBadge({
    required this.icon,
    this.badgeText,
    this.badgeNumber,
    this.badgeColor,
    this.badgeTextColor,
    this.position = BadgePosition.topRight,
    this.size = BadgeSize.small,
    this.onTap,
    this.tooltip,
    this.iconColor,
    this.iconSize = IconBadgeIconSize.medium,
    this.customIconSize,
    this.alwaysShowBadge = false,
    this.useResponsiveSizing = true,
    this.useRepaintBoundary = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine badge content
    final shouldShowBadge =
        alwaysShowBadge ||
        (badgeText != null && badgeText!.isNotEmpty) ||
        (badgeNumber != null && badgeNumber! > 0);

    final badgeContent = shouldShowBadge
        ? _buildBadge(context, colorScheme)
        : null;

    final iconWidget = Icon(
      icon,
      size: _getIconSize(context),
      color: iconColor ?? colorScheme.onSurface,
    );

    Widget content;
    if (onTap != null) {
      content = IconButton(
        onPressed: onTap,
        icon: Stack(
          children: [
            iconWidget,
            if (badgeContent != null) _getBadgePosition(badgeContent),
          ],
        ),
        tooltip: tooltip,
        padding: _getPadding(context),
        style: IconButton.styleFrom(
          backgroundColor: Colors.transparent,
          minimumSize: Size(_getMinSize(context), _getMinSize(context)),
        ),
      );
    } else {
      content = Stack(
        children: [
          iconWidget,
          if (badgeContent != null) _getBadgePosition(badgeContent),
        ],
      );
    }

    // Apply RepaintBoundary if requested
    if (useRepaintBoundary) {
      return RepaintBoundary(child: content);
    }

    return content;
  }

  Widget _buildBadge(BuildContext context, ColorScheme colorScheme) {
    final badgeSize = _getBadgeSize(context);
    final text = badgeNumber?.toString() ?? badgeText ?? '';

    return Container(
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(
        color: badgeColor ?? colorScheme.error,
        shape: BoxShape.circle,
        border: Border.all(color: colorScheme.surface, width: 2.0),
      ),
      child: Center(
        child: Text(
          text,
          style: _getBadgeTextStyle(
            context,
          ).copyWith(color: badgeTextColor ?? colorScheme.onError),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Positioned _getBadgePosition(Widget badge) {
    switch (position) {
      case BadgePosition.topRight:
        return Positioned(top: 0, right: 0, child: badge);
      case BadgePosition.topLeft:
        return Positioned(top: 0, left: 0, child: badge);
      case BadgePosition.bottomRight:
        return Positioned(bottom: 0, right: 0, child: badge);
      case BadgePosition.bottomLeft:
        return Positioned(bottom: 0, left: 0, child: badge);
    }
  }

  double _getIconSize(BuildContext context) {
    if (customIconSize != null) return customIconSize!;

    if (!useResponsiveSizing) {
      switch (iconSize) {
        case IconBadgeIconSize.small:
          return context.scale(20.0);
        case IconBadgeIconSize.medium:
          return context.scale(24.0);
        case IconBadgeIconSize.large:
          return context.scale(28.0);
      }
    }

    return context.getResponsiveIconSize(
      phoneSize: _getBaseIconSize(),
      tabletSize: _getBaseIconSize() * 1.1,
    );
  }

  double _getBaseIconSize() {
    switch (iconSize) {
      case IconBadgeIconSize.small:
        return 20.0;
      case IconBadgeIconSize.medium:
        return 24.0;
      case IconBadgeIconSize.large:
        return 28.0;
    }
  }

  double _getBadgeSize(BuildContext context) {
    switch (size) {
      case BadgeSize.small:
        return context.scale(16.0);
      case BadgeSize.medium:
        return context.scale(20.0);
      case BadgeSize.large:
        return context.scale(24.0);
    }
  }

  TextStyle _getBadgeTextStyle(BuildContext context) {
    switch (size) {
      case BadgeSize.small:
        return Theme.of(context).textTheme.labelSmall ?? const TextStyle();
      case BadgeSize.medium:
        return Theme.of(context).textTheme.labelMedium ?? const TextStyle();
      case BadgeSize.large:
        return Theme.of(context).textTheme.labelLarge ?? const TextStyle();
    }
  }

  double _getMinSize(BuildContext context) {
    return context.scale(48.0); // Standard 48dp minimum touch target
  }

  EdgeInsetsGeometry _getPadding(BuildContext context) {
    final spacing = context.scale(8.0);
    return EdgeInsets.all(spacing);
  }
}

/// Position presets for badge placement.
enum BadgePosition {
  /// Badge in the top-right corner.
  topRight,

  /// Badge in the top-left corner.
  topLeft,

  /// Badge in the bottom-right corner.
  bottomRight,

  /// Badge in the bottom-left corner.
  bottomLeft,
}

/// Size presets for badges.
enum BadgeSize {
  /// Small badge size.
  small,

  /// Medium badge size (default).
  medium,

  /// Large badge size.
  large,
}

/// Size presets for icons.
enum IconBadgeIconSize {
  /// Small icon size.
  small,

  /// Medium icon size (default).
  medium,

  /// Large icon size.
  large,
}
