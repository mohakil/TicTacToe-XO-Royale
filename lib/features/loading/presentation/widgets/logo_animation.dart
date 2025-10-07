import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/services/animation_pool.dart';

class LogoAnimation extends StatefulWidget {
  const LogoAnimation({super.key});

  @override
  State<LogoAnimation> createState() => _LogoAnimationState();
}

class _LogoAnimationState extends State<LogoAnimation>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;
  late Animation<Color?> _glowColorAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for subtle scaling - get from pool
    _pulseController = AnimationPool.getController(
      vsync: this,
      poolName: 'loading',
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Glow animation for color transition - get from pool
    _glowController = AnimationPool.getController(
      vsync: this,
      poolName: 'loading',
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _glowColorAnimation =
        ColorTween(
          begin: const Color(0xFF2DD4FF), // Azure
          end: const Color(0xFFF43F9D), // Magenta
        ).animate(
          CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    // Return controllers to the pool instead of disposing them directly
    AnimationPool.returnController(_pulseController, 'loading');
    AnimationPool.returnController(_glowController, 'loading');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _glowController]),
      builder: (context, child) => Transform.scale(
        scale: _pulseAnimation.value,
        child: Container(
          padding: EdgeInsets.all(
            context.getResponsiveSpacing(
              phoneSpacing: 16.0,
              tabletSpacing: 24.0,
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: context.getResponsiveBorderRadius(
              phoneRadius: 16.0,
              tabletRadius: 20.0,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    _glowColorAnimation.value?.withValues(
                      alpha: 0.3 * _glowAnimation.value,
                    ) ??
                    Colors.transparent,
                blurRadius: context.getResponsiveSpacing(
                  phoneSpacing: 16.0,
                  tabletSpacing: 24.0,
                ),
                spreadRadius: context.getResponsiveSpacing(
                  phoneSpacing: 6.0,
                  tabletSpacing: 8.0,
                ),
              ),
            ],
          ),
          child: Text(
            'XO',
            style: context.getResponsiveTextStyle(
              theme.textTheme.displayLarge!.copyWith(
                fontFamily: 'Sora',
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
                letterSpacing: -0.4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
