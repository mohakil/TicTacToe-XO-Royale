import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';

/// A reusable widget for displaying different states (loading, empty, error).
///
/// Provides consistent state messaging and styling across all features
/// with responsive design and accessibility support.
///
/// **Usage:**
/// ```dart
/// StateDisplay(
///   state: DisplayState.empty,
///   title: 'No items found',
///   subtitle: 'Check back later for new content',
///   icon: Icons.store,
///   action: ElevatedButton(
///     onPressed: () => refresh(),
///     child: Text('Refresh'),
///   ),
/// )
/// ```
class StateDisplay extends StatelessWidget {
  /// The state to display.
  final DisplayState state;

  /// The main title text to display.
  final String title;

  /// Optional subtitle text for additional context.
  final String? subtitle;

  /// Optional icon to display with the state.
  final IconData? icon;

  /// Optional action widget (e.g., button) to display below the content.
  final Widget? action;

  /// Custom icon size.
  final double? iconSize;

  /// Custom padding for the state display.
  final EdgeInsetsGeometry? padding;

  /// Whether to center the content.
  final bool centerContent;

  /// Custom color for the icon and text.
  final Color? color;

  const StateDisplay({
    required this.state,
    required this.title,
    this.subtitle,
    this.icon,
    this.action,
    this.iconSize,
    this.padding,
    this.centerContent = true,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final displayColor = color ?? colorScheme.onSurfaceVariant;
    final content = _buildContent(context, theme, colorScheme, displayColor);

    final widget = Container(
      padding: padding ?? _getDefaultPadding(context),
      child: centerContent ? Center(child: content) : content,
    );

    return widget;
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    Color displayColor,
  ) {
    final iconWidget = _buildIcon(context, displayColor);
    final titleWidget = _buildTitle(context, theme, displayColor);
    final subtitleWidget = _buildSubtitle(context, theme, displayColor);
    final actionWidget = _buildAction();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Check if we have limited height that might cause overflow
        final hasLimitedHeight = constraints.maxHeight < double.infinity;

        if (hasLimitedHeight) {
          // Use Flexible layout with proper constraints
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (iconWidget != null) ...[
                      iconWidget,
                      SizedBox(height: _getSpacing(context)),
                    ],
                    Flexible(child: titleWidget),
                    if (subtitleWidget != null) ...[
                      SizedBox(height: _getSpacing(context) * 0.5),
                      Flexible(child: subtitleWidget),
                    ],
                    if (actionWidget != null) ...[
                      SizedBox(height: _getSpacing(context)),
                      actionWidget,
                    ],
                  ],
                ),
              ),
            ),
          );
        } else {
          // Original layout for unconstrained height
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconWidget != null) ...[
                iconWidget,
                SizedBox(height: _getSpacing(context)),
              ],
              titleWidget,
              if (subtitleWidget != null) ...[
                SizedBox(height: _getSpacing(context) * 0.5),
                subtitleWidget,
              ],
              if (actionWidget != null) ...[
                SizedBox(height: _getSpacing(context)),
                actionWidget,
              ],
            ],
          );
        }
      },
    );
  }

  Widget? _buildIcon(BuildContext context, Color displayColor) {
    // Special handling for loading state
    if (state == DisplayState.loading) {
      return SizedBox(
        width: iconSize ?? _getIconSize(context),
        height: iconSize ?? _getIconSize(context),
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(
            displayColor.withValues(alpha: 0.8),
          ),
        ),
      );
    }

    if (icon == null) return null;

    return Icon(
      _getIconForState(),
      size: iconSize ?? _getIconSize(context),
      color: displayColor.withValues(alpha: 0.6),
    );
  }

  Widget _buildTitle(
    BuildContext context,
    ThemeData theme,
    Color displayColor,
  ) {
    return Text(
      title,
      style: _getTitleStyle(context, theme).copyWith(color: displayColor),
      textAlign: TextAlign.center,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget? _buildSubtitle(
    BuildContext context,
    ThemeData theme,
    Color displayColor,
  ) {
    if (subtitle == null || subtitle!.isEmpty) return null;

    return Text(
      subtitle!,
      style: _getSubtitleStyle(
        context,
        theme,
      ).copyWith(color: displayColor.withValues(alpha: 0.7)),
      textAlign: TextAlign.center,
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget? _buildAction() {
    return action;
  }

  IconData _getIconForState() {
    switch (state) {
      case DisplayState.loading:
        return Icons.refresh; // Fallback if no CircularProgressIndicator
      case DisplayState.empty:
        return icon ?? Icons.inbox;
      case DisplayState.error:
        return icon ?? Icons.error_outline;
    }
  }

  double _getIconSize(BuildContext context) {
    // Use responsive sizing with a reasonable maximum to prevent overflow
    final baseSize = context.scale(48.0);
    return baseSize.clamp(24.0, 64.0); // Clamp between 24px and 64px
  }

  TextStyle _getTitleStyle(BuildContext context, ThemeData theme) {
    final baseStyle = theme.textTheme.titleMedium ?? const TextStyle();
    return baseStyle.copyWith(
      fontSize: context.scale(baseStyle.fontSize ?? 16.0),
    );
  }

  TextStyle _getSubtitleStyle(BuildContext context, ThemeData theme) {
    final baseStyle = theme.textTheme.bodyMedium ?? const TextStyle();
    return baseStyle.copyWith(
      fontSize: context.scale(baseStyle.fontSize ?? 14.0),
    );
  }

  EdgeInsetsGeometry _getDefaultPadding(BuildContext context) {
    return EdgeInsets.all(context.scale(24.0));
  }

  double _getSpacing(BuildContext context) {
    return context.scale(12.0);
  }
}

/// Display states for the StateDisplay widget.
enum DisplayState {
  /// Loading state with progress indicator.
  loading,

  /// Empty state showing no content available.
  empty,

  /// Error state indicating something went wrong.
  error,
}
