import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
// No longer needed - using standard Material Icons

/// Optimized game header widget with performance improvements
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
    return RepaintBoundary(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.getResponsiveSpacing(
            phoneSpacing: 16.0,
            tabletSpacing: 24.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Player 1 (X)
            Expanded(
              child: _PlayerCard(
                playerName: player1Name,
                wins: player1Wins,
                symbol: 'X',
                isActive: currentPlayer == 'X',
                symbolColor: Theme.of(context).colorScheme.primary,
              ),
            ),

            // VS indicator - centered with proper spacing
            _VSIndicator(),

            // Player 2 (O)
            Expanded(
              child: _PlayerCard(
                playerName: player2Name,
                wins: player2Wins,
                symbol: 'O',
                isActive: currentPlayer == 'O',
                symbolColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Optimized player card widget with RepaintBoundary
class _PlayerCard extends StatelessWidget {
  final String playerName;
  final int wins;
  final String symbol;
  final bool isActive;
  final Color symbolColor;

  const _PlayerCard({
    required this.playerName,
    required this.wins,
    required this.symbol,
    required this.isActive,
    required this.symbolColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: Container(
        padding: EdgeInsets.all(
          context.getResponsiveSpacing(phoneSpacing: 12.0, tabletSpacing: 16.0),
        ),
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
              width: context.getResponsiveIconSize(
                phoneSize: 40.0,
                tabletSize: 48.0,
              ),
              height: context.getResponsiveIconSize(
                phoneSize: 40.0,
                tabletSize: 48.0,
              ),
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
              style: context.getResponsiveTextStyle(
                theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(
              height: context.getResponsiveSpacing(
                phoneSpacing: 2.0,
                tabletSpacing: 4.0,
              ),
            ),

            // Win count
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events,
                  size: context.getResponsiveIconSize(
                    phoneSize: 14.0,
                    tabletSize: 16.0,
                  ),
                  color: theme.colorScheme.primary,
                ),
                SizedBox(
                  width: context.getResponsiveSpacing(
                    phoneSpacing: 2.0,
                    tabletSpacing: 4.0,
                  ),
                ),
                Text(
                  wins.toString(),
                  style: context.getResponsiveTextStyle(
                    theme.textTheme.titleLarge!.copyWith(
                      fontFamily: 'JetBrainsMono',
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
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
      ),
    );
  }
}

/// Optimized VS indicator widget with RepaintBoundary
class _VSIndicator extends StatelessWidget {
  const _VSIndicator();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: context.getResponsiveSpacing(
            phoneSpacing: 12.0,
            tabletSpacing: 16.0,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: context.getResponsiveSpacing(
            phoneSpacing: 12.0,
            tabletSpacing: 16.0,
          ),
          vertical: context.getResponsiveSpacing(
            phoneSpacing: 6.0,
            tabletSpacing: 8.0,
          ),
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          'VS',
          style: context.getResponsiveTextStyle(
            theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
