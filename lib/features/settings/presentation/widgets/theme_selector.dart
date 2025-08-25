import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A theme selector widget for switching between light and dark themes
class ThemeSelector extends ConsumerWidget {
  const ThemeSelector({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
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
        title: Text('Theme', style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(
          'Choose your preferred theme',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        trailing: SegmentedButton<ThemeMode>(
          segments: const [
            ButtonSegment<ThemeMode>(
              value: ThemeMode.light,
              icon: Icon(Icons.light_mode),
              label: Text('Light'),
            ),
            ButtonSegment<ThemeMode>(
              value: ThemeMode.dark,
              icon: Icon(Icons.dark_mode),
              label: Text('Dark'),
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
