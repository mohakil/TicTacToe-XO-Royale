import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_xo_royale/app/router/routes.dart';
import 'package:tictactoe_xo_royale/core/services/animation_pool.dart';
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
    final setupRoute = AppRoutes.buildSetupRoute(gameMode: 'local');
    context.go(setupRoute);
  }

  void _onRobotModeSelected() {
    // Navigate to setup screen with robot mode pre-selected
    final setupRoute = AppRoutes.buildSetupRoute(gameMode: 'robot');
    context.go(setupRoute);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
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
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  // Removed settings button - now accessible via FAB
                ),

                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),

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
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),

                                  // Main hero text with typewriter effect
                                  TypewriterText(
                                    text: 'Ready to play?',
                                    style: theme.textTheme.displayMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onSurface,
                                          height: 1.1,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 60),

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

                                  const SizedBox(height: 32),

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

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
