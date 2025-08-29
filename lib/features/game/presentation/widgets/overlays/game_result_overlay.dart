import 'package:flutter/material.dart';
// No longer needed - using standard Material Icons

// ignore: public_member_api_docs
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
    final theme = Theme.of(context);

    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Result icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _getResultColor(theme).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(
                  _getResultIcon(),
                  size: 48,
                  color: _getResultColor(theme),
                ),
              ),

              const SizedBox(height: 24),

              // Result text
              Text(
                _getResultText(),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              if (isWin) ...[
                const SizedBox(height: 8),
                Text(
                  'Congratulations, $winner!',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 32),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Play Again button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onPlayAgain,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Play Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Home button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onHome,
                      icon: const Icon(Icons.home),
                      label: const Text('Home'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.onSurface,
                        side: BorderSide(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
