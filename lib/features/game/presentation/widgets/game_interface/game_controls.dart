import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/shared/widgets/buttons/enhanced_button.dart';

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
              child: _MigratedHintButton(hintCount: hintCount, onHint: onHint),
            ),

            SizedBox(
              width: context.getResponsiveSpacing(
                phoneSpacing: 12.0,
                tabletSpacing: 16.0,
              ),
            ),

            // New Game button
            Expanded(child: _MigratedNewGameButton(onNewGame: onNewGame)),
          ],
        ),
      ),
    );
  }
}

/// Migrated hint button using shared EnhancedButton
class _MigratedHintButton extends StatelessWidget {
  final int hintCount;
  final VoidCallback onHint;

  const _MigratedHintButton({required this.hintCount, required this.onHint});

  @override
  Widget build(BuildContext context) {
    final hasHints = hintCount > 0;

    return RepaintBoundary(
      child: EnhancedButton(
        text: 'Hint',
        onPressed: hasHints ? onHint : null,
        variant: ButtonVariant.secondary,
        size: ButtonSize.medium,
        icon: Icons.lightbulb,
        tooltip: hasHints
            ? 'Use hint ($hintCount remaining)'
            : 'No hints available',
      ),
    );
  }
}

/// Migrated new game button using shared EnhancedButton
class _MigratedNewGameButton extends StatelessWidget {
  final VoidCallback onNewGame;

  const _MigratedNewGameButton({required this.onNewGame});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: EnhancedButton(
        text: 'New Game',
        onPressed: onNewGame,
        variant: ButtonVariant.primary,
        size: ButtonSize.medium,
        icon: Icons.restart_alt,
        tooltip: 'Start a new game',
      ),
    );
  }
}
