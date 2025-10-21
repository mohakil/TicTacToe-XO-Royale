import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';

/// A circular avatar widget displaying an icon with optional border and background.
///
/// Perfect for user profile pictures, achievement icons, or any circular icon display
/// with responsive sizing and theme integration.
///
/// **Usage:**
/// ```dart
/// IconAvatar(
///   icon: Icons.person,
///   backgroundColor: colorScheme.primaryContainer,
///   size: AvatarSize.medium,
///   onTap: () => openProfile(),
/// )
/// ```
class IconAvatar extends StatelessWidget {
  /// The icon to display in the avatar.
  final IconData icon;

  /// Background color for the avatar circle.
  final Color? backgroundColor;

  /// Border color for the avatar.
  final Color? borderColor;

  /// Border width for the avatar.
  final double? borderWidth;

  /// Size preset for the avatar.
  final AvatarSize size;

  /// Custom size for the avatar.
  final double? customSize;

  /// Color for the icon.
  final Color? iconColor;

  /// Size preset for the icon.
  final IconAvatarIconSize iconSize;

  /// Custom size for the icon.
  final double? customIconSize;

  /// Callback when the avatar is tapped.
  final VoidCallback? onTap;

  /// Tooltip text for accessibility.
  final String? tooltip;

  /// Whether to use responsive sizing.
  final bool useResponsiveSizing;

  /// Whether to use RepaintBoundary for performance optimization.
  final bool useRepaintBoundary;

  const IconAvatar({
    required this.icon,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.size = AvatarSize.medium,
    this.customSize,
    this.iconColor,
    this.iconSize = IconAvatarIconSize.medium,
    this.customIconSize,
    this.onTap,
    this.tooltip,
    this.useResponsiveSizing = true,
    this.useRepaintBoundary = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final avatarSize = _getAvatarSize(context);
    final iconSizeValue = _getIconSize(context);

    final avatarWidget = Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
        border: borderColor != null || borderWidth != null
            ? Border.all(
                color: borderColor ?? colorScheme.outline,
                width: borderWidth ?? 2.0,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: iconSizeValue,
        color: iconColor ?? colorScheme.onSurfaceVariant,
      ),
    );

    Widget content;
    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(avatarSize / 2),
        radius: avatarSize / 2,
        child: avatarWidget,
      );
    } else {
      content = avatarWidget;
    }

    // Apply RepaintBoundary if requested
    if (useRepaintBoundary) {
      return RepaintBoundary(child: content);
    }

    return content;
  }

  double _getAvatarSize(BuildContext context) {
    if (customSize != null) return customSize!;

    if (!useResponsiveSizing) {
      switch (size) {
        case AvatarSize.small:
          return context.scale(32.0);
        case AvatarSize.medium:
          return context.scale(48.0);
        case AvatarSize.large:
          return context.scale(64.0);
        case AvatarSize.extraLarge:
          return context.scale(80.0);
      }
    }

    return context.getResponsiveIconSize(
      phoneSize: _getBaseAvatarSize(),
      tabletSize: _getBaseAvatarSize() * 1.2,
    );
  }

  double _getBaseAvatarSize() {
    switch (size) {
      case AvatarSize.small:
        return 32.0;
      case AvatarSize.medium:
        return 48.0;
      case AvatarSize.large:
        return 64.0;
      case AvatarSize.extraLarge:
        return 80.0;
    }
  }

  double _getIconSize(BuildContext context) {
    if (customIconSize != null) return customIconSize!;

    if (!useResponsiveSizing) {
      switch (iconSize) {
        case IconAvatarIconSize.small:
          return context.scale(16.0);
        case IconAvatarIconSize.medium:
          return context.scale(20.0);
        case IconAvatarIconSize.large:
          return context.scale(24.0);
      }
    }

    return context.getResponsiveIconSize(
      phoneSize: _getBaseIconSize(),
      tabletSize: _getBaseIconSize() * 1.1,
    );
  }

  double _getBaseIconSize() {
    switch (iconSize) {
      case IconAvatarIconSize.small:
        return 16.0;
      case IconAvatarIconSize.medium:
        return 20.0;
      case IconAvatarIconSize.large:
        return 24.0;
    }
  }
}

/// Size presets for avatars.
enum AvatarSize {
  /// Small avatar size (32dp).
  small,

  /// Medium avatar size (48dp, default).
  medium,

  /// Large avatar size (64dp).
  large,

  /// Extra large avatar size (80dp).
  extraLarge,
}

/// Size presets for icons within avatars.
enum IconAvatarIconSize {
  /// Small icon size.
  small,

  /// Medium icon size (default).
  medium,

  /// Large icon size.
  large,
}
