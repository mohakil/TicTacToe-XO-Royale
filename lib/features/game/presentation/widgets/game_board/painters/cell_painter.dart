import 'package:flutter/material.dart';

class CellPainter {
  static void paintHover(
    Canvas canvas,
    Rect cellRect,
    Paint hoverPaint,
    dynamic gameColors,
    double hoverAnimationValue, // 0.0 to 1.0 for animation
  ) {
    // Animate hover effect with scale and opacity
    final scale = 0.95 + (0.05 * hoverAnimationValue);
    final animatedRect = Rect.fromCenter(
      center: cellRect.center,
      width: cellRect.width * scale,
      height: cellRect.height * scale,
    );

    // Draw subtle hover effect with rounded corners
    final roundedRect = RRect.fromRectAndRadius(
      animatedRect,
      const Radius.circular(8.0),
    );

    // Animate opacity for smooth appearance
    final animatedPaint = Paint()
      ..color = hoverPaint.color.withValues(
        alpha: (hoverPaint.color.a / 255.0) * hoverAnimationValue,
      )
      ..style = hoverPaint.style;

    canvas.drawRRect(roundedRect, animatedPaint);

    // Add animated glow effect
    final glowPaint = Paint()
      ..color = const Color(
        0xFFF1F5F9,
      ).withValues(alpha: 0.3 * hoverAnimationValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0 + (2.0 * hoverAnimationValue)
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        2.0 + (3.0 * hoverAnimationValue),
      );

    canvas.drawRRect(roundedRect, glowPaint);
  }

  static void paintPressed(
    Canvas canvas,
    Rect cellRect,
    dynamic gameColors,
    double pressedAnimationValue,
  ) {
    // Animate pressed state with scale effect
    final scale = 1.0 - (0.04 * pressedAnimationValue);
    final pressedRect = Rect.fromCenter(
      center: cellRect.center,
      width: cellRect.width * scale,
      height: cellRect.height * scale,
    );

    final pressedPaint = Paint()
      ..color = const Color(
        0xFFE2E8F0,
      ).withValues(alpha: 0.8 * pressedAnimationValue)
      ..style = PaintingStyle.fill;

    final roundedRect = RRect.fromRectAndRadius(
      pressedRect,
      const Radius.circular(8.0),
    );

    canvas.drawRRect(roundedRect, pressedPaint);

    // Add subtle shadow effect when pressed
    if (pressedAnimationValue > 0.5) {
      final shadowPaint = Paint()
        ..color = const Color(
          0xFF000000,
        ).withValues(alpha: 0.1 * pressedAnimationValue)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

      final shadowRect = pressedRect.translate(2.0, 2.0);
      final shadowRoundedRect = RRect.fromRectAndRadius(
        shadowRect,
        const Radius.circular(8.0),
      );
      canvas.drawRRect(shadowRoundedRect, shadowPaint);
    }
  }

  static void paintEmpty(Canvas canvas, Rect cellRect, dynamic gameColors) {
    // Draw empty cell with subtle border
    final borderPaint = Paint()
      ..color = const Color(0xFFD6DAE3).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final roundedRect = RRect.fromRectAndRadius(
      cellRect,
      const Radius.circular(8.0),
    );

    canvas.drawRRect(roundedRect, borderPaint);
  }

  static void paintShake(
    Canvas canvas,
    Rect cellRect,
    double shakeAnimationValue,
    dynamic gameColors,
  ) {
    // Create shake effect with horizontal offset
    final shakeOffset = 3.0 * shakeAnimationValue * (shakeAnimationValue - 1.0);
    final shakenRect = cellRect.translate(shakeOffset, 0.0);

    // Draw cell with shake effect
    final shakePaint = Paint()
      ..color = const Color(
        0xFFFF6B6B,
      ).withValues(alpha: 0.3 * shakeAnimationValue)
      ..style = PaintingStyle.fill;

    final roundedRect = RRect.fromRectAndRadius(
      shakenRect,
      const Radius.circular(8.0),
    );

    canvas.drawRRect(roundedRect, shakePaint);
  }
}
