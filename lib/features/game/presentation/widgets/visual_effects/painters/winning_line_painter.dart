import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/app/theme/theme_extensions.dart';

// Static cached Paint objects for maximum performance
class _WinningLinePaints {
  static final Paint linePaint = Paint()
    ..strokeWidth = 8.0
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  static final Paint glowPaint = Paint()
    ..strokeWidth = 16.0
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
}

void paintWinningLine(
  Canvas canvas,
  List<Offset> cells,
  double animationValue,
  GameColors? gameColors,
) {
  if (cells.length < 2) {
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

  // Create gradient paint using static paint object
  final gradient = LinearGradient(colors: [startColor, endColor]);

  _WinningLinePaints.linePaint.shader = gradient.createShader(
    Rect.fromPoints(cells.first, cells.last),
  );

  canvas.drawPath(path, _WinningLinePaints.linePaint);
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

  // Create glow effect with blur using static paint object
  _WinningLinePaints.glowPaint.shader = LinearGradient(
    colors: [
      startColor.withValues(alpha: 0.6),
      endColor.withValues(alpha: 0.6),
    ],
  ).createShader(Rect.fromPoints(cells.first, cells.last));

  canvas.drawPath(path, _WinningLinePaints.glowPaint);
}
