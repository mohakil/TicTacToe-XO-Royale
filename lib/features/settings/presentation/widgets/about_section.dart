import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/shared/widgets/icons/icon_text.dart';

/// An about section widget for displaying app information
class AboutSection extends ConsumerStatefulWidget {
  const AboutSection({super.key});

  @override
  ConsumerState<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends ConsumerState<AboutSection> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _packageInfo = packageInfo;
      });
    } on Exception catch (e) {
      debugPrint('Failed to load package info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      label: 'About section with app information',
      child: Card(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconText(
                icon: Icons.info_outline,
                text: 'About',
                iconColor: colorScheme.primary,
                textStyle: context.getResponsiveTextStyle(
                  Theme.of(context).textTheme.titleLarge ?? const TextStyle(),
                  phoneSize: 20.0,
                  tabletSize: 22.0,
                ),
                size: IconTextSize.large,
                direction: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              SizedBox(
                height: context.getResponsiveSpacing(
                  phoneSpacing: 14.0,
                  tabletSpacing: 16.0,
                ),
              ),
              if (_packageInfo != null) ...[
                _InfoRow(label: 'App Name', value: _packageInfo!.appName),
                SizedBox(
                  height: context.getResponsiveSpacing(
                    phoneSpacing: 6.0,
                    tabletSpacing: 8.0,
                  ),
                ),
                _InfoRow(label: 'Version', value: _packageInfo!.version),
                SizedBox(
                  height: context.getResponsiveSpacing(
                    phoneSpacing: 6.0,
                    tabletSpacing: 8.0,
                  ),
                ),
                _InfoRow(
                  label: 'Build Number',
                  value: _packageInfo!.buildNumber,
                ),
                SizedBox(
                  height: context.getResponsiveSpacing(
                    phoneSpacing: 6.0,
                    tabletSpacing: 8.0,
                  ),
                ),
                _InfoRow(
                  label: 'Package Name',
                  value: _packageInfo!.packageName,
                ),
              ] else ...[
                const Center(child: CircularProgressIndicator()),
              ],
              SizedBox(
                height: context.getResponsiveSpacing(
                  phoneSpacing: 14.0,
                  tabletSpacing: 16.0,
                ),
              ),
              Text(
                'Tic Tac Toe XO Royale',
                style: context.getResponsiveTextStyle(
                  Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ) ??
                      const TextStyle(),
                  phoneSize: 16.0,
                  tabletSize: 18.0,
                ),
              ),
              SizedBox(
                height: context.getResponsiveSpacing(
                  phoneSpacing: 6.0,
                  tabletSpacing: 8.0,
                ),
              ),
              Text(
                'A modern, premium Tic Tac Toe game built with Flutter and Material 3. '
                'Features include beautiful animations, responsive design, and accessibility support.',
                style: context.getResponsiveTextStyle(
                  Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ) ??
                      const TextStyle(),
                  phoneSize: 14.0,
                  tabletSize: 16.0,
                ),
              ),
              SizedBox(
                height: context.getResponsiveSpacing(
                  phoneSpacing: 16.0,
                  tabletSpacing: 20.0,
                ),
              ),
              Text(
                'Developer',
                style: context.getResponsiveTextStyle(
                  Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ) ??
                      const TextStyle(),
                  phoneSize: 14.0,
                  tabletSize: 16.0,
                ),
              ),
              SizedBox(
                height: context.getResponsiveSpacing(
                  phoneSpacing: 6.0,
                  tabletSpacing: 8.0,
                ),
              ),
              _AuthorInfo(
                author: 'Mohammad Akil',
                telegram: '@i_am_akil',
                email: 'akilazmi1234@gmail.com',
              ),
              SizedBox(
                height: context.getResponsiveSpacing(
                  phoneSpacing: 14.0,
                  tabletSpacing: 16.0,
                ),
              ),
              Text(
                'Credits',
                style: context.getResponsiveTextStyle(
                  Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ) ??
                      const TextStyle(),
                  phoneSize: 14.0,
                  tabletSize: 16.0,
                ),
              ),
              SizedBox(
                height: context.getResponsiveSpacing(
                  phoneSpacing: 6.0,
                  tabletSpacing: 8.0,
                ),
              ),
              Text(
                '• Flutter & Material 3\n'
                '• CustomPainter for game board\n'
                '• Riverpod for state management\n'
                '• GoRouter for navigation\n'
                '• just_audio for audio\n'
                '• Custom fonts: Sora, Inter, JetBrains Mono',
                style: context.getResponsiveTextStyle(
                  Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ) ??
                      const TextStyle(),
                  phoneSize: 12.0,
                  tabletSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A helper widget for displaying info rows
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: context.scale(90.0),
          child: Text(
            label,
            style: context.getResponsiveTextStyle(
              Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ) ??
                  const TextStyle(),
              phoneSize: 14.0,
              tabletSize: 16.0,
            ),
          ),
        ),
        SizedBox(
          width: context.getResponsiveSpacing(
            phoneSpacing: 12.0,
            tabletSpacing: 16.0,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: context.getResponsiveTextStyle(
              Theme.of(context).textTheme.bodyMedium ?? const TextStyle(),
              phoneSize: 14.0,
              tabletSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }
}

/// A helper widget for displaying author information
class _AuthorInfo extends StatelessWidget {
  const _AuthorInfo({
    required this.author,
    required this.telegram,
    required this.email,
  });

  final String author;
  final String telegram;
  final String email;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconText(
          icon: Icons.person,
          text: author,
          iconColor: colorScheme.primary,
          textStyle: context.getResponsiveTextStyle(
            Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ) ??
                const TextStyle(),
            phoneSize: 16.0,
            tabletSize: 18.0,
          ),
          size: IconTextSize.small,
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        SizedBox(
          height: context.getResponsiveSpacing(
            phoneSpacing: 4.0,
            tabletSpacing: 6.0,
          ),
        ),
        IconText(
          icon: Icons.email,
          text: email,
          iconColor: colorScheme.outline,
          textStyle: context.getResponsiveTextStyle(
            Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ) ??
                const TextStyle(),
            phoneSize: 14.0,
            tabletSize: 16.0,
          ),
          size: IconTextSize.small,
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        SizedBox(
          height: context.getResponsiveSpacing(
            phoneSpacing: 2.0,
            tabletSpacing: 4.0,
          ),
        ),
        IconText(
          icon: Icons.send,
          text: telegram,
          iconColor: colorScheme.outline,
          textStyle: context.getResponsiveTextStyle(
            Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ) ??
                const TextStyle(),
            phoneSize: 14.0,
            tabletSize: 16.0,
          ),
          size: IconTextSize.small,
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      ],
    );
  }
}
