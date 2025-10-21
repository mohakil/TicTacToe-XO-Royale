import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tictactoe_xo_royale/core/services/animation_pool.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';

/// A reusable animated card component that encapsulates complex card animations.
///
/// Provides consistent hover/press animations with performance optimization
/// through animation controller pooling and haptic feedback integration.
///
/// **Usage:**
/// ```dart
/// AnimatedCard(
///   animation: CardAnimationConfig.standard,
///   child: Text('Interactive Card'),
///   onTap: () => print('Card tapped'),
/// )
/// ```
class AnimatedCard extends StatefulWidget {
  /// The child widget to animate.
  final Widget child;

  /// The animation configuration for the card.
  final CardAnimationConfig animation;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  /// Whether to enable haptic feedback on tap.
  final bool enableHapticFeedback;

  /// Custom duration for the animation.
  final Duration? duration;

  /// Whether to use RepaintBoundary for performance optimization.
  final bool useRepaintBoundary;

  /// Custom elevation range for the animation.
  final double? minElevation;

  /// Custom elevation range for the animation.
  final double? maxElevation;

  const AnimatedCard({
    required this.child,
    this.animation = CardAnimationConfig.standard,
    this.onTap,
    this.enableHapticFeedback = true,
    this.duration,
    this.useRepaintBoundary = true,
    this.minElevation,
    this.maxElevation,
    super.key,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<Offset> _parallaxAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
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
      duration: widget.duration ?? const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.animation.scaleEnd)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: widget.animation.scaleCurve,
          ),
        );

    _parallaxAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: widget.animation.parallaxOffset,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: widget.animation.parallaxCurve,
          ),
        );

    _elevationAnimation =
        Tween<double>(
          begin: widget.minElevation ?? widget.animation.minElevation,
          end: widget.maxElevation ?? widget.animation.maxElevation,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: widget.animation.elevationCurve,
          ),
        );
  }

  void _onHoverChanged(bool isHovered) {
    if (mounted) {
      setState(() {
        // _isHovered is no longer used, but keeping for compatibility
      });
    }

    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onTapDown(TapDownDetails details) {
    if (mounted) {
      setState(() {
        _isPressed = true;
      });
    }

    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (mounted) {
      setState(() {
        _isPressed = false;
      });
    }
  }

  void _onTapCancel() {
    if (mounted) {
      setState(() {
        _isPressed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardContent = AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _isPressed ? 0.96 : _scaleAnimation.value,
          child: Transform.translate(
            offset: _parallaxAnimation.value,
            child: Card(
              elevation: _elevationAnimation.value,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.scale(12.0)),
              ),
              child: widget.child,
            ),
          ),
        );
      },
    );

    // Wrap in gesture detectors for interaction
    Widget interactiveCard = MouseRegion(
      onEnter: (_) => _onHoverChanged(true),
      onExit: (_) => _onHoverChanged(false),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onTap,
        child: cardContent,
      ),
    );

    // Wrap in RepaintBoundary for performance if requested
    if (widget.useRepaintBoundary) {
      interactiveCard = RepaintBoundary(child: interactiveCard);
    }

    return interactiveCard;
  }
}

/// Configuration for card animations.
class CardAnimationConfig {
  /// The end scale value for hover animations.
  final double scaleEnd;

  /// The parallax offset for hover animations.
  final Offset parallaxOffset;

  /// The minimum elevation for animations.
  final double minElevation;

  /// The maximum elevation for animations.
  final double maxElevation;

  /// The curve for scale animations.
  final Curve scaleCurve;

  /// The curve for parallax animations.
  final Curve parallaxCurve;

  /// The curve for elevation animations.
  final Curve elevationCurve;

  /// Standard animation configuration with moderate effects.
  static const CardAnimationConfig standard = CardAnimationConfig(
    scaleEnd: 1.02,
    parallaxOffset: Offset(0, -2),
    minElevation: 0,
    maxElevation: 8,
    scaleCurve: Curves.easeOutCubic,
    parallaxCurve: Curves.easeOutCubic,
    elevationCurve: Curves.easeOutCubic,
  );

  /// Subtle animation configuration with minimal effects.
  static const CardAnimationConfig subtle = CardAnimationConfig(
    scaleEnd: 1.01,
    parallaxOffset: Offset(0, -1),
    minElevation: 0,
    maxElevation: 4,
    scaleCurve: Curves.easeInOut,
    parallaxCurve: Curves.easeInOut,
    elevationCurve: Curves.easeInOut,
  );

  /// Enhanced animation configuration with stronger effects.
  static const CardAnimationConfig enhanced = CardAnimationConfig(
    scaleEnd: 1.05,
    parallaxOffset: Offset(0, -4),
    minElevation: 0,
    maxElevation: 12,
    scaleCurve: Curves.easeOutBack,
    parallaxCurve: Curves.easeOutBack,
    elevationCurve: Curves.easeOutBack,
  );

  /// No animation configuration.
  static const CardAnimationConfig none = CardAnimationConfig(
    scaleEnd: 1.0,
    parallaxOffset: Offset.zero,
    minElevation: 0,
    maxElevation: 0,
    scaleCurve: Curves.linear,
    parallaxCurve: Curves.linear,
    elevationCurve: Curves.linear,
  );

  const CardAnimationConfig({
    required this.scaleEnd,
    required this.parallaxOffset,
    required this.minElevation,
    required this.maxElevation,
    required this.scaleCurve,
    required this.parallaxCurve,
    required this.elevationCurve,
  });
}
