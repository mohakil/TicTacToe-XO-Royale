import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/features/setup/presentation/widgets/board_preview.dart';
import 'package:tictactoe_xo_royale/features/setup/providers/setup_provider.dart';

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
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose the size of your game board',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
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
                    const SizedBox(height: 12),
                    Text(
                      _getBoardSizeLabel(boardSize),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getBoardSizeDescription(boardSize),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                        fontSize: 11,
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
