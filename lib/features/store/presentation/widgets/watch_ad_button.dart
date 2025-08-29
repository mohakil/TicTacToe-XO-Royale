import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      margin: const EdgeInsets.all(16),
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
                size: 20,
              ),
              label: Text(canWatchAd ? 'Watch Ad to Earn Gems' : 'Ad Cooldown'),
              style: ElevatedButton.styleFrom(
                backgroundColor: canWatchAd
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.surfaceDim,
                foregroundColor: canWatchAd
                    ? Theme.of(context).colorScheme.onSecondary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Cooldown Timer
          if (timeUntilNextAd != null && !canWatchAd)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceDim,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Next ad in ${_formatDuration(timeUntilNextAd)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // Info Text
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Watch a short ad to earn +10 gems. Available every 5 minutes.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
