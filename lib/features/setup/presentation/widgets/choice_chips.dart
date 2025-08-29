import 'package:flutter/material.dart';

class ChoiceChips<T> extends StatelessWidget {
  const ChoiceChips({
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
    super.key,
    this.label,
    this.isMultiSelect = false,
  });

  final List<ChoiceChipOption<T>> options;
  final T selectedOption;
  final ValueChanged<T> onOptionSelected;
  final String? label;
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

class ChoiceChipOption<T> {
  const ChoiceChipOption({
    required this.label,
    required this.value,
    this.description,
  });

  final String label;
  final T value;
  final String? description;
}
