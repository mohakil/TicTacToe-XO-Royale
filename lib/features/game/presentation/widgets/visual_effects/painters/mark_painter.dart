import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/app/theme/theme_extensions.dart';

// Static cached Paint objects for maximum performance
class _MarkPaints {
  static final Paint xPaint = Paint()
    ..color = const Color(0xFF2DD4FF)
    ..strokeWidth = 6.0
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  static final Paint oPaint = Paint()
    ..color = const Color(0xFFF43F9D)
    ..strokeWidth = 6.0
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  static final Paint xGlowPaint = Paint()
    ..color = const Color(0xFF2DD4FF)
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  static final Paint oGlowPaint = Paint()
    ..color = const Color(0xFFF43F9D)
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;
}

void paintMark(
  Canvas canvas,
  Rect cellRect,
  String mark,
  double animationValue,
  GameColors? gameColors, {
  double glowIntensity = 0.0, // 0.0 to 1.0 for glow effect
  bool enableShake = false,
  double shakeValue = 0.0, // 0.0 to 1.0 for shake effect
}) {
  // Always use maximum quality effects for best visual experience
  final effectiveGlowIntensity = glowIntensity; // Always use glow effects
  final effectiveShake = enableShake; // Always use high quality effects

  if (mark == 'X') {
    _paintX(
      canvas,
      cellRect,
      animationValue,
      effectiveGlowIntensity,
      effectiveShake,
      shakeValue,
    );
  } else if (mark == 'O') {
    _paintO(
      canvas,
      cellRect,
      animationValue,
      effectiveGlowIntensity,
      effectiveShake,
      shakeValue,
    );
  }
}

void _paintX(
  Canvas canvas,
  Rect cellRect,
  double animationValue,
  double glowIntensity,
  bool enableShake,
  double shakeValue,
) {
  final center = cellRect.center;
  final size = cellRect.width * 0.6;
  final halfSize = size / 2;

  // Apply shake effect if enabled
  final shakeOffset = enableShake ? 2.0 * shakeValue * (shakeValue - 1.0) : 0.0;
  final shakenCenter = center.translate(shakeOffset, 0);

  final firstStart = Offset(
    shakenCenter.dx - halfSize,
    shakenCenter.dy - halfSize,
  );
  final firstEnd = Offset(
    shakenCenter.dx + halfSize,
    shakenCenter.dy + halfSize,
  );

  // Always draw both strokes for visibility, animate if needed
  if (animationValue >= 1.0) {
    // Draw complete X
    canvas.drawLine(firstStart, firstEnd, _MarkPaints.xPaint);

    final secondStart = Offset(
      shakenCenter.dx + halfSize,
      shakenCenter.dy - halfSize,
    );
    final secondEnd = Offset(
      shakenCenter.dx - halfSize,
      shakenCenter.dy + halfSize,
    );
    canvas.drawLine(secondStart, secondEnd, _MarkPaints.xPaint);
  } else {
    // Animate first stroke using static paint
    final firstProgress = (animationValue * 2).clamp(0.0, 1.0);
    final firstCurrentEnd = Offset.lerp(firstStart, firstEnd, firstProgress)!;
    canvas.drawLine(firstStart, firstCurrentEnd, _MarkPaints.xPaint);

    // Second stroke (top-right to bottom-left) - starts after first stroke
    if (animationValue > 0.5) {
      final secondProgress = ((animationValue - 0.5) * 2).clamp(0.0, 1.0);
      final secondStart = Offset(
        shakenCenter.dx + halfSize,
        shakenCenter.dy - halfSize,
      );
      final secondEnd = Offset(
        shakenCenter.dx - halfSize,
        shakenCenter.dy + halfSize,
      );
      final secondCurrentEnd = Offset.lerp(
        secondStart,
        secondEnd,
        secondProgress,
      )!;

      canvas.drawLine(secondStart, secondCurrentEnd, _MarkPaints.xPaint);
    }
  }

  // Add animated glow effect when fully drawn
  if (animationValue >= 1.0 && glowIntensity > 0.0) {
    // Update static glow paint with current glow properties
    _MarkPaints.xGlowPaint
      ..color = const Color(0xFF2DD4FF).withValues(alpha: 0.3 * glowIntensity)
      ..strokeWidth = 8.0 + (4.0 * glowIntensity)
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        3.0 + (2.0 * glowIntensity),
      );

    final secondStart = Offset(
      shakenCenter.dx + halfSize,
      shakenCenter.dy - halfSize,
    );
    final secondEnd = Offset(
      shakenCenter.dx - halfSize,
      shakenCenter.dy + halfSize,
    );

    canvas
      ..drawLine(firstStart, firstEnd, _MarkPaints.xGlowPaint)
      ..drawLine(secondStart, secondEnd, _MarkPaints.xGlowPaint);
  }
}

void _paintO(
  Canvas canvas,
  Rect cellRect,
  double animationValue,
  double glowIntensity,
  bool enableShake,
  double shakeValue,
) {
  final center = cellRect.center;
  final radius = cellRect.width * 0.25;

  // Apply shake effect if enabled
  final shakeOffset = enableShake ? 2.0 * shakeValue * (shakeValue - 1.0) : 0.0;
  final shakenCenter = center.translate(shakeOffset, 0);

  // Always draw complete circle for visibility
  if (animationValue >= 1.0) {
    // Draw complete O
    canvas.drawCircle(shakenCenter, radius, _MarkPaints.oPaint);
  } else {
    // Animate circle drawing using static paint
    final sweepAngle = animationValue * 2 * 3.14159; // Full circle
    final rect = Rect.fromCircle(center: shakenCenter, radius: radius);

    // Start from top and sweep clockwise
    canvas.drawArc(rect, -3.14159 / 2, sweepAngle, false, _MarkPaints.oPaint);
  }

  // Add animated luminous edge effect when fully drawn
  if (animationValue >= 1.0 && glowIntensity > 0.0) {
    // Update static glow paint with current glow properties
    _MarkPaints.oGlowPaint
      ..color = const Color(0xFFF43F9D).withValues(alpha: 0.4 * glowIntensity)
      ..strokeWidth = 8.0 + (4.0 * glowIntensity)
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        2.0 + (3.0 * glowIntensity),
      );

    canvas.drawCircle(shakenCenter, radius, _MarkPaints.oGlowPaint);
  }
}

// Enhanced glow animation method
void paintMarkGlow(
  Canvas canvas,
  Rect cellRect,
  String mark,
  double glowAnimationValue,
  GameColors? gameColors,
) {
  if (mark == 'X') {
    _paintXGlow(canvas, cellRect, glowAnimationValue);
  } else if (mark == 'O') {
    _paintOGlow(canvas, cellRect, glowAnimationValue);
  }
}

void _paintXGlow(Canvas canvas, Rect cellRect, double glowAnimationValue) {
  final center = cellRect.center;
  final size = cellRect.width * 0.6;
  final halfSize = size / 2;

  // Create simple pulsing glow effect using linear interpolation
  final pulseValue = glowAnimationValue;

  // Update static glow paint with current glow properties
  _MarkPaints.xGlowPaint
    ..color = const Color(0xFF2DD4FF).withValues(alpha: 0.2 * pulseValue)
    ..strokeWidth = 10.0 + (4.0 * pulseValue)
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4.0 + (2.0 * pulseValue));

  final firstStart = Offset(center.dx - halfSize, center.dy - halfSize);
  final firstEnd = Offset(center.dx + halfSize, center.dy + halfSize);
  final secondStart = Offset(center.dx + halfSize, center.dy - halfSize);
  final secondEnd = Offset(center.dx - halfSize, center.dy + halfSize);

  canvas
    ..drawLine(firstStart, firstEnd, _MarkPaints.xGlowPaint)
    ..drawLine(secondStart, secondEnd, _MarkPaints.xGlowPaint);
}

void _paintOGlow(Canvas canvas, Rect cellRect, double glowAnimationValue) {
  final center = cellRect.center;
  final radius = cellRect.width * 0.25;

  // Create simple pulsing glow effect using linear interpolation
  final pulseValue = glowAnimationValue;

  // Update static glow paint with current glow properties
  _MarkPaints.oGlowPaint
    ..color = const Color(0xFFF43F9D).withValues(alpha: 0.3 * pulseValue)
    ..strokeWidth = 10.0 + (4.0 * pulseValue)
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3.0 + (2.0 * pulseValue));

  canvas.drawCircle(center, radius, _MarkPaints.oGlowPaint);
}
