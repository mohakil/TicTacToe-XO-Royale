import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'painters/board_painter.dart';
import 'package:tictactoe_xo_royale/app/theme/theme_extensions.dart';

class TicTacToeBoard extends ConsumerStatefulWidget {
  final int boardSize;
  final int winCondition;
  final List<List<String?>> boardState;
  final String currentPlayer;
  final bool isGameOver;
  final List<int>? winningLine;
  final Function(int, int) onCellTap;
  final bool showHints;
  final List<int>? hintCells;

  const TicTacToeBoard({
    super.key,
    required this.boardSize,
    required this.winCondition,
    required this.boardState,
    required this.currentPlayer,
    required this.isGameOver,
    this.winningLine,
    required this.onCellTap,
    this.showHints = false,
    this.hintCells,
  });

  @override
  ConsumerState<TicTacToeBoard> createState() => _TicTacToeBoardState();
}

class _TicTacToeBoardState extends ConsumerState<TicTacToeBoard>
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
    // Mark drawing animation
    _markAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _markAnimation = CurvedAnimation(
      parent: _markAnimationController,
      curve: Curves.easeOutBack,
    );

    // Winning line animation
    _winningLineController = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );
    _winningLineAnimation = CurvedAnimation(
      parent: _winningLineController,
      curve: Curves.easeInOut,
    );

    // Hint sparkle animation
    _hintController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _hintAnimation = CurvedAnimation(
      parent: _hintController,
      curve: Curves.easeInOut,
    );

    // Ambient background animation
    _ambientController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
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
    _markAnimationController.dispose();
    _winningLineController.dispose();
    _hintController.dispose();
    _ambientController.dispose();
    super.dispose();
  }

  void _onCellTap(int row, int col) {
    if (widget.boardState[row][col] == null && !widget.isGameOver) {
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
  void didUpdateWidget(TicTacToeBoard oldWidget) {
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
      child: AspectRatio(
        aspectRatio: 1.0, // Ensure square aspect ratio
        child: GestureDetector(
          onTapUp: (details) {
            final RenderBox renderBox = context.findRenderObject() as RenderBox;
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
            painter: BoardPainter(
              boardSize: widget.boardSize,
              boardState: widget.boardState,
              currentPlayer: widget.currentPlayer,
              isGameOver: widget.isGameOver,
              winningLine: widget.winningLine,
              hoveredCell: _hoveredRow != null && _hoveredCol != null
                  ? [_hoveredRow!, _hoveredCol!]
                  : null,
              showHints: widget.showHints,
              hintCells: widget.hintCells,
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
