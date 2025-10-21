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
import 'package:tictactoe_xo_royale/app/routing/app_routes.dart';
import 'package:tictactoe_xo_royale/shared/widgets/feedback/confirmation_dialog.dart';

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

  bool _animationsInitialized = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    if (_disposed || _animationsInitialized) return;

    // Get fresh controllers to ensure clean state for rapid navigation
    _heroAnimationController = AnimationPool.getFreshController(
      vsync: this,
      poolName: 'home',
      duration: const Duration(
        milliseconds: 600,
      ), // Reduced for better performance
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

    // Content animation controller - get fresh controller
    _contentAnimationController = AnimationPool.getFreshController(
      vsync: this,
      poolName: 'home',
      duration: const Duration(
        milliseconds: 400,
      ), // Reduced for better performance
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

    _animationsInitialized = true;

    // Start animations with staggered timing - use addPostFrameCallback for safety
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_disposed) {
        _startAnimations();
      }
    });
  }

  void _startAnimations() {
    if (!mounted || _disposed) return;

    // Reset animations to ensure they start from the beginning
    _heroAnimationController.reset();
    _contentAnimationController.reset();

    // Start hero animation
    _heroAnimationController.forward();

    // Start content animation with delay - use Future with error handling
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted && !_disposed) {
        _contentAnimationController.forward();
      }
    });
  }

  void _resetAnimations() {
    if (_disposed) return;

    if (_animationsInitialized) {
      try {
        _heroAnimationController.reset();
        _contentAnimationController.reset();
      } catch (e) {
        // Controllers might be disposed, ignore
      }
    }
    _animationsInitialized = false;
  }

  @override
  void dispose() {
    _disposed = true;

    // Return controllers to the pool instead of disposing them directly
    try {
      if (_heroAnimationController.isAnimating) {
        _heroAnimationController.stop();
      }
      AnimationPool.returnController(_heroAnimationController, 'home');
    } catch (e) {
      // Controller might be already disposed
    }

    try {
      if (_contentAnimationController.isAnimating) {
        _contentAnimationController.stop();
      }
      AnimationPool.returnController(_contentAnimationController, 'home');
    } catch (e) {
      // Controller might be already disposed
    }

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Restart animations when returning to home screen
    if (mounted && !_disposed && NavigationService.isOnHome(context)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_disposed) {
          _resetAnimations();
          _initializeAnimations();
        }
      });
    }
  }

  void _onLocalModeSelected() {
    // Navigate to setup screen with local mode pre-selected using type-safe parameters
    final params = GameSetupParams(
      gameMode: 'local',
      boardSize: AppRoutes.defaultBoardSize,
      winCondition: AppRoutes.defaultWinCondition,
    );
    NavigationService.goSetup(context, params: params);
  }

  void _onRobotModeSelected() {
    // Navigate to setup screen with robot mode pre-selected using type-safe parameters
    final params = GameSetupParams(
      gameMode: 'robot',
      boardSize: AppRoutes.defaultBoardSize,
      winCondition: AppRoutes.defaultWinCondition,
      difficulty: AppRoutes.defaultDifficulty,
    );
    NavigationService.goSetup(context, params: params);
  }

  /// Shows a robust exit confirmation dialog
  Future<bool?> _showExitDialog(BuildContext context) async {
    try {
      return await showDialog<bool>(
        context: context,
        barrierDismissible: false, // Prevent dismissing by tapping outside
        builder: (BuildContext context) {
          return PopScope(
            canPop: false, // Prevent back button from closing dialog
            child: ConfirmationDialog(
              title: 'Exit App',
              content: 'Are you sure you want to exit the game?',
              icon: Icons.exit_to_app,
              confirmText: 'Exit',
              cancelText: 'Cancel',
              confirmTextColor: Colors.black,
              autoPop: false, // Let the calling code handle navigation
              onConfirm: () => Navigator.of(context).pop(true),
              onCancel: () => Navigator.of(context).pop(false),
              barrierDismissible: false,
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

                                    // Quick stats ribbon - now uses real data from providers
                                    const QuickStatsRibbon(),
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
