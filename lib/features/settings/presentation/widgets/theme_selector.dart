import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';

/// A theme selector widget for switching between light and dark themes
class ThemeSelector extends ConsumerWidget {
  const ThemeSelector({
    required this.currentTheme,
    required this.onThemeChanged,
    super.key,
  });

  final ThemeMode currentTheme;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      label: 'Theme selector, currently ${currentTheme.name}',
      child: ListTile(
        leading: Icon(
          currentTheme == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
          color: colorScheme.primary,
        ),
        title: Text(
          'Theme',
          style: context.getResponsiveTextStyle(
            Theme.of(context).textTheme.titleMedium ?? const TextStyle(),
            phoneSize: 16.0,
            tabletSize: 18.0,
          ),
        ),
        subtitle: Text(
          'Choose your preferred theme',
          style: context.getResponsiveTextStyle(
            Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ) ??
                const TextStyle(),
            phoneSize: 14.0,
            tabletSize: 16.0,
          ),
        ),
        trailing: SegmentedButton<ThemeMode>(
          segments: [
            ButtonSegment<ThemeMode>(
              value: ThemeMode.light,
              icon: Icon(
                Icons.light_mode,
                size: context.getResponsiveIconSize(
                  phoneSize: 16.0,
                  tabletSize: 18.0,
                ),
              ),
              label: Text(
                'Light',
                style: context.getResponsiveTextStyle(
                  const TextStyle(),
                  phoneSize: 12.0,
                  tabletSize: 14.0,
                ),
              ),
            ),
            ButtonSegment<ThemeMode>(
              value: ThemeMode.dark,
              icon: Icon(
                Icons.dark_mode,
                size: context.getResponsiveIconSize(
                  phoneSize: 16.0,
                  tabletSize: 18.0,
                ),
              ),
              label: Text(
                'Dark',
                style: context.getResponsiveTextStyle(
                  const TextStyle(),
                  phoneSize: 12.0,
                  tabletSize: 14.0,
                ),
              ),
            ),
          ],
          selected: {currentTheme},
          onSelectionChanged: (Set<ThemeMode> selection) {
            if (selection.isNotEmpty) {
              onThemeChanged(selection.first);
            }
          },
        ),
      ),
    );
  }
}
