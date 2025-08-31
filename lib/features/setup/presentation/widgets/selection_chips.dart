import 'package:flutter/material.dart';

class SelectionChips<T> extends StatelessWidget {
  const SelectionChips({
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
    super.key,
    this.label,
    this.subText,
    this.isMultiSelect = false,
  });

  final List<SelectionChipOption<T>> options;
  final T selectedOption;
  final ValueChanged<T> onOptionSelected;
  final String? label;
  final String? subText;
  final bool isMultiSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          if (subText != null) ...[
            const SizedBox(height: 8),
            Text(
              subText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 12),
        ],
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = option.value == selectedOption;
            return FilterChip(
              label: Text(option.label),
              selected: isSelected,
              onSelected: (_) => onOptionSelected(option.value),
              backgroundColor: colorScheme.surfaceContainer,
              selectedColor: colorScheme.primaryContainer,
              checkmarkColor: colorScheme.onPrimaryContainer,
              labelStyle: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurface,
              ),
              side: BorderSide(
                color: isSelected ? colorScheme.primary : colorScheme.outline,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class SelectionChipOption<T> {
  const SelectionChipOption({
    required this.label,
    required this.value,
    this.description,
  });

  final String label;
  final T value;
  final String? description;
}
