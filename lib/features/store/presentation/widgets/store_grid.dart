import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/providers/store_provider.dart';
import 'package:tictactoe_xo_royale/features/store/presentation/widgets/store_item_preview.dart';

class StoreGrid extends ConsumerWidget {
  final bool useSliver;
  const StoreGrid({super.key, this.useSliver = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(storeCurrentCategoryItemsProvider);
    final isLoading = ref.watch(storeIsLoadingProvider);

    if (isLoading) {
      return _buildLoadingState(useSliver);
    }

    if (items.isEmpty) {
      return _buildEmptyState(useSliver, context);
    }

    if (useSliver) {
      return SliverPadding(
        padding: context.getResponsivePadding(
          phonePadding: 12.0,
          tabletPadding: 16.0,
        ),
        sliver: SliverGrid.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: context.getGridCrossAxisCount(
              phoneCount: 1,
              tabletCount: 2,
            ),
            crossAxisSpacing: context.getResponsiveSpacing(
              phoneSpacing: 12.0,
              tabletSpacing: 16.0,
            ),
            mainAxisSpacing: context.getResponsiveSpacing(
              phoneSpacing: 12.0,
              tabletSpacing: 16.0,
            ),
            childAspectRatio: context.isPhone ? 0.85 : 0.8,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return StoreItemPreview(item: item);
          },
        ),
      );
    } else {
      return Padding(
        padding: context.getResponsivePadding(
          phonePadding: 12.0,
          tabletPadding: 16.0,
        ),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: context.getGridCrossAxisCount(
              phoneCount: 1,
              tabletCount: 2,
            ),
            crossAxisSpacing: context.getResponsiveSpacing(
              phoneSpacing: 12.0,
              tabletSpacing: 16.0,
            ),
            mainAxisSpacing: context.getResponsiveSpacing(
              phoneSpacing: 12.0,
              tabletSpacing: 16.0,
            ),
            childAspectRatio: context.isPhone ? 0.85 : 0.8,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return StoreItemPreview(item: item);
          },
        ),
      );
    }
  }

  Widget _buildLoadingState(bool useSliver) {
    if (useSliver) {
      return SliverToBoxAdapter(
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
              Text('Loading store items...'),
            ],
          ),
        ),
      );
    } else {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading store items...'),
          ],
        ),
      );
    }
  }

  Widget _buildEmptyState(bool useSliver, BuildContext context) {
    final emptyWidget = Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.store,
              size: 64,
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No items available',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new items!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    if (useSliver) {
      return SliverFillRemaining(hasScrollBody: false, child: emptyWidget);
    } else {
      return emptyWidget;
    }
  }
}
