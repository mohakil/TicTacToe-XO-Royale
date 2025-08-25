import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiPainter {
  static final Random _random = Random();
  static const int _particleCount = 50;

  static void paint(Canvas canvas, Size size, dynamic gameColors) {
    final particles = _generateParticles(size);

    for (final particle in particles) {
      _drawParticle(canvas, particle);
    }
  }

  static List<_ConfettiParticle> _generateParticles(Size size) {
    final particles = <_ConfettiParticle>[];

    for (int i = 0; i < _particleCount; i++) {
      particles.add(
        _ConfettiParticle(
          position: Offset(
            _random.nextDouble() * size.width,
            _random.nextDouble() * size.height,
          ),
          velocity: Offset(
            (_random.nextDouble() - 0.5) * 200,
            (_random.nextDouble() - 0.5) * 200,
          ),
          color: _getRandomColor(),
          size: _random.nextDouble() * 8 + 4,
          rotation: _random.nextDouble() * 2 * pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 10,
          life: _random.nextDouble() * 0.5 + 0.5,
        ),
      );
    }

    return particles;
  }

  static Color _getRandomColor() {
    final colors = [
      const Color(0xFF2DD4FF), // Azure
      const Color(0xFFF43F9D), // Magenta
      const Color(0xFFA3E635), // Lime
      const Color(0xFFFFC24D), // Gold
      const Color(0xFFFFB020), // Amber
    ];

    return colors[_random.nextInt(colors.length)];
  }

  static void _drawParticle(Canvas canvas, _ConfettiParticle particle) {
    canvas.save();

    // Apply rotation
    canvas.translate(particle.position.dx, particle.position.dy);
    canvas.rotate(particle.rotation);

    // Draw confetti piece
    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: particle.size,
      height: particle.size * 0.3,
    );

    final paint = Paint()
      ..color = particle.color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2)),
      paint,
    );

    canvas.restore();
  }
}

class _ConfettiParticle {
  final Offset position;
  final Offset velocity;
  final Color color;
  final double size;
  final double rotation;
  final double rotationSpeed;
  final double life;

  _ConfettiParticle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
    required this.life,
  });
}
