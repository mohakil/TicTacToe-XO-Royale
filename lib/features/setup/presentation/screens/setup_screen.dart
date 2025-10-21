import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/providers/profile_provider.dart';
import 'package:tictactoe_xo_royale/core/services/navigation_service.dart';
import 'package:tictactoe_xo_royale/features/setup/presentation/widgets/board_size_selector.dart';
import 'package:tictactoe_xo_royale/features/setup/presentation/widgets/selection_chips.dart';
import 'package:tictactoe_xo_royale/features/setup/presentation/widgets/player_name_input.dart';
import 'package:tictactoe_xo_royale/features/setup/presentation/widgets/win_condition_selector.dart';
import 'package:tictactoe_xo_royale/features/setup/providers/setup_provider.dart';
import 'package:tictactoe_xo_royale/core/models/game_enums.dart';
import 'package:tictactoe_xo_royale/app/routing/app_routes.dart';
import 'package:tictactoe_xo_royale/shared/widgets/navigation/app_bar.dart';

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

      // Set player1 name - prioritize widget parameter, then profile nickname
      if (widget.player1 != null) {
        setupNotifier.setPlayer1Name(widget.player1!);
      } else {
        // Initialize player1 name from profile nickname if not provided via parameter
        final profileNickname = ref.read(profileNicknameProvider);
        if (profileNickname.isNotEmpty && profileNickname != 'Player') {
          setupNotifier.setPlayer1Name(profileNickname);
        }
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
        final boardSize = BoardSizeExtension.fromInt(widget.boardSize!);
        setupNotifier.setBoardSize(boardSize);
      }

      if (widget.winCondition != null) {
        final winCondition = WinConditionExtension.fromInt(
          widget.winCondition!,
        );
        setupNotifier.setWinCondition(winCondition);
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

    // Listen to profile nickname changes and sync to player1 name
    ref.listen<String>(profileNicknameProvider, (previous, next) {
      // Only update if nickname is not empty and has actually changed
      if (next.isNotEmpty && next != 'Player' && previous != next) {
        // Only update player1 name if it hasn't been manually customized
        // (i.e., if it still matches the previous profile nickname or is default)
        final currentPlayer1Name = ref.read(
          setupProvider.select((state) => state.player1Name),
        );
        if (currentPlayer1Name == previous ||
            currentPlayer1Name == 'Player 1' ||
            currentPlayer1Name.isEmpty) {
          setupNotifier.setPlayer1Name(next);
        }
      }
    });

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

    return PopScope(
      canPop: false, // Prevent default back behavior
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          // Navigate back to home screen using navigation service
          NavigationService.goHome(context);
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: SharedAppBar(
          title: 'Game Setup',
          showBackButton: true,
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: context.getResponsivePadding(
              phonePadding: 16.0,
              tabletPadding: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Player Names Section
                Text(
                  'Player Names',
                  style: context.getResponsiveTextStyle(
                    theme.textTheme.titleMedium!.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                SizedBox(
                  height: context.getResponsiveSpacing(
                    phoneSpacing: 16.0,
                    tabletSpacing: 20.0,
                  ),
                ),

                PlayerNameInput(
                  label: 'Player 1',
                  value: player1Name, // Use optimized value
                  onChanged: setupNotifier.setPlayer1Name,
                ),

                SizedBox(
                  height: context.getResponsiveSpacing(
                    phoneSpacing: 16.0,
                    tabletSpacing: 20.0,
                  ),
                ),

                PlayerNameInput(
                  label: 'Player 2',
                  value: player2Name, // Use consistent player 2 name
                  onChanged: setupNotifier.setPlayer2Name,
                  enabled:
                      mode == GameMode.local, // Only editable in local mode
                  hintText: mode == GameMode.robot
                      ? 'Auto-generated based on difficulty'
                      : 'Enter player name',
                ),

                SizedBox(
                  height: context.getResponsiveSpacing(
                    phoneSpacing: 24.0,
                    tabletSpacing: 32.0,
                  ),
                ),

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
                    SelectionChipOption(
                      label: 'Random',
                      value: FirstMove.random,
                    ),
                  ],
                  selectedOption: firstMove, // Use optimized value
                  onOptionSelected: setupNotifier.setFirstMove,
                ),

                SizedBox(
                  height: context.getResponsiveSpacing(
                    phoneSpacing: 24.0,
                    tabletSpacing: 32.0,
                  ),
                ),

                // Difficulty Selection (Robot mode only)
                if (mode == GameMode.robot) ...[
                  // Use optimized value
                  SelectionChips<Difficulty>(
                    label: 'Difficulty',
                    subText: 'Choose AI intelligence level',
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

                  SizedBox(
                    height: context.getResponsiveSpacing(
                      phoneSpacing: 24.0,
                      tabletSpacing: 32.0,
                    ),
                  ),
                ],

                // Board Size Carousel
                BoardSizeSelector(
                  selectedBoardSize: boardSize, // Use optimized value
                  onBoardSizeChanged: setupNotifier.setBoardSize,
                ),

                SizedBox(
                  height: context.getResponsiveSpacing(
                    phoneSpacing: 24.0,
                    tabletSpacing: 32.0,
                  ),
                ),

                // Win Condition Carousel
                WinConditionSelector(
                  selectedWinCondition: winCondition, // Use optimized value
                  onWinConditionChanged: setupNotifier.setWinCondition,
                  boardSize: boardSize, // Use optimized value
                ),

                SizedBox(
                  height: context.getResponsiveSpacing(
                    phoneSpacing: 32.0,
                    tabletSpacing: 48.0,
                  ),
                ),

                // Start Button
                SizedBox(
                  width: double.infinity,
                  height: context.getResponsiveButtonHeight(
                    phoneHeight: 48.0,
                    tabletHeight: 56.0,
                  ),
                  child: FilledButton(
                    onPressed:
                        isValid // Use optimized value
                        ? () async {
                            // Navigate to game screen with setup data using navigation service
                            final gameParams = GameSetupParams(
                              boardSize: boardSize.value,
                              winCondition: winCondition.value,
                              gameMode: mode.toString().split('.').last,
                              difficulty: mode == GameMode.local
                                  ? null
                                  : difficulty.value.toString().split('.').last,
                              player1: player1Name,
                              player2: player2Name,
                              firstMove: firstMove.value
                                  .toString()
                                  .split('.')
                                  .last,
                            );

                            await NavigationService.goGame(
                              context,
                              params: gameParams,
                            );
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
      ),
    );
  }
}
