import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/services/game_logic.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/game_board/board_cell.dart';

/// Optimized grid layout wrapper for the game board
///
/// This widget provides the grid structure for the Tic Tac Toe board:
/// - Creates a responsive grid layout
/// - Manages cell positioning and sizing
/// - Handles board state distribution
/// - Supports different board sizes (3x3, 4x4, 5x5)
/// - Provides consistent spacing and alignment
class BoardGrid extends StatelessWidget {
  /// Size of the game board (e.g., 3 for 3x3, 4 for 4x4)
  final int boardSize;

  /// Current state of all board cells
  final List<List<CellState>> boardState;

  /// Whether the game has ended
  final bool isGameOver;

  /// Positions of the winning line (if any)
  final List<Position>? winningLine;

  /// Whether to show hint cells
  final bool showHints;

  /// Positions of hint cells to highlight
  final List<Position>? hintCells;

  /// Callback when a cell is tapped
  final Function(int, int) onCellTap;

  /// Whether the board is interactive
  final bool isInteractive;

  const BoardGrid({
    super.key,
    required this.boardSize,
    required this.boardState,
    required this.onCellTap,
    this.isGameOver = false,
    this.winningLine,
    this.showHints = false,
    this.hintCells,
    this.isInteractive = true,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: _GridContainer(
        boardSize: boardSize,
        boardState: boardState,
        winningLine: winningLine,
        hintCells: hintCells,
        showHints: showHints,
        isInteractive: isInteractive,
        isGameOver: isGameOver,
        onCellTap: onCellTap,
      ),
    );
  }
}

/// Optimized grid container widget with RepaintBoundary
class _GridContainer extends StatelessWidget {
  final int boardSize;
  final List<List<CellState>> boardState;
  final List<Position>? winningLine;
  final List<Position>? hintCells;
  final bool showHints;
  final bool isInteractive;
  final bool isGameOver;
  final Function(int, int) onCellTap;

  const _GridContainer({
    required this.boardSize,
    required this.boardState,
    required this.winningLine,
    required this.hintCells,
    required this.showHints,
    required this.isInteractive,
    required this.isGameOver,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final availableSize = screenSize.width < screenSize.height
        ? screenSize.width * 0.8
        : screenSize.height * 0.6;

    final cellSize = availableSize / boardSize;
    final gridSpacing = cellSize * 0.05; // 5% of cell size for spacing

    return RepaintBoundary(
      child: Container(
        padding: EdgeInsets.all(gridSpacing),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: context.getResponsiveBorderRadius(
            phoneRadius: 12.0,
            tabletRadius: 16.0,
          ),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(boardSize, (row) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: row < boardSize - 1 ? gridSpacing : 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(boardSize, (col) {
                  final cellState = boardState[row][col];
                  final isWinningCell =
                      winningLine?.any(
                        (pos) => pos.row == row && pos.col == col,
                      ) ??
                      false;
                  final isHintCell =
                      hintCells?.any(
                        (pos) => pos.row == row && pos.col == col,
                      ) ??
                      false;

                  return Padding(
                    padding: EdgeInsets.only(
                      right: col < boardSize - 1 ? gridSpacing : 0,
                    ),
                    child: BoardCell(
                      row: row,
                      col: col,
                      cellState: cellState,
                      isWinningCell: isWinningCell,
                      isHintCell: isHintCell && showHints,
                      onTap: isInteractive && !isGameOver
                          ? onCellTap
                          : (_, _) {},
                      cellSize: cellSize,
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }
}
