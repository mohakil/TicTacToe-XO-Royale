import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/services/animation_pool.dart';

/// A reusable widget for fade/slide animation patterns.
///
/// Consolidates common animation patterns used across features,
/// particularly in home and loading screens for smooth content transitions.
///
/// **Usage:**
/// ```dart
/// AnimatedSection(
///   animationType: AnimationType.fadeSlide,
///   duration: const Duration(milliseconds: 800),
///   child: Text('Animated content'),
/// )
/// ```
class AnimatedSection extends StatefulWidget {
  /// The child widget to animate.
  final Widget child;

  /// The type of animation to apply.
  final AnimationType animationType;

  /// The duration for the animation.
  final Duration duration;

  /// Delay before starting the animation.
  final Duration delay;

  /// The direction for slide animations.
  final Axis slideDirection;

  /// Custom curve for the animation.
  final Curve? curve;

  /// Whether to use RepaintBoundary for performance optimization.
  final bool useRepaintBoundary;

  /// Whether to begin animation automatically when widget is built.
  final bool autoStart;

  /// Callback when animation completes.
  final VoidCallback? onAnimationComplete;

  const AnimatedSection({
    required this.child,
    this.animationType = AnimationType.fadeSlide,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.slideDirection = Axis.vertical,
    this.curve,
    this.useRepaintBoundary = false,
    this.autoStart = true,
    this.onAnimationComplete,
    super.key,
  });

  @override
  State<AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<AnimatedSection>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  bool _animationStarted = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    if (widget.autoStart) {
      _startAnimationWithDelay();
    }
  }

  @override
  void didUpdateWidget(AnimatedSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Restart animation if key parameters changed
    if (oldWidget.duration != widget.duration ||
        oldWidget.curve != widget.curve ||
        oldWidget.animationType != widget.animationType) {
      _animationController.dispose();
      _initializeAnimations();

      if (widget.autoStart) {
        _startAnimationWithDelay();
      }
    }
  }

  @override
  void dispose() {
    // Return controller to the pool instead of disposing it directly
    AnimationPool.returnController(_animationController, 'ui');
    super.dispose();
  }

  void _initializeAnimations() {
    // Get controller from pool for better performance
    _animationController = AnimationPool.getController(
      vsync: this,
      poolName: 'ui',
      duration: widget.duration,
    );

    final animationCurve = widget.curve ?? Curves.easeOut;

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: animationCurve),
    );

    // Slide animation
    final slideBegin = _getSlideBeginOffset();
    final slideEnd = Offset.zero;

    _slideAnimation = Tween<Offset>(begin: slideBegin, end: slideEnd).animate(
      CurvedAnimation(parent: _animationController, curve: animationCurve),
    );

    // Scale animation for scale-only animations
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: animationCurve),
    );

    // Listen for animation completion
    _animationController.addStatusListener(_onAnimationStatusChanged);
  }

  void _startAnimationWithDelay() {
    if (widget.delay > Duration.zero) {
      Future.delayed(widget.delay, () {
        if (mounted && !_animationStarted) {
          _startAnimation();
        }
      });
    } else {
      _startAnimation();
    }
  }

  void _startAnimation() {
    if (mounted && !_animationStarted) {
      setState(() {
        _animationStarted = true;
      });
      _animationController.forward();
    }
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed &&
        widget.onAnimationComplete != null) {
      widget.onAnimationComplete!();
    }
  }

  Offset _getSlideBeginOffset() {
    switch (widget.animationType) {
      case AnimationType.fadeSlide:
      case AnimationType.slideIn:
        switch (widget.slideDirection) {
          case Axis.vertical:
            return const Offset(0, 0.3); // Slide up from bottom
          case Axis.horizontal:
            return const Offset(-0.3, 0); // Slide in from left
        }
      case AnimationType.fadeIn:
      case AnimationType.scaleIn:
        return Offset.zero; // No slide offset
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_animationStarted) {
      // Show nothing until animation starts
      return const SizedBox.shrink();
    }

    final animatedChild = AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        Widget animatedWidget = child!;

        // Apply animations based on type
        switch (widget.animationType) {
          case AnimationType.fadeIn:
            animatedWidget = FadeTransition(
              opacity: _fadeAnimation,
              child: animatedWidget,
            );
            break;

          case AnimationType.slideIn:
            animatedWidget = SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: animatedWidget,
              ),
            );
            break;

          case AnimationType.fadeSlide:
            animatedWidget = FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: animatedWidget,
              ),
            );
            break;

          case AnimationType.scaleIn:
            animatedWidget = FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: animatedWidget,
              ),
            );
            break;
        }

        return animatedWidget;
      },
      child: widget.child,
    );

    // Apply RepaintBoundary if requested
    if (widget.useRepaintBoundary) {
      return RepaintBoundary(child: animatedChild);
    }

    return animatedChild;
  }

  /// Start the animation programmatically.
  void startAnimation() {
    _startAnimation();
  }

  /// Reset the animation to initial state.
  void resetAnimation() {
    if (mounted) {
      setState(() {
        _animationStarted = false;
      });
      _animationController.reset();
    }
  }

  /// Check if animation is currently running.
  bool get isAnimating => _animationController.isAnimating;

  /// Check if animation has completed.
  bool get isCompleted => _animationController.isCompleted;
}

/// Types of animations supported by AnimatedSection.
enum AnimationType {
  /// Fade in only.
  fadeIn,

  /// Slide in with fade.
  slideIn,

  /// Fade and slide combined (most common).
  fadeSlide,

  /// Scale in with fade.
  scaleIn,
}
