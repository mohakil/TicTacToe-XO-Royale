import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/app/router/app_router.dart';
import 'package:tictactoe_xo_royale/app/theme/app_theme.dart';
import 'package:tictactoe_xo_royale/core/providers/theme_provider.dart';
import 'package:tictactoe_xo_royale/core/widgets/error_boundary.dart';

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final errorLoggingService = ref.watch(errorLoggingProvider);

    return ErrorBoundary(
      onError: (error, stackTrace) {
        errorLoggingService.logError(
          error,
          stackTrace,
          context: 'MainApp',
          additionalData: {
            'themeMode': themeMode.name,
            'routerLocation': router.routerDelegate.currentConfiguration.uri
                .toString(),
          },
        );
      },
      onRetry: () {
        // Force router refresh on retry
        ref.invalidate(routerProvider);
      },
      child: MaterialApp.router(
        title: 'TicTacToe: XO Royale',
        debugShowCheckedModeBanner: false,
        themeMode: themeMode,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: router,
        // Add global error handling for the MaterialApp
        builder: (context, child) {
          return ErrorBoundary(
            onError: (error, stackTrace) {
              errorLoggingService.logError(
                error,
                stackTrace,
                context: 'MaterialApp',
              );
            },
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
