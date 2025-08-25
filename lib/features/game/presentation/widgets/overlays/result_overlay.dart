import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ResultOverlay extends StatelessWidget {
  final bool isWin;
  final bool isDraw;
  final String winner;
  final VoidCallback onPlayAgain;
  final VoidCallback onHome;

  const ResultOverlay({
    super.key,
    required this.isWin,
    required this.isDraw,
    required this.winner,
    required this.onPlayAgain,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32.0),
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1.0,
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
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: Icon(
                  _getResultIcon(),
                  size: 48,
                  color: _getResultColor(theme),
                ),
              ),

              const SizedBox(height: 24.0),

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
                const SizedBox(height: 8.0),
                Text(
                  'Congratulations, $winner!',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 32.0),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Play Again button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onPlayAgain,
                      icon: const Icon(Symbols.play_arrow),
                      label: const Text('Play Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16.0),

                  // Home button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onHome,
                      icon: const Icon(Symbols.home),
                      label: const Text('Home'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.onSurface,
                        side: BorderSide(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
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
    if (isWin) return theme.colorScheme.primary;
    if (isDraw) return theme.colorScheme.tertiary;
    return theme.colorScheme.error;
  }

  IconData _getResultIcon() {
    if (isWin) return Symbols.emoji_events;
    if (isDraw) return Symbols.horizontal_rule;
    return Symbols.heart_broken;
  }

  String _getResultText() {
    if (isWin) return 'You Win!';
    if (isDraw) return "It's a Draw!";
    return 'You Lose!';
  }
}
