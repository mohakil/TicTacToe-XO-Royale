import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/providers/achievements_provider.dart';
import 'package:tictactoe_xo_royale/features/achievements/presentation/widgets/achievement_card.dart';

class AchievementPreviewCard extends ConsumerWidget {
  const AchievementPreviewCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = ref.watch(achievementsListProvider);
    final unlockedCount = ref.watch(unlockedAchievementsCountProvider);
    final totalCount = ref.watch(totalAchievementsCountProvider);

    // Show same achievements as main screen (first 3 for preview)
    final displayAchievements = achievements.take(3).toList();

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
          // Header Row
          Row(
            children: [
              Icon(
                Icons.workspace_premium,
                color: Theme.of(context).colorScheme.primary,
                size: context.getResponsiveIconSize(
                  phoneSize: 24.0,
                  tabletSize: 26.0,
                ),
              ),
              SizedBox(
                width: context.getResponsiveSpacing(
                  phoneSpacing: 8.0,
                  tabletSpacing: 10.0,
                ),
              ),
              Expanded(
                child: Text(
                  'Achievements',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              TextButton(
                onPressed: () => context.push('/achievements'),
                style: TextButton.styleFrom(
                  padding: context.getResponsivePadding(
                    phonePadding: 8.0,
                    tabletPadding: 12.0,
                  ),
                ),
                child: Text(
                  'View All',
                  style: context.getResponsiveTextStyle(
                    const TextStyle(),
                    phoneSize: 12.0,
                    tabletSize: 14.0,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: context.getResponsiveSpacing(
              phoneSpacing: 12.0,
              tabletSpacing: 16.0,
            ),
          ),

          // Progress Summary
          Row(
            children: [
              Text(
                'Progress: $unlockedCount / $totalCount',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Container(
                padding: context.getResponsivePadding(
                  phonePadding: 4.0,
                  tabletPadding: 6.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${totalCount == 0 ? 0 : ((unlockedCount / totalCount) * 100).round()}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: context.getResponsiveSpacing(
              phoneSpacing: 8.0,
              tabletSpacing: 10.0,
            ),
          ),

          // Progress Bar
          Container(
            height: context.scale(4.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: totalCount > 0 ? unlockedCount / totalCount : 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          SizedBox(
            height: context.getResponsiveSpacing(
              phoneSpacing: 12.0,
              tabletSpacing: 16.0,
            ),
          ),

          // Achievement Cards
          if (displayAchievements.isNotEmpty) ...[
            Column(
              children: displayAchievements.map((achievement) {
                return Container(
                  width: context.scale(310.0),
                  margin: context.getResponsivePadding(
                    phonePadding: 4.0,
                    tabletPadding: 6.0,
                  ),
                  child: AchievementCard(achievement: achievement),
                );
              }).toList(),
            ),

            SizedBox(
              height: context.getResponsiveSpacing(
                phoneSpacing: 8.0,
                tabletSpacing: 12.0,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
