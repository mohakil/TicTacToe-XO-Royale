import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/features/setup/providers/setup_provider.dart';
import 'package:tictactoe_xo_royale/features/setup/presentation/widgets/board_preview.dart';

class WinCarousel extends StatelessWidget {
  const WinCarousel({
    super.key,
    required this.selectedWinCondition,
    required this.onWinConditionChanged,
    required this.boardSize,
  });

  final WinCondition selectedWinCondition;
  final ValueChanged<WinCondition> onWinConditionChanged;
  final BoardSize boardSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final availableWinConditions = _getAvailableWinConditions(boardSize);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Win Condition',
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
              initialPage: availableWinConditions.indexOf(selectedWinCondition),
            ),
            onPageChanged: (index) {
              onWinConditionChanged(availableWinConditions[index]);
            },
            itemCount: availableWinConditions.length,
            itemBuilder: (context, index) {
              final winCondition = availableWinConditions[index];
              final isSelected = winCondition == selectedWinCondition;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Transform.scale(
                      scale: isSelected ? 1.0 : 0.9,
                      child: BoardPreview(
                        boardSize: boardSize,
                        showWinLine: true,
                        winCondition: winCondition,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _getWinConditionLabel(winCondition),
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

  List<WinCondition> _getAvailableWinConditions(BoardSize boardSize) {
    switch (boardSize) {
      case BoardSize.threeByThree:
        return [WinCondition.threeInRow];
      case BoardSize.fourByFour:
        return [WinCondition.threeInRow, WinCondition.fourInRow];
      case BoardSize.fiveByFive:
        return [
          WinCondition.threeInRow,
          WinCondition.fourInRow,
          WinCondition.fiveInRow,
        ];
    }
  }

  String _getWinConditionLabel(WinCondition winCondition) {
    switch (winCondition) {
      case WinCondition.threeInRow:
        return '3 in a row';
      case WinCondition.fourInRow:
        return '4 in a row';
      case WinCondition.fiveInRow:
        return '5 in a row';
    }
  }
}
