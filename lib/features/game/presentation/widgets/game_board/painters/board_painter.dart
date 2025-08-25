import 'package:flutter/material.dart';
import 'cell_painter.dart';
import 'mark_painter.dart';
import 'winning_line_painter.dart';
import 'effects/confetti_painter.dart';
import 'effects/hint_sparkle_painter.dart';
import 'effects/ambient_painter.dart';

class BoardPainter extends CustomPainter {
  final int boardSize;
  final List<List<String?>> boardState;
  final String currentPlayer;
  final bool isGameOver;
  final List<int>? winningLine;
  final List<int>? hoveredCell;
  final bool showHints;
  final List<int>? hintCells;
  final Animation<double> markAnimation;
  final Animation<double> winningLineAnimation;
  final Animation<double> hintAnimation;
  final Animation<double> ambientAnimation;
  final dynamic gameColors;
  final dynamic motionDurations;
  final ThemeData themeData; // Add theme data for proper background color

  // Cached Paint objects for performance
  late final Paint _gridPaint;
  late final Paint _hoverPaint;
  late final Paint _backgroundPaint;

  BoardPainter({
    required this.boardSize,
    required this.boardState,
    required this.currentPlayer,
    required this.isGameOver,
    this.winningLine,
    this.hoveredCell,
    required this.showHints,
    this.hintCells,
    required this.markAnimation,
    required this.winningLineAnimation,
    required this.hintAnimation,
    required this.ambientAnimation,
    this.gameColors,
    this.motionDurations,
    required this.themeData, // Add theme data for proper background color
  }) {
    _initializePaints();
  }

  void _initializePaints() {
    // Grid lines paint
    _gridPaint = Paint()
      ..color = gameColors?.boardLine ?? const Color(0xFFD6DAE3)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Hover effect paint
    _hoverPaint = Paint()
      ..color = (gameColors?.cellHover ?? const Color(0xFF2DD4FF)).withValues(
        alpha: 0.1,
      )
      ..style = PaintingStyle.fill;

    // Background paint
    _backgroundPaint = Paint()
      ..color = themeData.scaffoldBackgroundColor
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / boardSize;

    // Draw background
    canvas.drawRect(Offset.zero & size, _backgroundPaint);

    // Draw ambient effects
    if (ambientAnimation.value > 0) {
      AmbientPainter.paint(canvas, size, ambientAnimation.value, gameColors);
    }

    // Draw grid
    _drawGrid(canvas, size, cellSize);

    // Draw cells with marks
    _drawCells(canvas, size, cellSize);

    // Draw hover effects
    if (hoveredCell != null) {
      _drawHoverEffect(canvas, size, cellSize, hoveredCell!);
    }

    // Draw winning line
    if (winningLine != null && winningLineAnimation.value > 0) {
      _drawWinningLine(canvas, size, cellSize, winningLine!);
    }

    // Draw hint effects
    if (showHints && hintCells != null && hintAnimation.value > 0) {
      _drawHintEffects(canvas, size, cellSize, hintCells!);
    }

    // Draw confetti for wins
    if (isGameOver && winningLine != null) {
      _drawConfetti(canvas, size);
    }
  }

  void _drawGrid(Canvas canvas, Size size, double cellSize) {
    // Draw vertical lines
    for (int i = 1; i < boardSize; i++) {
      final x = i * cellSize;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), _gridPaint);
    }

    // Draw horizontal lines
    for (int i = 1; i < boardSize; i++) {
      final y = i * cellSize;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), _gridPaint);
    }
  }

  void _drawCells(Canvas canvas, Size size, double cellSize) {
    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col < boardSize; col++) {
        final cellRect = Rect.fromLTWH(
          col * cellSize,
          row * cellSize,
          cellSize,
          cellSize,
        );

        final mark = boardState[row][col];
        if (mark != null) {
          MarkPainter.paint(
            canvas,
            cellRect,
            mark,
            markAnimation.value,
            gameColors,
            glowIntensity: markAnimation.value >= 1.0 ? 0.8 : 0.0,
            enableShake: false,
            shakeValue: 0.0,
          );
        }
      }
    }
  }

  void _drawHoverEffect(
    Canvas canvas,
    Size size,
    double cellSize,
    List<int> cell,
  ) {
    final row = cell[0];
    final col = cell[1];

    if (row >= 0 &&
        row < boardSize &&
        col >= 0 &&
        col < boardSize &&
        boardState[row][col] == null) {
      final cellRect = Rect.fromLTWH(
        col * cellSize,
        row * cellSize,
        cellSize,
        cellSize,
      );

      // Use animated hover effect
      CellPainter.paintHover(
        canvas,
        cellRect,
        _hoverPaint,
        gameColors,
        1.0, // Full hover animation value
      );
    }
  }

  void _drawWinningLine(
    Canvas canvas,
    Size size,
    double cellSize,
    List<int> winningLine,
  ) {
    if (winningLine.length >= 6) {
      // At least 3 cells (row1, col1, row2, col2, row3, col3)
      final cells = <Offset>[];
      for (int i = 0; i < winningLine.length; i += 2) {
        if (i + 1 < winningLine.length) {
          final row = winningLine[i];
          final col = winningLine[i + 1];
          final center = Offset((col + 0.5) * cellSize, (row + 0.5) * cellSize);
          cells.add(center);
        }
      }

      if (cells.length >= 3) {
        WinningLinePainter.paint(
          canvas,
          cells,
          winningLineAnimation.value,
          gameColors,
        );
      }
    }
  }

  void _drawHintEffects(
    Canvas canvas,
    Size size,
    double cellSize,
    List<int> hintCells,
  ) {
    for (int i = 0; i < hintCells.length; i += 2) {
      if (i + 1 < hintCells.length) {
        final row = hintCells[i];
        final col = hintCells[i + 1];
        final cellRect = Rect.fromLTWH(
          col * cellSize,
          row * cellSize,
          cellSize,
          cellSize,
        );

        HintSparklePainter.paint(
          canvas,
          cellRect,
          hintAnimation.value,
          gameColors,
        );
      }
    }
  }

  void _drawConfetti(Canvas canvas, Size size) {
    ConfettiPainter.paint(canvas, size, gameColors);
  }

  @override
  bool shouldRepaint(covariant BoardPainter oldDelegate) {
    return oldDelegate.boardState != boardState ||
        oldDelegate.currentPlayer != currentPlayer ||
        oldDelegate.isGameOver != isGameOver ||
        oldDelegate.winningLine != winningLine ||
        oldDelegate.hoveredCell != hoveredCell ||
        oldDelegate.showHints != showHints ||
        oldDelegate.hintCells != hintCells ||
        oldDelegate.markAnimation.value != markAnimation.value ||
        oldDelegate.winningLineAnimation.value != winningLineAnimation.value ||
        oldDelegate.hintAnimation.value != hintAnimation.value ||
        oldDelegate.ambientAnimation.value != ambientAnimation.value;
  }
}
