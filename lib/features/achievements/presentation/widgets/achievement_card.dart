import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/models/achievement.dart';
import 'package:tictactoe_xo_royale/shared/widgets/cards/enhanced_card.dart';
import 'package:tictactoe_xo_royale/shared/widgets/feedback/progress_animation.dart';

class AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const AchievementCard({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    final rarityColor = achievement.getRarityColor();
    final isUnlocked = achievement.isUnlocked;

    return EnhancedCard(
      variant: CardVariant.elevated,
      size: CardSize.medium,
      backgroundColor: isUnlocked
          ? Theme.of(context).colorScheme.surface
          : Theme.of(context).colorScheme.surfaceDim,
      borderColor: isUnlocked
          ? rarityColor.withValues(alpha: 0.3)
          : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
      elevation: isUnlocked ? 2.0 : 0.0,
      gradient: isUnlocked
          ? null
          : LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.surfaceDim,
                Theme.of(context).colorScheme.surfaceDim.withValues(alpha: 0.9),
              ],
            ),
      child: Stack(
        children: [
          // Main Content
          Padding(
            padding: EdgeInsets.all(
              context.getResponsiveSpacing(
                phoneSpacing: 12.0,
                tabletSpacing: 16.0,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // Prevent overflow
              children: [
                // Icon
                Icon(
                  achievement.icon,
                  size: context.getResponsiveIconSize(
                    phoneSize: 32.0,
                    tabletSize: 36.0,
                  ),
                  color: isUnlocked
                      ? rarityColor
                      : Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                ),
                SizedBox(
                  height: context.getResponsiveSpacing(
                    phoneSpacing: 6.0,
                    tabletSpacing: 8.0,
                  ),
                ),

                // Title
                Flexible(
                  child: Text(
                    achievement.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isUnlocked
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5),
                      fontSize: context.isPhone ? 13.0 : 14.0,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: context.getResponsiveSpacing(
                    phoneSpacing: 2.0,
                    tabletSpacing: 3.0,
                  ),
                ),

                // Description
                Flexible(
                  child: Text(
                    achievement.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isUnlocked
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Theme.of(context).colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.3),
                      fontSize: context.isPhone ? 10.0 : 11.0,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Progress Bar (show for achievements with progress, including unlocked ones)
                if (achievement.maxProgress > 1) ...[
                  SizedBox(
                    height: context.getResponsiveSpacing(
                      phoneSpacing: 4.0,
                      tabletSpacing: 6.0,
                    ),
                  ),
                  // Progress Text with validation
                  Builder(
                    builder: (context) {
                      // Ensure progress consistency
                      final displayProgress = isUnlocked
                          ? achievement
                                .maxProgress // Always show max for unlocked
                          : achievement.progress.clamp(
                              0,
                              achievement.maxProgress - 1,
                            );

                      return Text(
                        '$displayProgress/${achievement.maxProgress}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isUnlocked
                              ? rarityColor
                              : Theme.of(context).colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.7),
                          fontWeight: FontWeight.w500,
                          fontSize: context.isPhone ? 9.0 : 10.0,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                  SizedBox(
                    height: context.getResponsiveSpacing(
                      phoneSpacing: 2.0,
                      tabletSpacing: 3.0,
                    ),
                  ),
                  // Progress Bar - Using shared ProgressAnimation with validated progress
                  ProgressAnimation(
                    progress: isUnlocked
                        ? 1.0 // Always show 100% for unlocked achievements
                        : (achievement.progress.clamp(
                                    0,
                                    achievement.maxProgress - 1,
                                  ) /
                                  achievement.maxProgress)
                              .clamp(0.0, 0.99),
                    variant: ProgressAnimationVariant.linear,
                    color: isUnlocked
                        ? rarityColor
                        : Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    strokeWidth: context.scale(3.0),
                  ),
                ],

                if (isUnlocked && achievement.unlockedDate != null) ...[
                  SizedBox(
                    height: context.getResponsiveSpacing(
                      phoneSpacing: 3.0,
                      tabletSpacing: 4.0,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      'Unlocked ${achievement.formatUnlockedDate()}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: rarityColor,
                        fontWeight: FontWeight.w500,
                        fontSize: context.isPhone ? 9.0 : 10.0,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Lock Overlay
          if (!isUnlocked)
            Positioned(
              top: context.getResponsiveSpacing(
                phoneSpacing: 6.0,
                tabletSpacing: 8.0,
              ),
              right: context.getResponsiveSpacing(
                phoneSpacing: 6.0,
                tabletSpacing: 8.0,
              ),
              child: Container(
                padding: context.getResponsivePadding(
                  phonePadding: 3.0,
                  tabletPadding: 4.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceDim,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.lock,
                  size: context.getResponsiveIconSize(
                    phoneSize: 14.0,
                    tabletSize: 16.0,
                  ),
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),

          // Rarity Badge
          Positioned(
            top: context.getResponsiveSpacing(
              phoneSpacing: 6.0,
              tabletSpacing: 8.0,
            ),
            left: context.getResponsiveSpacing(
              phoneSpacing: 6.0,
              tabletSpacing: 8.0,
            ),
            child: Container(
              padding: context.getResponsivePadding(
                phonePadding: 4.0,
                tabletPadding: 6.0,
              ),
              decoration: BoxDecoration(
                color: rarityColor.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                achievement.getRarityText(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: context.isPhone ? 9.0 : 10.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
