import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/store_item.dart';
import '../../../../core/providers/store_provider.dart';
import '../../../../core/providers/profile_provider.dart';

class StoreItemPreview extends ConsumerWidget {
  final StoreItem item;

  const StoreItemPreview({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUnlocked = !item.locked;
    final userGems = ref.watch(profileGemsProvider);
    final canAfford = item.priceGems != null && userGems >= item.priceGems!;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Preview Image/Icon
                Expanded(child: Center(child: _buildPreviewContent(context))),

                const SizedBox(height: 12),

                // Item Name
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                // Item Description
                Text(
                  item.desc,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Price and Action Button
                Row(
                  children: [
                    // Price Chip
                    if (item.priceGems != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.tertiary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.tertiary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.diamond,
                              size: 16,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.priceGems.toString(),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.tertiary,
                                  ),
                            ),
                          ],
                        ),
                      )
                    else if (item.priceReal != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          '\$${item.priceReal!.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),

                    const Spacer(),

                    // Action Button
                    if (isUnlocked)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.tertiary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'UNLOCKED',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                        ),
                      )
                    else
                      _buildActionButton(context, ref, canAfford),
                  ],
                ),
              ],
            ),
          ),

          // Lock Overlay
          if (!isUnlocked)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceDim,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.lock,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),

          // Premium Badge
          if (item.premium)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'PREMIUM',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPreviewContent(BuildContext context) {
    // TODO: Implement actual preview content based on item type
    // For now, use placeholder icons
    final icon = _getPreviewIcon();
    final color = _getPreviewColor();

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: Icon(icon, size: 40, color: color),
    );
  }

  IconData _getPreviewIcon() {
    switch (item.category) {
      case StoreItemCategory.theme:
        return Icons.palette;
      case StoreItemCategory.board:
        return Icons.grid_on;
      case StoreItemCategory.symbol:
        return Icons.close;
      case StoreItemCategory.gems:
        return Icons.diamond;
    }
  }

  Color _getPreviewColor() {
    switch (item.category) {
      case StoreItemCategory.theme:
        return Colors.purple;
      case StoreItemCategory.board:
        return Colors.blue;
      case StoreItemCategory.symbol:
        return Colors.orange;
      case StoreItemCategory.gems:
        return Colors.amber;
    }
  }

  Widget _buildActionButton(
    BuildContext context,
    WidgetRef ref,
    bool canAfford,
  ) {
    if (item.priceGems != null) {
      return ElevatedButton(
        onPressed: canAfford ? () => _purchaseWithGems(context, ref) : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          foregroundColor: Theme.of(context).colorScheme.onTertiary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          canAfford
              ? 'UNLOCK'
              : 'NEED ${item.priceGems! - ref.read(profileGemsProvider)} GEMS',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      );
    } else if (item.priceReal != null) {
      return ElevatedButton(
        onPressed: () => _purchaseWithRealMoney(context, ref),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'BUY',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Future<void> _purchaseWithGems(BuildContext context, WidgetRef ref) async {
    if (item.priceGems == null) return;

    final success = await ref
        .read(storeProvider.notifier)
        .purchaseItem(item.id, item.priceGems!);

    if (success) {
      // Update user gems in profile
      await ref.read(profileProvider.notifier).spendGems(item.priceGems!);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.name} unlocked successfully!'),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to unlock item. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _purchaseWithRealMoney(
    BuildContext context,
    WidgetRef ref,
  ) async {
    // TODO: Implement real money purchase flow
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Real money purchases coming soon!'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}
