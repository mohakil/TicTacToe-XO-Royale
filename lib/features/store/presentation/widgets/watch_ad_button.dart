import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/providers/profile_provider.dart';
import 'package:tictactoe_xo_royale/core/providers/store_provider.dart';

class WatchAdButton extends ConsumerWidget {
  const WatchAdButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canWatchAd = ref.watch(storeCanWatchAdProvider);
    final timeUntilNextAd = ref.watch(storeTimeUntilNextAdProvider);
    final isWatching = ref.watch(storeIsLoadingProvider);

    return Container(
      margin: context.getResponsivePadding(
        phonePadding: 12.0,
        tabletPadding: 16.0,
      ),
      child: Column(
        children: [
          // Watch Ad Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: canWatchAd && !isWatching
                  ? () => _watchAd(context, ref)
                  : null,
              icon: Icon(
                canWatchAd ? Icons.play_circle : Icons.timer,
                size: context.getResponsiveIconSize(
                  phoneSize: 18.0,
                  tabletSize: 20.0,
                ),
              ),
              label: Text(
                canWatchAd ? 'Watch Ad to Earn Gems' : 'Ad Cooldown',
                style: context.getResponsiveTextStyle(
                  Theme.of(context).textTheme.labelLarge ?? const TextStyle(),
                  phoneSize: 14.0,
                  tabletSize: 16.0,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: canWatchAd
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.surfaceDim,
                foregroundColor: canWatchAd
                    ? Theme.of(context).colorScheme.onSecondary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                padding: context.getResponsivePadding(
                  phonePadding: 12.0,
                  tabletPadding: 16.0,
                ),
                minimumSize: Size(
                  double.infinity,
                  context.getResponsiveButtonHeight(
                    phoneHeight: 48.0,
                    tabletHeight: 56.0,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: context.getResponsiveBorderRadius(
                    phoneRadius: 10.0,
                    tabletRadius: 12.0,
                  ),
                ),
              ),
            ),
          ),

          // Cooldown Timer
          if (timeUntilNextAd != null && !canWatchAd)
            Container(
              margin: context.getResponsivePadding(
                phonePadding: 6.0,
                tabletPadding: 8.0,
              ),
              padding: context.getResponsivePadding(
                phonePadding: 8.0,
                tabletPadding: 12.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceDim,
                borderRadius: context.getResponsiveBorderRadius(
                  phoneRadius: 6.0,
                  tabletRadius: 8.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer,
                    size: context.getResponsiveIconSize(
                      phoneSize: 14.0,
                      tabletSize: 16.0,
                    ),
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(
                    width: context.getResponsiveSpacing(
                      phoneSpacing: 4.0,
                      tabletSpacing: 6.0,
                    ),
                  ),
                  Text(
                    'Next ad in ${_formatDuration(timeUntilNextAd)}',
                    style: context.getResponsiveTextStyle(
                      Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ) ??
                          const TextStyle(),
                      phoneSize: 12.0,
                      tabletSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),

          // Info Text
          Container(
            margin: context.getResponsivePadding(
              phonePadding: 8.0,
              tabletPadding: 12.0,
            ),
            padding: context.getResponsivePadding(
              phonePadding: 10.0,
              tabletPadding: 12.0,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: context.getResponsiveBorderRadius(
                phoneRadius: 6.0,
                tabletRadius: 8.0,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: context.getResponsiveIconSize(
                    phoneSize: 14.0,
                    tabletSize: 16.0,
                  ),
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                SizedBox(
                  width: context.getResponsiveSpacing(
                    phoneSpacing: 6.0,
                    tabletSpacing: 8.0,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Watch a short ad to earn +10 gems. Available every 5 minutes.',
                    style: context.getResponsiveTextStyle(
                      Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ) ??
                          const TextStyle(),
                      phoneSize: 12.0,
                      tabletSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _watchAd(BuildContext context, WidgetRef ref) async {
    // Show loading state
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Watching ad...'),
          ],
        ),
        duration: Duration(seconds: 3),
      ),
    );

    // Simulate ad watching
    await Future.delayed(const Duration(seconds: 3));

    // Process ad completion
    final success = await ref.read(storeProvider.notifier).watchAd();

    if (success) {
      // Add gems to user profile
      await ref.read(profileProvider.notifier).addGems(10);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                const SizedBox(width: 8),
                const Text('Ad completed! You earned +10 gems!'),
              ],
            ),
            backgroundColor: Theme.of(
              context,
            ).colorScheme.tertiary.withValues(alpha: 0.1),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ad failed to complete. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}
