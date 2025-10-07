import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
// No longer needed - using standard Material Icons

/// Optimized exit confirmation overlay widget with performance improvements
class ExitConfirmationOverlay extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onExit;

  const ExitConfirmationOverlay({
    required this.onContinue,
    required this.onExit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        color: Colors.black.withValues(alpha: 0.7),
        child: Center(
          child: _ExitDialog(onContinue: onContinue, onExit: onExit),
        ),
      ),
    );
  }
}

/// Optimized exit dialog widget with RepaintBoundary
class _ExitDialog extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onExit;

  const _ExitDialog({required this.onContinue, required this.onExit});

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
            // Warning icon
            _WarningIcon(),

            SizedBox(
              height: context.getResponsiveSpacing(
                phoneSpacing: 20.0,
                tabletSpacing: 24.0,
              ),
            ),

            // Title
            _TitleText(),

            SizedBox(
              height: context.getResponsiveSpacing(
                phoneSpacing: 12.0,
                tabletSpacing: 16.0,
              ),
            ),

            // Message
            _MessageText(),

            SizedBox(
              height: context.getResponsiveSpacing(
                phoneSpacing: 24.0,
                tabletSpacing: 32.0,
              ),
            ),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Continue button
                Expanded(child: _ContinueButton(onContinue: onContinue)),

                SizedBox(
                  width: context.getResponsiveSpacing(
                    phoneSpacing: 12.0,
                    tabletSpacing: 16.0,
                  ),
                ),

                // Exit button
                Expanded(child: _ExitButton(onExit: onExit)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Optimized warning icon widget with RepaintBoundary
class _WarningIcon extends StatelessWidget {
  const _WarningIcon();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: Container(
        width: context.getResponsiveIconSize(phoneSize: 56.0, tabletSize: 64.0),
        height: context.getResponsiveIconSize(
          phoneSize: 56.0,
          tabletSize: 64.0,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(
            context.getResponsiveIconSize(phoneSize: 28.0, tabletSize: 32.0),
          ),
        ),
        child: Icon(
          Icons.warning,
          size: context.getResponsiveIconSize(
            phoneSize: 32.0,
            tabletSize: 36.0,
          ),
          color: theme.colorScheme.error,
        ),
      ),
    );
  }
}

/// Optimized title text widget with RepaintBoundary
class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: Text(
        'Quit current game?',
        style: context.getResponsiveTextStyle(
          theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Optimized message text widget with RepaintBoundary
class _MessageText extends StatelessWidget {
  const _MessageText();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: Text(
        'Your progress will be lost.',
        style: context.getResponsiveTextStyle(
          theme.textTheme.bodyMedium!.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Optimized continue button widget with RepaintBoundary
class _ContinueButton extends StatelessWidget {
  final VoidCallback onContinue;

  const _ContinueButton({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: ElevatedButton(
        onPressed: onContinue,
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
        child: const Text('Continue'),
      ),
    );
  }
}

/// Optimized exit button widget with RepaintBoundary
class _ExitButton extends StatelessWidget {
  final VoidCallback onExit;

  const _ExitButton({required this.onExit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: OutlinedButton(
        onPressed: onExit,
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.error,
          side: BorderSide(
            color: theme.colorScheme.error.withValues(alpha: 0.5),
          ),
          padding: EdgeInsets.symmetric(
            vertical: context.getResponsiveSpacing(
              phoneSpacing: 12.0,
              tabletSpacing: 16.0,
            ),
          ),
        ),
        child: const Text('Exit'),
      ),
    );
  }
}
