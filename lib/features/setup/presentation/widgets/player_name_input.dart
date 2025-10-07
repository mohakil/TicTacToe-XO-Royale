import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';

class PlayerNameInput extends StatefulWidget {
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
  State<PlayerNameInput> createState() => _PlayerNameInputState();
}

class _PlayerNameInputState extends State<PlayerNameInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant PlayerNameInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      controller: _controller,
      onChanged: widget.onChanged,
      maxLength: widget.maxLength,
      enabled: widget.enabled,
      textCapitalization: widget.autoCapitalize
          ? TextCapitalization.words
          : TextCapitalization.none,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        labelStyle: context.getResponsiveTextStyle(
          theme.textTheme.bodyLarge!.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        hintStyle: context.getResponsiveTextStyle(
          theme.textTheme.bodyLarge!.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
        ),
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
        fillColor: widget.enabled
            ? colorScheme.surfaceContainer
            : colorScheme.surfaceDim,
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.getResponsiveSpacing(
            phoneSpacing: 16.0,
            tabletSpacing: 16.0,
          ),
          vertical: context.getResponsiveSpacing(
            phoneSpacing: 12.0,
            tabletSpacing: 16.0,
          ),
        ),
      ),
      style: theme.textTheme.bodyLarge?.copyWith(
        color: widget.enabled
            ? colorScheme.onSurface
            : colorScheme.onSurface.withValues(alpha: 0.38),
      ),
    );
  }
}
