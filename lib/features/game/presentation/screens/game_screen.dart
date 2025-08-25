import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../widgets/game_board/tic_tac_toe_board.dart';
import '../widgets/game_hud.dart';
import '../widgets/turn_indicator.dart';
import '../widgets/control_bar.dart';
import '../widgets/overlays/result_overlay.dart';
import '../widgets/overlays/exit_overlay.dart';
import '../widgets/overlays/settings_overlay.dart';

class GameScreen extends ConsumerStatefulWidget {
  final int boardSize;
  final int winCondition;
  final String player1Name;
  final String player2Name;
  final bool isRobotMode;
  final String difficulty;

  const GameScreen({
    super.key,
    this.boardSize = 3,
    this.winCondition = 3,
    this.player1Name = 'Player 1',
    this.player2Name = 'Player 2',
    this.isRobotMode = false,
    this.difficulty = 'medium',
  });

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late List<List<String?>> _boardState;
  late String _currentPlayer;
  late bool _isGameOver;
  late List<int>? _winningLine;
  late int _player1Wins;
  late int _player2Wins;
  late int _hintCount;

  bool _showExitDialog = false;
  bool _showSettings = false;
  bool _showHint = false;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _boardState = List.generate(
      widget.boardSize,
      (i) => List.generate(widget.boardSize, (j) => null),
    );
    _currentPlayer = 'X';
    _isGameOver = false;
    _winningLine = null;
    _player1Wins = 0;
    _player2Wins = 0;
    _hintCount = 3;
  }

  void _onCellTap(int row, int col) {
    if (_isGameOver || _boardState[row][col] != null) return;

    setState(() {
      _boardState[row][col] = _currentPlayer;
    });

    // Check for win
    if (_checkWin(row, col)) {
      _handleGameEnd();
      return;
    }

    // Check for draw
    if (_checkDraw()) {
      _handleDraw();
      return;
    }

    // Switch player
    setState(() {
      _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
    });

    // If robot mode and it's robot's turn
    if (widget.isRobotMode && _currentPlayer == 'O') {
      _makeRobotMove();
    }
  }

  bool _checkWin(int row, int col) {
    final player = _boardState[row][col]!;

    // Check row
    if (_checkLine(_boardState[row], player)) {
      _winningLine = _getWinningLine(row, 0, row, widget.boardSize - 1, true);
      return true;
    }

    // Check column
    final column = List.generate(widget.boardSize, (i) => _boardState[i][col]);
    if (_checkLine(column, player)) {
      _winningLine = _getWinningLine(0, col, widget.boardSize - 1, col, false);
      return true;
    }

    // Check diagonals
    if (row == col) {
      final diagonal = List.generate(
        widget.boardSize,
        (i) => _boardState[i][i],
      );
      if (_checkLine(diagonal, player)) {
        _winningLine = _getWinningLine(
          0,
          0,
          widget.boardSize - 1,
          widget.boardSize - 1,
          true,
        );
        return true;
      }
    }

    if (row + col == widget.boardSize - 1) {
      final diagonal = List.generate(
        widget.boardSize,
        (i) => _boardState[i][widget.boardSize - 1 - i],
      );
      if (_checkLine(diagonal, player)) {
        _winningLine = _getWinningLine(
          0,
          widget.boardSize - 1,
          widget.boardSize - 1,
          0,
          true,
        );
        return true;
      }
    }

    return false;
  }

  bool _checkLine(List<String?> line, String player) {
    int count = 0;
    for (final cell in line) {
      if (cell == player) {
        count++;
        if (count >= widget.winCondition) return true;
      } else {
        count = 0;
      }
    }
    return false;
  }

  List<int> _getWinningLine(
    int startRow,
    int startCol,
    int endRow,
    int endCol,
    bool isHorizontal,
  ) {
    final line = <int>[];
    if (isHorizontal) {
      for (int i = startCol; i <= endCol; i++) {
        line.add(startRow);
        line.add(i);
      }
    } else {
      for (int i = startRow; i <= endRow; i++) {
        line.add(i);
        line.add(startCol);
      }
    }
    return line;
  }

  bool _checkDraw() {
    for (final row in _boardState) {
      for (final cell in row) {
        if (cell == null) return false;
      }
    }
    return true;
  }

  void _handleGameEnd() {
    setState(() {
      _isGameOver = true;
      if (_currentPlayer == 'X') {
        _player1Wins++;
      } else {
        _player2Wins++;
      }
    });

    _showResult = true;
  }

  void _handleDraw() {
    setState(() {
      _isGameOver = true;
    });

    _showResult = true;
  }

  void _makeRobotMove() {
    // Simple robot logic - find first empty cell
    for (int i = 0; i < widget.boardSize; i++) {
      for (int j = 0; j < widget.boardSize; j++) {
        if (_boardState[i][j] == null) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              _onCellTap(i, j);
            }
          });
          return;
        }
      }
    }
  }

  void _newGame() {
    setState(() {
      _initializeGame();
      _showResult = false;
    });
  }

  void _useHint() {
    if (_hintCount > 0) {
      setState(() {
        _hintCount--;
        _showHint = true;
      });

      // Hide hint after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showHint = false;
          });
        }
      });
    }
  }

  void _exitGame() {
    setState(() {
      _showExitDialog = true;
    });
  }

  void _showSettingsOverlay() {
    setState(() {
      _showSettings = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // Game board - centered and properly sized
          Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: TicTacToeBoard(
                boardSize: widget.boardSize,
                winCondition: widget.winCondition,
                boardState: _boardState,
                currentPlayer: _currentPlayer,
                isGameOver: _isGameOver,
                winningLine: _winningLine,
                onCellTap: _onCellTap,
                showHints: _showHint,
                hintCells: _showHint ? [1, 1] : null, // Example hint cell
              ),
            ),
          ),

          // Top controls
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: IconButton(
              onPressed: _exitGame,
              icon: const Icon(Symbols.close),
              iconSize: 28,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: IconButton(
              onPressed: _showSettingsOverlay,
              icon: const Icon(Symbols.settings),
              iconSize: 28,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          // Game HUD - properly positioned above the board
          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            left: 0,
            right: 0,
            child: GameHUD(
              player1Name: widget.player1Name,
              player2Name: widget.player2Name,
              player1Wins: _player1Wins,
              player2Wins: _player2Wins,
              currentPlayer: _currentPlayer,
            ),
          ),

          // Turn indicator - positioned below HUD with proper spacing
          Positioned(
            top: MediaQuery.of(context).padding.top + 200,
            left: 0,
            right: 0,
            child: TurnIndicator(
              currentPlayer: _currentPlayer,
              isGameOver: _isGameOver,
            ),
          ),

          // Control bar - positioned at bottom with proper spacing
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 32,
            left: 24,
            right: 24,
            child: ControlBar(
              hintCount: _hintCount,
              onHint: _useHint,
              onNewGame: _newGame,
            ),
          ),

          // Overlays
          if (_showExitDialog)
            ExitOverlay(
              onContinue: () => setState(() => _showExitDialog = false),
              onExit: () => context.go('/home'),
            ),

          if (_showSettings)
            SettingsOverlay(
              onClose: () => setState(() => _showSettings = false),
            ),

          if (_showResult)
            ResultOverlay(
              isWin: _winningLine != null,
              isDraw: _winningLine == null,
              winner: _currentPlayer == 'X'
                  ? widget.player1Name
                  : widget.player2Name,
              onPlayAgain: _newGame,
              onHome: () => context.go('/home'),
            ),
        ],
      ),
    );
  }
}
