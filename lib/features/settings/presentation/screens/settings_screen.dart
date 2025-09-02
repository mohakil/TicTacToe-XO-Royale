import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/providers/settings_provider.dart';
import 'package:tictactoe_xo_royale/core/providers/theme_provider.dart';
import 'package:tictactoe_xo_royale/core/widgets/performance_monitor.dart';
import 'package:tictactoe_xo_royale/features/settings/presentation/widgets/about_section.dart';
import 'package:tictactoe_xo_royale/features/settings/presentation/widgets/settings_section.dart';
import 'package:tictactoe_xo_royale/features/settings/presentation/widgets/theme_selector.dart';
import 'package:tictactoe_xo_royale/features/settings/presentation/widgets/toggle_setting.dart';

/// The main settings screen for the app
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    // ✅ OPTIMIZED: Use select for granular rebuilds - only rebuild when specific values change
    final themeMode = ref.watch(themeModeProvider);

    // Use select for frequently accessed settings to minimize rebuilds
    final soundEnabled = ref.watch(
      settingsProvider.select((state) => state.soundEnabled),
    );
    final musicEnabled = ref.watch(
      settingsProvider.select((state) => state.musicEnabled),
    );
    final vibrationEnabled = ref.watch(
      settingsProvider.select((state) => state.vibrationEnabled),
    );
    final hapticFeedbackEnabled = ref.watch(
      settingsProvider.select((state) => state.hapticFeedbackEnabled),
    );
    final autoSaveEnabled = ref.watch(
      settingsProvider.select((state) => state.autoSaveEnabled),
    );
    final notificationsEnabled = ref.watch(
      settingsProvider.select((state) => state.notificationsEnabled),
    );
    final performanceMode = ref.watch(
      settingsProvider.select((state) => state.performanceMode),
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Settings Header
              Text(
                'Settings',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 24),

              // Audio & Haptics Section
              SettingsSection(
                title: 'Audio & Haptics',
                subtitle: 'Control sound effects, music, and haptic feedback',
                children: [
                  ToggleSetting(
                    title: 'Sound',
                    subtitle: 'Enable sound effects',
                    icon: Icons.volume_up,
                    value: soundEnabled, // Use optimized value
                    onChanged: (value) => ref
                        .read(settingsProvider.notifier)
                        .setSoundEnabled(enabled: value),
                  ),
                  const Divider(height: 1),
                  ToggleSetting(
                    title: 'Music',
                    subtitle: 'Enable background music',
                    icon: Icons.music_note,
                    value: musicEnabled, // Use optimized value
                    onChanged: (value) => ref
                        .read(settingsProvider.notifier)
                        .setMusicEnabled(enabled: value),
                  ),
                  const Divider(height: 1),
                  ToggleSetting(
                    title: 'Vibration',
                    subtitle: 'Enable vibration feedback',
                    icon: Icons.vibration,
                    value: vibrationEnabled, // Use optimized value
                    onChanged: (value) => ref
                        .read(settingsProvider.notifier)
                        .setVibrationEnabled(enabled: value),
                  ),
                  const Divider(height: 1),
                  ToggleSetting(
                    title: 'Haptic Feedback',
                    subtitle: 'Enable haptic feedback on supported devices',
                    icon: Icons.touch_app,
                    value: hapticFeedbackEnabled, // Use optimized value
                    onChanged: (value) => ref
                        .read(settingsProvider.notifier)
                        .setHapticFeedbackEnabled(enabled: value),
                  ),
                ],
              ),

              // Appearance Section
              SettingsSection(
                title: 'Appearance',
                subtitle: "Customize the app's look and feel",
                children: [
                  ThemeSelector(
                    currentTheme: themeMode,
                    onThemeChanged: (themeMode) {
                      ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(themeMode);
                    },
                  ),
                ],
              ),

              // Data & Storage Section
              SettingsSection(
                title: 'Data & Storage',
                subtitle: 'Manage your app data and preferences',
                children: [
                  ToggleSetting(
                    title: 'Auto Save',
                    subtitle: 'Automatically save game progress',
                    icon: Icons.save,
                    value: autoSaveEnabled, // Use optimized value
                    onChanged: (value) => ref
                        .read(settingsProvider.notifier)
                        .setAutoSaveEnabled(enabled: value),
                  ),
                  const Divider(height: 1),
                  ToggleSetting(
                    title: 'Notifications',
                    subtitle: 'Show game notifications',
                    icon: Icons.notifications,
                    value: notificationsEnabled, // Use optimized value
                    onChanged: (value) => ref
                        .read(settingsProvider.notifier)
                        .setNotificationsEnabled(enabled: value),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      Icons.delete_forever,
                      color: colorScheme.error,
                    ),
                    title: Text(
                      'Clear All Data',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                    subtitle: Text(
                      'This will reset all settings and clear local data',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    onTap: () => _showClearDataDialog(context, ref),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SettingsSection(
                title: 'Performance',
                subtitle: 'Optimize app performance and battery usage',
                children: [
                  ListTile(
                    title: const Text('Performance Mode'),
                    subtitle: const Text(
                      'Optimize for performance or battery life',
                    ),
                    leading: Icon(Icons.speed, color: colorScheme.primary),
                    trailing: DropdownButton<PerformanceMode>(
                      value: performanceMode, // Use optimized value
                      onChanged: (PerformanceMode? newValue) {
                        if (newValue != null) {
                          ref
                              .read(settingsProvider.notifier)
                              .setPerformanceMode(newValue);
                        }
                      },
                      items: PerformanceMode.values
                          .map(
                            (PerformanceMode mode) =>
                                DropdownMenuItem<PerformanceMode>(
                                  value: mode,
                                  child: Text(mode.name),
                                ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const PerformanceMonitor(),
                ],
              ),

              // About Section
              const AboutSection(),

              // Reset to Defaults Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showResetDefaultsDialog(context, ref),
                    icon: const Icon(Icons.restore),
                    label: const Text('Reset to Defaults'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      side: BorderSide(color: colorScheme.primary),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows a dialog to confirm clearing all data
  void _showClearDataDialog(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: colorScheme.error),
            const SizedBox(width: 8),
            const Text('Clear All Data'),
          ],
        ),
        content: const Text(
          'This action will permanently delete all your app data including:\n\n'
          '• Game progress and statistics\n'
          '• Settings and preferences\n'
          '• Local game data\n\n'
          'This action cannot be undone. Are you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _clearAllData(ref);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data has been cleared'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: const Text('Clear All Data'),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog to confirm resetting to defaults
  void _showResetDefaultsDialog(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.settings_backup_restore, color: colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Reset to Defaults'),
          ],
        ),
        content: const Text(
          'This will reset all settings to their default values. '
          'Your game data will not be affected. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(settingsProvider.notifier).resetToDefaults();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings reset to defaults'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  /// Clears all app data
  void _clearAllData(WidgetRef ref) {
    // Reset settings to defaults
    ref.read(settingsProvider.notifier).resetToDefaults();

    // TODO(Clear other app data like game progress, statistics, etc.)
    // This would involve clearing shared preferences, local storage, etc.
  }
}
