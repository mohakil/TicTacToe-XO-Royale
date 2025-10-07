import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
// No longer needed - using standard Material Icons

/// Optimized game control bar widget with performance improvements
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
    return RepaintBoundary(
      child: Container(
        padding: EdgeInsets.all(
          context.getResponsiveSpacing(phoneSpacing: 16.0, tabletSpacing: 20.0),
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.shadow.withValues(alpha: 0.1),
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
              child: _HintButton(hintCount: hintCount, onHint: onHint),
            ),

            SizedBox(
              width: context.getResponsiveSpacing(
                phoneSpacing: 12.0,
                tabletSpacing: 16.0,
              ),
            ),

            // New Game button
            Expanded(child: _NewGameButton(onNewGame: onNewGame)),
          ],
        ),
      ),
    );
  }
}

/// Optimized hint button widget with RepaintBoundary
class _HintButton extends StatelessWidget {
  final int hintCount;
  final VoidCallback onHint;

  const _HintButton({required this.hintCount, required this.onHint});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasHints = hintCount > 0;

    return RepaintBoundary(
      child: ElevatedButton.icon(
        onPressed: hasHints ? onHint : null,
        icon: Stack(
          children: [
            const Icon(Icons.lightbulb),
            if (hasHints)
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
        label: const Text('Hint'),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.secondaryContainer,
          foregroundColor: theme.colorScheme.onSecondaryContainer,
          elevation: 0,
          padding: EdgeInsets.symmetric(
            vertical: context.getResponsiveSpacing(
              phoneSpacing: 12.0,
              tabletSpacing: 16.0,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: context.getResponsiveBorderRadius(
              phoneRadius: 12.0,
              tabletRadius: 12.0,
            ),
          ),
        ),
      ),
    );
  }
}

/// Optimized new game button widget with RepaintBoundary
class _NewGameButton extends StatelessWidget {
  final VoidCallback onNewGame;

  const _NewGameButton({required this.onNewGame});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: ElevatedButton.icon(
        onPressed: onNewGame,
        icon: const Icon(Icons.restart_alt),
        label: const Text('New Game'),
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
          shape: RoundedRectangleBorder(
            borderRadius: context.getResponsiveBorderRadius(
              phoneRadius: 12.0,
              tabletRadius: 12.0,
            ),
          ),
        ),
      ),
    );
  }
}
