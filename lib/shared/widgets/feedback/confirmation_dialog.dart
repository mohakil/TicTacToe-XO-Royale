import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';

/// A reusable confirmation dialog widget for consistent dialog patterns.
///
/// Provides standardized confirmation dialogs with responsive design,
/// proper icon styling, and consistent button layouts.
///
/// **Usage:**
/// ```dart
/// ConfirmationDialog(
///   title: 'Exit Game',
///   content: 'Are you sure you want to exit?',
///   icon: Icons.exit_to_app,
///   onConfirm: () => Navigator.of(context).pop(true),
///   onCancel: () => Navigator.of(context).pop(false),
/// )
/// ```
class ConfirmationDialog extends StatelessWidget {
  /// The title text for the dialog.
  final String title;

  /// The content text for the dialog.
  final String content;

  /// The icon to display in the dialog title.
  final IconData icon;

  /// The text for the confirm button.
  final String confirmText;

  /// The text for the cancel button.
  final String cancelText;

  /// Callback when the confirm button is pressed.
  final VoidCallback? onConfirm;

  /// Callback when the cancel button is pressed.
  final VoidCallback? onCancel;

  /// Whether the dialog can be dismissed by tapping outside.
  final bool barrierDismissible;

  /// Custom color for the icon and confirm button.
  final Color? accentColor;

  /// Custom color for the confirm button text.
  final Color? confirmTextColor;

  /// Whether to show the icon in the title.
  final bool showIcon;

  /// Custom padding for the dialog content.
  final EdgeInsetsGeometry? contentPadding;

  /// Whether the dialog should automatically pop when buttons are pressed.
  /// If false, the calling code is responsible for handling navigation.
  final bool autoPop;

  const ConfirmationDialog({
    required this.title,
    required this.content,
    required this.icon,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.barrierDismissible = true,
    this.accentColor,
    this.confirmTextColor,
    this.showIcon = true,
    this.contentPadding,
    this.autoPop = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dialogAccentColor = accentColor ?? colorScheme.primary;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.scale(14.0)),
      ),
      title: showIcon
          ? Row(
              children: [
                Icon(icon, color: dialogAccentColor, size: context.scale(24.0)),
                SizedBox(width: context.scale(8.0)),
                Expanded(
                  child: Text(
                    title,
                    style:
                        (theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ) ??
                                const TextStyle())
                            .copyWith(fontSize: context.scale(20.0)),
                  ),
                ),
              ],
            )
          : Text(
              title,
              style:
                  (theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ) ??
                          const TextStyle())
                      .copyWith(fontSize: context.scale(20.0)),
            ),
      content: Padding(
        padding: contentPadding ?? EdgeInsets.zero,
        child: Text(
          content,
          style:
              (theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ) ??
                      const TextStyle())
                  .copyWith(fontSize: context.scale(14.0)),
        ),
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () {
            if (autoPop) {
              Navigator.of(context).pop();
            }
            onCancel?.call();
          },
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.onSurfaceVariant,
            padding: EdgeInsets.symmetric(
              horizontal: context.scale(16.0),
              vertical: context.scale(12.0),
            ),
          ),
          child: Text(
            cancelText,
            style:
                (theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ) ??
                        const TextStyle())
                    .copyWith(fontSize: context.scale(14.0)),
          ),
        ),

        // Confirm button
        FilledButton(
          onPressed: () {
            if (autoPop) {
              Navigator.of(context).pop();
            }
            onConfirm?.call();
          },
          style: FilledButton.styleFrom(
            backgroundColor: dialogAccentColor,
            foregroundColor: confirmTextColor ?? colorScheme.onPrimary,
            padding: EdgeInsets.symmetric(
              horizontal: context.scale(16.0),
              vertical: context.scale(12.0),
            ),
          ),
          child: Text(
            confirmText,
            style:
                (theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: confirmTextColor ?? colorScheme.onPrimary,
                        ) ??
                        TextStyle(
                          color: confirmTextColor ?? colorScheme.onPrimary,
                        ))
                    .copyWith(fontSize: context.scale(14.0)),
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.end,
    );
  }

  /// Show the confirmation dialog.
  ///
  /// Returns a Future that resolves to true if confirmed, false if cancelled.
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? accentColor,
    Color? confirmTextColor,
    bool barrierDismissible = true,
    bool autoPop = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => ConfirmationDialog(
        title: title,
        content: content,
        icon: icon,
        confirmText: confirmText,
        cancelText: cancelText,
        accentColor: accentColor,
        confirmTextColor: confirmTextColor,
        barrierDismissible: barrierDismissible,
        autoPop: autoPop,
        onConfirm: autoPop ? () => Navigator.of(context).pop(true) : null,
        onCancel: autoPop ? () => Navigator.of(context).pop(false) : null,
      ),
    );
  }
}
