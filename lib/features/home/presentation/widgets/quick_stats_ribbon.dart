import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
                 border: Border.all(
           color: colorScheme.outline.withValues(alpha: 0.2),
           width: 1,
         ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            icon: Icons.emoji_events,
            label: 'Last Result',
            value: lastResult,
            color: _getResultColor(lastResult, colorScheme),
          ),
          _StatItem(
            icon: Icons.local_fire_department,
            label: 'Streak',
            value: '$streak',
            color: colorScheme.tertiary,
          ),
          _StatItem(
            icon: Icons.diamond,
            label: 'Gems',
            value: '$gemsCount',
            color: colorScheme.tertiary,
          ),
          _StatItem(
            icon: Icons.lightbulb,
            label: 'Hints',
            value: '$hintCount',
            color: colorScheme.tertiary,
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
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
            fontFamily: 'JetBrains Mono',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
