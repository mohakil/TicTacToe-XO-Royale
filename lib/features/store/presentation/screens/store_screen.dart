import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/providers/store_provider.dart';
import 'package:tictactoe_xo_royale/features/store/presentation/widgets/gem_balance.dart';
import 'package:tictactoe_xo_royale/features/store/presentation/widgets/store_grid.dart';
import 'package:tictactoe_xo_royale/features/store/presentation/widgets/store_tabs.dart';
import 'package:tictactoe_xo_royale/features/store/presentation/widgets/watch_ad_button.dart';

class StoreScreen extends ConsumerWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(storeIsLoadingProvider);
    final error = ref.watch(storeErrorProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
            ? _buildErrorState(context, ref, error)
            : _buildStoreContent(context, ref),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String error) =>
      Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
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
                'Something went wrong',
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
                        ref.read(storeProvider.notifier).clearError(),
                    child: const Text('Dismiss'),
                  ),
                  FilledButton(
                    onPressed: () =>
                        ref.read(storeProvider.notifier).refreshStoreData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildStoreContent(BuildContext context, WidgetRef ref) =>
      RefreshIndicator(
        onRefresh: () => ref.read(storeProvider.notifier).refreshStoreData(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Store Header
              Text(
                'Store',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 24),

              // Gem Balance
              const GemBalance(),

              // Watch Ad Button
              const WatchAdButton(),

              // Store Tabs
              const StoreTabs(),

              // Store Grid
              const StoreGrid(),

              // Bottom Spacing
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
}
