import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/features/game/presentation/widgets/visual_effects/effects/robot_thinking_animation.dart';

/// Optimized game status widget with performance improvements
class GameStatus extends StatelessWidget {
  final String currentPlayer;
  final bool isGameOver;
  final bool isRobotThinking;

  const GameStatus({
    required this.currentPlayer,
    required this.isGameOver,
    required this.isRobotThinking,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Early return for better performance
    if (isGameOver) {
      return const SizedBox.shrink();
    }

    return RepaintBoundary(
      child: Center(
        child: _TurnIndicator(
          currentPlayer: currentPlayer,
          isRobotThinking: isRobotThinking,
        ),
      ),
    );
  }
}

/// Optimized turn indicator widget with RepaintBoundary
class _TurnIndicator extends StatelessWidget {
  final String currentPlayer;
  final bool isRobotThinking;

  const _TurnIndicator({
    required this.currentPlayer,
    required this.isRobotThinking,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isXPlayer = currentPlayer == 'X';
    final playerColor = isXPlayer
        ? theme.colorScheme.primary
        : theme.colorScheme.secondary;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.getResponsiveSpacing(
          phoneSpacing: 16.0,
          tabletSpacing: 24.0,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: context.getResponsiveSpacing(
          phoneSpacing: 16.0,
          tabletSpacing: 24.0,
        ),
        vertical: context.getResponsiveSpacing(
          phoneSpacing: 8.0,
          tabletSpacing: 12.0,
        ),
      ),
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
            width: context.getResponsiveIconSize(
              phoneSize: 28.0,
              tabletSize: 32.0,
            ),
            height: context.getResponsiveIconSize(
              phoneSize: 28.0,
              tabletSize: 32.0,
            ),
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

          SizedBox(
            width: context.getResponsiveSpacing(
              phoneSpacing: 8.0,
              tabletSpacing: 12.0,
            ),
          ),

          // Turn text or thinking animation
          if (isRobotThinking)
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Robot thinking',
                  style: context.getResponsiveTextStyle(
                    theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                SizedBox(
                  width: context.getResponsiveSpacing(
                    phoneSpacing: 8.0,
                    tabletSpacing: 12.0,
                  ),
                ),
                RobotThinkingAnimation(dotColor: playerColor),
              ],
            )
          else
            Text(
              'Your turn',
              style: context.getResponsiveTextStyle(
                theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
