import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';

/// A custom toggle setting widget for the settings screen
class ToggleSetting extends ConsumerWidget {
  const ToggleSetting({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
    super.key,
    this.enabled = true,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      label: '$title setting, currently ${value ? 'enabled' : 'disabled'}',
      child: ListTile(
        enabled: enabled,
        leading: Icon(
          icon,
          color: enabled
              ? colorScheme.primary
              : colorScheme.onSurface.withValues(alpha: 0.38),
        ),
        title: Text(
          title,
          style: context.getResponsiveTextStyle(
            Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: enabled
                      ? colorScheme.onSurface
                      : colorScheme.onSurface.withValues(alpha: 0.38),
                ) ??
                const TextStyle(),
            phoneSize: 16.0,
            tabletSize: 18.0,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: context.getResponsiveTextStyle(
            Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: enabled
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                ) ??
                const TextStyle(),
            phoneSize: 14.0,
            tabletSize: 16.0,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: enabled ? onChanged : null,
          activeThumbColor: colorScheme.primary,
        ),
        onTap: enabled ? () => onChanged(!value) : null,
      ),
    );
  }
}
