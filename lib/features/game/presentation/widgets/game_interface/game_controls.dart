import 'package:flutter/material.dart';
// No longer needed - using standard Material Icons

/// Game control bar widget with hint and new game functionality
///
/// This widget provides the main game controls during gameplay:
/// - Hint button with remaining hint count
/// - New game button to restart the current game
/// - Clean, accessible design following Material 3 guidelines
///
/// The control bar adapts to different screen sizes and provides
/// appropriate touch targets for optimal user experience.
class GameControls extends StatelessWidget {
  /// Number of hints remaining for the current game
  final int hintCount;

  /// Callback when the hint button is pressed
  final VoidCallback onHint;

  /// Callback when the new game button is pressed
  final VoidCallback onNewGame;

  const GameControls({
    required this.hintCount,
    required this.onHint,
    required this.onNewGame,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Hint button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: hintCount > 0 ? onHint : null,
              icon: Stack(
                children: [
                  const Icon(Icons.lightbulb),
                  if (hintCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          hintCount.toString(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onError,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              label: Text(
                'Hint',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondaryContainer,
                foregroundColor: theme.colorScheme.onSecondaryContainer,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // New Game button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onNewGame,
              icon: const Icon(Icons.restart_alt),
              label: Text(
                'New Game',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
