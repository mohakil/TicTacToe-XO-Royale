import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/features/setup/presentation/widgets/board_preview.dart';
import 'package:tictactoe_xo_royale/core/models/game_enums.dart';

class BoardSizeSelector extends StatelessWidget {
  const BoardSizeSelector({
    required this.selectedBoardSize,
    required this.onBoardSizeChanged,
    super.key,
  });

  final BoardSize selectedBoardSize;
  final ValueChanged<BoardSize> onBoardSizeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final boardOptions = [
      BoardSize.threeByThree,
      BoardSize.fourByFour,
      BoardSize.fiveByFive,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Board Size',
          style: context.getResponsiveTextStyle(
            theme.textTheme.titleMedium!.copyWith(color: colorScheme.onSurface),
          ),
        ),
        SizedBox(
          height: context.getResponsiveSpacing(
            phoneSpacing: 8.0,
            tabletSpacing: 8.0,
          ),
        ),
        Text(
          'Choose the size of your game board',
          style: context.getResponsiveTextStyle(
            theme.textTheme.bodySmall!.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        SizedBox(
          height: context.getResponsiveSpacing(
            phoneSpacing: 12.0,
            tabletSpacing: 16.0,
          ),
        ),
        SizedBox(
          height: context.getResponsiveButtonHeight(
            phoneHeight: 160.0,
            tabletHeight: 180.0,
          ),
          child: PageView.builder(
            controller: PageController(
              viewportFraction: 0.7,
              initialPage: boardOptions.indexOf(selectedBoardSize),
            ),
            onPageChanged: (index) {
              onBoardSizeChanged(boardOptions[index]);
            },
            itemCount: boardOptions.length,
            itemBuilder: (context, index) {
              final boardSize = boardOptions[index];
              final isSelected = boardSize == selectedBoardSize;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Transform.scale(
                      scale: isSelected ? 1.0 : 0.9,
                      child: BoardPreview(
                        key: ValueKey('board_${boardSize.name}'),
                        boardSize: boardSize,
                      ),
                    ),
                    SizedBox(
                      height: context.getResponsiveSpacing(
                        phoneSpacing: 8.0,
                        tabletSpacing: 12.0,
                      ),
                    ),
                    Text(
                      _getBoardSizeLabel(boardSize),
                      style: context.getResponsiveTextStyle(
                        theme.textTheme.bodyMedium!.copyWith(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: context.getResponsiveSpacing(
                        phoneSpacing: 4.0,
                        tabletSpacing: 4.0,
                      ),
                    ),
                    Text(
                      _getBoardSizeDescription(boardSize),
                      style: context.getResponsiveTextStyle(
                        theme.textTheme.bodySmall!.copyWith(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getBoardSizeLabel(BoardSize boardSize) {
    switch (boardSize) {
      case BoardSize.threeByThree:
        return '3 × 3';
      case BoardSize.fourByFour:
        return '4 × 4';
      case BoardSize.fiveByFive:
        return '5 × 5';
    }
  }

  String _getBoardSizeDescription(BoardSize boardSize) {
    switch (boardSize) {
      case BoardSize.threeByThree:
        return 'Classic tic-tac-toe';
      case BoardSize.fourByFour:
        return 'More strategic gameplay';
      case BoardSize.fiveByFive:
        return 'Advanced strategy game';
    }
  }
}
