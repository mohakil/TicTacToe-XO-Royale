import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/models/store_item.dart';
import 'package:tictactoe_xo_royale/core/providers/store_provider.dart';

class StoreTabs extends ConsumerWidget {
  const StoreTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(storeTabIndexProvider);
    if (tabIndex != 1) {
      return const SizedBox.shrink();
    }

    final selectedCategory = ref.watch(storeSelectedCategoryProvider);

    return Container(
      margin: context.getResponsivePadding(
        phonePadding: 12.0,
        tabletPadding: 16.0,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: StoreItemCategory.values
              .where((category) => category != StoreItemCategory.gems)
              .map((category) {
                final isSelected = selectedCategory == category;
                final itemCount = ref
                    .watch(storeItemsProvider)
                    .where((item) => item.category == category)
                    .length;
                final unlockedCount = ref
                    .watch(storeItemsProvider)
                    .where((item) => item.category == category && !item.locked)
                    .length;

                return Padding(
                  padding: context.getResponsivePadding(
                    phonePadding: 8.0,
                    tabletPadding: 12.0,
                  ),
                  child: _StoreTab(
                    category: category,
                    isSelected: isSelected,
                    itemCount: itemCount,
                    unlockedCount: unlockedCount,
                    onTap: () => ref
                        .read(storeProvider.notifier)
                        .selectCategory(category),
                  ),
                );
              })
              .toList(),
        ),
      ),
    );
  }
}

class _StoreTab extends StatelessWidget {
  final StoreItemCategory category;
  final bool isSelected;
  final int itemCount;
  final int unlockedCount;
  final VoidCallback onTap;

  const _StoreTab({
    required this.category,
    required this.isSelected,
    required this.itemCount,
    required this.unlockedCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final categoryInfo = _getCategoryInfo(category);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: context.getResponsivePadding(
          phonePadding: 16.0,
          tabletPadding: 20.0,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: context.getResponsiveBorderRadius(
            phoneRadius: 20.0,
            tabletRadius: 24.0,
          ),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: context.getResponsiveCardElevation(
                      phoneElevation: 6.0,
                      tabletElevation: 8.0,
                    ),
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            // Icon
            Icon(
              categoryInfo.icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              size: context.getResponsiveIconSize(
                phoneSize: 20.0,
                tabletSize: 24.0,
              ),
            ),
            SizedBox(
              height: context.getResponsiveSpacing(
                phoneSpacing: 6.0,
                tabletSpacing: 8.0,
              ),
            ),

            // Category Name
            Text(
              categoryInfo.name,
              style: context.getResponsiveTextStyle(
                Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                    ) ??
                    const TextStyle(),
                phoneSize: 12.0,
                tabletSize: 14.0,
              ),
            ),

            // Progress Indicator
            Container(
              margin: context.getResponsivePadding(
                phonePadding: 2.0,
                tabletPadding: 4.0,
              ),
              padding: context.getResponsivePadding(
                phonePadding: 6.0,
                tabletPadding: 8.0,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(
                        context,
                      ).colorScheme.onPrimary.withValues(alpha: 0.2)
                    : Theme.of(context).colorScheme.surface,
                borderRadius: context.getResponsiveBorderRadius(
                  phoneRadius: 10.0,
                  tabletRadius: 12.0,
                ),
              ),
              child: Text(
                '$unlockedCount/$itemCount',
                style: context.getResponsiveTextStyle(
                  Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ) ??
                      const TextStyle(),
                  phoneSize: 10.0,
                  tabletSize: 12.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  CategoryInfo _getCategoryInfo(StoreItemCategory category) {
    switch (category) {
      case StoreItemCategory.theme:
        return const CategoryInfo(name: 'Themes', icon: Icons.palette);
      case StoreItemCategory.board:
        return const CategoryInfo(name: 'Board Designs', icon: Icons.grid_on);
      case StoreItemCategory.symbol:
        return const CategoryInfo(name: 'X/O Symbols', icon: Icons.close);
      case StoreItemCategory.gems:
        return const CategoryInfo(name: 'Gems', icon: Icons.diamond);
    }
  }
}

class CategoryInfo {
  final String name;
  final IconData icon;

  const CategoryInfo({required this.name, required this.icon});
}
