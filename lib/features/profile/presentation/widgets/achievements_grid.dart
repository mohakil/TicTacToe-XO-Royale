import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AchievementsGrid extends ConsumerWidget {
  const AchievementsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(Replace with actual achievements data from provider)
    final mockAchievements = _generateMockAchievements();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 400;
        final margin = isSmallScreen ? 12.0 : 16.0;
        final padding = isSmallScreen ? 16.0 : 20.0;
        final crossAxisCount = isSmallScreen ? 1 : 2;

        return Container(
          margin: EdgeInsets.all(margin),
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.workspace_premium,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Achievements',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${mockAchievements.where((a) => a.isUnlocked).length}/${mockAchievements.length}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              if (mockAchievements.isEmpty)
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.workspace_premium,
                        size: 64,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No achievements yet',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 8),
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
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: isSmallScreen ? 12 : 16,
                    mainAxisSpacing: isSmallScreen ? 12 : 16,
                    childAspectRatio: isSmallScreen ? 1.4 : 1.2,
                  ),
                  itemCount: mockAchievements.length,
                  itemBuilder: (context, index) {
                    final achievement = mockAchievements[index];
                    return _AchievementCard(
                      achievement: achievement,
                      isSmallScreen: isSmallScreen,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  List<Achievement> _generateMockAchievements() => [
    Achievement(
      id: 'first_win',
      title: 'First Victory',
      description: 'Win your first game',
      icon: Icons.emoji_events,
      isUnlocked: true,
      unlockedDate: DateTime.now().subtract(const Duration(days: 5)),
      rarity: AchievementRarity.common,
    ),
    Achievement(
      id: 'win_streak_5',
      title: 'Hot Streak',
      description: 'Win 5 games in a row',
      icon: Icons.local_fire_department,
      isUnlocked: true,
      unlockedDate: DateTime.now().subtract(const Duration(days: 2)),
      rarity: AchievementRarity.rare,
    ),
    const Achievement(
      id: 'robot_master',
      title: 'Robot Master',
      description: 'Beat a robot on Hard difficulty',
      icon: Icons.smart_toy,
      isUnlocked: false,
      rarity: AchievementRarity.epic,
    ),
    Achievement(
      id: 'board_explorer',
      title: 'Board Explorer',
      description: 'Play on 3 different board sizes',
      icon: Icons.grid_on,
      isUnlocked: true,
      unlockedDate: DateTime.now().subtract(const Duration(days: 1)),
      rarity: AchievementRarity.common,
    ),
    const Achievement(
      id: 'speed_demon',
      title: 'Speed Demon',
      description: 'Win a game in under 2 minutes',
      icon: Icons.speed,
      isUnlocked: false,
      rarity: AchievementRarity.rare,
    ),
    const Achievement(
      id: 'perfect_game',
      title: 'Perfect Game',
      description: 'Win without losing a single piece',
      icon: Icons.star,
      isUnlocked: false,
      rarity: AchievementRarity.legendary,
    ),
  ];
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final bool isUnlocked;
  final DateTime? unlockedDate;
  final AchievementRarity rarity;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
    required this.rarity,
    this.unlockedDate,
  });
}

enum AchievementRarity { common, rare, epic, legendary }

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final bool isSmallScreen;

  const _AchievementCard({
    required this.achievement,
    this.isSmallScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final rarityColor = _getRarityColor(achievement.rarity);
    final isUnlocked = achievement.isUnlocked;

    return Container(
      decoration: BoxDecoration(
        color: isUnlocked
            ? Theme.of(context).colorScheme.surface
            : Theme.of(context).colorScheme.surfaceDim,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked
              ? rarityColor.withValues(alpha: 0.3)
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: isUnlocked ? 2 : 1,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: rarityColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Stack(
        children: [
          // Main Content
          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Icon(
                  achievement.icon,
                  size: isSmallScreen ? 40 : 48,
                  color: isUnlocked
                      ? rarityColor
                      : Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),

                // Title
                Text(
                  achievement.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isUnlocked
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    fontSize: isSmallScreen ? 14 : null,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isSmallScreen ? 2 : 4),

                // Description
                Text(
                  achievement.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isUnlocked
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                    fontSize: isSmallScreen ? 11 : null,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                if (isUnlocked && achievement.unlockedDate != null) ...[
                  SizedBox(height: isSmallScreen ? 4 : 8),
                  Text(
                    'Unlocked ${_formatDate(achievement.unlockedDate!)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: rarityColor,
                      fontWeight: FontWeight.w500,
                      fontSize: isSmallScreen ? 10 : null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),

          // Lock Overlay
          if (!isUnlocked)
            Positioned(
              top: isSmallScreen ? 6 : 8,
              right: isSmallScreen ? 6 : 8,
              child: Container(
                padding: EdgeInsets.all(isSmallScreen ? 3 : 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceDim,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.lock,
                  size: isSmallScreen ? 14 : 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),

          // Rarity Badge
          Positioned(
            top: isSmallScreen ? 6 : 8,
            left: isSmallScreen ? 6 : 8,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 4 : 6,
                vertical: isSmallScreen ? 1 : 2,
              ),
              decoration: BoxDecoration(
                color: rarityColor.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getRarityText(achievement.rarity),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: isSmallScreen ? 9 : 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRarityColor(AchievementRarity rarity) {
    switch (rarity) {
      case AchievementRarity.common:
        return Colors.grey;
      case AchievementRarity.rare:
        return Colors.blue;
      case AchievementRarity.epic:
        return Colors.purple;
      case AchievementRarity.legendary:
        return Colors.orange;
    }
  }

  String _getRarityText(AchievementRarity rarity) {
    switch (rarity) {
      case AchievementRarity.common:
        return 'C';
      case AchievementRarity.rare:
        return 'R';
      case AchievementRarity.epic:
        return 'E';
      case AchievementRarity.legendary:
        return 'L';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
