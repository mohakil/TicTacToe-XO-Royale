import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/services/animation_pool.dart';

class ProgressBar extends StatefulWidget {
  final double progress;
  final Duration duration;

  const ProgressBar({
    required this.progress,
    super.key,
    this.duration = const Duration(milliseconds: 2000),
  });

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationPool.getController(
      vsync: this,
      poolName: 'loading',
      duration: widget.duration,
    );

    _progressAnimation = Tween<double>(begin: 0, end: widget.progress).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void didUpdateWidget(ProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation =
          Tween<double>(
            begin: _progressAnimation.value,
            end: widget.progress,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            ),
          );
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    // Return controller to the pool instead of disposing it directly
    AnimationPool.returnController(_animationController, 'loading');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) => Container(
        width: double.infinity,
        height: context.getResponsiveSpacing(
          phoneSpacing: 6.0,
          tabletSpacing: 8.0,
        ),
        decoration: BoxDecoration(
          borderRadius: context.getResponsiveBorderRadius(
            phoneRadius: 3.0,
            tabletRadius: 4.0,
          ),
          color: theme.colorScheme.surfaceContainer,
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: ClipRRect(
          borderRadius: context.getResponsiveBorderRadius(
            phoneRadius: 3.0,
            tabletRadius: 4.0,
          ),
          child: LinearProgressIndicator(
            value: _progressAnimation.value,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(_getGradientColor(theme)),
          ),
        ),
      ),
    );
  }

  Color _getGradientColor(ThemeData theme) {
    // Create a subtle gradient effect using the primary color
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;

    // Blend colors based on progress for a subtle gradient effect
    final progress = _progressAnimation.value;
    return Color.lerp(primaryColor, secondaryColor, progress * 0.3)!;
  }
}
