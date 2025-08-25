import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_xo_royale/features/setup/providers/setup_provider.dart';
import 'package:tictactoe_xo_royale/features/setup/presentation/widgets/choice_chips.dart';
import 'package:tictactoe_xo_royale/features/setup/presentation/widgets/custom_text_field.dart';
import 'package:tictactoe_xo_royale/features/setup/presentation/widgets/board_carousel.dart';
import 'package:tictactoe_xo_royale/features/setup/presentation/widgets/win_carousel.dart';
import 'package:tictactoe_xo_royale/app/router/routes.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({
    super.key,
    this.challengeId,
    this.tournamentId,
    this.boardSize,
    this.winCondition,
    this.gameMode,
    this.difficulty,
    this.player1,
    this.player2,
    this.firstMove,
  });

  final String? challengeId;
  final String? tournamentId;
  final int? boardSize;
  final int? winCondition;
  final String? gameMode;
  final String? difficulty;
  final String? player1;
  final String? player2;
  final String? firstMove;

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    // Initialize setup state with query parameters if provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSetupState();
    });
  }

  void _initializeSetupState() {
    final setupNotifier = ref.read(setupProvider.notifier);

    if (widget.player1 != null) {
      setupNotifier.setPlayer1Name(widget.player1!);
    }

    if (widget.player2 != null) {
      setupNotifier.setPlayer2Name(widget.player2!);
    }

    if (widget.gameMode != null) {
      final mode = widget.gameMode == 'robot' ? GameMode.robot : GameMode.local;
      setupNotifier.setMode(mode);
    }

    if (widget.difficulty != null) {
      final difficulty = _parseDifficulty(widget.difficulty!);
      if (difficulty != null) {
        setupNotifier.setDifficulty(difficulty);
      }
    }

    if (widget.firstMove != null) {
      final firstMove = _parseFirstMove(widget.firstMove!);
      if (firstMove != null) {
        setupNotifier.setFirstMove(firstMove);
      }
    }

    if (widget.boardSize != null) {
      final boardSize = _parseBoardSize(widget.boardSize!);
      if (boardSize != null) {
        setupNotifier.setBoardSize(boardSize);
      }
    }

    if (widget.winCondition != null) {
      final winCondition = _parseWinCondition(widget.winCondition!);
      if (winCondition != null) {
        setupNotifier.setWinCondition(winCondition);
      }
    }
  }

  Difficulty? _parseDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Difficulty.easy;
      case 'medium':
        return Difficulty.medium;
      case 'hard':
        return Difficulty.hard;
      default:
        return null;
    }
  }

  FirstMove? _parseFirstMove(String firstMove) {
    switch (firstMove.toLowerCase()) {
      case 'x':
        return FirstMove.x;
      case 'o':
        return FirstMove.o;
      case 'random':
        return FirstMove.random;
      default:
        return null;
    }
  }

  BoardSize? _parseBoardSize(int boardSize) {
    switch (boardSize) {
      case 3:
        return BoardSize.threeByThree;
      case 4:
        return BoardSize.fourByFour;
      case 5:
        return BoardSize.fiveByFive;
      default:
        return null;
    }
  }

  WinCondition? _parseWinCondition(int winCondition) {
    switch (winCondition) {
      case 3:
        return WinCondition.threeInRow;
      case 4:
        return WinCondition.fourInRow;
      case 5:
        return WinCondition.fiveInRow;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final setup = ref.watch(setupProvider);
    final setupNotifier = ref.read(setupProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Game Setup',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game Mode Selection
            ChoiceChips<GameMode>(
              label: 'Game Mode',
              options: const [
                ChoiceChipOption(
                  label: 'Local Player',
                  value: GameMode.local,
                  description: 'Play with a friend',
                ),
                ChoiceChipOption(
                  label: 'Robot',
                  value: GameMode.robot,
                  description: 'Challenge the computer',
                ),
              ],
              selectedOption: setup.mode,
              onOptionSelected: setupNotifier.setMode,
            ),

            const SizedBox(height: 32),

            // Player Names Section
            Text(
              'Player Names',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Player 1',
              value: setup.player1Name,
              onChanged: setupNotifier.setPlayer1Name,
              maxLength: 12,
              autoCapitalize: true,
            ),

            const SizedBox(height: 16),

            CustomTextField(
              label: 'Player 2',
              value: setup.player2Name,
              onChanged: setupNotifier.setPlayer2Name,
              maxLength: 12,
              autoCapitalize: true,
              enabled: setup.mode == GameMode.local,
              hintText: setup.mode == GameMode.robot
                  ? 'CPU'
                  : 'Enter player name',
            ),

            const SizedBox(height: 32),

            // First Move Selection
            ChoiceChips<FirstMove>(
              label: 'First Move',
              options: const [
                ChoiceChipOption(label: 'X', value: FirstMove.x),
                ChoiceChipOption(label: 'O', value: FirstMove.o),
                ChoiceChipOption(label: 'Random', value: FirstMove.random),
              ],
              selectedOption: setup.firstMove,
              onOptionSelected: setupNotifier.setFirstMove,
            ),

            const SizedBox(height: 32),

            // Difficulty Selection (Robot mode only)
            if (setup.mode == GameMode.robot) ...[
              ChoiceChips<Difficulty>(
                label: 'Difficulty',
                options: const [
                  ChoiceChipOption(
                    label: 'Easy',
                    value: Difficulty.easy,
                    description: 'Random moves with occasional blunders',
                  ),
                  ChoiceChipOption(
                    label: 'Medium',
                    value: Difficulty.medium,
                    description: 'Strategic play with limited depth',
                  ),
                  ChoiceChipOption(
                    label: 'Hard',
                    value: Difficulty.hard,
                    description: 'Optimal play with full analysis',
                  ),
                ],
                selectedOption: setup.difficulty,
                onOptionSelected: setupNotifier.setDifficulty,
              ),

              const SizedBox(height: 32),
            ],

            // Board Size Carousel
            BoardCarousel(
              selectedBoardSize: setup.boardSize,
              onBoardSizeChanged: setupNotifier.setBoardSize,
            ),

            const SizedBox(height: 32),

            // Win Condition Carousel
            WinCarousel(
              selectedWinCondition: setup.winCondition,
              onWinConditionChanged: setupNotifier.setWinCondition,
              boardSize: setup.boardSize,
            ),

            const SizedBox(height: 48),

            // Start Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: (setupNotifier.isValid && !_isNavigating)
                    ? () async {
                        // Prevent multiple navigation calls
                        if (mounted && !_isNavigating) {
                          setState(() {
                            _isNavigating = true;
                          });

                          try {
                            // Store context before async operation
                            final navigatorContext = context;

                            // Add a small delay to prevent rapid navigation calls
                            await Future.delayed(
                              const Duration(milliseconds: 100),
                            );

                            // Navigate to game screen with setup data
                            final gameRoute = AppRoutes.getGameRoute(
                              boardSize: setupNotifier.boardSizeValue,
                              winCondition: setupNotifier.winConditionValue,
                              gameMode: setupNotifier.gameModeValue,
                              difficulty: setupNotifier.difficultyValue,
                              player1: setup.player1Name,
                              player2: setup.player2Name,
                              firstMove: setupNotifier.firstMoveValue,
                            );

                            // Use pushReplacement to avoid navigation stack issues
                            if (mounted) {
                              navigatorContext.pushReplacement(gameRoute);
                            }
                          } catch (e) {
                            // Fallback navigation if there's an error
                            debugPrint('Navigation error: $e');
                            if (mounted) {
                              context.go(AppRoutes.game);
                            }
                          } finally {
                            if (mounted) {
                              setState(() {
                                _isNavigating = false;
                              });
                            }
                          }
                        }
                      }
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isNavigating
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Text(
                        'Start Game',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
