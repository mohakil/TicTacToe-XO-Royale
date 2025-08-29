import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/app/theme/theme_extensions.dart';

const int _ambientShapeCount = 6;

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
  final paint = Paint()
    ..color = _getAmbientColor(index).withValues(alpha: opacity)
    ..style = PaintingStyle.fill;

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

Color _getAmbientColor(int index) {
  final colors = [
    const Color(0xFF2DD4FF), // Azure
    const Color(0xFFF43F9D), // Magenta
    const Color(0xFFA3E635), // Lime
  ];

  return colors[index % colors.length];
}
