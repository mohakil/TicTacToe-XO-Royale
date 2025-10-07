# Font Assets

This directory contains font files for TicTacToe: XO Royale.

## Font Family Setup

The app uses three primary font families integrated through Google Fonts:

### 1. Sora (Primary UI Font)
- **Usage:** Headings, titles, prominent UI text
- **Characteristics:** Modern, geometric, high readability
- **File:** `Sora-VariableFont_wght.ttf`
- **Weight Range:** 100-800

### 2. Inter (Body Text Font) 
- **Usage:** Body text, descriptions, secondary UI text
- **Characteristics:** Optimized for screen reading, excellent legibility
- **File:** `Inter-VariableFont_opsz,wght.ttf`
- **Weight Range:** 100-900
- **Optical Size Range:** 14-32px

### 3. JetBrains Mono (Monospace Font)
- **Usage:** Code snippets, technical text, debugging info
- **Characteristics:** Developer-friendly monospace, clear character distinction
- **File:** `JetBrainsMono-VariableFont_wght.ttf`
- **Weight Range:** 100-800

## Integration

Fonts are configured in `pubspec.yaml` and integrated through:
- `GoogleFonts` package for dynamic loading
- Local fallback files in this directory
- Theme system in `lib/app/theme/typography.dart`

## Download Instructions

To add the actual font files:

1. **Sora:** Download from [Google Fonts](https://fonts.google.com/specimen/Sora)
2. **Inter:** Download from [Google Fonts](https://fonts.google.com/specimen/Inter)  
3. **JetBrains Mono:** Download from [JetBrains](https://www.jetbrains.com/lp/mono/) or [Google Fonts](https://fonts.google.com/specimen/JetBrains+Mono)

Place the variable font files in this directory and ensure the filenames match the `pubspec.yaml` configuration.

## Guidelines

- Use variable fonts for better performance and flexibility
- Test fonts across different screen densities
- Ensure proper licensing for distribution
- Consider accessibility and readability standards