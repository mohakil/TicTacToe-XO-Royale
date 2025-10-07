import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/providers/services_provider.dart';
import 'package:tictactoe_xo_royale/core/providers/store_provider.dart';
import 'package:tictactoe_xo_royale/features/store/presentation/widgets/store_grid.dart';
import 'package:tictactoe_xo_royale/features/store/presentation/widgets/store_tabs.dart';
import 'package:tictactoe_xo_royale/features/store/presentation/widgets/watch_ad_button.dart';

class StoreScreen extends ConsumerStatefulWidget {
  const StoreScreen({super.key});

  @override
  ConsumerState<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Controller listener for tab changes (user swipe/click)
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(storeProvider.notifier).selectTab(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(storeIsLoadingProvider);
    final error = ref.watch(storeErrorProvider);
    final brightness = Theme.of(context).brightness;

    // Listen for provider changes and sync controller
    ref.listen(storeTabIndexProvider, (previous, next) {
      if (next != _tabController.index) {
        _tabController.animateTo(next);
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go('/home');
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          backgroundColor: brightness == Brightness.light
              ? Theme.of(context).colorScheme.surface
              : Colors.transparent,
          elevation: 0,
          title: Text(
            'Store',
            style: context.getResponsiveTextStyle(
              Theme.of(context).textTheme.headlineSmall ?? const TextStyle(),
              phoneSize: 20.0,
              tabletSize: 24.0,
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2.0,
                ),
              ),
            ),
            labelStyle: Theme.of(context).textTheme.labelLarge,
            tabs: const [
              Tab(text: 'Gems'),
              Tab(text: 'Cosmetics'),
            ],
            onTap: (index) {
              final currentTab = ref.read(storeTabIndexProvider);
              if (index != currentTab) {
                ref.read(hapticServiceProvider).lightImpact();
              }
            },
          ),
        ),
        body: Stack(
          children: [
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (error != null)
              Center(
                child: Card(
                  margin: context.getResponsivePadding(
                    phonePadding: 8.0,
                    tabletPadding: 16.0,
                  ),
                  elevation: context.getResponsiveCardElevation(
                    phoneElevation: 1.0,
                    tabletElevation: 2.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: context.getResponsiveBorderRadius(
                      phoneRadius: 14.0,
                      tabletRadius: 16.0,
                    ),
                  ),
                  child: Padding(
                    padding: context.getResponsivePadding(
                      phonePadding: 16.0,
                      tabletPadding: 24.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Semantics(
                          label: 'Error loading store items',
                          child: Icon(
                            Icons.error_outline,
                            size: context.getResponsiveIconSize(
                              phoneSize: 56.0,
                              tabletSize: 64.0,
                            ),
                            color: Theme.of(context).colorScheme.error,
                          ),
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
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
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
                              onPressed: () => context.go('/home'),
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
                                  Theme.of(context).textTheme.labelLarge ??
                                      const TextStyle(),
                                  phoneSize: 14.0,
                                  tabletSize: 16.0,
                                ),
                              ),
                            ),
                            FilledButton(
                              onPressed: () => ref
                                  .read(storeProvider.notifier)
                                  .refreshStoreData(),
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
                                  Theme.of(context).textTheme.labelLarge ??
                                      const TextStyle(),
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
                ),
              )
            else
              SafeArea(
                child: RefreshIndicator(
                  onRefresh: () =>
                      ref.read(storeProvider.notifier).refreshStoreData(),
                  child: RepaintBoundary(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Gems Tab
                        Column(
                          children: [
                            Padding(
                              padding: context.getResponsivePadding(
                                phonePadding: 16.0,
                                tabletPadding: 20.0,
                              ),
                              child: const WatchAdButton(),
                            ),
                            Expanded(
                              child: CustomScrollView(
                                slivers: [
                                  SliverPadding(
                                    padding: context.getResponsivePadding(
                                      phonePadding: 12.0,
                                      tabletPadding: 16.0,
                                    ),
                                    sliver: StoreGrid(useSliver: true),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Cosmetics Tab
                        Column(
                          children: [
                            Padding(
                              padding: context.getResponsivePadding(
                                phonePadding: 16.0,
                                tabletPadding: 20.0,
                              ),
                              child: const StoreTabs(),
                            ),
                            Expanded(
                              child: CustomScrollView(
                                slivers: [
                                  SliverPadding(
                                    padding: context.getResponsivePadding(
                                      phonePadding: 12.0,
                                      tabletPadding: 16.0,
                                    ),
                                    sliver: StoreGrid(useSliver: true),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
