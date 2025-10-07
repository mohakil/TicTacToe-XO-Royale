import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/services/animation_pool.dart';
import 'package:tictactoe_xo_royale/core/services/navigation_service.dart';
import 'package:tictactoe_xo_royale/features/home/presentation/widgets/ambient_particles.dart';
import 'package:tictactoe_xo_royale/features/home/presentation/widgets/game_mode_cards.dart';
import 'package:tictactoe_xo_royale/features/home/presentation/widgets/quick_stats_ribbon.dart';
import 'package:tictactoe_xo_royale/features/home/presentation/widgets/typewriter_text.dart';
import 'package:tictactoe_xo_royale/features/home/providers/home_provider.dart';

/// Home screen with hero section, CTA cards, stats ribbon, and ambient effects
/// Implements the design specified in the PRD with responsive layout and accessibility
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _heroAnimationController;
  late Animation<double> _heroFadeAnimation;
  late Animation<Offset> _heroSlideAnimation;

  late AnimationController _contentAnimationController;
  late Animation<double> _contentFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Hero animation controller - get from pool
    _heroAnimationController = AnimationPool.getController(
      vsync: this,
      poolName: 'home',
      duration: const Duration(milliseconds: 1200),
    );

    _heroFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _heroAnimationController,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );

    _heroSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _heroAnimationController,
            curve: const Interval(0, 0.6, curve: Curves.easeOutCubic),
          ),
        );

    // Content animation controller - get from pool
    _contentAnimationController = AnimationPool.getController(
      vsync: this,
      poolName: 'home',
      duration: const Duration(milliseconds: 800),
    );

    _contentFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: const Interval(0, 1, curve: Curves.easeOut),
      ),
    );

    _contentSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentAnimationController,
            curve: const Interval(0, 1, curve: Curves.easeOutCubic),
          ),
        );

    // Start animations with staggered timing
    _heroAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _contentAnimationController.forward();
    });
  }

  @override
  void dispose() {
    // Return controllers to the pool instead of disposing them directly
    AnimationPool.returnController(_heroAnimationController, 'home');
    AnimationPool.returnController(_contentAnimationController, 'home');
    super.dispose();
  }

  void _onLocalModeSelected() {
    // Navigate to setup screen with local mode pre-selected
    NavigationService.goSetup(context, params: {'gameMode': 'local'});
  }

  void _onRobotModeSelected() {
    // Navigate to setup screen with robot mode pre-selected
    NavigationService.goSetup(context, params: {'gameMode': 'robot'});
  }

  /// Shows a robust exit confirmation dialog
  Future<bool?> _showExitDialog(BuildContext context) async {
    final colorScheme = Theme.of(context).colorScheme;

    try {
      return await showDialog<bool>(
        context: context,
        barrierDismissible: false, // Prevent dismissing by tapping outside
        builder: (BuildContext context) {
          return PopScope(
            canPop: false, // Prevent back button from closing dialog
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: context.getResponsiveBorderRadius(
                  phoneRadius: 14.0,
                  tabletRadius: 16.0,
                ),
              ),
              title: Row(
                children: [
                  Icon(
                    Icons.exit_to_app,
                    color: colorScheme.error,
                    size: context.getResponsiveIconSize(
                      phoneSize: 24.0,
                      tabletSize: 28.0,
                    ),
                  ),
                  SizedBox(
                    width: context.getResponsiveSpacing(
                      phoneSpacing: 8.0,
                      tabletSpacing: 12.0,
                    ),
                  ),
                  Text(
                    'Exit App',
                    style: context.getResponsiveTextStyle(
                      Theme.of(context).textTheme.headlineSmall ??
                          const TextStyle(),
                      phoneSize: 18.0,
                      tabletSize: 20.0,
                    ),
                  ),
                ],
              ),
              content: Text(
                'Are you sure you want to exit the game?',
                style: context.getResponsiveTextStyle(
                  Theme.of(context).textTheme.bodyMedium ?? const TextStyle(),
                  phoneSize: 14.0,
                  tabletSize: 16.0,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.onSurfaceVariant,
                    padding: context.getResponsivePadding(
                      phonePadding: 16.0,
                      tabletPadding: 20.0,
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: context.getResponsiveTextStyle(
                      Theme.of(context).textTheme.labelLarge ??
                          const TextStyle(),
                      phoneSize: 14.0,
                      tabletSize: 16.0,
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                    padding: context.getResponsivePadding(
                      phonePadding: 16.0,
                      tabletPadding: 20.0,
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
                    'Exit',
                    style: context.getResponsiveTextStyle(
                      Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: colorScheme.onError,
                          ) ??
                          TextStyle(color: colorScheme.onError),
                      phoneSize: 14.0,
                      tabletSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      // Fallback: if dialog fails, just exit
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      canPop: false, // Handle back button manually
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          // Check if we're on the home route (not redirected from other routes)
          final currentPath = NavigationService.getCurrentPath(context);

          // Only show exit dialog if we're actually on the home route
          if (currentPath == '/home') {
            // Show exit dialog with robust implementation
            final shouldExit = await _showExitDialog(context);
            if (shouldExit == true) {
              // Use multiple methods to ensure app exits
              try {
                SystemNavigator.pop();
              } catch (e) {
                // Fallback method
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              }
            }
          } else {
            // If we're not on home route, navigate to home
            NavigationService.goHome(context);
          }
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: Stack(
          children: [
            // Ambient particles background
            const AmbientParticles(),

            // Main content
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  // App bar - simplified without settings button
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    floating: true,
                    title: Semantics(
                      label: 'XO Royale - Home',
                      child: Text(
                        'XO Royale',
                        style: context.getResponsiveTextStyle(
                          theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ) ??
                              const TextStyle(),
                          phoneSize: 28.0,
                          tabletSize: 32.0,
                        ),
                      ),
                    ),
                    // Removed settings button - now accessible via FAB
                  ),

                  // Content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: context.getResponsivePadding(
                        phonePadding: 20.0,
                        tabletPadding: 24.0,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: context.getResponsiveSpacing(
                              phoneSpacing: 32.0,
                              tabletSpacing: 40.0,
                            ),
                          ),

                          // Hero section with typewriter animation
                          AnimatedBuilder(
                            animation: _heroAnimationController,
                            builder: (context, child) => FadeTransition(
                              opacity: _heroFadeAnimation,
                              child: SlideTransition(
                                position: _heroSlideAnimation,
                                child: Column(
                                  children: [
                                    // Welcome back message
                                    Text(
                                      'Welcome back!',
                                      style: context.getResponsiveTextStyle(
                                        theme.textTheme.titleMedium?.copyWith(
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ) ??
                                            const TextStyle(),
                                        phoneSize: 16.0,
                                        tabletSize: 18.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: context.getResponsiveSpacing(
                                        phoneSpacing: 12.0,
                                        tabletSpacing: 16.0,
                                      ),
                                    ),

                                    // Main hero text with typewriter effect
                                    TypewriterText(
                                      text: 'Ready to play?',
                                      style: context.getResponsiveTextStyle(
                                        theme.textTheme.displayMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: colorScheme.onSurface,
                                              height: 1.1,
                                            ) ??
                                            const TextStyle(),
                                        phoneSize: 32.0,
                                        tabletSize: 40.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: context.getResponsiveSpacing(
                              phoneSpacing: 48.0,
                              tabletSpacing: 60.0,
                            ),
                          ),

                          // Game mode cards
                          AnimatedBuilder(
                            animation: _contentAnimationController,
                            builder: (context, child) => FadeTransition(
                              opacity: _contentFadeAnimation,
                              child: SlideTransition(
                                position: _contentSlideAnimation,
                                child: Column(
                                  children: [
                                    GameModeCards(
                                      onLocalModeSelected: _onLocalModeSelected,
                                      onRobotModeSelected: _onRobotModeSelected,
                                    ),

                                    SizedBox(
                                      height: context.getResponsiveSpacing(
                                        phoneSpacing: 24.0,
                                        tabletSpacing: 32.0,
                                      ),
                                    ),

                                    // Quick stats ribbon - optimized with select for granular rebuilds
                                    Consumer(
                                      builder: (context, ref, child) {
                                        // Use select for granular rebuilds - only rebuild when specific values change
                                        final lastResult = ref.watch(
                                          homeProvider.select(
                                            (state) => state.lastResult,
                                          ),
                                        );
                                        final streak = ref.watch(
                                          homeProvider.select(
                                            (state) => state.streak,
                                          ),
                                        );
                                        final gemsCount = ref.watch(
                                          homeProvider.select(
                                            (state) => state.gemsCount,
                                          ),
                                        );
                                        final hintCount = ref.watch(
                                          homeProvider.select(
                                            (state) => state.hintCount,
                                          ),
                                        );

                                        return QuickStatsRibbon(
                                          lastResult: lastResult,
                                          streak: streak,
                                          gemsCount: gemsCount,
                                          hintCount: hintCount,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: context.getResponsiveSpacing(
                              phoneSpacing: 32.0,
                              tabletSpacing: 40.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
