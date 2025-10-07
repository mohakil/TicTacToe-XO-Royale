import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/models/achievement.dart';
import 'package:tictactoe_xo_royale/core/providers/achievements_provider.dart';
import 'package:tictactoe_xo_royale/core/services/navigation_service.dart';
import 'package:tictactoe_xo_royale/features/achievements/presentation/widgets/achievement_list.dart';

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
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            onPressed: () => NavigationService.goBack(context),
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            iconSize: context.getResponsiveIconSize(
              phoneSize: 24.0,
              tabletSize: 28.0,
            ),
          ),
          title: Text(
            'Achievements',
            style: context.getResponsiveTextStyle(
              Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ) ??
                  const TextStyle(),
              phoneSize: 20.0,
              tabletSize: 24.0,
            ),
          ),
          centerTitle: true,
        ),
        body: isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading achievements...'),
                  ],
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
            children: [
              Text(
                'Progress: $unlockedCount / $totalCount',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              // Achievement progress indicator (could be enhanced)
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
              tabletSpacing: 12.0,
            ),
          ),
          // Progress bar (simple visual indicator)
          Container(
            height: context.scale(4.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
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
        ],
      ),
    );
  }
}
