import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_xo_royale/core/providers/providers.dart';
import 'package:tictactoe_xo_royale/core/models/game_enums.dart';
import 'package:tictactoe_xo_royale/core/models/robot_config.dart';
import 'package:tictactoe_xo_royale/core/models/game_config.dart';
import 'package:tictactoe_xo_royale/core/services/game_logic.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/game_interface/game_controls.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/game_board/game_board.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/game_interface/game_header.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/overlays/exit_confirmation_overlay.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/overlays/game_result_overlay.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/overlays/game_settings_overlay.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/game_interface/game_status.dart';

/// Main game screen widget for Tic Tac Toe XO Royale
///
/// This screen manages the entire game interface including:
/// - Game board with interactive cells
/// - Player turn indicator
/// - Game control bar with settings and hints
/// - Result overlay for game outcomes
/// - Exit confirmation dialog
/// - Settings overlay for game preferences
///
/// The screen uses Riverpod for state management and integrates with
/// the game logic service for move validation and win detection.
class GameScreen extends ConsumerStatefulWidget {
  /// Size of the game board (e.g., 3 for 3x3, 4 for 4x4)
  final int boardSize;

  /// Number of consecutive marks needed to win
  final int winCondition;

  /// Name of the first player (X)
  final String player1Name;

  /// Name of the second player (O) or robot name
  final String player2Name;

  /// Whether the game is in robot/AI mode
  final bool isRobotMode;

  /// Difficulty level for robot opponent ('easy', 'medium', 'hard')
  final String difficulty;

  /// Which player makes the first move ('player1', 'player2', 'random')
  final String firstMove;

  const GameScreen({
    super.key,
    this.boardSize = 3,
    this.winCondition = 3,
    this.player1Name = 'Player 1',
    this.player2Name = 'Player 2',
    this.isRobotMode = false,
    this.difficulty = 'medium',
    this.firstMove = 'random',
  });

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  // UI state (not game state)
  bool _showExitDialog = false;
  bool _showSettings = false;
  bool _showHint = false;
  bool _showResult = false;
  int _hintCount = 3;

  @override
  void initState() {
    super.initState();
    // Initialize game configuration
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeGameConfig();
    });
  }

  void _initializeGameConfig() {
    final gameNotifier = ref.read(gameProvider.notifier);

    // Create game configuration
    final config = GameConfig(
      boardSize: BoardSizeExtension.fromInt(widget.boardSize),
      winCondition: WinConditionExtension.fromInt(widget.winCondition),
      gameMode: widget.isRobotMode ? GameMode.robot : GameMode.local,
      firstMove: FirstMoveExtension.fromString(widget.firstMove),
      player1Name: widget.player1Name,
      player2Name: widget.player2Name,
      robotConfig: widget.isRobotMode
          ? RobotConfig.forDifficulty(
              DifficultyExtension.fromString(widget.difficulty),
            )
          : null,
    );

    gameNotifier.initializeGame(config);
  }

  void _onCellTap(int row, int col) {
    // Use ref.read to get the notifier and make the move
    final gameNotifier = ref.read(gameProvider.notifier);
    gameNotifier.makeMove(row, col);

    // Check game result after move
    final gameResult = gameNotifier.gameResult;

    // Show result overlay if game is over
    if (gameResult.isGameOver) {
      setState(() {
        _showResult = true;
      });
    }
  }

  void _newGame() {
    setState(() {
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
    setState(() => _showSettings = true);
  }

  @override
  Widget build(BuildContext context) {
    // Use simplified providers
    final gameLogic = ref.watch(gameProvider);
    final gameResult = ref.gameResult;
    final currentPlayer = ref.currentPlayer;
    final isGameOver = ref.isGameOver;
    final boardState = gameLogic.board;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          // Show game exit overlay
          setState(() {
            _showExitDialog = true;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Stack(
          children: [
            // Game board - positioned above turn indicator
            Positioned(
              top: MediaQuery.of(context).padding.top + 320,
              left: 0,
              right: 0,
              child: RepaintBoundary(
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.9,
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: GameBoard(
                      boardSize: widget.boardSize,
                      winCondition: widget.winCondition,
                      boardState: boardState, // Use optimized board state
                      currentPlayer:
                          currentPlayer, // Use optimized current player
                      isGameOver: isGameOver, // Use optimized game over state
                      winningLine: gameResult.winningLine,
                      onCellTap: _onCellTap,
                      showHints: _showHint,
                      hintCells: _showHint
                          ? [const Position(1, 1)]
                          : null, // Example hint cell
                    ),
                  ),
                ),
              ),
            ),

            // Top controls - positioned just below safe area
            Positioned(
              top: MediaQuery.of(context).padding.top - 16,
              left: 16,
              child: RepaintBoundary(
                child: IconButton(
                  onPressed: _exitGame,
                  icon: const Icon(Icons.close),
                  iconSize: 28,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top - 16,
              right: 16,
              child: RepaintBoundary(
                child: IconButton(
                  onPressed: _showSettingsOverlay,
                  icon: const Icon(Icons.settings),
                  iconSize: 28,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),

            // Game HUD - positioned closer to top controls
            Positioned(
              top: MediaQuery.of(context).padding.top + 40,
              left: 0,
              right: 0,
              child: RepaintBoundary(
                child: GameHeader(
                  player1Name: widget.player1Name,
                  player2Name: widget.player2Name,
                  player1Wins: 0, // TODO(Add win tracking to providers)
                  player2Wins: 0, // TODO(Add win tracking to providers)
                  currentPlayer:
                      currentPlayer.name, // Use optimized current player
                ),
              ),
            ),

            // Turn indicator - positioned just below game header
            Positioned(
              top: MediaQuery.of(context).padding.top + 220,
              left: 0,
              right: 0,
              child: RepaintBoundary(
                child: GameStatus(
                  currentPlayer:
                      currentPlayer.name, // Use optimized current player
                  isGameOver: isGameOver, // Use optimized game over state
                ),
              ),
            ),

            // Control bar - positioned at bottom with proper spacing
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 32,
              left: 24,
              right: 24,
              child: RepaintBoundary(
                child: GameControls(
                  hintCount: _hintCount,
                  onHint: _useHint,
                  onNewGame: _newGame,
                ),
              ),
            ),

            // Overlays
            if (_showExitDialog)
              ExitConfirmationOverlay(
                onContinue: () => setState(() => _showExitDialog = false),
                onExit: () => context.go('/home'),
              ),

            if (_showSettings)
              GameSettingsOverlay(
                onClose: () => setState(() => _showSettings = false),
              ),

            if (_showResult)
              GameResultOverlay(
                isWin: gameResult.isWin,
                isDraw: gameResult.isDraw,
                winner: gameResult.winner == CellState.X
                    ? widget.player1Name
                    : widget.player2Name,
                onPlayAgain: _newGame,
                onHome: () => context.go('/home'),
              ),
          ],
        ),
      ),
    );
  }
}
