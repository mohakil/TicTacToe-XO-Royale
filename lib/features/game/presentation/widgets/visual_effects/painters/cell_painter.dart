import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/app/theme/theme_extensions.dart';

/// Static Paint objects for cell painting operations to improve performance
class _CellPaints {
  // Hover effect paints
  static final Paint _hoverPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = const Color(0xFFF1F5F9).withValues(alpha: 0.1);

  static final Paint _hoverGlowPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = const Color(0xFFF1F5F9).withValues(alpha: 0.3)
    ..strokeWidth = 1.0;

  // Pressed effect paints
  static final Paint _pressedPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = const Color(0xFFE2E8F0).withValues(alpha: 0.8);

  static final Paint _pressedShadowPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = const Color(0xFF000000).withValues(alpha: 0.1);

  // Empty cell paint
  static final Paint _emptyBorderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = const Color(0xFFD6DAE3).withValues(alpha: 0.3)
    ..strokeWidth = 1.0;

  // Shake effect paint
  static final Paint _shakePaint = Paint()
    ..style = PaintingStyle.fill
    ..color = const Color(0xFFFF6B6B).withValues(alpha: 0.3);

  // Getters for accessing static paints
  static Paint get hoverPaint => _hoverPaint;
  static Paint get hoverGlowPaint => _hoverGlowPaint;
  static Paint get pressedPaint => _pressedPaint;
  static Paint get pressedShadowPaint => _pressedShadowPaint;
  static Paint get emptyBorderPaint => _emptyBorderPaint;
  static Paint get shakePaint => _shakePaint;
}

/// Optimized paint hover effect on a game cell
/// Creates an animated hover effect with scaling and glow for visual feedback
/// when the user hovers over a cell.
void paintHover(
  Canvas canvas,
  Rect cellRect,
  Paint hoverPaint,
  GameColors? gameColors,
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
    const Radius.circular(8),
  );

  // Animate opacity for smooth appearance using static paint
  final animatedPaint = Paint()
    ..color = _CellPaints.hoverPaint.color.withValues(
      alpha: (_CellPaints.hoverPaint.color.a / 255.0) * hoverAnimationValue,
    )
    ..style = _CellPaints.hoverPaint.style;

  canvas.drawRRect(roundedRect, animatedPaint);

  // Add animated glow effect using static paint
  final glowPaint = Paint()
    ..color = _CellPaints.hoverGlowPaint.color.withValues(
      alpha: 0.3 * hoverAnimationValue,
    )
    ..style = _CellPaints.hoverGlowPaint.style
    ..strokeWidth = 1.0 + (2.0 * hoverAnimationValue)
    ..maskFilter = MaskFilter.blur(
      BlurStyle.normal,
      2.0 + (3.0 * hoverAnimationValue),
    );

  canvas.drawRRect(roundedRect, glowPaint);
}

/// Optimized paint pressed effect on a game cell
/// Creates an animated pressed effect with scaling and shadow
/// to provide visual feedback when a cell is pressed.
void paintPressed(
  Canvas canvas,
  Rect cellRect,
  GameColors? gameColors,
  double pressedAnimationValue,
) {
  // Animate pressed state with scale effect
  final scale = 1.0 - (0.04 * pressedAnimationValue);
  final pressedRect = Rect.fromCenter(
    center: cellRect.center,
    width: cellRect.width * scale,
    height: cellRect.height * scale,
  );

  // Use static paint with animated opacity
  final pressedPaint = Paint()
    ..color = _CellPaints.pressedPaint.color.withValues(
      alpha: 0.8 * pressedAnimationValue,
    )
    ..style = _CellPaints.pressedPaint.style;

  final roundedRect = RRect.fromRectAndRadius(
    pressedRect,
    const Radius.circular(8),
  );

  canvas.drawRRect(roundedRect, pressedPaint);

  // Add subtle shadow effect when pressed using static paint
  if (pressedAnimationValue > 0.5) {
    final shadowPaint = Paint()
      ..color = _CellPaints.pressedShadowPaint.color.withValues(
        alpha: 0.1 * pressedAnimationValue,
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final shadowRect = pressedRect.translate(2, 2);
    final shadowRoundedRect = RRect.fromRectAndRadius(
      shadowRect,
      const Radius.circular(8),
    );
    canvas.drawRRect(shadowRoundedRect, shadowPaint);
  }
}

/// Optimized paint empty cell with subtle border
/// Draws a basic empty cell with a subtle border to indicate
/// an available space for game pieces.
void paintEmpty(Canvas canvas, Rect cellRect, GameColors? gameColors) {
  // Draw empty cell with subtle border using static paint
  final roundedRect = RRect.fromRectAndRadius(
    cellRect,
    const Radius.circular(8),
  );

  canvas.drawRRect(roundedRect, _CellPaints.emptyBorderPaint);
}

/// Optimized paint shake effect on a game cell
/// Creates an animated shake effect to provide visual feedback
/// for invalid moves or error states.
void paintShake(
  Canvas canvas,
  Rect cellRect,
  double shakeAnimationValue,
  GameColors? gameColors,
) {
  // Create shake effect with horizontal offset
  final shakeOffset = 3.0 * shakeAnimationValue * (shakeAnimationValue - 1.0);
  final shakenRect = cellRect.translate(shakeOffset, 0);

  // Draw cell with shake effect using static paint
  final shakePaint = Paint()
    ..color = _CellPaints.shakePaint.color.withValues(
      alpha: 0.3 * shakeAnimationValue,
    )
    ..style = _CellPaints.shakePaint.style;

  final roundedRect = RRect.fromRectAndRadius(
    shakenRect,
    const Radius.circular(8),
  );

  canvas.drawRRect(roundedRect, shakePaint);
}
