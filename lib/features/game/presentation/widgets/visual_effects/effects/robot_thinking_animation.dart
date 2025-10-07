import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/services/animation_pool.dart';

/// Animated thinking indicator for robot moves
/// Shows animated dots that pulse to indicate robot is thinking
class RobotThinkingAnimation extends StatefulWidget {
  final Color dotColor;

  const RobotThinkingAnimation({
    super.key,
    this.dotColor = Colors.grey, // Default fallback color
  });

  @override
  State<RobotThinkingAnimation> createState() => _RobotThinkingAnimationState();
}

class _RobotThinkingAnimationState extends State<RobotThinkingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Get animation controller from pool
    _animationController = AnimationPool.getController(
      vsync: this,
      poolName: 'robot_thinking',
      duration: const Duration(milliseconds: 1200),
    );

    // Pulse animation for opacity changes
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.3,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.3,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_animationController);

    // Scale animation for subtle size changes
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.8,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.2,
          end: 0.8,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_animationController);

    // Start the animation
    _animationController.repeat();
  }

  @override
  void dispose() {
    // Return controller to pool instead of disposing
    AnimationPool.returnController(_animationController, 'robot_thinking');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            // Each dot will use its index for staggered animation

            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: context.getResponsiveSpacing(
                  phoneSpacing: 2.0,
                  tabletSpacing: 3.0,
                ),
              ),
              child: Opacity(
                opacity: _pulseAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: context.getResponsiveIconSize(
                      phoneSize: 8.0,
                      tabletSize: 10.0,
                    ),
                    height: context.getResponsiveIconSize(
                      phoneSize: 8.0,
                      tabletSize: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: widget.dotColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
