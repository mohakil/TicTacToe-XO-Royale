import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_xo_royale/app/router/routes.dart';

/// Simple navigation service for the app
class NavigationService {
  /// Navigate to a route
  static void goTo(BuildContext context, String route) {
    context.go(route);
  }

  /// Push a new route
  static void push(BuildContext context, String route) {
    context.push(route);
  }

  /// Navigate to game setup with parameters
  static void goToGameSetup(
    BuildContext context, {
    int? boardSize,
    int? winCondition,
    String? gameMode,
    String? difficulty,
    String? player1,
    String? player2,
    String? firstMove,
    String? challengeId,
    String? tournamentId,
  }) {
    final route = AppRoutes.buildSetupRoute(
      boardSize: boardSize,
      winCondition: winCondition,
      gameMode: gameMode,
      difficulty: difficulty,
      player1: player1,
      player2: player2,
      firstMove: firstMove,
      challengeId: challengeId,
      tournamentId: tournamentId,
    );
    context.push(route);
  }

  /// Navigate to game with parameters
  static void goToGame(
    BuildContext context, {
    int? boardSize,
    int? winCondition,
    String? gameMode,
    String? difficulty,
    String? player1,
    String? player2,
    String? firstMove,
  }) {
    final route = AppRoutes.buildGameRoute(
      boardSize: boardSize,
      winCondition: winCondition,
      gameMode: gameMode,
      difficulty: difficulty,
      player1: player1,
      player2: player2,
      firstMove: firstMove,
    );
    context.push(route);
  }

  /// Navigate to home
  static void goToHome(BuildContext context) {
    context.go(AppRoutes.home);
  }

  /// Navigate to store
  static void goToStore(BuildContext context) {
    context.go(AppRoutes.store);
  }

  /// Navigate to profile
  static void goToProfile(BuildContext context) {
    context.go(AppRoutes.profile);
  }

  /// Navigate to settings
  static void goToSettings(BuildContext context) {
    context.go(AppRoutes.settings);
  }

  /// Navigate back
  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }
}
