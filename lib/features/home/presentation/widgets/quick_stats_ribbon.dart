import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';

/// Quick stats ribbon displaying game statistics
/// Shows last result, streak, gems count, and hint count
class QuickStatsRibbon extends StatelessWidget {
  const QuickStatsRibbon({
    super.key,
    this.lastResult = 'Win',
    this.streak = 3,
    this.gemsCount = 150,
    this.hintCount = 5,
  });

  final String lastResult;
  final int streak;
  final int gemsCount;
  final int hintCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
            child: _StatItem(
              icon: Icons.emoji_events,
              label: 'Last Result',
              value: lastResult,
              color: _getResultColor(lastResult, colorScheme),
            ),
          ),
          Expanded(
            child: _StatItem(
              icon: Icons.local_fire_department,
              label: 'Streak',
              value: '$streak',
              color: colorScheme.tertiary,
            ),
          ),
          Expanded(
            child: _StatItem(
              icon: Icons.diamond,
              label: 'Gems',
              value: '$gemsCount',
              color: colorScheme.tertiary,
            ),
          ),
          Expanded(
            child: _StatItem(
              icon: Icons.lightbulb,
              label: 'Hints',
              value: '$hintCount',
              color: colorScheme.tertiary,
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

/// Individual stat item within the ribbon
class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: context.getResponsiveIconSize(
            phoneSize: 20.0,
            tabletSize: 24.0,
          ),
        ),
        SizedBox(
          height: context.getResponsiveSpacing(
            phoneSpacing: 2.0,
            tabletSpacing: 4.0,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: context.getResponsiveTextStyle(
              theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                    fontFamily: 'JetBrains Mono',
                  ) ??
                  const TextStyle(),
              phoneSize: 16.0,
              tabletSize: 18.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: context.getResponsiveSpacing(
            phoneSpacing: 1.0,
            tabletSpacing: 2.0,
          ),
        ),
        Text(
          label,
          style: context.getResponsiveTextStyle(
            theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ) ??
                const TextStyle(),
            phoneSize: 10.0,
            tabletSize: 12.0,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
