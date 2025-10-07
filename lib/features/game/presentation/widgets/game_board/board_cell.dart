import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/services/game_logic.dart';

/// Optimized individual cell widget for the game board
///
/// This widget represents a single cell in the Tic Tac Toe grid:
/// - Displays X, O, or empty state
/// - Handles tap interactions
/// - Shows hover effects on desktop
/// - Supports different board sizes
/// - Animated state transitions
class BoardCell extends ConsumerWidget {
  /// Row position of the cell
  final int row;

  /// Column position of the cell
  final int col;

  /// Current state of the cell (X, O, or null)
  final CellState? cellState;

  /// Whether this cell is part of the winning line
  final bool isWinningCell;

  /// Whether this cell is a hint
  final bool isHintCell;

  /// Whether the cell is being hovered over (desktop)
  final bool isHovered;

  /// Callback when the cell is tapped
  final Function(int, int) onTap;

  /// Size of the cell (calculated from board size)
  final double cellSize;

  const BoardCell({
    super.key,
    required this.row,
    required this.col,
    required this.cellState,
    required this.onTap,
    required this.cellSize,
    this.isWinningCell = false,
    this.isHintCell = false,
    this.isHovered = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: () {
          onTap(row, col);
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: _AnimatedCell(
            cellSize: cellSize,
            cellState: cellState,
            isWinningCell: isWinningCell,
            isHintCell: isHintCell,
            isHovered: isHovered,
          ),
        ),
      ),
    );
  }
}

/// Optimized animated cell widget with RepaintBoundary
class _AnimatedCell extends StatelessWidget {
  final double cellSize;
  final CellState? cellState;
  final bool isWinningCell;
  final bool isHintCell;
  final bool isHovered;

  const _AnimatedCell({
    required this.cellSize,
    required this.cellState,
    required this.isWinningCell,
    required this.isHintCell,
    required this.isHovered,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RepaintBoundary(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: cellSize,
        height: cellSize,
        decoration: BoxDecoration(
          color: _getCellColor(colorScheme),
          border: Border.all(color: _getBorderColor(colorScheme), width: 2.0),
          borderRadius: BorderRadius.circular(8),
          boxShadow: _getBoxShadow(colorScheme),
        ),
        child: Center(child: _buildCellContent(colorScheme)),
      ),
    );
  }

  Color _getCellColor(ColorScheme colorScheme) {
    if (isWinningCell) {
      return colorScheme.primary.withValues(alpha: 0.1);
    }
    if (isHintCell) {
      return colorScheme.secondary.withValues(alpha: 0.1);
    }
    if (isHovered) {
      return colorScheme.surfaceContainerHighest;
    }
    return colorScheme.surface;
  }

  Color _getBorderColor(ColorScheme colorScheme) {
    if (isWinningCell) {
      return colorScheme.primary;
    }
    if (isHintCell) {
      return colorScheme.secondary;
    }
    return colorScheme.outline.withValues(alpha: 0.3);
  }

  List<BoxShadow>? _getBoxShadow(ColorScheme colorScheme) {
    if (isWinningCell) {
      return [
        BoxShadow(
          color: colorScheme.primary.withValues(alpha: 0.3),
          blurRadius: 8,
          spreadRadius: 2,
        ),
      ];
    }
    if (isHovered) {
      return [
        BoxShadow(
          color: colorScheme.shadow.withValues(alpha: 0.2),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];
    }
    return null;
  }

  Widget _buildCellContent(ColorScheme colorScheme) {
    if (cellState == null) {
      return const SizedBox.shrink();
    }

    final isX = cellState == CellState.X;
    final color = isX ? colorScheme.primary : colorScheme.secondary;
    final text = isX ? 'X' : 'O';

    return RepaintBoundary(
      child: AnimatedScale(
        duration: const Duration(milliseconds: 300),
        scale: 1.0,
        child: Text(
          text,
          style: TextStyle(
            fontSize: cellSize * 0.4,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
