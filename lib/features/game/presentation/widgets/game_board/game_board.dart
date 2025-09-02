import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/app/theme/theme_extensions.dart';
import 'package:tictactoe_xo_royale/core/services/animation_pool.dart';
import 'package:tictactoe_xo_royale/core/services/game_logic.dart';

import 'package:tictactoe_xo_royale/features/game/presentation/widgets/visual_effects/painters/board_painter.dart';

/// Interactive Tic Tac Toe game board widget
///
/// This widget renders the game board with the following features:
/// - Custom painting for optimal performance
/// - Smooth animations for marks, winning lines, and effects
/// - Hover effects for desktop interaction
/// - Touch feedback for mobile devices
/// - Hint system for player guidance
/// - Winning line highlighting
/// - Ambient animation effects
///
/// The board uses a custom painter for efficient rendering and
/// supports various board sizes (3x3, 4x4, 5x5, etc.).
class GameBoard extends ConsumerStatefulWidget {
  /// Size of the game board (e.g., 3 for 3x3, 4 for 4x4)
  final int boardSize;

  /// Number of consecutive marks needed to win
  final int winCondition;

  /// Current state of all board cells
  final List<List<CellState>> boardState;

  /// Current player's turn (X or O)
  final CellState currentPlayer;

  /// Whether the game has ended
  final bool isGameOver;

  /// Positions of the winning line (if any)
  final List<Position>? winningLine;

  /// Callback when a cell is tapped
  final Function(int, int) onCellTap;

  /// Whether to show hint cells
  final bool showHints;

  /// Positions of hint cells to highlight
  final List<Position>? hintCells;

  const GameBoard({
    required this.boardSize,
    required this.winCondition,
    required this.boardState,
    required this.currentPlayer,
    required this.isGameOver,
    required this.onCellTap,
    super.key,
    this.winningLine,
    this.showHints = false,
    this.hintCells,
  });

  @override
  ConsumerState<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends ConsumerState<GameBoard>
    with TickerProviderStateMixin {
  late AnimationController _markAnimationController;
  late AnimationController _winningLineController;
  late AnimationController _hintController;
  late AnimationController _ambientController;

  late Animation<double> _markAnimation;
  late Animation<double> _winningLineAnimation;
  late Animation<double> _hintAnimation;
  late Animation<double> _ambientAnimation;

  // Hover state
  int? _hoveredRow;
  int? _hoveredCol;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Mark drawing animation - get from pool
    _markAnimationController = AnimationPool.getController(
      vsync: this,
      poolName: 'game',
      duration: const Duration(milliseconds: 400),
    );
    _markAnimation = CurvedAnimation(
      parent: _markAnimationController,
      curve: Curves.easeOutBack,
    );

    // Winning line animation - get from pool
    _winningLineController = AnimationPool.getController(
      vsync: this,
      poolName: 'game',
      duration: const Duration(milliseconds: 450),
    );
    _winningLineAnimation = CurvedAnimation(
      parent: _winningLineController,
      curve: Curves.easeInOut,
    );

    // Hint sparkle animation - get from pool
    _hintController = AnimationPool.getController(
      vsync: this,
      poolName: 'game',
      duration: const Duration(milliseconds: 800),
    );
    _hintAnimation = CurvedAnimation(
      parent: _hintController,
      curve: Curves.easeInOut,
    );

    // Ambient background animation - get from pool
    _ambientController = AnimationPool.getController(
      vsync: this,
      poolName: 'game',
      duration: const Duration(milliseconds: 3000),
    );
    _ambientAnimation = CurvedAnimation(
      parent: _ambientController,
      curve: Curves.easeInOut,
    );

    // Start ambient animation loop
    _ambientController.repeat(reverse: true);
  }

  @override
  void dispose() {
    // Return controllers to the pool instead of disposing them directly
    AnimationPool.returnController(_markAnimationController, 'game');
    AnimationPool.returnController(_winningLineController, 'game');
    AnimationPool.returnController(_hintController, 'game');
    AnimationPool.returnController(_ambientController, 'game');
    super.dispose();
  }

  void _onCellTap(int row, int col) {
    if (widget.boardState[row][col] == CellState.empty && !widget.isGameOver) {
      widget.onCellTap(row, col);

      // Trigger mark animation
      _markAnimationController.forward().then((_) {
        _markAnimationController.reset();
      });
    }
  }

  void _onCellHover(int row, int col) {
    setState(() {
      _hoveredRow = row;
      _hoveredCol = col;
    });
  }

  void _onCellExit() {
    setState(() {
      _hoveredRow = null;
      _hoveredCol = null;
    });
  }

  @override
  void didUpdateWidget(GameBoard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger winning line animation when game ends
    if (widget.isGameOver &&
        widget.winningLine != null &&
        oldWidget.winningLine == null) {
      _winningLineController.forward();
    }

    // Trigger hint animation when hints are shown
    if (widget.showHints &&
        widget.hintCells != null &&
        oldWidget.hintCells != widget.hintCells) {
      _hintController.forward().then((_) {
        _hintController.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: ValueKey('game_board_${widget.boardState.hashCode}'),
      child: AspectRatio(
        aspectRatio: 1, // Ensure square aspect ratio
        child: GestureDetector(
          onTapUp: (details) {
            final renderBox = context.findRenderObject()! as RenderBox;
            final localPosition = renderBox.globalToLocal(
              details.globalPosition,
            );
            final cellSize = _calculateCellSize(context);
            final row = (localPosition.dy / cellSize).floor();
            final col = (localPosition.dx / cellSize).floor();

            if (row >= 0 &&
                row < widget.boardSize &&
                col >= 0 &&
                col < widget.boardSize) {
              _onCellTap(row, col);
            }
          },
          child: CustomPaint(
            key: ValueKey(
              '${widget.boardState.hashCode}',
            ), // Force rebuild when board changes
            painter: BoardPainter(
              boardSize: widget.boardSize,
              // Convert CellState board to String board for BoardPainter compatibility
              boardState: widget.boardState
                  .map(
                    (row) => row
                        .map(
                          (cell) => cell == CellState.empty ? null : cell.name,
                        )
                        .toList(),
                  )
                  .toList(),
              currentPlayer: widget.currentPlayer.name,
              isGameOver: widget.isGameOver,
              winningLine: widget.winningLine
                  ?.expand((pos) => [pos.row, pos.col])
                  .toList(),
              hoveredCell: _hoveredRow != null && _hoveredCol != null
                  ? [_hoveredRow!, _hoveredCol!]
                  : null,
              showHints: widget.showHints,
              hintCells: widget.hintCells
                  ?.expand((pos) => [pos.row, pos.col])
                  .toList(),
              markAnimation: _markAnimation,
              winningLineAnimation: _winningLineAnimation,
              hintAnimation: _hintAnimation,
              ambientAnimation: _ambientAnimation,
              gameColors: Theme.of(context).extension<GameColors>(),
              themeData: Theme.of(context),
            ),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: MouseRegion(
                onHover: (event) {
                  final cellSize = _calculateCellSize(context);
                  final row = (event.localPosition.dy / cellSize).floor();
                  final col = (event.localPosition.dx / cellSize).floor();

                  if (row >= 0 &&
                      row < widget.boardSize &&
                      col >= 0 &&
                      col < widget.boardSize) {
                    _onCellHover(row, col);
                  }
                },
                onExit: (_) => _onCellExit(),
                child:
                    const SizedBox.shrink(), // Empty sized box for mouse region
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _calculateCellSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final boardDimension = size.width < size.height
        ? size.width * 0.8
        : size.height * 0.64;
    return boardDimension / widget.boardSize;
  }
}
