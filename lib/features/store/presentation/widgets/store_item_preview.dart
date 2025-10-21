import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/models/store_item.dart';
import 'package:tictactoe_xo_royale/core/providers/profile_provider.dart';
import 'package:tictactoe_xo_royale/core/providers/store_provider.dart';
import 'package:tictactoe_xo_royale/shared/widgets/cards/enhanced_card.dart';
import 'package:tictactoe_xo_royale/shared/widgets/buttons/enhanced_button.dart';
import 'package:tictactoe_xo_royale/shared/widgets/icons/icon_text.dart';

class StoreItemPreview extends ConsumerWidget {
  final StoreItem item;

  const StoreItemPreview({required this.item, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUnlocked = !item.locked;
    final userGems = ref.watch(profileGemsProvider);
    final canAfford = item.priceGems != null && userGems >= item.priceGems!;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return EnhancedCard(
      variant: CardVariant.elevated,
      size: CardSize.medium,
      backgroundColor: isUnlocked
          ? colorScheme.surfaceContainerHighest
          : colorScheme.surfaceContainer,
      borderColor: isUnlocked
          ? colorScheme.primary.withValues(alpha: 0.2)
          : colorScheme.outline.withValues(alpha: 0.1),
      elevation: isUnlocked ? 4.0 : 1.0,
      child: Stack(
        children: [
          // Main Content
          Padding(
            padding: context.getResponsivePadding(
              phonePadding: 12.0,
              tabletPadding: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Preview Image/Icon
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: !isUnlocked ? colorScheme.surfaceContainer : null,
                      borderRadius: context.getResponsiveBorderRadius(
                        phoneRadius: 16.0,
                        tabletRadius: 20.0,
                      ),
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: _buildPreviewByCategory(context),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: context.getResponsiveSpacing(
                    phoneSpacing: 8.0,
                    tabletSpacing: 12.0,
                  ),
                ),

                // Item Name
                Text(
                  item.name,
                  style: context.getResponsiveTextStyle(
                    theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isUnlocked
                              ? colorScheme.onSurface
                              : colorScheme.onSurfaceVariant,
                        ) ??
                        const TextStyle(),
                    phoneSize: 15.0,
                    tabletSize: 17.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(
                  height: context.getResponsiveSpacing(
                    phoneSpacing: 4.0,
                    tabletSpacing: 6.0,
                  ),
                ),

                // Item Description
                Text(
                  item.desc,
                  style: context.getResponsiveTextStyle(
                    theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.8,
                          ),
                          height: 1.3,
                        ) ??
                        const TextStyle(),
                    phoneSize: 11.0,
                    tabletSize: 13.0,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(
                  height: context.getResponsiveSpacing(
                    phoneSpacing: 8.0,
                    tabletSpacing: 12.0,
                  ),
                ),

                // Price Chip and Action Button Row
                Row(
                  children: [
                    // Price Chip - Flexible to prevent overflow
                    Flexible(
                      child: item.priceGems != null
                          ? IntrinsicWidth(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.getResponsiveSpacing(
                                    phoneSpacing: 8.0,
                                    tabletSpacing: 12.0,
                                  ),
                                  vertical: context.getResponsiveSpacing(
                                    phoneSpacing: 4.0,
                                    tabletSpacing: 6.0,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      colorScheme.tertiary.withValues(
                                        alpha: 0.15,
                                      ),
                                      colorScheme.tertiary.withValues(
                                        alpha: 0.05,
                                      ),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: context
                                      .getResponsiveBorderRadius(
                                        phoneRadius: 12.0,
                                        tabletRadius: 16.0,
                                      ),
                                  border: Border.all(
                                    color: colorScheme.tertiary.withValues(
                                      alpha: 0.3,
                                    ),
                                    width: 1,
                                  ),
                                ),
                                child: IconText(
                                  icon: Icons.diamond,
                                  text: item.priceGems.toString(),
                                  iconColor: colorScheme.tertiary,
                                  textStyle: context.getResponsiveTextStyle(
                                    theme.textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: colorScheme.tertiary,
                                        ) ??
                                        const TextStyle(),
                                    phoneSize: 11.0,
                                    tabletSize: 13.0,
                                  ),
                                  size: IconTextSize.small,
                                  direction: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  useResponsiveSizing:
                                      false, // Using custom sizing
                                ),
                              ),
                            )
                          : item.priceReal != null
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.getResponsiveSpacing(
                                  phoneSpacing: 8.0,
                                  tabletSpacing: 12.0,
                                ),
                                vertical: context.getResponsiveSpacing(
                                  phoneSpacing: 4.0,
                                  tabletSpacing: 6.0,
                                ),
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    colorScheme.secondary,
                                    colorScheme.secondary.withValues(
                                      alpha: 0.8,
                                    ),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: context.getResponsiveBorderRadius(
                                  phoneRadius: 12.0,
                                  tabletRadius: 16.0,
                                ),
                              ),
                              child: Text(
                                'PREMIUM',
                                style: context.getResponsiveTextStyle(
                                  theme.textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ) ??
                                      const TextStyle(),
                                  phoneSize: 10.0,
                                  tabletSize: 12.0,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    SizedBox(
                      width: context.getResponsiveSpacing(
                        phoneSpacing: 8.0,
                        tabletSpacing: 12.0,
                      ),
                    ),

                    // CTA Button - Flexible to prevent overflow
                    Flexible(
                      child: isUnlocked
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.getResponsiveSpacing(
                                  phoneSpacing: 8.0,
                                  tabletSpacing: 12.0,
                                ),
                                vertical: context.getResponsiveSpacing(
                                  phoneSpacing: 4.0,
                                  tabletSpacing: 6.0,
                                ),
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    colorScheme.primary.withValues(alpha: 0.1),
                                    colorScheme.primary.withValues(alpha: 0.05),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: context.getResponsiveBorderRadius(
                                  phoneRadius: 12.0,
                                  tabletRadius: 16.0,
                                ),
                                border: Border.all(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'SELECTED',
                                style: context.getResponsiveTextStyle(
                                  theme.textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: colorScheme.primary,
                                      ) ??
                                      const TextStyle(),
                                  phoneSize: 10.0,
                                  tabletSize: 12.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            )
                          : _buildActionButton(context, ref, canAfford),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Lock Overlay
          if (!isUnlocked)
            Positioned(
              top: context.getResponsiveSpacing(
                phoneSpacing: 8.0,
                tabletSpacing: 12.0,
              ),
              right: context.getResponsiveSpacing(
                phoneSpacing: 8.0,
                tabletSpacing: 12.0,
              ),
              child: Container(
                padding: EdgeInsets.all(
                  context.getResponsiveSpacing(
                    phoneSpacing: 6.0,
                    tabletSpacing: 8.0,
                  ),
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceDim.withValues(alpha: 0.9),
                  borderRadius: context.getResponsiveBorderRadius(
                    phoneRadius: 12.0,
                    tabletRadius: 16.0,
                  ),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.lock,
                  size: context.getResponsiveIconSize(
                    phoneSize: 16.0,
                    tabletSize: 20.0,
                  ),
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),

          // Premium Badge
          if (item.premium)
            Positioned(
              top: context.getResponsiveSpacing(
                phoneSpacing: 8.0,
                tabletSpacing: 12.0,
              ),
              left: context.getResponsiveSpacing(
                phoneSpacing: 8.0,
                tabletSpacing: 12.0,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.getResponsiveSpacing(
                    phoneSpacing: 8.0,
                    tabletSpacing: 12.0,
                  ),
                  vertical: context.getResponsiveSpacing(
                    phoneSpacing: 4.0,
                    tabletSpacing: 6.0,
                  ),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.secondary,
                      colorScheme.secondary.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: context.getResponsiveBorderRadius(
                    phoneRadius: 12.0,
                    tabletRadius: 16.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.secondary.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'PREMIUM',
                  style: context.getResponsiveTextStyle(
                    theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ) ??
                        const TextStyle(),
                    phoneSize: 9.0,
                    tabletSize: 11.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

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

  Widget _buildGemPreview(BuildContext context) => IconText(
    icon: Icons.diamond,
    text: item.priceReal != null
        ? '\\${item.priceReal!.toStringAsFixed(2)}'
        : '${item.priceGems} Gems',
    iconColor: Theme.of(context).colorScheme.tertiary,
    textStyle:
        Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ) ??
        const TextStyle(),
    size: IconTextSize.medium,
    direction: Axis.vertical,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    useResponsiveSizing: false, // Using fixed sizing for this preview
  );

  Widget _buildActionButton(
    BuildContext context,
    WidgetRef ref,
    bool canAfford,
  ) {
    if (item.priceGems != null) {
      return EnhancedButton(
        text: 'UNLOCK',
        onPressed: canAfford ? () => _purchaseWithGems(context, ref) : null,
        variant: ButtonVariant.primary,
        size: ButtonSize.small,
        isDisabled: !canAfford,
      );
    } else if (item.priceReal != null) {
      return EnhancedButton(
        text: 'BUY',
        onPressed: null, // Disabled for premium items as per PRD
        variant: ButtonVariant.secondary,
        size: ButtonSize.small,
        isDisabled: true,
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
