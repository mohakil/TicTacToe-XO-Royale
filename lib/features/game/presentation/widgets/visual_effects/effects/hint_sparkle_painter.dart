import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/app/theme/theme_extensions.dart';

const int _hintSparkleCount = 8;

/// Static Paint objects for hint sparkle effects to improve performance
class _HintSparklePaints {
  // Sparkle line paint
  static final Paint _sparklePaint = Paint()
    ..color = const Color(0xFFFFB020)
    ..strokeWidth = 2.0
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  // Sparkle glow paint
  static final Paint _sparkleGlowPaint = Paint()
    ..color = const Color(0xFFFFB020)
    ..strokeWidth = 4.0
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

  // Central glow paint
  static final Paint _centralGlowPaint = Paint()
    ..color = const Color(0xFFFFB020)
    ..style = PaintingStyle.fill
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

  // Getters for accessing static paints
  static Paint get sparklePaint => _sparklePaint;
  static Paint get sparkleGlowPaint => _sparkleGlowPaint;
  static Paint get centralGlowPaint => _centralGlowPaint;
}

/// Optimized paint hint sparkle effects
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

  // Draw cross sparkle using static paint
  final paint = Paint()
    ..color = _HintSparklePaints.sparklePaint.color.withValues(alpha: alpha)
    ..strokeWidth = _HintSparklePaints.sparklePaint.strokeWidth
    ..strokeCap = _HintSparklePaints.sparklePaint.strokeCap
    ..style = _HintSparklePaints.sparklePaint.style;

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

  // Add glow effect using static paint
  final glowPaint = Paint()
    ..color = _HintSparklePaints.sparkleGlowPaint.color.withValues(
      alpha: alpha * 0.5,
    )
    ..strokeWidth = _HintSparklePaints.sparkleGlowPaint.strokeWidth
    ..strokeCap = _HintSparklePaints.sparkleGlowPaint.strokeCap
    ..style = _HintSparklePaints.sparkleGlowPaint.style
    ..maskFilter = _HintSparklePaints.sparkleGlowPaint.maskFilter;

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
  // Use static paint with animated opacity
  final glowPaint = Paint()
    ..color = _HintSparklePaints.centralGlowPaint.color.withValues(
      alpha: 0.3 * animationValue,
    )
    ..style = _HintSparklePaints.centralGlowPaint.style
    ..maskFilter = _HintSparklePaints.centralGlowPaint.maskFilter;

  final glowRadius = radius * (0.5 + 0.5 * animationValue);
  canvas.drawCircle(center, glowRadius, glowPaint);
}
