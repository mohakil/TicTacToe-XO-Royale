import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/providers/profile_provider.dart';

class ProfileHeader extends ConsumerStatefulWidget {
  const ProfileHeader({super.key});

  @override
  ConsumerState<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends ConsumerState<ProfileHeader> {
  // Class body starts here
  late TextEditingController _nicknameController;
  late FocusNode _nicknameFocusNode;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController();
    _nicknameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _nicknameFocusNode.dispose();
    super.dispose();
  }

  void _startEditing() {
    // Use Riverpod state instead of local state
    ref.read(profileProvider.notifier).setEditing(isEditing: true);
    _nicknameController.text = ref.read(profileNicknameProvider);
    Future.delayed(const Duration(milliseconds: 100), () {
      _nicknameFocusNode.requestFocus();
    });
  }

  Future<void> _saveNickname() async {
    final newNickname = _nicknameController.text.trim();
    if (newNickname.isNotEmpty &&
        newNickname != ref.read(profileNicknameProvider)) {
      await ref.read(profileProvider.notifier).updateNickname(newNickname);
    }
    // Use Riverpod state instead of local state
    ref.read(profileProvider.notifier).setEditing(isEditing: false);
    _nicknameFocusNode.unfocus();
  }

  void _cancelEditing() {
    // Use Riverpod state instead of local state
    ref.read(profileProvider.notifier).setEditing(isEditing: false);
    _nicknameFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final nickname = ref.watch(profileNicknameProvider);
    final avatar = ref.watch(profileAvatarProvider);
    final gems = ref.watch(profileGemsProvider);
    final hints = ref.watch(profileHintsProvider);
    final isEditing = ref.watch(profileIsEditingProvider);

    // Use app's standard responsive system
    final isVerySmallScreen = context.screenWidth < 380; // Extra small phones
    final isLargeTablet = context.isTablet && context.screenWidth > 800;

    // Detect high DPI screens for better scaling
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final isHighDPI = pixelRatio > 2.0; // Retina/high DPI displays

    // Adjust sizes for high DPI displays
    final densityMultiplier = isHighDPI ? 1.1 : 1.0;

    return Container(
      padding: context.getResponsivePadding(
        phonePadding: 16.0,
        tabletPadding: 24.0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surfaceContainer,
            Theme.of(context).colorScheme.surface,
          ],
        ),
        borderRadius: context.getResponsiveBorderRadius(
          phoneRadius: 20.0,
          tabletRadius: 24.0,
        ),
      ),
      child: Column(
        children: [
          // Avatar Section
          Center(
            child: Stack(
              children: [
                Container(
                  width: context.getResponsiveIconSize(
                    phoneSize:
                        (isVerySmallScreen ? 90.0 : 100.0) * densityMultiplier,
                    tabletSize:
                        (isLargeTablet ? 130.0 : 120.0) * densityMultiplier,
                  ),
                  height: context.getResponsiveIconSize(
                    phoneSize:
                        (isVerySmallScreen ? 90.0 : 100.0) * densityMultiplier,
                    tabletSize:
                        (isLargeTablet ? 130.0 : 120.0) * densityMultiplier,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: context.getResponsiveCardElevation(
                        phoneElevation: 3.0,
                        tabletElevation: 4.0,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: context.getResponsiveCardElevation(
                          phoneElevation: 16.0,
                          tabletElevation: 20.0,
                        ),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: context.getResponsiveIconSize(
                      phoneSize:
                          (isVerySmallScreen ? 40.0 : 45.0) * densityMultiplier,
                      tabletSize:
                          (isLargeTablet ? 61.0 : 56.0) * densityMultiplier,
                    ),
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainer,
                    backgroundImage: avatar != null
                        ? NetworkImage(avatar)
                        : null,
                    child: avatar == null
                        ? Icon(
                            Icons.person,
                            size: context.getResponsiveIconSize(
                              phoneSize:
                                  (isVerySmallScreen ? 45.0 : 50.0) *
                                  densityMultiplier,
                              tabletSize:
                                  (isLargeTablet ? 65.0 : 60.0) *
                                  densityMultiplier,
                            ),
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          )
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: context.getResponsivePadding(
                      phonePadding: 6.0,
                      tabletPadding: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        width: context.getResponsiveCardElevation(
                          phoneElevation: 2.0,
                          tabletElevation: 3.0,
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.edit,
                      size: context.getResponsiveIconSize(
                        phoneSize: isVerySmallScreen ? 14.0 : 16.0,
                        tabletSize: isLargeTablet ? 22.0 : 20.0,
                      ),
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: context.getResponsiveSpacing(
              phoneSpacing: isVerySmallScreen ? 16.0 : 20.0,
              tabletSpacing: isLargeTablet ? 28.0 : 24.0,
            ),
          ),

          // Nickname Section
          if (isEditing) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _nicknameController,
                    focusNode: _nicknameFocusNode,
                    textAlign: TextAlign.center,
                    style: context.getResponsiveTextStyle(
                      Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ) ??
                          const TextStyle(),
                      phoneSize: 24.0,
                      tabletSize: 28.0,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: context.getResponsiveBorderRadius(
                          phoneRadius: 10.0,
                          tabletRadius: 12.0,
                        ),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: context.getResponsiveBorderRadius(
                          phoneRadius: 10.0,
                          tabletRadius: 12.0,
                        ),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: context.getResponsivePadding(
                        phonePadding: 12.0,
                        tabletPadding: 16.0,
                      ),
                    ),
                    onSubmitted: (_) => _saveNickname(),
                  ),
                ),
                SizedBox(
                  width: context.getResponsiveSpacing(
                    phoneSpacing: 8.0,
                    tabletSpacing: 12.0,
                  ),
                ),
                IconButton(
                  onPressed: _saveNickname,
                  icon: Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.primary,
                    size: context.getResponsiveIconSize(
                      phoneSize: 20.0,
                      tabletSize: 24.0,
                    ),
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    minimumSize: Size(
                      context.getResponsiveButtonHeight(
                        phoneHeight: isVerySmallScreen ? 36.0 : 40.0,
                        tabletHeight: isLargeTablet ? 48.0 : 44.0,
                      ),
                      context.getResponsiveButtonHeight(
                        phoneHeight: isVerySmallScreen ? 36.0 : 40.0,
                        tabletHeight: isLargeTablet ? 48.0 : 44.0,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _cancelEditing,
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.error,
                    size: context.getResponsiveIconSize(
                      phoneSize: 20.0,
                      tabletSize: 24.0,
                    ),
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.errorContainer,
                    minimumSize: Size(
                      context.getResponsiveButtonHeight(
                        phoneHeight: isVerySmallScreen ? 36.0 : 40.0,
                        tabletHeight: isLargeTablet ? 48.0 : 44.0,
                      ),
                      context.getResponsiveButtonHeight(
                        phoneHeight: isVerySmallScreen ? 36.0 : 40.0,
                        tabletHeight: isLargeTablet ? 48.0 : 44.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  nickname,
                  style: context.getResponsiveTextStyle(
                    Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ) ??
                        const TextStyle(),
                    phoneSize: 24.0,
                    tabletSize: 28.0,
                  ),
                ),
                SizedBox(
                  width: context.getResponsiveSpacing(
                    phoneSpacing: 6.0,
                    tabletSpacing: 8.0,
                  ),
                ),
                IconButton(
                  onPressed: _startEditing,
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: context.getResponsiveIconSize(
                      phoneSize: 20.0,
                      tabletSize: 24.0,
                    ),
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainer,
                    minimumSize: Size(
                      context.getResponsiveButtonHeight(
                        phoneHeight: isVerySmallScreen ? 32.0 : 36.0,
                        tabletHeight: isLargeTablet ? 44.0 : 40.0,
                      ),
                      context.getResponsiveButtonHeight(
                        phoneHeight: isVerySmallScreen ? 32.0 : 36.0,
                        tabletHeight: isLargeTablet ? 44.0 : 40.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          SizedBox(
            height: context.getResponsiveSpacing(
              phoneSpacing: isVerySmallScreen ? 16.0 : 20.0,
              tabletSpacing: isLargeTablet ? 28.0 : 24.0,
            ),
          ),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatCard(
                icon: Icons.diamond,
                value: gems.toString(),
                label: 'Gems',
                color: Theme.of(context).colorScheme.tertiary,
              ),
              _StatCard(
                icon: Icons.lightbulb,
                value: hints.toString(),
                label: 'Hints',
                color: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
          SizedBox(
            height: context.getResponsiveSpacing(
              phoneSpacing: isVerySmallScreen
                  ? 16.0
                  : (context.isPhone ? 20.0 : 24.0),
              tabletSpacing: isLargeTablet ? 28.0 : 24.0,
            ),
          ),

          // Action Buttons
          if (context.isPhone) ...[
            Column(
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO(Implement login functionality)
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Login'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: isVerySmallScreen ? 8.0 : 12.0),
                FilledButton.icon(
                  onPressed: () {
                    // TODO(Implement link account functionality)
                  },
                  icon: const Icon(Icons.link),
                  label: const Text('Link Account'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO(Implement login functionality)
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('Login'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                  child: FilledButton.icon(
                    onPressed: () {
                      // TODO(Implement link account functionality)
                    },
                    icon: const Icon(Icons.link),
                    label: const Text('Link Account'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Use responsive system instead of parameter
    final padding = context.getResponsiveSpacing(
      phoneSpacing: 12.0,
      tabletSpacing: 16.0,
    );
    final iconSize = context.getResponsiveIconSize(
      phoneSize: 28.0,
      tabletSize: 32.0,
    );

    return Container(
      padding: EdgeInsets.all(padding),
      constraints: BoxConstraints(
        minWidth: context.scale(80.0),
        maxWidth: context.scale(120.0),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: iconSize),
          SizedBox(
            height: context.getResponsiveSpacing(
              phoneSpacing: 6.0,
              tabletSpacing: 8.0,
            ),
          ),
          Text(
            value,
            style: context.getResponsiveTextStyle(
              Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ) ??
                  const TextStyle(),
              phoneSize: 18.0,
              tabletSize: 20.0,
            ),
          ),
          Text(
            label,
            style: context.getResponsiveTextStyle(
              Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ) ??
                  const TextStyle(),
              phoneSize: 12.0,
              tabletSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
