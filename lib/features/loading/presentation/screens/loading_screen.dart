import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/features/loading/presentation/widgets/ambient_background.dart';
import 'package:tictactoe_xo_royale/features/loading/presentation/widgets/logo_animation.dart';
import 'package:tictactoe_xo_royale/features/loading/presentation/widgets/progress_bar.dart';
import 'package:tictactoe_xo_royale/features/loading/presentation/widgets/tips_carousel.dart';
import 'package:tictactoe_xo_royale/features/loading/providers/loading_provider.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({super.key});

  @override
  ConsumerState<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Start loading when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(loadingProvider.notifier).startLoading();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loadingState = ref.watch(loadingProvider);
    final theme = Theme.of(context);

    // Navigate to home when loading completes
    if (!loadingState.isLoading && loadingState.progress >= 1.0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/home');
      });
    }

    return PopScope(
      canPop: false, // Disable back button on loading screen
      child: Scaffold(
        body: Stack(
          children: [
            // Animated background
            const AmbientBackground(),

            // Main content
            SafeArea(
              child: Padding(
                padding: context.getResponsivePadding(
                  phonePadding: 16.0,
                  tabletPadding: 24.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(flex: 2),

                    // Logo animation
                    const LogoAnimation(),

                    SizedBox(
                      height: context.getResponsiveSpacing(
                        phoneSpacing: 32.0,
                        tabletSpacing: 48.0,
                      ),
                    ),

                    // Progress bar
                    ProgressBar(progress: loadingState.progress),

                    SizedBox(
                      height: context.getResponsiveSpacing(
                        phoneSpacing: 16.0,
                        tabletSpacing: 24.0,
                      ),
                    ),

                    // Loading text
                    Text(
                      'Loading...',
                      style: context.getResponsiveTextStyle(
                        theme.textTheme.titleLarge!.copyWith(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Tips carousel
                    const TipsCarousel(),

                    SizedBox(
                      height: context.getResponsiveSpacing(
                        phoneSpacing: 24.0,
                        tabletSpacing: 32.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
