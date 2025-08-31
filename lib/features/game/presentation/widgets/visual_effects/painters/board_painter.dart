import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/app/theme/theme_extensions.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/visual_effects/painters/cell_painter.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/visual_effects/effects/ambient_painter.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/visual_effects/effects/confetti_painter.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/visual_effects/effects/hint_sparkle_painter.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/visual_effects/painters/mark_painter.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/visual_effects/painters/winning_line_painter.dart';

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
  final GameColors? gameColors;
  final dynamic motionDurations;
  final ThemeData themeData;

  // Cached values for performance optimization
  late final double _cellSize;

  // Cached Paint objects for performance
  late final Paint _gridPaint;
  late final Paint _hoverPaint;
  late final Paint _backgroundPaint;

  // Cached animation values to avoid repeated getter calls
  late final double _markAnimValue;
  late final double _winningLineAnimValue;
  late final double _hintAnimValue;
  late final double _ambientAnimValue;

  BoardPainter({
    required this.boardSize,
    required this.boardState,
    required this.currentPlayer,
    required this.isGameOver,
    required this.showHints,
    required this.markAnimation,
    required this.winningLineAnimation,
    required this.hintAnimation,
    required this.ambientAnimation,
    required this.themeData,
    this.winningLine,
    this.hoveredCell,
    this.hintCells,
    this.gameColors,
    this.motionDurations,
  }) {
    _initializeCachedValues();
    _initializePaints();
  }

  void _initializeCachedValues() {
    // Pre-compute commonly used values
    _cellSize = 1.0 / boardSize; // Normalized for efficiency

    // Cache animation values to avoid repeated getter calls
    _markAnimValue = markAnimation.value;
    _winningLineAnimValue = winningLineAnimation.value;
    _hintAnimValue = hintAnimation.value;
    _ambientAnimValue = ambientAnimation.value;
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
    final cellSize = size.width * _cellSize; // Use cached normalized value

    // Draw background - use cached rect scaled to actual size
    canvas.drawRect(Offset.zero & size, _backgroundPaint);

    // Draw ambient effects - use cached animation value
    if (_ambientAnimValue > 0) {
      paintAmbient(canvas, size, _ambientAnimValue, gameColors);
    }

    // Draw grid
    _drawGrid(canvas, size, cellSize);

    // Draw cells with marks - use cached animation value
    _drawCellsOptimized(canvas, size, cellSize);

    // Draw hover effects
    if (hoveredCell != null) {
      _drawHoverEffect(canvas, size, cellSize, hoveredCell!);
    }

    // Draw winning line - use cached animation value
    if (winningLine != null && _winningLineAnimValue > 0) {
      _drawWinningLine(canvas, size, cellSize, winningLine!);
    }

    // Draw hint effects - use cached animation value
    if (showHints && hintCells != null && _hintAnimValue > 0) {
      _drawHintEffects(canvas, size, cellSize, hintCells!);
    }

    // Draw confetti for wins
    if (isGameOver && winningLine != null) {
      _drawConfetti(canvas, size);
    }
  }

  void _drawGrid(Canvas canvas, Size size, double cellSize) {
    // Pre-compute common values to reduce allocations
    final width = size.width;
    final height = size.height;

    // Draw vertical lines - unroll loop for small board sizes
    if (boardSize <= 5) {
      // Optimized for common tic-tac-toe sizes (3x3, 4x4, 5x5)
      for (var i = 1; i < boardSize; i++) {
        final x = i * cellSize;
        canvas.drawLine(Offset(x, 0), Offset(x, height), _gridPaint);
      }
    } else {
      // Fallback for larger boards
      for (var i = 1; i < boardSize; i++) {
        final x = i * cellSize;
        canvas.drawLine(Offset(x, 0), Offset(x, height), _gridPaint);
      }
    }

    // Draw horizontal lines
    for (var i = 1; i < boardSize; i++) {
      final y = i * cellSize;
      canvas.drawLine(Offset(0, y), Offset(width, y), _gridPaint);
    }
  }

  void _drawCellsOptimized(Canvas canvas, Size size, double cellSize) {
    // Pre-compute glow intensity to avoid repeated calculations
    final glowIntensity = _markAnimValue >= 1.0 ? 0.8 : 0.0;

    // Ensure we don't exceed the board dimensions safely
    final maxRows = boardState.length < boardSize
        ? boardState.length
        : boardSize;

    for (var row = 0; row < maxRows; row++) {
      final maxCols = boardState[row].length < boardSize
          ? boardState[row].length
          : boardSize;

      for (var col = 0; col < maxCols; col++) {
        final mark = boardState[row][col];
        if (mark != null && mark.isNotEmpty) {
          // Inline cell rect calculation for better performance
          final cellRect = Rect.fromLTWH(
            col * cellSize,
            row * cellSize,
            cellSize,
            cellSize,
          );

          paintMark(
            canvas,
            cellRect,
            mark,
            _markAnimValue, // Use cached animation value
            gameColors,
            glowIntensity: glowIntensity,
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
      paintHover(
        canvas,
        cellRect,
        _hoverPaint,
        gameColors,
        1, // Full hover animation value
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
      for (var i = 0; i < winningLine.length; i += 2) {
        if (i + 1 < winningLine.length) {
          final row = winningLine[i];
          final col = winningLine[i + 1];
          final center = Offset((col + 0.5) * cellSize, (row + 0.5) * cellSize);
          cells.add(center);
        }
      }

      if (cells.length >= 3) {
        paintWinningLine(canvas, cells, winningLineAnimation.value, gameColors);
      }
    }
  }

  void _drawHintEffects(
    Canvas canvas,
    Size size,
    double cellSize,
    List<int> hintCells,
  ) {
    for (var i = 0; i < hintCells.length; i += 2) {
      if (i + 1 < hintCells.length) {
        final row = hintCells[i];
        final col = hintCells[i + 1];
        final cellRect = Rect.fromLTWH(
          col * cellSize,
          row * cellSize,
          cellSize,
          cellSize,
        );

        paintHintSparkle(canvas, cellRect, hintAnimation.value, gameColors);
      }
    }
  }

  void _drawConfetti(Canvas canvas, Size size) {
    paintConfetti(canvas, size, gameColors);
  }

  @override
  bool shouldRepaint(covariant BoardPainter oldDelegate) {
    // Always repaint if board state has changed
    if (oldDelegate.boardState != boardState) {
      return true;
    }

    // Check other state changes
    return oldDelegate.currentPlayer != currentPlayer ||
        oldDelegate.isGameOver != isGameOver ||
        oldDelegate.winningLine != winningLine ||
        oldDelegate.hoveredCell != hoveredCell ||
        oldDelegate.showHints != showHints ||
        oldDelegate.hintCells != hintCells ||
        oldDelegate._markAnimValue != _markAnimValue ||
        oldDelegate._winningLineAnimValue != _winningLineAnimValue ||
        oldDelegate._hintAnimValue != _hintAnimValue ||
        oldDelegate._ambientAnimValue != _ambientAnimValue;
  }
}
