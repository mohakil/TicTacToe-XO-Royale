import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/providers/profile_provider.dart';
import 'package:tictactoe_xo_royale/features/profile/presentation/widgets/achievements_grid.dart';
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

    return Scaffold(
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
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String error) =>
      Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load profile',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () =>
                        ref.read(profileProvider.notifier).clearError(),
                    child: const Text('Dismiss'),
                  ),
                  FilledButton(
                    onPressed: () =>
                        ref.read(profileProvider.notifier).refreshProfile(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildProfileContent(BuildContext context, WidgetRef ref) =>
      LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 400;
          final horizontalPadding = isSmallScreen ? 16.0 : 24.0;
          final verticalSpacing = isSmallScreen ? 20.0 : 24.0;

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(profileProvider.notifier).refreshProfile(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  Text(
                    'Profile',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: isSmallScreen ? 28 : null,
                    ),
                  ),
                  SizedBox(height: verticalSpacing),

                  // Profile Header Widget
                  const ProfileHeader(),

                  SizedBox(height: verticalSpacing),

                  // Stats Section
                  const StatsSection(),

                  SizedBox(height: verticalSpacing),

                  // History List
                  const HistoryList(),

                  SizedBox(height: verticalSpacing),

                  // Achievements Grid
                  const AchievementsGrid(),

                  // Bottom Spacing
                  SizedBox(height: verticalSpacing),
                ],
              ),
            ),
          );
        },
      );
}
