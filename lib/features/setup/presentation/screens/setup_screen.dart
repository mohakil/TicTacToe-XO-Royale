import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_xo_royale/app/router/routes.dart';
import 'package:tictactoe_xo_royale/features/setup/presentation/widgets/board_size_selector.dart';
import 'package:tictactoe_xo_royale/features/setup/presentation/widgets/selection_chips.dart';
import 'package:tictactoe_xo_royale/features/setup/presentation/widgets/player_name_input.dart';
import 'package:tictactoe_xo_royale/features/setup/presentation/widgets/win_condition_selector.dart';
import 'package:tictactoe_xo_royale/features/setup/providers/setup_provider.dart';

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
  final BoardSize? boardSize;
  final WinCondition? winCondition;
  final String? gameMode;
  final String? difficulty;
  final String? player1;
  final String? player2;
  final String? firstMove;

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize the provider state based on widget parameters
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final setupNotifier = ref.read(setupProvider.notifier);

      // Set game mode first (this affects other settings)
      if (widget.gameMode != null) {
        final mode = widget.gameMode == 'robot'
            ? GameMode.robot
            : GameMode.local;
        setupNotifier.setMode(mode);
      }

      // Set other parameters if provided
      if (widget.player1 != null) {
        setupNotifier.setPlayer1Name(widget.player1!);
      }

      if (widget.player2 != null) {
        setupNotifier.setPlayer2Name(widget.player2!);
      }

      if (widget.firstMove != null) {
        final firstMove = _parseFirstMove(widget.firstMove!);
        if (firstMove != null) {
          setupNotifier.setFirstMove(firstMove);
        }
      }

      if (widget.difficulty != null) {
        final difficulty = _parseDifficulty(widget.difficulty!);
        if (difficulty != null) {
          setupNotifier.setDifficulty(difficulty);
        }
      }

      if (widget.boardSize != null) {
        setupNotifier.setBoardSize(widget.boardSize!);
      }

      if (widget.winCondition != null) {
        setupNotifier.setWinCondition(widget.winCondition!);
      }
    });
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
      case 'player1':
      case 'x':
        return FirstMove.player1;
      case 'player2':
      case 'o':
        return FirstMove.player2;
      case 'random':
        return FirstMove.random;
      default:
        return null;
    }
  }

  // Helper method to check if setup is valid
  bool _isValidSetup(GameSetup setup) {
    if (setup.player1Name.trim().isEmpty) {
      return false;
    }
    if (setup.mode == GameMode.local && setup.player2Name.trim().isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // ✅ OPTIMIZED: Use select for granular rebuilds - only rebuild when specific values change
    final setupNotifier = ref.read(setupProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Use select for frequently accessed setup properties to minimize rebuilds
    final player1Name = ref.watch(
      setupProvider.select((state) => state.player1Name),
    );
    final player2Name = ref.watch(
      setupProvider.select((state) => state.player2Name),
    );
    final mode = ref.watch(setupProvider.select((state) => state.mode));
    final firstMove = ref.watch(
      setupProvider.select((state) => state.firstMove),
    );
    final difficulty = ref.watch(
      setupProvider.select((state) => state.difficulty),
    );
    final boardSize = ref.watch(
      setupProvider.select((state) => state.boardSize),
    );
    final winCondition = ref.watch(
      setupProvider.select((state) => state.winCondition),
    );
    final isValid = ref.watch(
      setupProvider.select((state) => _isValidSetup(state)),
    );

    // Provider state is now properly initialized in initState

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          tooltip: 'Back to Home',
        ),
        title: Text(
          'Game Setup',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Player Names Section
              Text(
                'Player Names',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),

              PlayerNameInput(
                label: 'Player 1',
                value: player1Name, // Use optimized value
                onChanged: setupNotifier.setPlayer1Name,
              ),

              const SizedBox(height: 16),

              PlayerNameInput(
                label: 'Player 2',
                value: player2Name, // Use optimized value
                onChanged: setupNotifier.setPlayer2Name,
                enabled: mode == GameMode.local, // Use optimized value
                hintText:
                    mode ==
                        GameMode
                            .robot // Use optimized value
                    ? 'CPU'
                    : 'Enter player name',
              ),

              const SizedBox(height: 32),

              // First Move Selection
              SelectionChips<FirstMove>(
                label: 'First Move',
                subText: 'Choose who goes first',
                options: const [
                  SelectionChipOption(
                    label: 'Player 1 (X)',
                    value: FirstMove.player1,
                  ),
                  SelectionChipOption(
                    label: 'Player 2 (O)',
                    value: FirstMove.player2,
                  ),
                  SelectionChipOption(label: 'Random', value: FirstMove.random),
                ],
                selectedOption: firstMove, // Use optimized value
                onOptionSelected: setupNotifier.setFirstMove,
              ),

              const SizedBox(height: 32),

              // Difficulty Selection (Robot mode only)
              if (mode == GameMode.robot) ...[
                // Use optimized value
                SelectionChips<Difficulty>(
                  label: 'Difficulty',
                  options: const [
                    SelectionChipOption(
                      label: 'Easy',
                      value: Difficulty.easy,
                      description: 'Random moves with occasional blunders',
                    ),
                    SelectionChipOption(
                      label: 'Medium',
                      value: Difficulty.medium,
                      description: 'Strategic play with limited depth',
                    ),
                    SelectionChipOption(
                      label: 'Hard',
                      value: Difficulty.hard,
                      description: 'Optimal play with full analysis',
                    ),
                  ],
                  selectedOption: difficulty, // Use optimized value
                  onOptionSelected: setupNotifier.setDifficulty,
                ),

                const SizedBox(height: 32),
              ],

              // Board Size Carousel
              BoardSizeSelector(
                selectedBoardSize: boardSize, // Use optimized value
                onBoardSizeChanged: setupNotifier.setBoardSize,
              ),

              const SizedBox(height: 32),

              // Win Condition Carousel
              WinConditionSelector(
                selectedWinCondition: winCondition, // Use optimized value
                onWinConditionChanged: setupNotifier.setWinCondition,
                boardSize: boardSize, // Use optimized value
              ),

              const SizedBox(height: 48),

              // Start Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed:
                      isValid // Use optimized value
                      ? () {
                          // Navigate to game screen with setup data
                          final gameRoute = AppRoutes.getGameRoute(
                            boardSize: setupNotifier.boardSizeValue,
                            winCondition: setupNotifier.winConditionValue,
                            gameMode: setupNotifier.gameModeValue,
                            difficulty: setupNotifier.difficultyValue,
                            player1: player1Name, // Use optimized value
                            player2: player2Name, // Use optimized value
                            firstMove: setupNotifier.firstMoveValue,
                          );

                          // Use go to navigate to game route
                          GoRouter.of(context).go(gameRoute);
                        }
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
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
      ),
    );
  }
}
