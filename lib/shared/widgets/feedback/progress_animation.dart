import 'package:flutter/material.dart';

/// A reusable animated progress indicator component for loading and progress states.
///
/// This widget standardizes progress visualization across all features with
/// smooth animations, consistent styling, and responsive behavior.
///
/// **Usage:**
/// ```dart
/// ProgressAnimation(
///   progress: 0.7,
///   variant: ProgressAnimationVariant.linear,
///   showPercentage: true,
///   animationDuration: Duration(milliseconds: 800),
/// )
/// ```
class ProgressAnimation extends StatefulWidget {
  /// Current progress value (0.0 to 1.0).
  final double progress;

  /// The visual variant of the progress indicator.
  final ProgressAnimationVariant variant;

  /// Custom color for the progress indicator.
  final Color? color;

  /// Background color for the progress track.
  final Color? backgroundColor;

  /// Custom size for the indicator.
  final double? size;

  /// Custom stroke width for linear/circular indicators.
  final double? strokeWidth;

  /// Whether to show percentage text.
  final bool showPercentage;

  /// Custom style for percentage text.
  final TextStyle? percentageStyle;

  /// Animation duration for progress changes.
  final Duration animationDuration;

  /// Animation curve for progress changes.
  final Curve animationCurve;

  /// Custom padding for the widget.
  final EdgeInsetsGeometry? padding;

  /// Whether to use responsive sizing.
  final bool useResponsiveSpacing;

  /// Optional label text above the progress indicator.
  final String? label;

  /// Custom style for the label text.
  final TextStyle? labelStyle;

  /// Whether to show an indefinite animation when progress is 0.
  final bool indefiniteWhenEmpty;

  /// Custom builder for completely custom progress visualization.
  final Widget Function(BuildContext context, double animatedProgress)? builder;

  const ProgressAnimation({
    super.key,
    required this.progress,
    this.variant = ProgressAnimationVariant.linear,
    this.color,
    this.backgroundColor,
    this.size,
    this.strokeWidth,
    this.showPercentage = false,
    this.percentageStyle,
    this.animationDuration = const Duration(milliseconds: 800),
    this.animationCurve = Curves.easeInOut,
    this.padding,
    this.useResponsiveSpacing = true,
    this.label,
    this.labelStyle,
    this.indefiniteWhenEmpty = false,
    this.builder,
  });

  @override
  State<ProgressAnimation> createState() => _ProgressAnimationState();
}

class _ProgressAnimationState extends State<ProgressAnimation>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _progressAnimation =
        Tween<double>(begin: 0.0, end: widget.progress.clamp(0.0, 1.0)).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: widget.animationCurve,
          ),
        );

    _animationController.forward();
  }

  @override
  void didUpdateWidget(ProgressAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.progress != widget.progress) {
      _progressAnimation =
          Tween<double>(
            begin: _progressAnimation.value,
            end: widget.progress.clamp(0.0, 1.0),
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: widget.animationCurve,
            ),
          );

      _animationController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use responsive padding if enabled
    final effectivePadding =
        widget.padding ??
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);

    final effectiveSize = widget.size ?? 48.0;

    final effectiveStrokeWidth = widget.strokeWidth ?? 4.0;

    final progressColor = widget.color ?? theme.colorScheme.primary;
    final backgroundColor =
        widget.backgroundColor ?? theme.colorScheme.surfaceContainerHighest;

    return Padding(
      padding: effectivePadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null) ...[
            Text(
              widget.label!,
              style:
                  widget.labelStyle ??
                  theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ) ??
                  const TextStyle(),
            ),
            const SizedBox(height: 8.0),
          ],
          if (widget.builder != null) ...[
            widget.builder!(context, _progressAnimation.value),
          ] else ...[
            SizedBox(
              width: effectiveSize,
              height: effectiveSize,
              child: _buildProgressIndicator(
                context,
                _progressAnimation.value,
                progressColor,
                backgroundColor,
                effectiveSize,
                effectiveStrokeWidth,
              ),
            ),
          ],
          if (widget.showPercentage) ...[
            const SizedBox(height: 8.0),
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                final percentage = (_progressAnimation.value * 100).round();
                return Text(
                  '$percentage%',
                  style:
                      widget.percentageStyle ??
                      theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: progressColor,
                      ) ??
                      const TextStyle(fontWeight: FontWeight.w600),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(
    BuildContext context,
    double animatedProgress,
    Color progressColor,
    Color backgroundColor,
    double size,
    double strokeWidth,
  ) {
    switch (widget.variant) {
      case ProgressAnimationVariant.linear:
        return _buildLinearIndicator(
          animatedProgress,
          progressColor,
          backgroundColor,
          strokeWidth,
        );

      case ProgressAnimationVariant.circular:
        return _buildCircularIndicator(
          animatedProgress,
          progressColor,
          backgroundColor,
          size,
          strokeWidth,
        );

      case ProgressAnimationVariant.dots:
        return _buildDotsIndicator(
          animatedProgress,
          progressColor,
          backgroundColor,
          size,
        );

      case ProgressAnimationVariant.wave:
        return _buildWaveIndicator(
          animatedProgress,
          progressColor,
          backgroundColor,
          size,
        );
    }
  }

  Widget _buildLinearIndicator(
    double progress,
    Color progressColor,
    Color backgroundColor,
    double strokeWidth,
  ) {
    return Container(
      height: strokeWidth,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(strokeWidth / 2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: progressColor,
            borderRadius: BorderRadius.circular(strokeWidth / 2),
          ),
        ),
      ),
    );
  }

  Widget _buildCircularIndicator(
    double progress,
    Color progressColor,
    Color backgroundColor,
    double size,
    double strokeWidth,
  ) {
    return CircularProgressIndicator(
      value: widget.indefiniteWhenEmpty && progress == 0.0 ? null : progress,
      strokeWidth: strokeWidth,
      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
      backgroundColor: backgroundColor,
    );
  }

  Widget _buildDotsIndicator(
    double progress,
    Color progressColor,
    Color backgroundColor,
    double size,
  ) {
    const dotCount = 5;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(dotCount, (index) {
        final dotProgress = (progress * dotCount).clamp(
          0.0,
          dotCount.toDouble(),
        );
        final isActive =
            index < dotProgress.floor() ||
            (index == dotProgress.floor() &&
                (dotProgress - dotProgress.floor()) > 0.5);

        return AnimatedContainer(
          duration: widget.animationDuration,
          width: size / 10,
          height: size / 10,
          margin: EdgeInsets.symmetric(horizontal: size / 40),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? progressColor : backgroundColor,
          ),
        );
      }),
    );
  }

  Widget _buildWaveIndicator(
    double progress,
    Color progressColor,
    Color backgroundColor,
    double size,
  ) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              width: size * 0.8,
              height: size * 0.8,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: widget.strokeWidth ?? 4.0,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
          ),
          if (widget.indefiniteWhenEmpty && progress == 0.0)
            Center(
              child: Icon(Icons.waves, size: size * 0.4, color: progressColor),
            ),
        ],
      ),
    );
  }
}

/// Variants for progress animation styling.
enum ProgressAnimationVariant {
  /// Linear progress bar.
  linear,

  /// Circular progress indicator.
  circular,

  /// Animated dots pattern.
  dots,

  /// Wave-style circular indicator.
  wave,
}
