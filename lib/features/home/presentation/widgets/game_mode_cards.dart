import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/shared/widgets/cards/animated_card.dart';
import 'package:tictactoe_xo_royale/shared/mixins/responsive_mixins.dart';

/// Migrated game mode card using shared AnimatedCard component
/// Provides consistent card styling with hover/press animations
class GameModeCard extends StatelessWidget {
  const GameModeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    super.key,
    this.isRobotMode = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool isRobotMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedCard(
      onTap: onTap,
      animation: CardAnimationConfig.standard,
      child: Container(
        width: double.infinity,
        height: 120,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surfaceContainer,
              Theme.of(
                context,
              ).colorScheme.surfaceContainer.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Icon(
                icon,
                size: 48,
                color: isRobotMode
                    ? colorScheme.secondary
                    : colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Container for displaying game mode cards in a responsive grid
/// Uses ResponsiveLayout mixin for clean, type-safe responsive behavior
class GameModeCards extends StatelessWidget with ResponsiveLayout {
  const GameModeCards({
    required this.onLocalModeSelected,
    required this.onRobotModeSelected,
    super.key,
  });

  final VoidCallback onLocalModeSelected;
  final VoidCallback onRobotModeSelected;

  @override
  Widget build(BuildContext context) {
    // Create the game mode cards
    final localPlayerCard = GameModeCard(
      title: 'Local Player',
      subtitle: 'Play with a friend',
      icon: Icons.groups_2,
      onTap: onLocalModeSelected,
    );

    final robotCard = GameModeCard(
      title: 'Robot',
      subtitle: 'Challenge the computer',
      icon: Icons.smart_toy,
      onTap: onRobotModeSelected,
      isRobotMode: true,
    );

    // Use ResponsiveLayout mixin for clean responsive behavior
    return buildResponsiveLayout(
      context: context,
      children: [
        localPlayerCard,
        SizedBox(
          height: context.getResponsiveSpacing(
            phoneSpacing: 16.0,
            tabletSpacing: 20.0,
          ),
        ),
        robotCard,
      ],
      phoneDirection: Axis.vertical,
      tabletDirection: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
    );
  }
}
