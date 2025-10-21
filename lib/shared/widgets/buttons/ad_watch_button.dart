import 'package:flutter/material.dart';

/// A specialized button component for ad watching functionality with state management.
///
/// This widget standardizes ad watching UI patterns across all features with
/// loading states, countdown timers, and consistent styling.
///
/// **Usage:**
/// ```dart
/// AdWatchButton(
///   onWatchAd: () => watchAd(),
///   rewardText: '+50 Gems',
///   variant: AdWatchVariant.rewarded,
/// )
/// ```
class AdWatchButton extends StatefulWidget {
  /// Callback when the ad watch button is pressed.
  final VoidCallback? onWatchAd;

  /// Text to display showing the reward (e.g., '+50 Gems').
  final String rewardText;

  /// The variant of ad watch button.
  final AdWatchVariant variant;

  /// Custom text style for the reward text.
  final TextStyle? rewardTextStyle;

  /// Custom text style for the action text.
  final TextStyle? actionTextStyle;

  /// Custom background color for the button.
  final Color? backgroundColor;

  /// Custom foreground color for the button.
  final Color? foregroundColor;

  /// Custom padding for the button.
  final EdgeInsetsGeometry? padding;

  /// Whether the button is in a loading state.
  final bool isLoading;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// Custom countdown duration for cooldown state.
  final Duration? countdownDuration;

  /// Callback when countdown completes.
  final VoidCallback? onCountdownComplete;

  /// Whether to use responsive spacing.
  final bool useResponsiveSpacing;

  /// Custom icon for the button.
  final IconData? icon;

  /// Custom size for the icon.
  final double? iconSize;

  /// Animation duration for state transitions.
  final Duration animationDuration;

  const AdWatchButton({
    super.key,
    this.onWatchAd,
    required this.rewardText,
    this.variant = AdWatchVariant.rewarded,
    this.rewardTextStyle,
    this.actionTextStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.isLoading = false,
    this.isDisabled = false,
    this.countdownDuration,
    this.onCountdownComplete,
    this.useResponsiveSpacing = true,
    this.icon,
    this.iconSize,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<AdWatchButton> createState() => _AdWatchButtonState();
}

class _AdWatchButtonState extends State<AdWatchButton>
    with TickerProviderStateMixin {
  AnimationController? _countdownController;
  Animation<double>? _countdownAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize countdown animation if duration is provided
    if (widget.countdownDuration != null) {
      _countdownController = AnimationController(
        duration: widget.countdownDuration,
        vsync: this,
      );

      _countdownAnimation = Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(_countdownController!);

      _countdownController!.forward().whenComplete(() {
        widget.onCountdownComplete?.call();
      });
    }
  }

  @override
  void dispose() {
    _countdownController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use responsive padding if enabled
    final effectivePadding =
        widget.padding ??
        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);

    final effectiveIconSize = widget.iconSize ?? 20.0;

    final buttonColor =
        widget.backgroundColor ?? _getBackgroundColor(theme, widget.variant);

    final textColor =
        widget.foregroundColor ?? _getForegroundColor(theme, widget.variant);

    return AnimatedContainer(
      duration: widget.animationDuration,
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: widget.isDisabled ? theme.disabledColor : buttonColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: _getBoxShadow(theme, widget.variant),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isDisabled || widget.isLoading
              ? null
              : widget.onWatchAd,
          borderRadius: BorderRadius.circular(12.0),
          child: Padding(
            padding: effectivePadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: effectiveIconSize, color: textColor),
                  const SizedBox(width: 8.0),
                ],
                if (widget.countdownDuration != null &&
                    _countdownAnimation != null) ...[
                  _buildCountdownContent(theme, textColor),
                ] else if (widget.isLoading) ...[
                  _buildLoadingContent(theme, textColor),
                ] else ...[
                  _buildNormalContent(theme, textColor),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountdownContent(ThemeData theme, Color textColor) {
    return AnimatedBuilder(
      animation: _countdownAnimation!,
      builder: (context, child) {
        final remainingSeconds =
            (_countdownAnimation!.value * widget.countdownDuration!.inSeconds)
                .round();
        return Row(
          children: [
            Icon(Icons.timer, size: 16, color: textColor),
            SizedBox(width: 8.0),
            Text(
              '${remainingSeconds}s',
              style:
                  widget.actionTextStyle ??
                  theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingContent(ThemeData theme, Color textColor) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(textColor),
          ),
        ),
        SizedBox(width: 8),
        Text(
          'Loading...',
          style:
              widget.actionTextStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
        ),
      ],
    );
  }

  Widget _buildNormalContent(ThemeData theme, Color textColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.rewardText,
          style:
              widget.rewardTextStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
        ),
        SizedBox(height: 2),
        Text(
          'Watch Ad',
          style:
              widget.actionTextStyle ??
              theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: textColor.withValues(alpha: 0.8),
              ),
        ),
      ],
    );
  }

  Color _getBackgroundColor(ThemeData theme, AdWatchVariant variant) {
    switch (variant) {
      case AdWatchVariant.rewarded:
        return theme.colorScheme.primary;
      case AdWatchVariant.skippable:
        return theme.colorScheme.secondary;
      case AdWatchVariant.mandatory:
        return theme.colorScheme.tertiary;
    }
  }

  Color _getForegroundColor(ThemeData theme, AdWatchVariant variant) {
    switch (variant) {
      case AdWatchVariant.rewarded:
        return theme.colorScheme.onPrimary;
      case AdWatchVariant.skippable:
        return theme.colorScheme.onSecondary;
      case AdWatchVariant.mandatory:
        return theme.colorScheme.onTertiary;
    }
  }

  List<BoxShadow>? _getBoxShadow(ThemeData theme, AdWatchVariant variant) {
    switch (variant) {
      case AdWatchVariant.rewarded:
        return [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ];
      case AdWatchVariant.skippable:
        return [
          BoxShadow(
            color: theme.colorScheme.secondary.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ];
      case AdWatchVariant.mandatory:
        return [
          BoxShadow(
            color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ];
    }
  }
}

/// Variants for ad watch button styling and behavior.
enum AdWatchVariant {
  /// Rewarded ad variant for optional ads with rewards.
  rewarded,

  /// Skippable ad variant for ads that can be skipped.
  skippable,

  /// Mandatory ad variant for required ads without skip option.
  mandatory,
}
