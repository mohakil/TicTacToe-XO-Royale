import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/providers/profile_provider.dart';
import 'package:tictactoe_xo_royale/core/services/navigation_service.dart';
import 'package:tictactoe_xo_royale/features/achievements/achievements.dart';
import 'package:tictactoe_xo_royale/features/profile/presentation/widgets/history_list.dart';
import 'package:tictactoe_xo_royale/features/profile/presentation/widgets/profile_header.dart';
import 'package:tictactoe_xo_royale/features/profile/presentation/widgets/stats_section.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ OPTIMIZED: Use select for granular rebuilds - only rebuild when specific values change
    final isLoading = ref.watch(profileIsLoadingProvider);
    final error = ref.watch(profileErrorProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          // Navigate back to home screen using navigation service
          NavigationService.goHome(context);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: isLoading
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading profile...'),
                    ],
                  ),
                )
              : error != null
              ? _buildErrorState(context, ref, error)
              : _buildProfileContent(context, ref),
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    WidgetRef ref,
    String error,
  ) => Center(
    child: Padding(
      padding: context.getResponsivePadding(
        phonePadding: 20.0,
        tabletPadding: 24.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: context.getResponsiveIconSize(
              phoneSize: 56.0,
              tabletSize: 64.0,
            ),
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(
            height: context.getResponsiveSpacing(
              phoneSpacing: 16.0,
              tabletSpacing: 20.0,
            ),
          ),
          Text(
            'Failed to load profile',
            style: context.getResponsiveTextStyle(
              Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ) ??
                  const TextStyle(),
              phoneSize: 18.0,
              tabletSize: 20.0,
            ),
          ),
          SizedBox(
            height: context.getResponsiveSpacing(
              phoneSpacing: 8.0,
              tabletSpacing: 12.0,
            ),
          ),
          Text(
            error,
            style: context.getResponsiveTextStyle(
              Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ) ??
                  const TextStyle(),
              phoneSize: 14.0,
              tabletSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: context.getResponsiveSpacing(
              phoneSpacing: 20.0,
              tabletSpacing: 24.0,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () =>
                    ref.read(profileProvider.notifier).clearError(),
                style: OutlinedButton.styleFrom(
                  padding: context.getResponsivePadding(
                    phonePadding: 12.0,
                    tabletPadding: 16.0,
                  ),
                  minimumSize: Size(
                    context.scale(80.0),
                    context.getResponsiveButtonHeight(
                      phoneHeight: 36.0,
                      tabletHeight: 40.0,
                    ),
                  ),
                ),
                child: Text(
                  'Dismiss',
                  style: context.getResponsiveTextStyle(
                    Theme.of(context).textTheme.labelLarge ?? const TextStyle(),
                    phoneSize: 14.0,
                    tabletSize: 16.0,
                  ),
                ),
              ),
              FilledButton(
                onPressed: () =>
                    ref.read(profileProvider.notifier).refreshProfile(),
                style: FilledButton.styleFrom(
                  padding: context.getResponsivePadding(
                    phonePadding: 12.0,
                    tabletPadding: 16.0,
                  ),
                  minimumSize: Size(
                    context.scale(80.0),
                    context.getResponsiveButtonHeight(
                      phoneHeight: 36.0,
                      tabletHeight: 40.0,
                    ),
                  ),
                ),
                child: Text(
                  'Retry',
                  style: context.getResponsiveTextStyle(
                    Theme.of(context).textTheme.labelLarge ?? const TextStyle(),
                    phoneSize: 14.0,
                    tabletSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ],
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
