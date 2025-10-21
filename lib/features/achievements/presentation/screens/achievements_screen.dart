import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/models/achievement.dart';
import 'package:tictactoe_xo_royale/core/providers/achievements_provider.dart';
import 'package:tictactoe_xo_royale/core/services/navigation_service.dart';
import 'package:tictactoe_xo_royale/features/achievements/presentation/widgets/achievement_list.dart';
import 'package:tictactoe_xo_royale/shared/widgets/navigation/app_bar.dart';
import 'package:tictactoe_xo_royale/shared/widgets/feedback/state_display.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = ref.watch(achievementsListProvider);
    final unlockedCount = ref.watch(unlockedAchievementsCountProvider);
    final totalCount = ref.watch(totalAchievementsCountProvider);
    final isLoading = ref.watch(achievementsProvider).isLoading;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          NavigationService.goBack(context);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: SharedAppBar(
          title: 'Achievements',
          onBackPressed: () => NavigationService.goBack(context),
          centerTitle: true,
        ),
        body: isLoading
            ? const Center(
                child: StateDisplay(
                  state: DisplayState.loading,
                  title: 'Loading achievements',
                  subtitle: 'Please wait while we fetch your achievements',
                  icon: Icons.emoji_events,
                ),
              )
            : _buildAchievementsContent(
                context,
                ref,
                achievements,
                unlockedCount,
                totalCount,
              ),
      ),
    );
  }

  Widget _buildAchievementsContent(
    BuildContext context,
    WidgetRef ref,
    List<Achievement> achievements,
    int unlockedCount,
    int totalCount,
  ) {
    return RefreshIndicator(
      onRefresh: () =>
          ref.read(achievementsProvider.notifier).refreshAchievements(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Summary
            _buildProgressSummary(context, unlockedCount, totalCount),

            // Achievement List
            AchievementList(achievements: achievements),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSummary(
    BuildContext context,
    int unlockedCount,
    int totalCount,
  ) {
    return Padding(
      padding: context.getResponsivePadding(
        phonePadding: 16.0,
        tabletPadding: 24.0,
      ),
      child: Column(
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
    );
  }
}
