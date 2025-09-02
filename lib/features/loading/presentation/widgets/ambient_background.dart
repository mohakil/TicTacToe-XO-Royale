import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/services/animation_pool.dart';

class AmbientBackground extends StatefulWidget {
  const AmbientBackground({super.key});

  @override
  State<AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<AmbientBackground>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationPool.getController(
      vsync: this,
      poolName: 'loading',
      duration: const Duration(seconds: 8),
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    // Return controller to the pool instead of disposing it directly
    AnimationPool.returnController(_animationController, 'loading');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _animationController,
    builder: (context, child) => CustomPaint(
      painter: _AmbientBackgroundPainter(
        fadeValue: _fadeAnimation.value,
        rotationValue: _rotationAnimation.value,
      ),
      size: Size.infinite,
    ),
  );
}

class _AmbientBackgroundPainter extends CustomPainter {
  final double fadeValue;
  final double rotationValue;

  _AmbientBackgroundPainter({
    required this.fadeValue,
    required this.rotationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.overlay;

    // Create subtle geometric shapes that move slowly
    _drawFloatingShapes(canvas, size, paint);
    _drawGradientCircles(canvas, size, paint);
  }

  void _drawFloatingShapes(Canvas canvas, Size size, Paint paint) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw subtle geometric shapes
    for (var i = 0; i < 6; i++) {
      final angle = (i * pi / 3) + rotationValue * 0.1;
      final radius = 80.0 + 20.0 * sin(rotationValue * 0.5 + i);
      final x = center.dx + cos(angle) * radius;
      final y = center.dy + sin(angle) * radius;

      paint.color = Colors.white.withValues(alpha: 0.02 * fadeValue);

      if (i.isEven) {
        // Draw circles
        canvas.drawCircle(Offset(x, y), 8 + 4 * sin(rotationValue + i), paint);
      } else {
        // Draw squares
        final rect = Rect.fromCenter(
          center: Offset(x, y),
          width: 12 + 6 * sin(rotationValue + i),
          height: 12 + 6 * sin(rotationValue + i),
        );
        canvas.drawRect(rect, paint);
      }
    }
  }

  void _drawGradientCircles(Canvas canvas, Size size, Paint paint) {
    // Draw large, very subtle gradient circles
    final center = Offset(size.width / 2, size.height / 2);

    // Top-left gradient
    paint.shader = RadialGradient(
      colors: [
        Colors.blue.withValues(alpha: 0.01 * fadeValue),
        Colors.transparent,
      ],
      stops: const [0.0, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawCircle(Offset(center.dx - 100, center.dy - 100), 120, paint);

    // Bottom-right gradient
    paint.shader = RadialGradient(
      colors: [
        Colors.purple.withValues(alpha: 0.01 * fadeValue),
        Colors.transparent,
      ],
      stops: const [0.0, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawCircle(Offset(center.dx + 100, center.dy + 100), 100, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
