import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/models/store_item.dart';
import 'package:tictactoe_xo_royale/core/providers/profile_provider.dart';
import 'package:tictactoe_xo_royale/core/providers/store_provider.dart';

class StoreItemPreview extends ConsumerWidget {
  final StoreItem item;

  const StoreItemPreview({required this.item, super.key});

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

                const SizedBox(height: 12),

                // Price Chip and Action Button Row
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
                          ).colorScheme.secondary.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'PREMIUM',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 10,
                              ),
                        ),
                      ),

                    const Spacer(),

                    // CTA Button
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
                          'SELECTED',
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

  Widget _buildPreviewContent(BuildContext context) => Container(
    width: double.infinity,
    height: 100,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
      ),
    ),
    child: _buildPreviewByCategory(context),
  );

  Widget _buildPreviewByCategory(BuildContext context) {
    switch (item.category) {
      case StoreItemCategory.theme:
        return _buildThemePreview(context);
      case StoreItemCategory.board:
        return _buildBoardPreview(context);
      case StoreItemCategory.symbol:
        return _buildSymbolPreview(context);
      case StoreItemCategory.gems:
        return _buildGemPreview(context);
    }
  }

  Widget _buildThemePreview(BuildContext context) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Icon(Icons.palette, size: 40, color: Colors.white),
  );

  Widget _buildBoardPreview(BuildContext context) =>
      CustomPaint(painter: _BoardPreviewPainter(), child: Container());

  Widget _buildSymbolPreview(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'X',
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      const SizedBox(width: 12),
      Text(
        'O',
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    ],
  );

  Widget _buildGemPreview(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.diamond,
        size: 32,
        color: Theme.of(context).colorScheme.tertiary,
      ),
      const SizedBox(height: 4),
      Text(
        item.priceReal != null
            ? '\$${item.priceReal!.toStringAsFixed(2)}'
            : '${item.priceGems} Gems',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    ],
  );

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
          backgroundColor: canAfford
              ? Theme.of(context).colorScheme.tertiary
              : Theme.of(context).colorScheme.surfaceDim,
          foregroundColor: canAfford
              ? Theme.of(context).colorScheme.onTertiary
              : Theme.of(context).colorScheme.onSurfaceVariant,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'UNLOCK',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      );
    } else if (item.priceReal != null) {
      return ElevatedButton(
        onPressed: null, // Disabled for premium items as per PRD
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          backgroundColor: Theme.of(context).colorScheme.surfaceDim,
          foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
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
    if (item.priceGems == null) {
      return;
    }

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

  // ignore: unused_element - Placeholder for future real money purchase functionality
  Future<void> _purchaseWithRealMoney(
    BuildContext context,
    WidgetRef ref,
  ) async {
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

class _BoardPreviewPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final cellSize = size.width / 3;

    // Draw grid lines
    for (var i = 1; i < 3; i++) {
      // Vertical lines
      canvas
        ..drawLine(
          Offset(i * cellSize, 0),
          Offset(i * cellSize, size.height),
          paint,
        )
        // Horizontal lines
        ..drawLine(
          Offset(0, i * cellSize),
          Offset(size.width, i * cellSize),
          paint,
        );
    }

    // Draw some sample marks
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Draw X in center
    textPainter
      ..text = const TextSpan(
        text: 'X',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      )
      ..layout()
      ..paint(
        canvas,
        Offset(
          cellSize + (cellSize - textPainter.width) / 2,
          cellSize + (cellSize - textPainter.height) / 2,
        ),
      )
      // Draw O in top-left
      ..text = const TextSpan(
        text: 'O',
        style: TextStyle(
          color: Colors.red,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      )
      ..layout()
      ..paint(
        canvas,
        Offset(
          (cellSize - textPainter.width) / 2,
          (cellSize - textPainter.height) / 2,
        ),
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
