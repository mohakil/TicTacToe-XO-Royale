import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

/// A blur overlay that provides a modal background with blur effects.
/// Falls back to a semi-transparent overlay on devices that don't support blur.
class BlurOverlay extends StatelessWidget {
  /// The child widget to display over the blur background.
  final Widget child;

  /// Whether the overlay is visible.
  final bool visible;

  /// The blur intensity (0.0 to 20.0).
  final double blurIntensity;

  /// The background color opacity (0.0 to 1.0).
  final double backgroundOpacity;

  /// Callback when the overlay is tapped (for dismissing).
  final VoidCallback? onTap;

  /// Whether to show a close button in the top-right corner.
  final bool showCloseButton;

  /// Callback when the close button is tapped.
  final VoidCallback? onClose;

  /// The color of the background overlay.
  final Color? backgroundColor;

  /// Whether to animate the overlay in/out.
  final bool animate;

  const BlurOverlay({
    required this.child,
    super.key,
    this.visible = true,
    this.blurIntensity = 8.0,
    this.backgroundOpacity = 0.3,
    this.onTap,
    this.showCloseButton = false,
    this.onClose,
    this.backgroundColor,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final effectiveBackgroundColor =
        backgroundColor ??
        theme.colorScheme.surface.withValues(alpha: backgroundOpacity);

    Widget overlay = Stack(
      children: [
        // Blur background or fallback
        _buildBackground(context, effectiveBackgroundColor),

        // Content
        Center(
          child: Material(color: Colors.transparent, child: child),
        ),

        // Close button if requested
        if (showCloseButton && onClose != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: _CloseButton(onClose: onClose!),
          ),
      ],
    );

    // Add tap to dismiss if callback provided
    if (onTap != null) {
      overlay = GestureDetector(onTap: onTap, child: overlay);
    }

    // Add animation if requested
    if (animate) {
      overlay = AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: overlay,
      );
    }

    return overlay;
  }

  Widget _buildBackground(BuildContext context, Color backgroundColor) {
    // Check if blur is supported on this platform
    if (_isBlurSupported()) {
      return ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurIntensity,
            sigmaY: blurIntensity,
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: backgroundColor,
          ),
        ),
      );
    } else {
      // Fallback for devices that don't support blur
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: backgroundColor,
      );
    }
  }

  /// Check if blur effects are supported on the current platform.
  bool _isBlurSupported() {
    // iOS and macOS support blur effects
    if (Platform.isIOS || Platform.isMacOS) {
      return true;
    }

    // Android supports blur effects on API level 31+ (Android 12+)
    if (Platform.isAndroid) {
      // Note: In a real app, you'd check the actual API level
      // For now, we'll assume modern Android devices support it
      return true;
    }

    // Web and other platforms may have limited blur support
    return false;
  }
}

/// A close button widget for the blur overlay.
class _CloseButton extends StatelessWidget {
  final VoidCallback onClose;

  const _CloseButton({required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClose,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Icon(
            Icons.close,
            color: theme.colorScheme.onSurface,
            size: 20,
          ),
        ),
      ),
    );
  }
}

/// A scrim overlay that can be used as a simpler alternative to blur.
/// Useful for devices that don't support blur effects well.
class ScrimOverlay extends StatelessWidget {
  final Widget child;
  final bool visible;
  final double opacity;
  final Color? color;
  final VoidCallback? onTap;
  final bool animate;

  const ScrimOverlay({
    required this.child,
    super.key,
    this.visible = true,
    this.opacity = 0.5,
    this.color,
    this.onTap,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final effectiveColor =
        color ?? theme.colorScheme.surface.withValues(alpha: opacity);

    Widget overlay = Stack(
      children: [
        // Scrim background
        Container(
          width: double.infinity,
          height: double.infinity,
          color: effectiveColor,
        ),

        // Content
        Center(
          child: Material(color: Colors.transparent, child: child),
        ),
      ],
    );

    // Add tap to dismiss if callback provided
    if (onTap != null) {
      overlay = GestureDetector(onTap: onTap, child: overlay);
    }

    // Add animation if requested
    if (animate) {
      overlay = AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: overlay,
      );
    }

    return overlay;
  }
}
