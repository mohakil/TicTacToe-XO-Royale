import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/providers/profile_provider.dart';
import 'package:tictactoe_xo_royale/features/achievements/achievements.dart';
import 'package:tictactoe_xo_royale/core/providers/achievements_provider.dart';
import 'package:tictactoe_xo_royale/features/profile/presentation/widgets/history_list.dart';
import 'package:tictactoe_xo_royale/features/profile/presentation/widgets/profile_header.dart';
import 'package:tictactoe_xo_royale/features/profile/presentation/widgets/stats_section.dart';
import 'package:tictactoe_xo_royale/shared/widgets/feedback/state_display.dart';
import 'package:tictactoe_xo_royale/shared/widgets/buttons/enhanced_button.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _scheduleAutoReload();
  }

  // Schedule auto reload outside widget lifecycle to avoid provider modification errors
  void _scheduleAutoReload() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isInitialized) {
        _isInitialized = true;
        // Delay the auto reload to ensure it happens after widget tree is fully built
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _executeAutoReload();
          }
        });
      }
    });
  }

  // Execute automatic reload for both profile and achievements
  Future<void> _executeAutoReload() async {
    try {
      debugPrint('Auto refreshing profile and achievements data...');

      // Refresh profile data
      await ref.read(profileProvider.notifier).refreshProfile();

      // Small delay between operations to avoid overwhelming the system
      await Future.delayed(const Duration(milliseconds: 50));

      // Refresh achievements data
      await ref.read(achievementsProvider.notifier).refreshAchievements();

      debugPrint('Profile and achievements data reloaded successfully');
    } catch (e) {
      debugPrint('Auto reload failed: $e');
      // Continue even if reload fails - don't block user experience
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ OPTIMIZED: Use select for granular rebuilds - only rebuild when specific values change
    final isLoading = ref.watch(profileIsLoadingProvider);
    final error = ref.watch(profileErrorProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (isLoading) {
              return const Center(
                child: StateDisplay(
                  state: DisplayState.loading,
                  title: 'Loading profile',
                  subtitle: 'Please wait while we load your profile data',
                  icon: Icons.person,
                ),
              );
            }
            if (error != null) {
              return _buildErrorState(context, ref, error);
            }
            return _buildProfileContent(context, ref);
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String error) =>
      Center(
        child: Padding(
          padding: context.getResponsivePadding(
            phonePadding: 20.0,
            tabletPadding: 24.0,
          ),
          child: StateDisplay(
            state: DisplayState.error,
            title: 'Failed to load profile',
            subtitle: error,
            icon: Icons.error_outline,
            action: EnhancedButton(
              text: 'Retry',
              onPressed: () =>
                  ref.read(profileProvider.notifier).refreshProfile(),
              variant: ButtonVariant.primary,
              size: ButtonSize.medium,
              icon: Icons.refresh,
            ),
          ),
        ),
      );

  Widget _buildProfileContent(BuildContext context, WidgetRef ref) =>
      RefreshIndicator(
        onRefresh: () => ref.read(profileProvider.notifier).refreshProfile(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: context.getResponsivePadding(
            phonePadding: 16.0,
            tabletPadding: 24.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Text(
                'Profile',
                style: context.getResponsiveTextStyle(
                  Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ) ??
                      const TextStyle(),
                  phoneSize: 28.0,
                  tabletSize: 32.0,
                ),
              ),
              SizedBox(
                height: context.getResponsiveSpacing(
                  phoneSpacing: 16.0,
                  tabletSpacing: 20.0,
                ),
              ),

              // Profile Header Widget
              const ProfileHeader(),

              SizedBox(
                height: context.getResponsiveSpacing(
                  phoneSpacing: 16.0,
                  tabletSpacing: 20.0,
                ),
              ),

              // Stats Section
              const StatsSection(),

              SizedBox(
                height: context.getResponsiveSpacing(
                  phoneSpacing: 16.0,
                  tabletSpacing: 20.0,
                ),
              ),

              // History List
              const HistoryList(),

              SizedBox(
                height: context.getResponsiveSpacing(
                  phoneSpacing: 16.0,
                  tabletSpacing: 20.0,
                ),
              ),

              // Achievements Preview Card
              const AchievementPreviewCard(),

              // Bottom Spacing
              SizedBox(
                height: context.getResponsiveSpacing(
                  phoneSpacing: 16.0,
                  tabletSpacing: 20.0,
                ),
              ),
            ],
          ),
        ),
      );
}
