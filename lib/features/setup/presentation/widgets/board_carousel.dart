import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/features/setup/providers/setup_provider.dart';
import 'package:tictactoe_xo_royale/features/setup/presentation/widgets/board_preview.dart';

class BoardCarousel extends StatelessWidget {
  const BoardCarousel({
    super.key,
    required this.selectedBoardSize,
    required this.onBoardSizeChanged,
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
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
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
                      child: BoardPreview(boardSize: boardSize),
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
}
