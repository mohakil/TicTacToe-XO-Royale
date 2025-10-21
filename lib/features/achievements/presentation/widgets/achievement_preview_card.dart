import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/providers/achievements_provider.dart';
import 'package:tictactoe_xo_royale/features/achievements/presentation/widgets/achievement_card.dart';
import 'package:tictactoe_xo_royale/shared/widgets/icons/icon_text.dart';

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
              IconText(
                icon: Icons.workspace_premium,
                text: 'Achievements',
                iconColor: Theme.of(context).colorScheme.primary,
                textStyle: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                size: IconTextSize.large,
                direction: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              const Spacer(),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    '$unlockedCount/$totalCount',
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
              // Progress bar matching profile screen win rate design
              LinearProgressIndicator(
                value: totalCount > 0 ? unlockedCount / totalCount : 0.0,
                backgroundColor: Theme.of(context).colorScheme.surfaceDim,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.tertiary,
                ),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),

          SizedBox(
            height: context.getResponsiveSpacing(
              phoneSpacing: 12.0,
              tabletSpacing: 16.0,
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
