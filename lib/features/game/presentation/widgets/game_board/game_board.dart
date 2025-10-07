import 'dart:async';
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
  final Function(int, int)? onCellTap;

  /// Whether to show hint cells
  final bool showHints;

  /// Positions of hint cells to highlight
  final List<Position>? hintCells;

  /// Whether it's currently the robot's turn (for disabling player interaction)
  final bool isRobotTurn;

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
    this.isRobotTurn = false,
  });

  @override
  ConsumerState<GameBoard> createState() => _GameBoardState();
}

String? _cellStateToString(CellState state) {
  return switch (state) {
    CellState.X => 'X',
    CellState.O => 'O',
    CellState.empty => null,
  };
}

List<List<String?>> _convertBoardToStrings(List<List<CellState>> board) {
  return board.map((row) => row.map(_cellStateToString).toList()).toList();
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

  Timer? _hoverDebounce;

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
    _hoverDebounce?.cancel();
    // Return controllers to the pool instead of disposing them directly
    AnimationPool.returnController(_markAnimationController, 'game');
    AnimationPool.returnController(_winningLineController, 'game');
    AnimationPool.returnController(_hintController, 'game');
    AnimationPool.returnController(_ambientController, 'game');
    super.dispose();
  }

  void _onCellTap(int row, int col) {
    if (widget.boardState[row][col] == CellState.empty &&
        !widget.isGameOver &&
        !widget.isRobotTurn && // Don't allow taps when it's robot's turn
        widget.onCellTap != null) {
      widget.onCellTap!(row, col);

      // Trigger mark animation - don't reset immediately
      _markAnimationController.forward();
    }
  }

  void _onCellHover(int row, int col) {
    if (_hoverDebounce?.isActive ?? false) _hoverDebounce?.cancel();
    _hoverDebounce = Timer(const Duration(milliseconds: 16), () {
      if (mounted && (row != _hoveredRow || col != _hoveredCol)) {
        setState(() {
          _hoveredRow = row;
          _hoveredCol = col;
        });
      }
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

    // Trigger mark animation when board state changes (new moves made)
    if (widget.boardState != oldWidget.boardState) {
      _markAnimationController.reset();
      _markAnimationController.forward();
    }

    // Trigger winning line animation when game ends
    if (widget.isGameOver &&
        widget.winningLine != null &&
        widget.winningLine!.isNotEmpty &&
        (oldWidget.winningLine == null ||
            oldWidget.winningLine!.isEmpty ||
            !_listEquals(oldWidget.winningLine, widget.winningLine))) {
      _winningLineController.reset();
      _winningLineController.forward().then((_) {
        // Keep the winning line visible for a moment
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _winningLineController.reset();
          }
        });
      });
    }

    // Trigger hint animation when hints are shown
    if (widget.showHints &&
        widget.hintCells != null &&
        widget.hintCells!.isNotEmpty &&
        oldWidget.hintCells != widget.hintCells) {
      _hintController.forward().then((_) {
        _hintController.reset();
      });
    }
  }

  // Helper method to compare lists
  bool _listEquals(List<Position>? a, List<Position>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
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
            var localPosition = renderBox.globalToLocal(details.globalPosition);
            final size = renderBox.size;
            final cellSize = size.width / widget.boardSize;
            // Offset for grid line stroke (half of 2.0 width) to align with visual cells
            localPosition = Offset(
              localPosition.dx - 1.0,
              localPosition.dy - 1.0,
            );
            final row = (localPosition.dy / cellSize).floor().clamp(
              0,
              widget.boardSize - 1,
            );
            final col = (localPosition.dx / cellSize).floor().clamp(
              0,
              widget.boardSize - 1,
            );

            _onCellTap(row, col);
          },
          child: CustomPaint(
            key: ValueKey(
              '${widget.boardState.hashCode}',
            ), // Force rebuild when board changes
            painter: BoardPainter(
              boardSize: widget.boardSize,
              // Convert CellState board to String board for BoardPainter compatibility
              boardState: _convertBoardToStrings(widget.boardState),
              currentPlayer: _cellStateToString(widget.currentPlayer)!,
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
                  final renderBox = context.findRenderObject()! as RenderBox;
                  final size = renderBox.size;
                  final cellSize = size.width / widget.boardSize;
                  var localPosition = event.localPosition;
                  // Offset for grid line stroke (half of 2.0 width) to align with visual cells
                  localPosition = Offset(
                    localPosition.dx - 1.0,
                    localPosition.dy - 1.0,
                  );
                  final row = (localPosition.dy / cellSize).floor().clamp(
                    0,
                    widget.boardSize - 1,
                  );
                  final col = (localPosition.dx / cellSize).floor().clamp(
                    0,
                    widget.boardSize - 1,
                  );

                  _onCellHover(row, col);
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

  // Removed _calculateCellSize as it's now computed dynamically in gestures
}
