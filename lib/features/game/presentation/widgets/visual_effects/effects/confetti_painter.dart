import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/app/theme/theme_extensions.dart';

final Random _confettiRandom = Random();
const int _confettiParticleCount = 50;

/// Static Paint objects for confetti effects to improve performance
class _ConfettiPaints {
  // Confetti particle paint
  static final Paint _particlePaint = Paint()..style = PaintingStyle.fill;

  // Getters for accessing static paints
  static Paint get particlePaint => _particlePaint;
}

/// Optimized paint confetti effects
void paintConfetti(Canvas canvas, Size size, GameColors? gameColors) {
  final particles = _generateParticles(size);

  for (final particle in particles) {
    _drawParticle(canvas, particle);
  }
}

List<_ConfettiParticle> _generateParticles(Size size) {
  final particles = <_ConfettiParticle>[];

  for (var i = 0; i < _confettiParticleCount; i++) {
    particles.add(
      _ConfettiParticle(
        position: Offset(
          _confettiRandom.nextDouble() * size.width,
          _confettiRandom.nextDouble() * size.height,
        ),
        velocity: Offset(
          (_confettiRandom.nextDouble() - 0.5) * 200,
          (_confettiRandom.nextDouble() - 0.5) * 200,
        ),
        color: _getRandomConfettiColor(),
        size: _confettiRandom.nextDouble() * 8 + 4,
        rotation: _confettiRandom.nextDouble() * 2 * pi,
        rotationSpeed: (_confettiRandom.nextDouble() - 0.5) * 10,
        life: _confettiRandom.nextDouble() * 0.5 + 0.5,
      ),
    );
  }

  return particles;
}

Color _getRandomConfettiColor() {
  final colors = [
    const Color(0xFF2DD4FF), // Azure
    const Color(0xFFF43F9D), // Magenta
    const Color(0xFFA3E635), // Lime
    const Color(0xFFFFC24D), // Gold
    const Color(0xFFFFB020), // Amber
  ];

  return colors[_confettiRandom.nextInt(colors.length)];
}

void _drawParticle(Canvas canvas, _ConfettiParticle particle) {
  canvas
    ..save()
    // Apply rotation
    ..translate(particle.position.dx, particle.position.dy)
    ..rotate(particle.rotation);

  // Draw confetti piece
  final rect = Rect.fromCenter(
    center: Offset.zero,
    width: particle.size,
    height: particle.size * 0.3,
  );

  // Use static paint with particle color
  final paint = Paint()
    ..color = particle.color
    ..style = _ConfettiPaints.particlePaint.style;

  canvas
    ..drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(2)), paint)
    ..restore();
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
