import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    // Logo animation
                    const LogoAnimation(),

                    const SizedBox(height: 48),

                    // Progress bar
                    ProgressBar(progress: loadingState.progress),

                    const SizedBox(height: 24),

                    // Loading text
                    Text(
                      'Loading...',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const Spacer(),

                    // Tips carousel
                    const TipsCarousel(),

                    const SizedBox(height: 32),
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
