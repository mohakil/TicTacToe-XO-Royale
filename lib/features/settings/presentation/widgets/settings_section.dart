import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/shared/widgets/cards/enhanced_card.dart';

/// A settings section widget for grouping related settings
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    required this.title,
    required this.children,
    super.key,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title settings section',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: context.getResponsivePadding(
              phonePadding: 12.0,
              tabletPadding: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.getResponsiveTextStyle(
                    Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ) ??
                        const TextStyle(),
                    phoneSize: 18.0,
                    tabletSize: 20.0,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(
                    height: context.getResponsiveSpacing(
                      phoneSpacing: 4.0,
                      tabletSpacing: 6.0,
                    ),
                  ),
                  Text(
                    subtitle!,
                    style: context.getResponsiveTextStyle(
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ) ??
                          const TextStyle(),
                      phoneSize: 12.0,
                      tabletSize: 14.0,
                    ),
                  ),
                ],
              ],
            ),
          ),
          EnhancedCard(
            variant: CardVariant.filled,
            size: CardSize.medium,
            margin: context.getResponsivePadding(
              phonePadding: 12.0,
              tabletPadding: 16.0,
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}
