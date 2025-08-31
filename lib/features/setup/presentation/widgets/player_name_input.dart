import 'package:flutter/material.dart';

class PlayerNameInput extends StatelessWidget {
  const PlayerNameInput({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
    this.maxLength = 12,
    this.autoCapitalize = true,
    this.enabled = true,
    this.hintText,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final int maxLength;
  final bool autoCapitalize;
  final bool enabled;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      maxLength: maxLength,
      enabled: enabled,
      textCapitalization: autoCapitalize
          ? TextCapitalization.words
          : TextCapitalization.none,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        counterText: '', // Hide character counter
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.38),
          ),
        ),
        filled: true,
        fillColor: enabled
            ? colorScheme.surfaceContainer
            : colorScheme.surfaceDim,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      style: theme.textTheme.bodyLarge?.copyWith(
        color: enabled
            ? colorScheme.onSurface
            : colorScheme.onSurface.withValues(alpha: 0.38),
      ),
    );
  }
}
