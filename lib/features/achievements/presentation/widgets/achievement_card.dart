import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/models/achievement.dart';

class AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const AchievementCard({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    final rarityColor = achievement.getRarityColor();
    final isUnlocked = achievement.isUnlocked;

    // Use responsive system instead of parameter
    final padding = context.getResponsiveSpacing(
      phoneSpacing: 12.0,
      tabletSpacing: 16.0,
    );

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
            padding: EdgeInsets.all(padding),
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
