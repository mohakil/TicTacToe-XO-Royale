import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/app/theme/theme_extensions.dart';

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
  if (mark == 'X') {
    _paintX(
      canvas,
      cellRect,
      animationValue,
      glowIntensity,
      enableShake,
      shakeValue,
    );
  } else if (mark == 'O') {
    _paintO(
      canvas,
      cellRect,
      animationValue,
      glowIntensity,
      enableShake,
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

  // X mark color - using default azure color
  const xColor = Color(0xFF2DD4FF);

  // First stroke (top-left to bottom-right)
  final firstStrokePaint = Paint()
    ..color = xColor
    ..strokeWidth = 4.0
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  final firstStart = Offset(
    shakenCenter.dx - halfSize,
    shakenCenter.dy - halfSize,
  );
  final firstEnd = Offset(
    shakenCenter.dx + halfSize,
    shakenCenter.dy + halfSize,
  );

  // Animate first stroke
  final firstProgress = (animationValue * 2).clamp(0.0, 1.0);
  final firstCurrentEnd = Offset.lerp(firstStart, firstEnd, firstProgress)!;
  canvas.drawLine(firstStart, firstCurrentEnd, firstStrokePaint);

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

    canvas.drawLine(secondStart, secondCurrentEnd, firstStrokePaint);

    // Add animated glow effect when fully drawn
    if (animationValue >= 1.0 && glowIntensity > 0.0) {
      final glowPaint = Paint()
        ..color = xColor.withValues(alpha: 0.3 * glowIntensity)
        ..strokeWidth = 6.0 + (4.0 * glowIntensity)
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          3.0 + (2.0 * glowIntensity),
        );

      canvas
        ..drawLine(firstStart, firstEnd, glowPaint)
        ..drawLine(secondStart, secondEnd, glowPaint);
    }
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

  // O mark color - using default magenta color
  const oColor = Color(0xFFF43F9D);

  final circlePaint = Paint()
    ..color = oColor
    ..strokeWidth = 4.0
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  // Animate circle drawing
  final sweepAngle = animationValue * 2 * 3.14159; // Full circle
  final rect = Rect.fromCircle(center: shakenCenter, radius: radius);

  // Start from top and sweep clockwise
  canvas.drawArc(rect, -3.14159 / 2, sweepAngle, false, circlePaint);

  // Add animated luminous edge effect when fully drawn
  if (animationValue >= 1.0 && glowIntensity > 0.0) {
    final glowPaint = Paint()
      ..color = oColor.withValues(alpha: 0.4 * glowIntensity)
      ..strokeWidth = 6.0 + (4.0 * glowIntensity)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        2.0 + (3.0 * glowIntensity),
      );

    canvas.drawCircle(shakenCenter, radius, glowPaint);
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

  const xColor = Color(0xFF2DD4FF);

  // Create simple pulsing glow effect using linear interpolation
  final pulseValue = glowAnimationValue;
  final glowPaint = Paint()
    ..color = xColor.withValues(alpha: 0.2 * pulseValue)
    ..strokeWidth = 8.0 + (4.0 * pulseValue)
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4.0 + (2.0 * pulseValue));

  final firstStart = Offset(center.dx - halfSize, center.dy - halfSize);
  final firstEnd = Offset(center.dx + halfSize, center.dy + halfSize);
  final secondStart = Offset(center.dx + halfSize, center.dy - halfSize);
  final secondEnd = Offset(center.dx - halfSize, center.dy + halfSize);

  canvas
    ..drawLine(firstStart, firstEnd, glowPaint)
    ..drawLine(secondStart, secondEnd, glowPaint);
}

void _paintOGlow(Canvas canvas, Rect cellRect, double glowAnimationValue) {
  final center = cellRect.center;
  final radius = cellRect.width * 0.25;

  const oColor = Color(0xFFF43F9D);

  // Create simple pulsing glow effect using linear interpolation
  final pulseValue = glowAnimationValue;
  final glowPaint = Paint()
    ..color = oColor.withValues(alpha: 0.3 * pulseValue)
    ..strokeWidth = 8.0 + (4.0 * pulseValue)
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3.0 + (2.0 * pulseValue));

  canvas.drawCircle(center, radius, glowPaint);
}
