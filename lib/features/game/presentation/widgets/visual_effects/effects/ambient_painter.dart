import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/app/theme/theme_extensions.dart';

const int _ambientShapeCount = 6;

/// Static Paint objects for ambient effects to improve performance
class _AmbientPaints {
  // Ambient shape paints for different colors
  static final Paint _azurePaint = Paint()
    ..style = PaintingStyle.fill
    ..color = const Color(0xFF2DD4FF);

  static final Paint _magentaPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = const Color(0xFFF43F9D);

  static final Paint _limePaint = Paint()
    ..style = PaintingStyle.fill
    ..color = const Color(0xFFA3E635);

  // Getters for accessing static paints
  static Paint get azurePaint => _azurePaint;
  static Paint get magentaPaint => _magentaPaint;
  static Paint get limePaint => _limePaint;
}

/// Optimized paint ambient effects
void paintAmbient(
  Canvas canvas,
  Size size,
  double animationValue,
  GameColors? gameColors,
) {
  // Draw subtle floating shapes
  for (var i = 0; i < _ambientShapeCount; i++) {
    final seed = i * 1000;
    final position = _getAmbientPosition(size, seed, animationValue);
    final opacity = 0.05 + 0.02 * sin(animationValue * 2 * pi + seed);

    _drawAmbientShape(canvas, position, opacity, i);
  }
}

Offset _getAmbientPosition(Size size, int seed, double animationValue) {
  final random = Random(seed);
  final baseX = random.nextDouble() * size.width;
  final baseY = random.nextDouble() * size.height;

  // Add subtle movement
  final offsetX = sin(animationValue * 2 * pi + seed) * 20;
  final offsetY = cos(animationValue * 2 * pi + seed) * 20;

  return Offset(baseX + offsetX, baseY + offsetY);
}

void _drawAmbientShape(
  Canvas canvas,
  Offset position,
  double opacity,
  int index,
) {
  // Use static paint with animated opacity
  final basePaint = _getAmbientPaint(index);
  final paint = Paint()
    ..color = basePaint.color.withValues(alpha: opacity)
    ..style = basePaint.style;

  switch (index % 3) {
    case 0:
      // Circle
      canvas.drawCircle(position, 8, paint);
      break;
    case 1:
      // Square
      final rect = Rect.fromCenter(center: position, width: 16, height: 16);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(2)),
        paint,
      );
      break;
    case 2:
      // Triangle
      final path = Path();
      path.moveTo(position.dx, position.dy - 8);
      path.lineTo(position.dx - 6, position.dy + 6);
      path.lineTo(position.dx + 6, position.dy + 6);
      path.close();
      canvas.drawPath(path, paint);
      break;
  }
}

Paint _getAmbientPaint(int index) {
  switch (index % 3) {
    case 0:
      return _AmbientPaints.azurePaint;
    case 1:
      return _AmbientPaints.magentaPaint;
    case 2:
      return _AmbientPaints.limePaint;
    default:
      return _AmbientPaints.azurePaint;
  }
}
