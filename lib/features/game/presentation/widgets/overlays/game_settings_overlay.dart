import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
// No longer needed - using standard Material Icons

/// Optimized game settings overlay widget with performance improvements
class GameSettingsOverlay extends StatelessWidget {
  final VoidCallback onClose;

  const GameSettingsOverlay({required this.onClose, super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        color: Colors.black.withValues(alpha: 0.7),
        child: Center(child: _SettingsDialog(onClose: onClose)),
      ),
    );
  }
}

/// Optimized settings dialog widget with RepaintBoundary
class _SettingsDialog extends StatelessWidget {
  final VoidCallback onClose;

  const _SettingsDialog({required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: Container(
        margin: EdgeInsets.all(
          context.getResponsiveSpacing(phoneSpacing: 24.0, tabletSpacing: 32.0),
        ),
        padding: EdgeInsets.all(
          context.getResponsiveSpacing(phoneSpacing: 24.0, tabletSpacing: 32.0),
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: context.getResponsiveBorderRadius(
            phoneRadius: 20.0,
            tabletRadius: 24.0,
          ),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _SettingsHeader(onClose: onClose),

            SizedBox(
              height: context.getResponsiveSpacing(
                phoneSpacing: 20.0,
                tabletSpacing: 24.0,
              ),
            ),

            // Settings toggles
            _SoundEffectsToggle(),

            SizedBox(
              height: context.getResponsiveSpacing(
                phoneSpacing: 12.0,
                tabletSpacing: 16.0,
              ),
            ),

            _BackgroundMusicToggle(),

            SizedBox(
              height: context.getResponsiveSpacing(
                phoneSpacing: 12.0,
                tabletSpacing: 16.0,
              ),
            ),

            _HapticFeedbackToggle(),

            SizedBox(
              height: context.getResponsiveSpacing(
                phoneSpacing: 24.0,
                tabletSpacing: 32.0,
              ),
            ),

            // Close button
            _CloseButton(onClose: onClose),
          ],
        ),
      ),
    );
  }
}

/// Optimized settings header widget with RepaintBoundary
class _SettingsHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _SettingsHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: Row(
        children: [
          Icon(
            Icons.settings,
            size: context.getResponsiveIconSize(
              phoneSize: 24.0,
              tabletSize: 28.0,
            ),
            color: theme.colorScheme.onSurface,
          ),
          SizedBox(
            width: context.getResponsiveSpacing(
              phoneSpacing: 8.0,
              tabletSpacing: 12.0,
            ),
          ),
          Text(
            'Game Settings',
            style: context.getResponsiveTextStyle(
              theme.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close),
            iconSize: context.getResponsiveIconSize(
              phoneSize: 20.0,
              tabletSize: 24.0,
            ),
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

/// Optimized sound effects toggle widget with RepaintBoundary
class _SoundEffectsToggle extends StatelessWidget {
  const _SoundEffectsToggle();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: _SettingToggle(
        icon: Icons.volume_up,
        title: 'Sound Effects',
        subtitle: 'Enable game sound effects',
        value: true,
        onChanged: (value) {
          // TODO(Implement sound toggle)
        },
      ),
    );
  }
}

/// Optimized background music toggle widget with RepaintBoundary
class _BackgroundMusicToggle extends StatelessWidget {
  const _BackgroundMusicToggle();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: _SettingToggle(
        icon: Icons.music_note,
        title: 'Background Music',
        subtitle: 'Enable background music',
        value: false,
        onChanged: (value) {
          // TODO(Implement music toggle)
        },
      ),
    );
  }
}

/// Optimized haptic feedback toggle widget with RepaintBoundary
class _HapticFeedbackToggle extends StatelessWidget {
  const _HapticFeedbackToggle();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: _SettingToggle(
        icon: Icons.vibration,
        title: 'Haptic Feedback',
        subtitle: 'Enable vibration feedback',
        value: true,
        onChanged: (value) {
          // TODO(Implement haptic toggle)
        },
      ),
    );
  }
}

/// Optimized close button widget with RepaintBoundary
class _CloseButton extends StatelessWidget {
  final VoidCallback onClose;

  const _CloseButton({required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onClose,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            elevation: 0,
            padding: EdgeInsets.symmetric(
              vertical: context.getResponsiveSpacing(
                phoneSpacing: 12.0,
                tabletSpacing: 16.0,
              ),
            ),
          ),
          child: const Text('Close'),
        ),
      ),
    );
  }
}

/// Optimized setting toggle widget with RepaintBoundary
class _SettingToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: Container(
        padding: EdgeInsets.all(
          context.getResponsiveSpacing(phoneSpacing: 12.0, tabletSpacing: 16.0),
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: context.getResponsiveIconSize(
                phoneSize: 20.0,
                tabletSize: 24.0,
              ),
              color: theme.colorScheme.onSurfaceVariant,
            ),

            SizedBox(
              width: context.getResponsiveSpacing(
                phoneSpacing: 12.0,
                tabletSpacing: 16.0,
              ),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.getResponsiveTextStyle(
                      theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: context.getResponsiveTextStyle(
                      theme.textTheme.bodySmall!.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
