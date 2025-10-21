import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/models/game_enums.dart';
import 'package:tictactoe_xo_royale/core/models/game_history.dart';
import 'package:tictactoe_xo_royale/core/providers/providers.dart';
import 'package:tictactoe_xo_royale/core/models/robot_config.dart';
import 'package:tictactoe_xo_royale/core/models/game_config.dart';
import 'package:tictactoe_xo_royale/core/services/game_logic.dart';
import 'package:tictactoe_xo_royale/core/services/navigation_service.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/overlays/game_result_overlay.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/game_interface/game_controls.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/game_board/game_board.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/game_interface/game_header.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/overlays/exit_confirmation_overlay.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/overlays/game_settings_overlay.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/overlays/game_countdown_overlay.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/game_interface/game_status.dart';
import 'package:tictactoe_xo_royale/features/achievements/services/achievement_data_service.dart';

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
  bool _isWinAnimationPlaying = false;
  bool _showCountdown = true; // Show countdown on game start
  int _hintCount = 3;
  Position? _hintPosition;

  // Session stats (separate from profile lifetime stats)
  int _player1SessionWins = 0;
  int _player2SessionWins = 0;

  @override
  void initState() {
    super.initState();
    // Initialize game configuration after countdown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Don't initialize game immediately, wait for countdown
      // Game will initialize when countdown completes
    });
  }

  void _onCountdownComplete() {
    setState(() {
      _showCountdown = false;
    });
    // Initialize game after countdown
    _initializeGameConfig();
  }

  void _initializeGameConfig() {
    // Reset session stats for fresh game start
    _resetSessionStats();

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
    final success = gameNotifier.makeMove(row, col);

    if (success) {
      // Check game result after move
      final gameResult = gameNotifier.gameResult;

      // Handle win sequence: start animation first, then show popup
      if (gameResult.isGameOver) {
        _handleWinSequence(gameResult);
      }
    }
  }

  void _handleWinSequence(GameLogicResult gameResult) {
    if (gameResult.isWin &&
        gameResult.winningLine != null &&
        gameResult.winningLine!.isNotEmpty) {
      // Start win animation sequence
      setState(() {
        _isWinAnimationPlaying = true;
      });

      // Wait for winning line animation to complete (2 seconds)
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          // Update profile stats before showing result
          _updateProfileStats(gameResult);

          setState(() {
            _isWinAnimationPlaying = false;
            _showResult = true;
          });
        }
      });
    } else {
      // For draws or games without winning lines, show result immediately
      // Update profile stats before showing result
      _updateProfileStats(gameResult);

      setState(() {
        _showResult = true;
      });
    }
  }

  void _updateProfileStats(GameLogicResult gameResult) {
    // Update profile stats based on game result
    final profileNotifier = ref.read(profileProvider.notifier);

    if (gameResult.isWin) {
      // Player X wins
      if (gameResult.winner == CellState.X) {
        profileNotifier.updateGameStats(isWin: true);
        _player1SessionWins++; // Update session stats for display
      } else {
        // Player O wins (robot or player2)
        profileNotifier.updateGameStats(isWin: false);
        _player2SessionWins++; // Update session stats for display
      }
    } else if (gameResult.isDraw) {
      // Draw
      profileNotifier.updateGameStats(isDraw: true);
    }

    // Check for achievement unlocks based on game result
    _checkForAchievementUnlocks(gameResult);

    // Add game to history
    _addGameToHistory(gameResult);

    // Update UI state to reflect new session stats
    setState(() {});
  }

  void _checkForAchievementUnlocks(GameLogicResult gameResult) {
    try {
      // Get current profile stats for achievement checking
      final currentProfile = ref.read(profileProvider).profile;
      final currentStats = currentProfile?.stats;

      if (currentStats == null) return;

      // Determine game context for achievement checking
      final isRobotGame = widget.isRobotMode;
      final robotDifficulty = widget.isRobotMode
          ? DifficultyExtension.fromString(widget.difficulty).index + 1
          : null;

      // Check if this is a perfect game (no pieces lost by winner)
      final isPerfectGame =
          gameResult.isWin &&
          gameResult.winner != null &&
          _isPerfectGame(gameResult);

      // Check if this is a comeback (won after being behind)
      final isComeback =
          gameResult.isWin &&
          gameResult.winner != null &&
          _isComeback(gameResult);

      // Get board sizes and win conditions played (for board/win condition achievements)
      final boardSizesPlayed = _getBoardSizesPlayed();
      final winConditionsPlayed = _getWinConditionsPlayed();

      // Check for achievement unlocks
      final unlockedAchievementId =
          AchievementDataService.checkForAchievementUnlock(
            currentStats.wins,
            currentStats.streak,
            boardSizesPlayed,
            winConditionsPlayed,
            isRobotGame,
            robotDifficulty,
            isPerfectGame,
            isComeback,
          );

      if (unlockedAchievementId != null) {
        // Unlock the achievement in the database
        final achievementsNotifier = ref.read(achievementsProvider.notifier);
        achievementsNotifier.unlockAchievement(unlockedAchievementId);
      }
    } catch (error) {
      // Log error but don't crash the game
      debugPrint('Error checking for achievement unlocks: $error');
    }
  }

  bool _isPerfectGame(GameLogicResult gameResult) {
    // A perfect game is when the winner didn't lose any pieces
    // This is a simplified check - in a real implementation, you'd need to track piece losses
    return gameResult.isWin && gameResult.winner != null;
  }

  bool _isComeback(GameLogicResult gameResult) {
    // A comeback is when you win after being 2 pieces behind
    // This is a simplified check - in a real implementation, you'd need to track board state
    return gameResult.isWin && gameResult.winner != null;
  }

  Set<int> _getBoardSizesPlayed() {
    // In a real implementation, this would track all board sizes played
    // For now, return the current board size
    return {widget.boardSize};
  }

  Set<int> _getWinConditionsPlayed() {
    // In a real implementation, this would track all win conditions played
    // For now, return the current win condition
    return {widget.winCondition};
  }

  void _addGameToHistory(GameLogicResult gameResult) {
    final profileNotifier = ref.read(profileProvider.notifier);

    // Determine opponent name based on game mode
    final gameLogic = ref.read(gameProvider);
    final opponentName = gameLogic.config.isRobotMode
        ? widget.player2Name
        : 'Local Player';

    // Create game history item
    final historyItem = GameHistoryItem(
      opponent: opponentName,
      result: gameResult.isWin
          ? (gameResult.winner == CellState.X
                ? GameResult.win
                : GameResult.loss)
          : GameResult.draw,
      boardSize: '${widget.boardSize}x${widget.boardSize}',
      date: DateTime.now(),
      duration: const Duration(
        minutes: 5,
      ), // Default duration, can be enhanced later
      score: gameResult.isWin
          ? (gameResult.winner == CellState.X ? '3-0' : '0-3')
          : '1-1',
    );

    // Add to history
    profileNotifier.addGameToHistory(historyItem);
  }

  void _newGame() {
    // Reset game state
    final gameNotifier = ref.read(gameProvider.notifier);
    gameNotifier.resetGame();

    // DO NOT reset session stats - keep current session win counts
    // Session stats only reset when starting fresh from setup screen

    // Reset UI state
    setState(() {
      _showResult = false;
      _showHint = false;
      _isWinAnimationPlaying = false;
      _hintCount = 3; // Reset hint count
    });
  }

  void _resetSessionStats() {
    // Reset session win counts to 0 for fresh game start
    _player1SessionWins = 0;
    _player2SessionWins = 0;
  }

  void _useHint() {
    if (_hintCount > 0) {
      final gameLogic = ref.read(gameProvider);
      final availableMoves = gameLogic.getAvailableMoves();
      final board = gameLogic.board;
      final currentPlayer = gameLogic.getNextPlayer();
      final robotService = ref.read(robotServiceProvider);
      _hintPosition = robotService.getHint(
        availableMoves: availableMoves,
        board: board,
        boardSize: widget.boardSize,
        winCondition: widget.winCondition,
        currentPlayer: currentPlayer,
      );

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

    // Auto-show result overlay when game ends (for robot moves or initialization)
    if (isGameOver && !_showResult && !_isWinAnimationPlaying) {
      // Check if we need to show win animation first
      if (gameResult.isWin &&
          gameResult.winningLine != null &&
          gameResult.winningLine!.isNotEmpty) {
        _isWinAnimationPlaying = true;
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            // Update profile stats before showing result
            _updateProfileStats(gameResult);

            setState(() {
              _isWinAnimationPlaying = false;
              _showResult = true;
            });
          }
        });
      } else {
        // Update profile stats before showing result
        _updateProfileStats(gameResult);

        _showResult = true;
      }
    }

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
              top:
                  context.topSafeArea +
                  context.getResponsiveSpacing(
                    phoneSpacing: context.screenHeight * 0.35,
                    tabletSpacing: context.screenHeight * 0.30,
                  ),
              left: 0,
              right: 0,
              child: RepaintBoundary(
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: context.screenWidth * 0.9,
                      maxHeight: context.screenHeight * 0.6,
                    ),
                    child: GameBoard(
                      boardSize: widget.boardSize,
                      winCondition: widget.winCondition,
                      boardState: boardState, // Use optimized board state
                      currentPlayer:
                          currentPlayer, // Use optimized current player
                      isGameOver: isGameOver, // Use optimized game over state
                      winningLine: gameResult.winningLine,
                      onCellTap: _isWinAnimationPlaying
                          ? null
                          : _onCellTap, // Disable taps during win animation
                      showHints: _showHint,
                      hintCells: _showHint
                          ? [_hintPosition!]
                          : null, // Real hint position
                      isRobotTurn:
                          widget.isRobotMode &&
                          currentPlayer == CellState.O &&
                          !isGameOver, // Robot's turn when it's O and game not over
                    ),
                  ),
                ),
              ),
            ),

            // Top controls - positioned just below safe area
            Positioned(
              top:
                  context.topSafeArea -
                  context.getResponsiveSpacing(
                    phoneSpacing: 6.0,
                    tabletSpacing: 6.0,
                  ),
              left: context.getResponsiveSpacing(
                phoneSpacing: 16.0,
                tabletSpacing: 16.0,
              ),
              child: RepaintBoundary(
                child: IconButton(
                  onPressed: _exitGame,
                  icon: const Icon(Icons.close),
                  iconSize: context.getResponsiveIconSize(
                    phoneSize: 24.0,
                    tabletSize: 28.0,
                  ),
                  color: Theme.of(context).colorScheme.onSurface,
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.all(
                      context.getResponsiveSpacing(
                        phoneSpacing: 10.0,
                        tabletSpacing: 10.0,
                      ),
                    ), // Ensure 48dp tap target
                  ),
                ),
              ),
            ),

            Positioned(
              top:
                  context.topSafeArea -
                  context.getResponsiveSpacing(
                    phoneSpacing: 6.0,
                    tabletSpacing: 6.0,
                  ),
              right: context.getResponsiveSpacing(
                phoneSpacing: 16.0,
                tabletSpacing: 16.0,
              ),
              child: RepaintBoundary(
                child: IconButton(
                  onPressed: _showSettingsOverlay,
                  icon: const Icon(Icons.settings),
                  iconSize: context.getResponsiveIconSize(
                    phoneSize: 24.0,
                    tabletSize: 28.0,
                  ),
                  color: Theme.of(context).colorScheme.onSurface,
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.all(
                      context.getResponsiveSpacing(
                        phoneSpacing: 10.0,
                        tabletSpacing: 10.0,
                      ),
                    ), // Ensure 48dp tap target
                  ),
                ),
              ),
            ),

            // Game HUD - positioned closer to top controls
            // Note: Verify color contrast meets WCAG 4.5:1 for accessibility
            Positioned(
              top:
                  context.topSafeArea +
                  context.getResponsiveSpacing(
                    phoneSpacing: context.screenHeight * 0.05,
                    tabletSpacing: context.screenHeight * 0.04,
                  ),
              left: 0,
              right: 0,
              child: RepaintBoundary(
                child: GameHeader(
                  player1Name: widget.player1Name,
                  player2Name: widget.player2Name,
                  player1Wins: _player1SessionWins,
                  player2Wins: _player2SessionWins,
                  currentPlayer:
                      currentPlayer.name, // Use optimized current player
                ),
              ),
            ),

            // Turn indicator - positioned just below game header
            Positioned(
              top:
                  context.topSafeArea +
                  context.getResponsiveSpacing(
                    phoneSpacing: context.screenHeight * 0.25,
                    tabletSpacing: context.screenHeight * 0.22,
                  ),
              left: 0,
              right: 0,
              child: RepaintBoundary(
                child: GameStatus(
                  currentPlayer: _isWinAnimationPlaying
                      ? "🎉 WINNING!"
                      : currentPlayer.name, // Use optimized current player
                  isGameOver: isGameOver, // Use optimized game over state
                  isRobotThinking:
                      ref.isRobotThinking, // Pass robot thinking state
                ),
              ),
            ),

            // Control bar - positioned at bottom with proper spacing
            Positioned(
              bottom:
                  context.bottomSafeArea +
                  context.getResponsiveSpacing(
                    phoneSpacing: 24.0,
                    tabletSpacing: 32.0,
                  ),
              left: context.getResponsiveSpacing(
                phoneSpacing: 16.0,
                tabletSpacing: 24.0,
              ),
              right: context.getResponsiveSpacing(
                phoneSpacing: 16.0,
                tabletSpacing: 24.0,
              ),
              child: RepaintBoundary(
                child: GameControls(
                  hintCount: _hintCount,
                  onHint: _useHint,
                  onNewGame: _newGame,
                ),
              ),
            ),

            // Overlays
            if (_showCountdown)
              GameCountdownOverlay(onComplete: _onCountdownComplete),

            if (_showExitDialog)
              ExitConfirmationOverlay(
                onContinue: () => setState(() => _showExitDialog = false),
                onExit: () => NavigationService.goHome(context),
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
                onHome: () => NavigationService.goHome(context),
              ),
          ],
        ),
      ),
    );
  }
}
