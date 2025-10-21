import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/providers/profile_provider.dart';
import 'package:tictactoe_xo_royale/shared/widgets/icons/icon_text.dart';

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
          IconText(
            icon: Icons.analytics,
            text: 'Game Statistics',
            iconColor: Theme.of(context).colorScheme.primary,
            textStyle: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            size: IconTextSize.large,
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconText(
                      icon: Icons.emoji_events,
                      text: stats.wins.toString(),
                      iconColor: Theme.of(context).colorScheme.tertiary,
                      textStyle: context.getResponsiveTextStyle(
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.tertiary,
                            ) ??
                            const TextStyle(),
                        phoneSize: 18.0,
                        tabletSize: 20.0,
                      ),
                      size: IconTextSize.medium,
                      direction: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    SizedBox(
                      height: context.getResponsiveSpacing(
                        phoneSpacing: 4.0,
                        tabletSpacing: 6.0,
                      ),
                    ),
                    Text(
                      'Wins',
                      style: context.getResponsiveTextStyle(
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ) ??
                            const TextStyle(),
                        phoneSize: 12.0,
                        tabletSize: 14.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: context.getResponsiveSpacing(
                  phoneSpacing: 8.0,
                  tabletSpacing: 16.0,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconText(
                      icon: Icons.close,
                      text: stats.losses.toString(),
                      iconColor: Theme.of(context).colorScheme.error,
                      textStyle: context.getResponsiveTextStyle(
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.error,
                            ) ??
                            const TextStyle(),
                        phoneSize: 18.0,
                        tabletSize: 20.0,
                      ),
                      size: IconTextSize.medium,
                      direction: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    SizedBox(
                      height: context.getResponsiveSpacing(
                        phoneSpacing: 4.0,
                        tabletSpacing: 6.0,
                      ),
                    ),
                    Text(
                      'Losses',
                      style: context.getResponsiveTextStyle(
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ) ??
                            const TextStyle(),
                        phoneSize: 12.0,
                        tabletSize: 14.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: context.getResponsiveSpacing(
                  phoneSpacing: 8.0,
                  tabletSpacing: 16.0,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconText(
                      icon: Icons.remove,
                      text: stats.draws.toString(),
                      iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
                      textStyle: context.getResponsiveTextStyle(
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ) ??
                            const TextStyle(),
                        phoneSize: 18.0,
                        tabletSize: 20.0,
                      ),
                      size: IconTextSize.medium,
                      direction: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    SizedBox(
                      height: context.getResponsiveSpacing(
                        phoneSpacing: 4.0,
                        tabletSpacing: 6.0,
                      ),
                    ),
                    Text(
                      'Draws',
                      style: context.getResponsiveTextStyle(
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ) ??
                            const TextStyle(),
                        phoneSize: 12.0,
                        tabletSize: 14.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconText(
                      icon: Icons.games,
                      text: totalGames.toString(),
                      iconColor: Theme.of(context).colorScheme.primary,
                      textStyle: context.getResponsiveTextStyle(
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ) ??
                            const TextStyle(),
                        phoneSize: 14.0,
                        tabletSize: 16.0,
                      ),
                      size: IconTextSize.small,
                      direction: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    SizedBox(
                      height: context.getResponsiveSpacing(
                        phoneSpacing: 2.0,
                        tabletSpacing: 3.0,
                      ),
                    ),
                    Text(
                      'Total Games',
                      style: context.getResponsiveTextStyle(
                        Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ) ??
                            const TextStyle(),
                        phoneSize: 10.0,
                        tabletSize: 12.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: context.getResponsiveSpacing(
                  phoneSpacing: 12.0,
                  tabletSpacing: 16.0,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconText(
                      icon: Icons.local_fire_department,
                      text: stats.streak.toString(),
                      iconColor: Theme.of(context).colorScheme.secondary,
                      textStyle: context.getResponsiveTextStyle(
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.secondary,
                            ) ??
                            const TextStyle(),
                        phoneSize: 14.0,
                        tabletSize: 16.0,
                      ),
                      size: IconTextSize.small,
                      direction: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    SizedBox(
                      height: context.getResponsiveSpacing(
                        phoneSpacing: 2.0,
                        tabletSpacing: 3.0,
                      ),
                    ),
                    Text(
                      'Current Streak',
                      style: context.getResponsiveTextStyle(
                        Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ) ??
                            const TextStyle(),
                        phoneSize: 10.0,
                        tabletSize: 12.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
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

// Removed _StatTile and _SecondaryStatTile classes - replaced with IconText
