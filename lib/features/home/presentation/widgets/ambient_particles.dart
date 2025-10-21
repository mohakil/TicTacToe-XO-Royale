import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/services/animation_pool.dart';

/// Ambient floating X/O shapes with subtle animations
/// Creates a background effect with floating game symbols
class AmbientParticles extends StatefulWidget {
  const AmbientParticles({
    super.key,
    this.particleCount = 5, // Reduced from 8 for better performance
    this.opacity = 0.03, // Reduced opacity for better performance
    this.movementSpeed = 0.15, // Slightly reduced speed
  });

  final int particleCount;
  final double opacity;
  final double movementSpeed;

  @override
  State<AmbientParticles> createState() => _AmbientParticlesState();
}

class _AmbientParticlesState extends State<AmbientParticles>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<Offset> _positions;
  late List<bool> _isX;
  late List<double> _sizes;
  late List<double> _speeds;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      widget.particleCount,
      (index) => AnimationPool.getController(
        vsync: this,
        poolName: 'home',
        duration: Duration(
          milliseconds: (6000 + index * 400).toInt(),
        ), // Reduced durations
      ),
    );

    _animations = _controllers
        .map(
          (controller) => Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          ),
        )
        .toList();

    _positions = List.generate(
      widget.particleCount,
      (index) => Offset(
        math.Random().nextDouble() * 400 - 200,
        math.Random().nextDouble() * 400 - 200,
      ),
    );

    _isX = List.generate(
      widget.particleCount,
      (index) => math.Random().nextBool(),
    );

    _sizes = List.generate(
      widget.particleCount,
      (index) => 20 + math.Random().nextDouble() * 30,
    );

    _speeds = List.generate(
      widget.particleCount,
      (index) => widget.movementSpeed * (0.5 + math.Random().nextDouble()),
    );

    // Start all animations
    for (final controller in _controllers) {
      controller.repeat();
    }
  }

  @override
  void dispose() {
    // Return controllers to the pool instead of disposing them directly
    for (final controller in _controllers) {
      AnimationPool.returnController(controller, 'home');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox.expand(
    child: Stack(
      children: List.generate(
        widget.particleCount,
        (index) => AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            final animation = _animations[index];
            final progress = animation.value;

            // Calculate position with gentle floating movement
            final x =
                _positions[index].dx +
                math.sin(progress * 2 * math.pi) * 50 * _speeds[index];
            final y =
                _positions[index].dy +
                math.cos(progress * 2 * math.pi) * 30 * _speeds[index];

            return Positioned(
              left: x,
              top: y,
              child: Opacity(
                opacity: widget.opacity,
                child: _isX[index]
                    ? _buildX(_sizes[index])
                    : _buildO(_sizes[index]),
              ),
            );
          },
        ),
      ),
    ),
  );

  Widget _buildX(double size) =>
      CustomPaint(size: Size(size, size), painter: _XPainter());

  Widget _buildO(double size) =>
      CustomPaint(size: Size(size, size), painter: _OPainter());
}

/// Custom painter for X symbol
class _XPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final padding = size.width * 0.2;
    final startX = padding;
    final endX = size.width - padding;
    final startY = padding;
    final endY = size.height - padding;

    // Draw X
    canvas
      ..drawLine(Offset(startX, startY), Offset(endX, endY), paint)
      ..drawLine(Offset(startX, endY), Offset(endX, startY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for O symbol
class _OPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - size.width * 0.4) / 2;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
