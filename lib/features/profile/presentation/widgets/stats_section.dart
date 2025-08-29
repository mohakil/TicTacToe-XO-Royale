import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/providers/profile_provider.dart';

class StatsSection extends ConsumerWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(profileStatsProvider);
    final winRate = ref.watch(profileWinRateProvider);
    final totalGames = ref.watch(profileTotalGamesProvider);

    if (stats == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 400;
        final margin = isSmallScreen ? 12.0 : 16.0;
        final padding = isSmallScreen ? 16.0 : 20.0;

        return Container(
          margin: EdgeInsets.all(margin),
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.analytics,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Game Statistics',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Main Stats Grid
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      icon: Icons.emoji_events,
                      value: stats.wins.toString(),
                      label: 'Wins',
                      color: Theme.of(context).colorScheme.tertiary,
                      isPrimary: true,
                      isSmallScreen: isSmallScreen,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 16),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.close,
                      value: stats.losses.toString(),
                      label: 'Losses',
                      color: Theme.of(context).colorScheme.error,
                      isSmallScreen: isSmallScreen,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 16),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.remove,
                      value: stats.draws.toString(),
                      label: 'Draws',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      isSmallScreen: isSmallScreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Secondary Stats
              Row(
                children: [
                  Expanded(
                    child: _SecondaryStatTile(
                      icon: Icons.games,
                      value: totalGames.toString(),
                      label: 'Total Games',
                      color: Theme.of(context).colorScheme.primary,
                      isSmallScreen: isSmallScreen,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 12 : 16),
                  Expanded(
                    child: _SecondaryStatTile(
                      icon: Icons.local_fire_department,
                      value: stats.streak.toString(),
                      label: 'Current Streak',
                      color: Theme.of(context).colorScheme.secondary,
                      isSmallScreen: isSmallScreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Win Rate Progress
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Win Rate',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${(winRate * 100).toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: winRate,
                    backgroundColor: Theme.of(context).colorScheme.surfaceDim,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.tertiary,
                    ),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool isPrimary;
  final bool isSmallScreen;

  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.isPrimary = false,
    this.isSmallScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final padding = isSmallScreen ? 12.0 : 16.0;
    final iconSize = isSmallScreen ? 28.0 : 32.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: isPrimary
            ? color.withValues(alpha: 0.1)
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPrimary
              ? color.withValues(alpha: 0.3)
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          width: isPrimary ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: iconSize),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
              fontSize: isSmallScreen ? 18 : null,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
              fontSize: isSmallScreen ? 12 : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _SecondaryStatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool isSmallScreen;

  const _SecondaryStatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.isSmallScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final padding = isSmallScreen ? 12.0 : 16.0;
    final iconSize = isSmallScreen ? 20.0 : 24.0;
    final spacing = isSmallScreen ? 8.0 : 12.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: iconSize),
          SizedBox(width: spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                    fontSize: isSmallScreen ? 16 : null,
                  ),
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: isSmallScreen ? 11 : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
