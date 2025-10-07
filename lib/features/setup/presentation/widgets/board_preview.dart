import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/models/game_enums.dart';

class BoardPreview extends StatelessWidget {
  const BoardPreview({
    required this.boardSize,
    super.key,
    this.showWinLine = false,
    this.winCondition = WinCondition.threeInRow,
  });

  final BoardSize boardSize;
  final bool showWinLine;
  final WinCondition winCondition;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Use responsive sizing for board preview
    final previewSize = context.getResponsiveButtonHeight(
      phoneHeight: 100.0,
      tabletHeight: 120.0,
    );

    return Container(
      width: previewSize,
      height: previewSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline),
        color: colorScheme.surfaceContainer,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CustomPaint(
          painter: BoardPreviewPainter(
            boardSize: boardSize,
            showWinLine: showWinLine,
            winCondition: winCondition,
            colorScheme: colorScheme,
          ),
        ),
      ),
    );
  }
}

class BoardPreviewPainter extends CustomPainter {
  BoardPreviewPainter({
    required this.boardSize,
    required this.showWinLine,
    required this.winCondition,
    required this.colorScheme,
  });

  final BoardSize boardSize;
  final bool showWinLine;
  final WinCondition winCondition;
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colorScheme.outline
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final cellSize = size.width / _getGridSize();
    final gridSize = _getGridSize();

    // Draw grid lines
    for (var i = 1; i < gridSize; i++) {
      final x = i * cellSize;
      final y = i * cellSize;

      // Vertical lines
      canvas
        ..drawLine(Offset(x, 0), Offset(x, size.height), paint)
        // Horizontal lines
        ..drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw win line if requested
    if (showWinLine) {
      _drawWinLine(canvas, size, cellSize, gridSize);
    }
  }

  void _drawWinLine(Canvas canvas, Size size, double cellSize, int gridSize) {
    final winPaint = Paint()
      ..color = colorScheme.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final winLength = _getWinLength();

    // Draw horizontal win line
    final startX = cellSize * 0.5;
    final endX = startX + (winLength - 1) * cellSize;
    final centerY = size.height / 2;

    canvas.drawLine(Offset(startX, centerY), Offset(endX, centerY), winPaint);
  }

  int _getGridSize() {
    switch (boardSize) {
      case BoardSize.threeByThree:
        return 3;
      case BoardSize.fourByFour:
        return 4;
      case BoardSize.fiveByFive:
        return 5;
    }
  }

  int _getWinLength() {
    switch (winCondition) {
      case WinCondition.threeInRow:
        return 3;
      case WinCondition.fourInRow:
        return 4;
      case WinCondition.fiveInRow:
        return 5;
    }
  }

  @override
  bool shouldRepaint(covariant BoardPreviewPainter oldDelegate) {
    // Always repaint when any of these properties change
    return oldDelegate.boardSize != boardSize ||
        oldDelegate.showWinLine != showWinLine ||
        oldDelegate.winCondition != winCondition ||
        oldDelegate.colorScheme != colorScheme;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BoardPreviewPainter &&
        other.boardSize == boardSize &&
        other.showWinLine == showWinLine &&
        other.winCondition == winCondition &&
        other.colorScheme == colorScheme;
  }

  @override
  int get hashCode {
    return Object.hash(boardSize, showWinLine, winCondition, colorScheme);
  }
}
