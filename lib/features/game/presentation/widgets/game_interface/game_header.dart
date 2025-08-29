import 'package:flutter/material.dart';
// No longer needed - using standard Material Icons

class GameHeader extends StatelessWidget {
  final String player1Name;
  final String player2Name;
  final int player1Wins;
  final int player2Wins;
  final String currentPlayer;

  const GameHeader({
    required this.player1Name,
    required this.player2Name,
    required this.player1Wins,
    required this.player2Wins,
    required this.currentPlayer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Player 1 (X)
          Expanded(
            child: _buildPlayerCard(
              context,
              player1Name,
              player1Wins,
              'X',
              currentPlayer == 'X',
              theme.colorScheme.primary,
            ),
          ),

          // VS indicator - centered with proper spacing
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              'VS',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          // Player 2 (O)
          Expanded(
            child: _buildPlayerCard(
              context,
              player2Name,
              player2Wins,
              'O',
              currentPlayer == 'O',
              theme.colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(
    BuildContext context,
    String playerName,
    int wins,
    String symbol,
    bool isActive,
    Color symbolColor,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? symbolColor.withValues(alpha: 0.5)
              : theme.colorScheme.outline.withValues(alpha: 0.2),
          width: isActive ? 2.0 : 1.0,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: symbolColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Player symbol
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: symbolColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                symbol,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: symbolColor,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Player name - with better text handling
          Text(
            playerName,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          // Win count
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_events,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                wins.toString(),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontFamily: 'JetBrainsMono',
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),

          // Active indicator
          if (isActive) ...[
            const SizedBox(height: 8),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: symbolColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
