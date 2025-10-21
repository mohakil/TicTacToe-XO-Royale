import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';

/// Countdown overlay that appears when the game starts
/// Shows 3, 2, 1, GO! animation before gameplay begins
class GameCountdownOverlay extends StatefulWidget {
  /// Callback when countdown completes
  final VoidCallback onComplete;

  /// Duration for each countdown number
  final Duration countdownDuration;

  const GameCountdownOverlay({
    super.key,
    required this.onComplete,
    this.countdownDuration = const Duration(milliseconds: 800),
  });

  @override
  State<GameCountdownOverlay> createState() => _GameCountdownOverlayState();
}

class _GameCountdownOverlayState extends State<GameCountdownOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  int _currentCount = 3;
  Timer? _countdownTimer;
  bool _showGo = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: widget.countdownDuration,
    );

    // Scale animation (bounce effect)
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Start countdown
    _startCountdown();
  }

  void _startCountdown() {
    // Animate first number
    _animationController.forward();

    // Start timer for countdown sequence
    _countdownTimer = Timer.periodic(widget.countdownDuration, (timer) {
      if (_currentCount > 1) {
        setState(() {
          _currentCount--;
          _animationController.reset();
          _animationController.forward();
        });
      } else {
        // Show "GO!" after countdown
        setState(() {
          _showGo = true;
          _animationController.reset();
          _animationController.forward();
        });

        // Complete countdown after showing GO!
        Future.delayed(widget.countdownDuration, () {
          timer.cancel();
          widget.onComplete();
        });
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colorScheme.surface.withValues(alpha: 0.95),
      child: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Countdown number or GO text
                    if (!_showGo)
                      Text(
                        '$_currentCount',
                        style: context.getResponsiveTextStyle(
                          textTheme.displayLarge!.copyWith(
                            fontSize: 120,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                            shadows: [
                              Shadow(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          phoneSize: 100,
                          tabletSize: 140,
                        ),
                      )
                    else
                      Column(
                        children: [
                          Text(
                            'GO!',
                            style: context.getResponsiveTextStyle(
                              textTheme.displayLarge!.copyWith(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.secondary,
                                shadows: [
                                  Shadow(
                                    color: colorScheme.secondary.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 20,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              phoneSize: 80,
                              tabletSize: 120,
                            ),
                          ),
                          SizedBox(height: context.getResponsiveSpacing()),
                          Text(
                            'Good Luck!',
                            style: context.getResponsiveTextStyle(
                              textTheme.titleLarge!.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.7,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                    // Decorative circle behind the number
                    if (!_showGo)
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: Container(
                          width: 200,
                          height: 4,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.primary.withValues(alpha: 0.0),
                                colorScheme.primary,
                                colorScheme.primary.withValues(alpha: 0.0),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
