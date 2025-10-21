import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/providers/profile_provider.dart';
import 'package:tictactoe_xo_royale/shared/widgets/icons/icon_avatar.dart';
import 'package:tictactoe_xo_royale/shared/widgets/icons/icon_text.dart';

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
                IconAvatar(
                  icon: Icons.person,
                  size: isVerySmallScreen
                      ? AvatarSize.large
                      : AvatarSize.extraLarge,
                  customSize: context.getResponsiveIconSize(
                    phoneSize:
                        (isVerySmallScreen ? 90.0 : 100.0) * densityMultiplier,
                    tabletSize:
                        (isLargeTablet ? 130.0 : 120.0) * densityMultiplier,
                  ),
                  backgroundColor: avatar != null
                      ? null
                      : Theme.of(context).colorScheme.surfaceContainer,
                  borderColor: Theme.of(context).colorScheme.primary,
                  borderWidth: context.getResponsiveCardElevation(
                    phoneElevation: 3.0,
                    tabletElevation: 4.0,
                  ),
                  useResponsiveSizing: false, // Using custom sizing
                ),
                if (avatar != null)
                  Container(
                    width: context.getResponsiveIconSize(
                      phoneSize:
                          (isVerySmallScreen ? 90.0 : 100.0) *
                          densityMultiplier,
                      tabletSize:
                          (isLargeTablet ? 130.0 : 120.0) * densityMultiplier,
                    ),
                    height: context.getResponsiveIconSize(
                      phoneSize:
                          (isVerySmallScreen ? 90.0 : 100.0) *
                          densityMultiplier,
                      tabletSize:
                          (isLargeTablet ? 130.0 : 120.0) * densityMultiplier,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(avatar),
                        fit: BoxFit.cover,
                      ),
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
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconText(
                    icon: Icons.diamond,
                    text: gems.toString(),
                    iconColor: Theme.of(context).colorScheme.tertiary,
                    textStyle: context.getResponsiveTextStyle(
                      Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.tertiary,
                          ) ??
                          const TextStyle(),
                      phoneSize: 18.0,
                      tabletSize: 20.0,
                    ),
                    size: IconTextSize.medium,
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  SizedBox(
                    height: context.getResponsiveSpacing(
                      phoneSpacing: 4.0,
                      tabletSpacing: 6.0,
                    ),
                  ),
                  Text(
                    'Gems',
                    style: context.getResponsiveTextStyle(
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ) ??
                          const TextStyle(),
                      phoneSize: 12.0,
                      tabletSize: 14.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: context.getResponsiveSpacing(
                  phoneSpacing: 20.0,
                  tabletSpacing: 24.0,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconText(
                    icon: Icons.lightbulb,
                    text: hints.toString(),
                    iconColor: Theme.of(context).colorScheme.secondary,
                    textStyle: context.getResponsiveTextStyle(
                      Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.secondary,
                          ) ??
                          const TextStyle(),
                      phoneSize: 18.0,
                      tabletSize: 20.0,
                    ),
                    size: IconTextSize.medium,
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  SizedBox(
                    height: context.getResponsiveSpacing(
                      phoneSpacing: 4.0,
                      tabletSpacing: 6.0,
                    ),
                  ),
                  Text(
                    'Hints',
                    style: context.getResponsiveTextStyle(
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ) ??
                          const TextStyle(),
                      phoneSize: 12.0,
                      tabletSize: 14.0,
                    ),
                  ),
                ],
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
