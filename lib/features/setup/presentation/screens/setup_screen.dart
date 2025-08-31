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

  @override
  Widget build(BuildContext context) {
    final setup = ref.watch(setupProvider);
    final setupNotifier = ref.read(setupProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                value: setup.player1Name,
                onChanged: setupNotifier.setPlayer1Name,
              ),

              const SizedBox(height: 16),

              PlayerNameInput(
                label: 'Player 2',
                value: setup.player2Name,
                onChanged: setupNotifier.setPlayer2Name,
                enabled: setup.mode == GameMode.local,
                hintText: setup.mode == GameMode.robot
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
                selectedOption: setup.firstMove,
                onOptionSelected: setupNotifier.setFirstMove,
              ),

              const SizedBox(height: 32),

              // Difficulty Selection (Robot mode only)
              if (setup.mode == GameMode.robot) ...[
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
                  selectedOption: setup.difficulty,
                  onOptionSelected: setupNotifier.setDifficulty,
                ),

                const SizedBox(height: 32),
              ],

              // Board Size Carousel
              BoardSizeSelector(
                selectedBoardSize: setup.boardSize,
                onBoardSizeChanged: setupNotifier.setBoardSize,
              ),

              const SizedBox(height: 32),

              // Win Condition Carousel
              WinConditionSelector(
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
                  onPressed: setupNotifier.isValid
                      ? () {
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
