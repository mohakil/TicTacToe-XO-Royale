import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tictactoe_xo_royale/core/services/navigation_service.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/shared/widgets/buttons/icon_action_button.dart';

/// A reusable app bar component for consistent navigation across all screens.
///
/// Provides standardized navigation bar behavior with responsive design,
/// proper back button handling, and integration with the NavigationService.
///
/// **Usage:**
/// ```dart
/// const SharedAppBar(
///   title: 'Achievements',
///   showBackButton: true,
///   showSettingsButton: false,
/// )
/// ```
class SharedAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title text to display in the app bar.
  final String title;

  /// Whether to show the back button.
  final bool showBackButton;

  /// Whether to show the settings button.
  final bool showSettingsButton;

  /// Custom callback when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// Custom callback when the settings button is pressed.
  final VoidCallback? onSettingsPressed;

  /// Additional action widgets to display in the app bar.
  final List<Widget>? actions;

  /// Whether to center the title.
  final bool centerTitle;

  /// Custom background color for the app bar.
  final Color? backgroundColor;

  /// Custom elevation for the app bar.
  final double? elevation;

  /// Custom foreground color for the app bar content.
  final Color? foregroundColor;

  /// Whether to use the safe area for top padding.
  final bool useSafeArea;

  /// Custom leading widget instead of the default back button.
  final Widget? leading;

  /// Whether to automatically set the status bar color to match the app bar.
  final bool setStatusBarColor;

  const SharedAppBar({
    required this.title,
    this.showBackButton = true,
    this.showSettingsButton = false,
    this.onBackPressed,
    this.onSettingsPressed,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation,
    this.foregroundColor,
    this.useSafeArea = true,
    this.leading,
    this.setStatusBarColor = true,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLightTheme = theme.brightness == Brightness.light;

    // Theme-adaptive background and foreground colors
    final adaptiveBackgroundColor = backgroundColor ?? colorScheme.surface;

    final adaptiveForegroundColor =
        foregroundColor ??
        (isLightTheme ? colorScheme.onSurface : colorScheme.onSurface);

    // Set status bar color to match app bar background
    if (setStatusBarColor) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: adaptiveBackgroundColor,
            statusBarIconBrightness: isLightTheme
                ? Brightness.dark
                : Brightness.light,
            statusBarBrightness: isLightTheme
                ? Brightness.light
                : Brightness.dark,
          ),
        );
      });
    }

    return AppBar(
      backgroundColor: adaptiveBackgroundColor,
      elevation: elevation ?? 0,
      foregroundColor: adaptiveForegroundColor,
      leading: _buildLeading(context),
      title: _buildTitle(context, theme),
      centerTitle: centerTitle,
      actions: _buildActions(context),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) {
      return leading;
    }

    if (!showBackButton) {
      return null;
    }

    return IconActionButton(
      icon: Icons.arrow_back,
      onPressed: () {
        if (onBackPressed != null) {
          onBackPressed!();
        } else {
          NavigationService.goBack(context);
        }
      },
      tooltip: 'Back',
      size: IconButtonSize.medium,
      useResponsiveSizing: true,
    );
  }

  Widget _buildTitle(BuildContext context, ThemeData theme) {
    return Text(
      title,
      style:
          (theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: foregroundColor ?? theme.colorScheme.onSurface,
                  ) ??
                  const TextStyle())
              .copyWith(fontSize: context.scale(20.0)),
    );
  }

  List<Widget>? _buildActions(BuildContext context) {
    final actionList = <Widget>[];

    // Add settings button if requested
    if (showSettingsButton) {
      actionList.add(
        IconActionButton(
          icon: Icons.settings,
          onPressed: () {
            if (onSettingsPressed != null) {
              onSettingsPressed!();
            } else {
              NavigationService.goSettings(context);
            }
          },
          tooltip: 'Settings',
          size: IconButtonSize.medium,
          useResponsiveSizing: true,
        ),
      );
    }

    // Add custom actions if provided
    if (actions != null) {
      actionList.addAll(actions!);
    }

    return actionList.isNotEmpty ? actionList : null;
  }
}
