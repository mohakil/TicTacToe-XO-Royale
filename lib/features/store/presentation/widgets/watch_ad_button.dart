import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/providers/profile_provider.dart';
import 'package:tictactoe_xo_royale/core/providers/store_provider.dart';
import 'package:tictactoe_xo_royale/shared/widgets/buttons/ad_watch_button.dart';

class WatchAdButton extends ConsumerWidget {
  const WatchAdButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canWatchAd = ref.watch(storeCanWatchAdProvider);
    final isWatching = ref.watch(storeIsLoadingProvider);

    return Container(
      margin: context.getResponsivePadding(
        phonePadding: 16.0,
        tabletPadding: 20.0,
      ),
      child: AdWatchButton(
        onWatchAd: canWatchAd && !isWatching
            ? () => _watchAd(context, ref)
            : null,
        rewardText: '+50 Gems',
        variant: AdWatchVariant.rewarded,
        isLoading: isWatching,
        isDisabled: !canWatchAd,
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
}
