import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/app/theme/theme_extensions.dart';

const int _hintSparkleCount = 8;

void paintHintSparkle(
  Canvas canvas,
  Rect cellRect,
  double animationValue,
  GameColors? gameColors,
) {
  final center = cellRect.center;
  final radius = cellRect.width * 0.3;

  // Draw sparkles around the cell
  for (var i = 0; i < _hintSparkleCount; i++) {
    final angle = (i / _hintSparkleCount) * 2 * pi;
    final sparkleRadius = radius * (0.8 + 0.4 * animationValue);

    final position = Offset(
      center.dx + cos(angle) * sparkleRadius,
      center.dy + sin(angle) * sparkleRadius,
    );

    _drawHintSparkle(canvas, position, animationValue);
  }

  // Draw central glow
  _drawCentralGlow(canvas, center, radius, animationValue);
}

void _drawHintSparkle(Canvas canvas, Offset position, double animationValue) {
  final size = 4.0 * animationValue;
  final alpha = (1.0 - animationValue).clamp(0.0, 1.0);

  // Draw cross sparkle
  final paint = Paint()
    ..color = const Color(0xFFFFB020).withValues(alpha: alpha)
    ..strokeWidth = 2.0
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  // Horizontal line
  canvas
    ..drawLine(
      Offset(position.dx - size, position.dy),
      Offset(position.dx + size, position.dy),
      paint,
    )
    // Vertical line
    ..drawLine(
      Offset(position.dx, position.dy - size),
      Offset(position.dx, position.dy + size),
      paint,
    );

  // Add glow effect
  final glowPaint = Paint()
    ..color = const Color(0xFFFFB020).withValues(alpha: alpha * 0.5)
    ..strokeWidth = 4.0
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

  canvas
    ..drawLine(
      Offset(position.dx - size, position.dy),
      Offset(position.dx + size, position.dy),
      glowPaint,
    )
    ..drawLine(
      Offset(position.dx, position.dy - size),
      Offset(position.dx, position.dy + size),
      glowPaint,
    );
}

void _drawCentralGlow(
  Canvas canvas,
  Offset center,
  double radius,
  double animationValue,
) {
  final glowPaint = Paint()
    ..color = const Color(0xFFFFB020).withValues(alpha: 0.3 * animationValue)
    ..style = PaintingStyle.fill
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

  final glowRadius = radius * (0.5 + 0.5 * animationValue);
  canvas.drawCircle(center, glowRadius, glowPaint);
}
