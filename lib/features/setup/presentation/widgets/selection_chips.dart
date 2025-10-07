import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';

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
            style: context.getResponsiveTextStyle(
              theme.textTheme.titleMedium!.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          if (subText != null) ...[
            SizedBox(
              height: context.getResponsiveSpacing(
                phoneSpacing: 8.0,
                tabletSpacing: 8.0,
              ),
            ),
            Text(
              subText!,
              style: context.getResponsiveTextStyle(
                theme.textTheme.bodySmall!.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
          SizedBox(
            height: context.getResponsiveSpacing(
              phoneSpacing: 12.0,
              tabletSpacing: 12.0,
            ),
          ),
        ],
        Wrap(
          spacing: context.getResponsiveChipSpacing(
            phoneSpacing: 8.0,
            tabletSpacing: 8.0,
          ),
          runSpacing: context.getResponsiveChipSpacing(
            phoneSpacing: 8.0,
            tabletSpacing: 8.0,
          ),
          children: options.map((option) {
            final isSelected = option.value == selectedOption;
            return FilterChip(
              label: Text(option.label),
              selected: isSelected,
              onSelected: (_) => onOptionSelected(option.value),
              backgroundColor: colorScheme.surfaceContainer,
              selectedColor: colorScheme.primaryContainer,
              checkmarkColor: colorScheme.onPrimaryContainer,
              labelStyle: context.getResponsiveTextStyle(
                theme.textTheme.bodyMedium!.copyWith(
                  color: isSelected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurface,
                ),
              ),
              side: BorderSide(
                color: isSelected ? colorScheme.primary : colorScheme.outline,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: context.getResponsiveSpacing(
                  phoneSpacing: 16.0,
                  tabletSpacing: 16.0,
                ),
                vertical: context.getResponsiveSpacing(
                  phoneSpacing: 8.0,
                  tabletSpacing: 8.0,
                ),
              ),
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
