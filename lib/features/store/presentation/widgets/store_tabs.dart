import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/models/store_item.dart';
import 'package:tictactoe_xo_royale/core/providers/store_provider.dart';
import 'package:tictactoe_xo_royale/shared/widgets/buttons/category_tab.dart';

class StoreTabs extends ConsumerWidget {
  const StoreTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(storeSelectedCategoryProvider);

    return Container(
      margin: context.getResponsivePadding(
        phonePadding: 20.0,
        tabletPadding: 24.0,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: StoreItemCategory.values.map((category) {
            final isSelected = selectedCategory == category;
            final categoryName = _getCategoryInfo(category);

            return Padding(
              padding: EdgeInsets.only(
                right: context.getResponsiveSpacing(
                  phoneSpacing: 8.0,
                  tabletSpacing: 12.0,
                ),
              ),
              child: CategoryTab(
                key: ValueKey('category_${category.name}'),
                label: categoryName,
                isSelected: isSelected,
                variant: CategoryTabVariant.filled,
                onTap: () =>
                    ref.read(storeProvider.notifier).selectCategory(category),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getCategoryInfo(StoreItemCategory category) {
    switch (category) {
      case StoreItemCategory.theme:
        return 'Themes';
      case StoreItemCategory.board:
        return 'Boards';
      case StoreItemCategory.symbol:
        return 'Symbols';
      case StoreItemCategory.gems:
        return 'Gems';
    }
  }
}
