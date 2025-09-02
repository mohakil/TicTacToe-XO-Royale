import 'package:flutter/material.dart';

/// Optimized game status widget with performance improvements
class GameStatus extends StatelessWidget {
  final String currentPlayer;
  final bool isGameOver;

  const GameStatus({
    required this.currentPlayer,
    required this.isGameOver,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Early return for better performance
    if (isGameOver) {
      return const SizedBox.shrink();
    }

    return RepaintBoundary(
      child: Center(child: _TurnIndicator(currentPlayer: currentPlayer)),
    );
  }
}

/// Optimized turn indicator widget with RepaintBoundary
class _TurnIndicator extends StatelessWidget {
  final String currentPlayer;

  const _TurnIndicator({required this.currentPlayer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isXPlayer = currentPlayer == 'X';
    final playerColor = isXPlayer
        ? theme.colorScheme.primary
        : theme.colorScheme.secondary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
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
              color: playerColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                currentPlayer,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: playerColor,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

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
    );
  }
}
