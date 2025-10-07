import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

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
                    Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ) ??
                        const TextStyle(),
                    phoneSize: 16.0,
                    tabletSize: 18.0,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(
                    height: context.getResponsiveSpacing(
                      phoneSpacing: 2.0,
                      tabletSpacing: 4.0,
                    ),
                  ),
                  Text(
                    subtitle!,
                    style: context.getResponsiveTextStyle(
                      Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
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
          Card(
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
