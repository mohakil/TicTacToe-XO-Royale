import 'package:flutter/material.dart';

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

    // Pulse animation for subtle scaling
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // Glow animation for color transition
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
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
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _glowController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color:
                      _glowColorAnimation.value?.withValues(
                        alpha: 0.3 * _glowAnimation.value,
                      ) ??
                      Colors.transparent,
                  blurRadius: 24,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Text(
              'XO',
              style: theme.textTheme.displayLarge?.copyWith(
                fontFamily: 'Sora',
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
                letterSpacing: -0.4,
              ),
            ),
          ),
        );
      },
    );
  }
}
