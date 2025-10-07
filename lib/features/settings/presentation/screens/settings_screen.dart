import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/providers/settings_provider.dart';
import 'package:tictactoe_xo_royale/core/providers/theme_provider.dart';
import 'package:tictactoe_xo_royale/core/services/navigation_service.dart';

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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          // Navigate back to home screen using navigation service
          NavigationService.goHome(context);
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: context.getResponsivePadding(
              phonePadding: 20.0,
              tabletPadding: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Settings Header
                Text(
                  'Settings',
                  style: context.getResponsiveTextStyle(
                    Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ) ??
                        const TextStyle(),
                    phoneSize: 28.0,
                    tabletSize: 32.0,
                  ),
                ),
                SizedBox(
                  height: context.getResponsiveSpacing(
                    phoneSpacing: 20.0,
                    tabletSpacing: 24.0,
                  ),
                ),

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

                // About Section
                const AboutSection(),

                // Reset to Defaults Button
                Padding(
                  padding: context.getResponsivePadding(
                    phonePadding: 12.0,
                    tabletPadding: 16.0,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showResetDefaultsDialog(context, ref),
                      icon: Icon(
                        Icons.restore,
                        size: context.getResponsiveIconSize(
                          phoneSize: 20.0,
                          tabletSize: 24.0,
                        ),
                      ),
                      label: Text(
                        'Reset to Defaults',
                        style: context.getResponsiveTextStyle(
                          Theme.of(context).textTheme.labelLarge ??
                              const TextStyle(),
                          phoneSize: 14.0,
                          tabletSize: 16.0,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                        side: BorderSide(color: colorScheme.primary),
                        padding: context.getResponsivePadding(
                          phonePadding: 16.0,
                          tabletPadding: 20.0,
                        ),
                        minimumSize: Size(
                          double.infinity,
                          context.getResponsiveButtonHeight(
                            phoneHeight: 48.0,
                            tabletHeight: 56.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: context.getResponsiveSpacing(
                    phoneSpacing: 24.0,
                    tabletSpacing: 32.0,
                  ),
                ),
              ],
            ),
          ),
        ),
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
            Icon(
              Icons.settings_backup_restore,
              color: colorScheme.primary,
              size: context.getResponsiveIconSize(
                phoneSize: 24.0,
                tabletSize: 28.0,
              ),
            ),
            SizedBox(
              width: context.getResponsiveSpacing(
                phoneSpacing: 8.0,
                tabletSpacing: 12.0,
              ),
            ),
            Text(
              'Reset to Defaults',
              style: context.getResponsiveTextStyle(
                Theme.of(context).textTheme.headlineSmall ?? const TextStyle(),
                phoneSize: 18.0,
                tabletSize: 20.0,
              ),
            ),
          ],
        ),
        content: Text(
          'This will reset all settings to their default values. '
          'Your game data will not be affected. Continue?',
          style: context.getResponsiveTextStyle(
            Theme.of(context).textTheme.bodyMedium ?? const TextStyle(),
            phoneSize: 14.0,
            tabletSize: 16.0,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: context.getResponsivePadding(
                phonePadding: 16.0,
                tabletPadding: 20.0,
              ),
            ),
            child: Text(
              'Cancel',
              style: context.getResponsiveTextStyle(
                Theme.of(context).textTheme.labelLarge ?? const TextStyle(),
                phoneSize: 14.0,
                tabletSize: 16.0,
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(settingsProvider.notifier).resetToDefaults();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Settings reset to defaults',
                    style: context.getResponsiveTextStyle(
                      Theme.of(context).textTheme.bodyMedium ??
                          const TextStyle(),
                      phoneSize: 14.0,
                      tabletSize: 16.0,
                    ),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: context.getResponsivePadding(
                phonePadding: 16.0,
                tabletPadding: 20.0,
              ),
              minimumSize: Size(
                context.scale(80.0),
                context.getResponsiveButtonHeight(
                  phoneHeight: 36.0,
                  tabletHeight: 40.0,
                ),
              ),
            ),
            child: Text(
              'Reset',
              style: context.getResponsiveTextStyle(
                Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimary,
                    ) ??
                    TextStyle(color: colorScheme.onPrimary),
                phoneSize: 14.0,
                tabletSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
