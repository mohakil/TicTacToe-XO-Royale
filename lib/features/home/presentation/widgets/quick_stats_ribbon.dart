import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/shared/widgets/icons/icon_text.dart';
import 'package:tictactoe_xo_royale/features/home/providers/home_provider.dart';

/// Quick stats ribbon displaying game statistics
/// Shows last result, streak, gems count, and hint count
class QuickStatsRibbon extends ConsumerWidget {
  const QuickStatsRibbon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Watch real data from providers
    final homeStats = ref.watch(homeStatsProvider);

    return Container(
      width: double.infinity,
      padding: context.getResponsivePadding(
        phonePadding: 12.0,
        tabletPadding: 16.0,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: context.getResponsiveBorderRadius(
          phoneRadius: 10.0,
          tabletRadius: 12.0,
        ),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconText(
                  icon: Icons.emoji_events,
                  text: homeStats.lastResult,
                  iconColor: _getResultColor(homeStats.lastResult, colorScheme),
                  textStyle: context.getResponsiveTextStyle(
                    theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _getResultColor(
                            homeStats.lastResult,
                            colorScheme,
                          ),
                          fontFamily: 'JetBrains Mono',
                        ) ??
                        const TextStyle(),
                    phoneSize: 16.0,
                    tabletSize: 18.0,
                  ),
                  size: IconTextSize.medium,
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                SizedBox(
                  height: context.getResponsiveSpacing(
                    phoneSpacing: 2.0,
                    tabletSpacing: 4.0,
                  ),
                ),
                Text(
                  'Last Result',
                  style: context.getResponsiveTextStyle(
                    theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
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
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconText(
                  icon: Icons.local_fire_department,
                  text: '${homeStats.streak}',
                  iconColor: colorScheme.secondary,
                  textStyle: context.getResponsiveTextStyle(
                    theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.secondary,
                          fontFamily: 'JetBrains Mono',
                        ) ??
                        const TextStyle(),
                    phoneSize: 16.0,
                    tabletSize: 18.0,
                  ),
                  size: IconTextSize.medium,
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                SizedBox(
                  height: context.getResponsiveSpacing(
                    phoneSpacing: 2.0,
                    tabletSpacing: 4.0,
                  ),
                ),
                Text(
                  'Streak',
                  style: context.getResponsiveTextStyle(
                    theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
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
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconText(
                  icon: Icons.diamond,
                  text: '${homeStats.gemsCount}',
                  iconColor: colorScheme.tertiary,
                  textStyle: context.getResponsiveTextStyle(
                    theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.tertiary,
                          fontFamily: 'JetBrains Mono',
                        ) ??
                        const TextStyle(),
                    phoneSize: 16.0,
                    tabletSize: 18.0,
                  ),
                  size: IconTextSize.medium,
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                SizedBox(
                  height: context.getResponsiveSpacing(
                    phoneSpacing: 2.0,
                    tabletSpacing: 4.0,
                  ),
                ),
                Text(
                  'Gems',
                  style: context.getResponsiveTextStyle(
                    theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
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
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconText(
                  icon: Icons.lightbulb,
                  text: '${homeStats.hintCount}',
                  iconColor: colorScheme.secondary,
                  textStyle: context.getResponsiveTextStyle(
                    theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.secondary,
                          fontFamily: 'JetBrains Mono',
                        ) ??
                        const TextStyle(),
                    phoneSize: 16.0,
                    tabletSize: 18.0,
                  ),
                  size: IconTextSize.medium,
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                SizedBox(
                  height: context.getResponsiveSpacing(
                    phoneSpacing: 2.0,
                    tabletSpacing: 4.0,
                  ),
                ),
                Text(
                  'Hints',
                  style: context.getResponsiveTextStyle(
                    theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
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
    );
  }

  Color _getResultColor(String result, ColorScheme colorScheme) {
    switch (result.toLowerCase()) {
      case 'win':
        return colorScheme.tertiary;
      case 'loss':
        return colorScheme.error;
      case 'draw':
        return colorScheme.outline;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }
}
