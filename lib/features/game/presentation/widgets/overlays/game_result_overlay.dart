import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';

/// Optimized game result overlay widget with performance improvements
class GameResultOverlay extends StatelessWidget {
  final bool isWin;
  final bool isDraw;
  final String winner;
  final VoidCallback onPlayAgain;
  final VoidCallback onHome;

  const GameResultOverlay({
    required this.isWin,
    required this.isDraw,
    required this.winner,
    required this.onPlayAgain,
    required this.onHome,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        color: Colors.black.withValues(alpha: 0.7),
        child: Center(
          child: _ResultDialog(
            isWin: isWin,
            isDraw: isDraw,
            winner: winner,
            onPlayAgain: onPlayAgain,
            onHome: onHome,
          ),
        ),
      ),
    );
  }
}

/// Optimized result dialog widget with RepaintBoundary
class _ResultDialog extends StatelessWidget {
  final bool isWin;
  final bool isDraw;
  final String winner;
  final VoidCallback onPlayAgain;
  final VoidCallback onHome;

  const _ResultDialog({
    required this.isWin,
    required this.isDraw,
    required this.winner,
    required this.onPlayAgain,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resultColor = _getResultColor(theme);
    final resultIcon = _getResultIcon();
    final resultText = _getResultText();

    return RepaintBoundary(
      child: Container(
        margin: EdgeInsets.all(
          context.getResponsiveSpacing(phoneSpacing: 24.0, tabletSpacing: 32.0),
        ),
        padding: EdgeInsets.all(
          context.getResponsiveSpacing(phoneSpacing: 24.0, tabletSpacing: 32.0),
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: context.getResponsiveBorderRadius(
            phoneRadius: 20.0,
            tabletRadius: 24.0,
          ),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Result icon
            Container(
              width: context.getResponsiveIconSize(
                phoneSize: 72.0,
                tabletSize: 80.0,
              ),
              height: context.getResponsiveIconSize(
                phoneSize: 72.0,
                tabletSize: 80.0,
              ),
              decoration: BoxDecoration(
                color: resultColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(
                  context.getResponsiveIconSize(
                    phoneSize: 36.0,
                    tabletSize: 40.0,
                  ),
                ),
              ),
              child: Icon(
                resultIcon,
                size: context.getResponsiveIconSize(
                  phoneSize: 44.0,
                  tabletSize: 48.0,
                ),
                color: resultColor,
              ),
            ),

            SizedBox(
              height: context.getResponsiveSpacing(
                phoneSpacing: 20.0,
                tabletSpacing: 24.0,
              ),
            ),

            // Result text
            Text(
              resultText,
              style: context.getResponsiveTextStyle(
                theme.textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              textAlign: TextAlign.center,
            ),

            if (isWin) ...[
              SizedBox(
                height: context.getResponsiveSpacing(
                  phoneSpacing: 6.0,
                  tabletSpacing: 8.0,
                ),
              ),
              Text(
                'Congratulations, $winner!',
                style: context.getResponsiveTextStyle(
                  theme.textTheme.titleMedium!.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ],

            SizedBox(
              height: context.getResponsiveSpacing(
                phoneSpacing: 24.0,
                tabletSpacing: 32.0,
              ),
            ),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Play Again button
                Expanded(child: _PlayAgainButton(onPlayAgain: onPlayAgain)),

                SizedBox(
                  width: context.getResponsiveSpacing(
                    phoneSpacing: 12.0,
                    tabletSpacing: 16.0,
                  ),
                ),

                // Home button
                Expanded(child: _HomeButton(onHome: onHome)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getResultColor(ThemeData theme) {
    if (isWin) {
      return theme.colorScheme.primary;
    }
    if (isDraw) {
      return theme.colorScheme.tertiary;
    }
    return theme.colorScheme.error;
  }

  IconData _getResultIcon() {
    if (isWin) {
      return Icons.emoji_events;
    }
    if (isDraw) {
      return Icons.horizontal_rule;
    }
    return Icons.heart_broken;
  }

  String _getResultText() {
    if (isWin) {
      return 'You Win!';
    }
    if (isDraw) {
      return "It's a Draw!";
    }
    return 'You Lose!';
  }
}

/// Optimized play again button widget with RepaintBoundary
class _PlayAgainButton extends StatelessWidget {
  final VoidCallback onPlayAgain;

  const _PlayAgainButton({required this.onPlayAgain});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: ElevatedButton.icon(
        onPressed: onPlayAgain,
        icon: const Icon(Icons.play_arrow),
        label: const Text('Play Again'),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: 0,
          padding: EdgeInsets.symmetric(
            vertical: context.getResponsiveSpacing(
              phoneSpacing: 12.0,
              tabletSpacing: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}

/// Optimized home button widget with RepaintBoundary
class _HomeButton extends StatelessWidget {
  final VoidCallback onHome;

  const _HomeButton({required this.onHome});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: OutlinedButton.icon(
        onPressed: onHome,
        icon: const Icon(Icons.home),
        label: const Text('Home'),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurface,
          side: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.5),
          ),
          padding: EdgeInsets.symmetric(
            vertical: context.getResponsiveSpacing(
              phoneSpacing: 12.0,
              tabletSpacing: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
