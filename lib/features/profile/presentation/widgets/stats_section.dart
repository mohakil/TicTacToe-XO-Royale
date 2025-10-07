import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
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

    return Container(
      margin: context.getResponsivePadding(
        phonePadding: 12.0,
        tabletPadding: 16.0,
      ),
      padding: context.getResponsivePadding(
        phonePadding: 16.0,
        tabletPadding: 20.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
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
                size: context.getResponsiveIconSize(
                  phoneSize: 26.0,
                  tabletSize: 28.0,
                ),
              ),
              SizedBox(
                width: context.getResponsiveSpacing(
                  phoneSpacing: 10.0,
                  tabletSpacing: 12.0,
                ),
              ),
              Text(
                'Game Statistics',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: context.getResponsiveSpacing(
              phoneSpacing: 18.0,
              tabletSpacing: 20.0,
            ),
          ),

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
                ),
              ),
              SizedBox(
                width: context.getResponsiveSpacing(
                  phoneSpacing: 8.0,
                  tabletSpacing: 16.0,
                ),
              ),
              Expanded(
                child: _StatTile(
                  icon: Icons.close,
                  value: stats.losses.toString(),
                  label: 'Losses',
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              SizedBox(
                width: context.getResponsiveSpacing(
                  phoneSpacing: 8.0,
                  tabletSpacing: 16.0,
                ),
              ),
              Expanded(
                child: _StatTile(
                  icon: Icons.remove,
                  value: stats.draws.toString(),
                  label: 'Draws',
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(
            height: context.getResponsiveSpacing(
              phoneSpacing: 18.0,
              tabletSpacing: 20.0,
            ),
          ),

          // Secondary Stats
          Row(
            children: [
              Expanded(
                child: _SecondaryStatTile(
                  icon: Icons.games,
                  value: totalGames.toString(),
                  label: 'Total Games',
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(
                width: context.getResponsiveSpacing(
                  phoneSpacing: 12.0,
                  tabletSpacing: 16.0,
                ),
              ),
              Expanded(
                child: _SecondaryStatTile(
                  icon: Icons.local_fire_department,
                  value: stats.streak.toString(),
                  label: 'Current Streak',
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          SizedBox(
            height: context.getResponsiveSpacing(
              phoneSpacing: 18.0,
              tabletSpacing: 20.0,
            ),
          ),

          // Win Rate Progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Win Rate',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${(winRate * 100).toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: context.getResponsiveSpacing(
                  phoneSpacing: 6.0,
                  tabletSpacing: 8.0,
                ),
              ),
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
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool isPrimary;

  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    // Use responsive system instead of parameter
    final padding = context.getResponsiveSpacing(
      phoneSpacing: 12.0,
      tabletSpacing: 16.0,
    );
    final iconSize = context.getResponsiveIconSize(
      phoneSize: 28.0,
      tabletSize: 32.0,
    );

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
          SizedBox(
            height: context.getResponsiveSpacing(
              phoneSpacing: 6.0,
              tabletSpacing: 8.0,
            ),
          ),
          Text(
            value,
            style: context.getResponsiveTextStyle(
              Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ) ??
                  const TextStyle(),
              phoneSize: 18.0,
              tabletSize: 20.0,
            ),
          ),
          Text(
            label,
            style: context.getResponsiveTextStyle(
              Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ) ??
                  const TextStyle(),
              phoneSize: 12.0,
              tabletSize: 14.0,
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

  const _SecondaryStatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Use responsive system instead of parameter
    final padding = context.getResponsiveSpacing(
      phoneSpacing: 12.0,
      tabletSpacing: 16.0,
    );
    final iconSize = context.getResponsiveIconSize(
      phoneSize: 20.0,
      tabletSize: 24.0,
    );
    final spacing = context.getResponsiveSpacing(
      phoneSpacing: 8.0,
      tabletSpacing: 12.0,
    );

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
                  style: context.getResponsiveTextStyle(
                    Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: color,
                        ) ??
                        const TextStyle(),
                    phoneSize: 16.0,
                    tabletSize: 18.0,
                  ),
                ),
                Text(
                  label,
                  style: context.getResponsiveTextStyle(
                    Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ) ??
                        const TextStyle(),
                    phoneSize: 11.0,
                    tabletSize: 12.0,
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
