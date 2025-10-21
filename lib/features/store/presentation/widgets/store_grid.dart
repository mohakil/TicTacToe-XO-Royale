import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/providers/store_provider.dart';
import 'package:tictactoe_xo_royale/features/store/presentation/widgets/store_item_preview.dart';
import 'package:tictactoe_xo_royale/shared/widgets/feedback/state_display.dart';

class StoreGrid extends ConsumerWidget {
  const StoreGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(storeCurrentCategoryItemsProvider);
    final isLoading = ref.watch(storeIsLoadingProvider);

    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: StateDisplay(
            state: DisplayState.loading,
            title: 'Loading store items',
            subtitle: 'Please wait while we fetch the latest items',
            icon: Icons.store,
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: StateDisplay(
            state: DisplayState.empty,
            title: 'No items available',
            subtitle: 'Check back later for new items',
            icon: Icons.store,
          ),
        ),
      );
    }

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
            phoneCount: 2,
            tabletCount: 3,
          ),
          crossAxisSpacing: context.getResponsiveSpacing(
            phoneSpacing: 12.0,
            tabletSpacing: 16.0,
          ),
          mainAxisSpacing: context.getResponsiveSpacing(
            phoneSpacing: 12.0,
            tabletSpacing: 16.0,
          ),
          childAspectRatio: context.isPhone ? 0.75 : 0.8,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return StoreItemPreview(
            key: ValueKey('store_item_${item.id}'),
            item: item,
          );
        },
      ),
    );
  }
}
