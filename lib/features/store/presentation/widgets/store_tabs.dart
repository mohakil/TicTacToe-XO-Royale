import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/models/store_item.dart';
import 'package:tictactoe_xo_royale/core/providers/store_provider.dart';

class StoreTabs extends ConsumerWidget {
  const StoreTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(storeSelectedCategoryProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: StoreItemCategory.values.map((category) {
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
              padding: const EdgeInsets.only(right: 12),
              child: _StoreTab(
                category: category,
                isSelected: isSelected,
                itemCount: itemCount,
                unlockedCount: unlockedCount,
                onTap: () =>
                    ref.read(storeProvider.notifier).selectCategory(category),
              ),
            );
          }).toList(),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(24),
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
                    blurRadius: 8,
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
              size: 24,
            ),
            const SizedBox(height: 8),

            // Category Name
            Text(
              categoryInfo.name,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),

            // Progress Indicator
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(
                        context,
                      ).colorScheme.onPrimary.withValues(alpha: 0.2)
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$unlockedCount/$itemCount',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
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
