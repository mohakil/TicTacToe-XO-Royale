import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'widgets/typewriter_text.dart';
import 'widgets/game_mode_cards.dart';
import 'widgets/quick_stats_ribbon.dart';
import 'widgets/ambient_particles.dart';
import '../providers/home_provider.dart';

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

    // Hero animation controller
    _heroAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _heroFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _heroAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _heroSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _heroAnimationController,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
          ),
        );

    // Content animation controller
    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );

    _contentSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentAnimationController,
            curve: const Interval(0.0, 1.0, curve: Curves.easeOutCubic),
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
    _heroAnimationController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  void _onLocalModeSelected() {
    // Navigate to setup screen with local mode
    context.go('/setup');
  }

  void _onRobotModeSelected() {
    // Navigate to setup screen with robot mode
    context.go('/setup');
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
          const AmbientParticles(
            particleCount: 8,
            opacity: 0.05,
            movementSpeed: 0.2,
          ),

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
                          builder: (context, child) {
                            return FadeTransition(
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
                                      speed: const Duration(milliseconds: 40),
                                      caretBlinkDuration: const Duration(
                                        milliseconds: 600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 60),

                        // Game mode cards
                        AnimatedBuilder(
                          animation: _contentAnimationController,
                          builder: (context, child) {
                            return FadeTransition(
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

                                    // Quick stats ribbon
                                    Consumer(
                                      builder: (context, ref, child) {
                                        final lastResult = ref.watch(
                                          lastResultProvider,
                                        );
                                        final streak = ref.watch(
                                          streakProvider,
                                        );
                                        final gemsCount = ref.watch(
                                          gemsCountProvider,
                                        );
                                        final hintCount = ref.watch(
                                          hintCountProvider,
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
                            );
                          },
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
