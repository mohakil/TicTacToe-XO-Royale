import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/app/theme/theme_extensions.dart';

void paintWinningLine(
  Canvas canvas,
  List<Offset> cells,
  double animationValue,
  GameColors? gameColors,
) {
  if (cells.length < 3) {
    return;
  }

  // Create gradient from azure to magenta
  const startColor = Color(0xFF2DD4FF);
  const endColor = Color(0xFFF43F9D);

  // Animate the line drawing
  final totalLength = _calculateTotalLength(cells);
  final currentLength = totalLength * animationValue;

  // Draw the winning line with gradient
  _drawGradientLine(canvas, cells, currentLength, startColor, endColor);

  // Add glow effect
  _drawGlowEffect(canvas, cells, currentLength, startColor, endColor);
}

double _calculateTotalLength(List<Offset> cells) {
  var totalLength = 0.0;
  for (var i = 0; i < cells.length - 1; i++) {
    totalLength += (cells[i + 1] - cells[i]).distance;
  }
  return totalLength;
}

void _drawGradientLine(
  Canvas canvas,
  List<Offset> cells,
  double currentLength,
  Color startColor,
  Color endColor,
) {
  if (cells.length < 2) {
    return;
  }

  final path = Path()..moveTo(cells[0].dx, cells[0].dy);

  var drawnLength = 0.0;
  for (var i = 0; i < cells.length - 1; i++) {
    final segmentLength = (cells[i + 1] - cells[i]).distance;
    final segmentProgress = (currentLength - drawnLength) / segmentLength;

    if (segmentProgress <= 0) {
      break;
    }

    final progress = segmentProgress.clamp(0.0, 1.0);
    final endPoint = Offset.lerp(cells[i], cells[i + 1], progress)!;

    path.lineTo(endPoint.dx, endPoint.dy);
    drawnLength += segmentLength;

    if (drawnLength >= currentLength) {
      break;
    }
  }

  // Create gradient paint
  final gradient = LinearGradient(colors: [startColor, endColor]);

  final paint = Paint()
    ..shader = gradient.createShader(Rect.fromPoints(cells.first, cells.last))
    ..strokeWidth = 8.0
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  canvas.drawPath(path, paint);
}

void _drawGlowEffect(
  Canvas canvas,
  List<Offset> cells,
  double currentLength,
  Color startColor,
  Color endColor,
) {
  if (cells.length < 2) {
    return;
  }

  final path = Path()..moveTo(cells[0].dx, cells[0].dy);

  var drawnLength = 0.0;
  for (var i = 0; i < cells.length - 1; i++) {
    final segmentLength = (cells[i + 1] - cells[i]).distance;
    final segmentProgress = (currentLength - drawnLength) / segmentLength;

    if (segmentProgress <= 0) {
      break;
    }

    final progress = segmentProgress.clamp(0.0, 1.0);
    final endPoint = Offset.lerp(cells[i], cells[i + 1], progress)!;

    path.lineTo(endPoint.dx, endPoint.dy);
    drawnLength += segmentLength;

    if (drawnLength >= currentLength) {
      break;
    }
  }

  // Create glow effect with blur
  final glowPaint = Paint()
    ..shader = LinearGradient(
      colors: [
        startColor.withValues(alpha: 0.6),
        endColor.withValues(alpha: 0.6),
      ],
    ).createShader(Rect.fromPoints(cells.first, cells.last))
    ..strokeWidth = 16.0
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

  canvas.drawPath(path, glowPaint);
}
