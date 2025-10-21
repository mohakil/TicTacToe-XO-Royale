import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/app/router/app_router.dart';
import 'package:tictactoe_xo_royale/app/routing/navigation_performance.dart';
import 'package:tictactoe_xo_royale/app/theme/app_theme.dart';
import 'package:tictactoe_xo_royale/core/providers/theme_provider.dart';

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Schedule warmup after first frame when router is available
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (mounted && !_isInitialized) {
          try {
            await NavigationPerformance.warmUpNavigation(context);
          } catch (e) {
            debugPrint('Navigation warmup failed: $e');
            // Continue without warmup - non-critical
          }
          if (mounted) {
            setState(() {
              _isInitialized = true;
            });
          }
        }
      });
    } catch (e) {
      debugPrint('App initialization failed: $e');
      // Continue without warmup - non-critical
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'TicTacToe: XO Royale',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
