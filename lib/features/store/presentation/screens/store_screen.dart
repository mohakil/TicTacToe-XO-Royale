import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/providers/store_provider.dart';
import 'package:tictactoe_xo_royale/features/store/presentation/widgets/store_grid.dart';
import 'package:tictactoe_xo_royale/features/store/presentation/widgets/store_tabs.dart';
import 'package:tictactoe_xo_royale/features/store/presentation/widgets/watch_ad_button.dart';
import 'package:tictactoe_xo_royale/shared/widgets/buttons/enhanced_button.dart';

class StoreScreen extends ConsumerStatefulWidget {
  const StoreScreen({super.key});

  @override
  ConsumerState<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen> {
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(storeIsLoadingProvider);
    final error = ref.watch(storeErrorProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go('/home');
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () =>
                ref.read(storeProvider.notifier).refreshStoreData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Compact Header
                  Padding(
                    padding: context.getResponsivePadding(
                      phonePadding: 20.0,
                      tabletPadding: 24.0,
                    ),
                    child: Row(
                      children: [
                        // Store Title
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Store',
                                style: context.getResponsiveTextStyle(
                                  theme.textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: colorScheme.onSurface,
                                      ) ??
                                      const TextStyle(),
                                  phoneSize: 28.0,
                                  tabletSize: 32.0,
                                ),
                              ),
                              SizedBox(
                                height: context.getResponsiveSpacing(
                                  phoneSpacing: 4.0,
                                  tabletSpacing: 6.0,
                                ),
                              ),
                              Text(
                                'Premium themes & customizations',
                                style: context.getResponsiveTextStyle(
                                  theme.textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ) ??
                                      const TextStyle(),
                                  phoneSize: 14.0,
                                  tabletSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Store Icon
                        Container(
                          padding: EdgeInsets.all(
                            context.getResponsiveSpacing(
                              phoneSpacing: 12.0,
                              tabletSpacing: 16.0,
                            ),
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.primary.withValues(alpha: 0.1),
                                colorScheme.secondary.withValues(alpha: 0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: context.getResponsiveBorderRadius(
                              phoneRadius: 16.0,
                              tabletRadius: 20.0,
                            ),
                          ),
                          child: Icon(
                            Icons.storefront,
                            size: context.getResponsiveIconSize(
                              phoneSize: 24.0,
                              tabletSize: 28.0,
                            ),
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Loading State
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.all(64.0),
                      child: Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Loading store items...'),
                          ],
                        ),
                      ),
                    )
                  else if (error != null)
                    Padding(
                      padding: context.getResponsivePadding(
                        phonePadding: 20.0,
                        tabletPadding: 24.0,
                      ),
                      child: Card(
                        elevation: context.getResponsiveCardElevation(
                          phoneElevation: 2.0,
                          tabletElevation: 4.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: context.getResponsiveBorderRadius(
                            phoneRadius: 16.0,
                            tabletRadius: 20.0,
                          ),
                        ),
                        child: Padding(
                          padding: context.getResponsivePadding(
                            phonePadding: 24.0,
                            tabletPadding: 32.0,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: context.getResponsiveIconSize(
                                  phoneSize: 56.0,
                                  tabletSize: 64.0,
                                ),
                                color: colorScheme.error,
                              ),
                              SizedBox(
                                height: context.getResponsiveSpacing(
                                  phoneSpacing: 16.0,
                                  tabletSpacing: 20.0,
                                ),
                              ),
                              Text(
                                'Something went wrong',
                                style: context.getResponsiveTextStyle(
                                  theme.textTheme.headlineSmall?.copyWith(
                                        color: colorScheme.error,
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
                                  theme.textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ) ??
                                      const TextStyle(),
                                  phoneSize: 14.0,
                                  tabletSize: 16.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: context.getResponsiveSpacing(
                                  phoneSpacing: 24.0,
                                  tabletSpacing: 32.0,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  EnhancedButton(
                                    text: 'Go Back',
                                    onPressed: () => context.go('/home'),
                                    variant: ButtonVariant.outline,
                                    size: ButtonSize.medium,
                                  ),
                                  EnhancedButton(
                                    text: 'Retry',
                                    onPressed: () => ref
                                        .read(storeProvider.notifier)
                                        .refreshStoreData(),
                                    variant: ButtonVariant.primary,
                                    size: ButtonSize.medium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    // Unified Store Content
                    _buildUnifiedStoreContent(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnifiedStoreContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gems Section - Compact
        Padding(
          padding: context.getResponsivePadding(
            phonePadding: 20.0,
            tabletPadding: 24.0,
          ),
          child: const WatchAdButton(),
        ),

        SizedBox(
          height: context.getResponsiveSpacing(
            phoneSpacing: 24.0,
            tabletSpacing: 32.0,
          ),
        ),

        // Category Pills - Single Line
        const StoreTabs(),

        SizedBox(
          height: context.getResponsiveSpacing(
            phoneSpacing: 20.0,
            tabletSpacing: 24.0,
          ),
        ),

        // Store Grid
        const StoreGrid(),
      ],
    );
  }
}
