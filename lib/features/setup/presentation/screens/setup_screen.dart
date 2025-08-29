import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_xo_royale/app/router/routes.dart';
import 'package:tictactoe_xo_royale/features/setup/presentation/widgets/board_carousel.dart';
import 'package:tictactoe_xo_royale/features/setup/presentation/widgets/choice_chips.dart';
import 'package:tictactoe_xo_royale/features/setup/presentation/widgets/custom_text_field.dart';
import 'package:tictactoe_xo_royale/features/setup/presentation/widgets/win_carousel.dart';
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
    // No provider modification here - let the UI react to the initial parameters
  }

  // Difficulty? _parseDifficulty(String difficulty) { ... }
  // FirstMove? _parseFirstMove(String firstMove) { ... }

  @override
  Widget build(BuildContext context) {
    final setup = ref.watch(setupProvider);
    final setupNotifier = ref.read(setupProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Use widget parameters to determine the effective setup state
    final effectiveMode = widget.gameMode == 'robot'
        ? GameMode.robot
        : GameMode.local;
    final effectiveSetup = setup.copyWith(mode: effectiveMode);

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

              CustomTextField(
                label: 'Player 1',
                value: effectiveSetup.player1Name,
                onChanged: setupNotifier.setPlayer1Name,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                label: 'Player 2',
                value: effectiveSetup.player2Name,
                onChanged: setupNotifier.setPlayer2Name,
                enabled: effectiveSetup.mode == GameMode.local,
                hintText: effectiveSetup.mode == GameMode.robot
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
                selectedOption: effectiveSetup.firstMove,
                onOptionSelected: setupNotifier.setFirstMove,
              ),

              const SizedBox(height: 32),

              // Difficulty Selection (Robot mode only)
              if (effectiveSetup.mode == GameMode.robot) ...[
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
                  selectedOption: effectiveSetup.difficulty,
                  onOptionSelected: setupNotifier.setDifficulty,
                ),

                const SizedBox(height: 32),
              ],

              // Board Size Carousel
              BoardCarousel(
                selectedBoardSize: effectiveSetup.boardSize,
                onBoardSizeChanged: setupNotifier.setBoardSize,
              ),

              const SizedBox(height: 32),

              // Win Condition Carousel
              WinCarousel(
                selectedWinCondition: effectiveSetup.winCondition,
                onWinConditionChanged: setupNotifier.setWinCondition,
                boardSize: effectiveSetup.boardSize,
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
                            player1: effectiveSetup.player1Name,
                            player2: effectiveSetup.player2Name,
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
