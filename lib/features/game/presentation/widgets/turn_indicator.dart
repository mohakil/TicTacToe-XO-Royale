import 'package:flutter/material.dart';

class TurnIndicator extends StatelessWidget {
  final String currentPlayer;
  final bool isGameOver;

  const TurnIndicator({
    super.key,
    required this.currentPlayer,
    required this.isGameOver,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isGameOver) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24.0),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 4.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Turn indicator icon
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: currentPlayer == 'X'
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : theme.colorScheme.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Center(
                child: Text(
                  currentPlayer,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: currentPlayer == 'X'
                        ? theme.colorScheme.primary
                        : theme.colorScheme.secondary,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12.0),

            // Turn text
            Text(
              'Your turn',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
