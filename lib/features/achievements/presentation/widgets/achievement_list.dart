import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/models/achievement.dart';
import 'package:tictactoe_xo_royale/features/achievements/presentation/widgets/achievement_card.dart';

class AchievementList extends ConsumerWidget {
  final List<Achievement> achievements;

  const AchievementList({super.key, required this.achievements});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (achievements.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: context.getResponsivePadding(
        phonePadding: 16.0,
        tabletPadding: 24.0,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return Container(
          width: context.scale(310.0),
          margin: context.getResponsivePadding(
            phonePadding: 8.0,
            tabletPadding: 12.0,
          ),
          child: AchievementCard(achievement: achievement),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.workspace_premium,
            size: context.getResponsiveIconSize(
              phoneSize: 60.0,
              tabletSize: 64.0,
            ),
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          SizedBox(
            height: context.getResponsiveSpacing(
              phoneSpacing: 14.0,
              tabletSpacing: 16.0,
            ),
          ),
          Text(
            'No achievements yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(
            height: context.getResponsiveSpacing(
              phoneSpacing: 6.0,
              tabletSpacing: 8.0,
            ),
          ),
          Text(
            'Keep playing to unlock achievements!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
