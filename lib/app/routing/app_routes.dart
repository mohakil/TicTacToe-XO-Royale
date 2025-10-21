/// Application route constants and path definitions
///
/// This file contains all route paths, names, and parameter definitions
/// for type-safe navigation throughout the application.
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // Root paths
  static const String loading = '/loading';
  static const String home = '/home';
  static const String store = '/store';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String setup = '/setup';
  static const String game = '/game';
  static const String achievements = '/achievements';

  // Route names for named navigation
  static const String loadingName = 'loading';
  static const String homeName = 'home';
  static const String storeName = 'store';
  static const String profileName = 'profile';
  static const String settingsName = 'settings';
  static const String setupName = 'setup';
  static const String gameName = 'game';
  static const String achievementsName = 'achievements';

  // Query parameter keys
  static const String gameModeParam = 'gameMode';
  static const String boardSizeParam = 'boardSize';
  static const String winConditionParam = 'winCondition';
  static const String difficultyParam = 'difficulty';
  static const String player1Param = 'player1';
  static const String player2Param = 'player2';
  static const String firstMoveParam = 'firstMove';

  // Navigation destinations for bottom navigation
  static const List<String> mainNavRoutes = [home, store, profile, settings];

  // Default parameter values
  static const int defaultBoardSize = 3;
  static const int defaultWinCondition = 3;
  static const String defaultGameMode = 'local';
  static const String defaultDifficulty = 'medium';
  static const String defaultPlayer1 = 'Player 1';
  static const String defaultPlayer2 = 'Player 2';
  static const String defaultFirstMove = 'player1';

  // Helper methods for building URLs with parameters
  static String buildSetupUrl({
    String? gameMode,
    int? boardSize,
    int? winCondition,
    String? difficulty,
    String? player1,
    String? player2,
    String? firstMove,
  }) {
    final params = <String, String>{};

    if (gameMode != null) {
      params[gameModeParam] = gameMode;
    }
    if (boardSize != null) {
      params[boardSizeParam] = boardSize.toString();
    }
    if (winCondition != null) {
      params[winConditionParam] = winCondition.toString();
    }
    if (difficulty != null) {
      params[difficultyParam] = difficulty;
    }
    if (player1 != null) {
      params[player1Param] = player1;
    }
    if (player2 != null) {
      params[player2Param] = player2;
    }
    if (firstMove != null) {
      params[firstMoveParam] = firstMove;
    }

    return _buildUrl(setup, params);
  }

  static String buildGameUrl({
    int? boardSize,
    int? winCondition,
    String? gameMode,
    String? difficulty,
    String? player1,
    String? player2,
    String? firstMove,
  }) {
    final params = <String, String>{};

    if (boardSize != null) {
      params[boardSizeParam] = boardSize.toString();
    }
    if (winCondition != null) {
      params[winConditionParam] = winCondition.toString();
    }
    if (gameMode != null) {
      params[gameModeParam] = gameMode;
    }
    if (difficulty != null) {
      params[difficultyParam] = difficulty;
    }
    if (player1 != null) {
      params[player1Param] = player1;
    }
    if (player2 != null) {
      params[player2Param] = player2;
    }
    if (firstMove != null) {
      params[firstMoveParam] = firstMove;
    }

    return _buildUrl(game, params);
  }

  static String _buildUrl(String path, Map<String, String> params) {
    if (params.isEmpty) return path;

    final queryString = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '$path?$queryString';
  }

  // Route validation helpers
  static bool isMainNavRoute(String path) {
    return mainNavRoutes.contains(path);
  }

  static bool isShellRoute(String path) {
    return isMainNavRoute(path);
  }

  static bool isExternalRoute(String path) {
    return !isShellRoute(path) && path != loading;
  }
}

/// Route parameters data classes for type safety
class GameSetupParams {
  final String? gameMode;
  final int? boardSize;
  final int? winCondition;
  final String? difficulty;
  final String? player1;
  final String? player2;
  final String? firstMove;

  const GameSetupParams({
    this.gameMode,
    this.boardSize,
    this.winCondition,
    this.difficulty,
    this.player1,
    this.player2,
    this.firstMove,
  });

  Map<String, String> toQueryParams() {
    return {
      if (gameMode != null) AppRoutes.gameModeParam: gameMode!,
      if (boardSize != null) AppRoutes.boardSizeParam: boardSize.toString(),
      if (winCondition != null)
        AppRoutes.winConditionParam: winCondition.toString(),
      if (difficulty != null) AppRoutes.difficultyParam: difficulty!,
      if (player1 != null) AppRoutes.player1Param: player1!,
      if (player2 != null) AppRoutes.player2Param: player2!,
      if (firstMove != null) AppRoutes.firstMoveParam: firstMove!,
    };
  }

  factory GameSetupParams.fromQueryParams(Map<String, String> params) {
    return GameSetupParams(
      gameMode: params[AppRoutes.gameModeParam],
      boardSize: int.tryParse(params[AppRoutes.boardSizeParam] ?? ''),
      winCondition: int.tryParse(params[AppRoutes.winConditionParam] ?? ''),
      difficulty: params[AppRoutes.difficultyParam],
      player1: params[AppRoutes.player1Param],
      player2: params[AppRoutes.player2Param],
      firstMove: params[AppRoutes.firstMoveParam],
    );
  }

  GameSetupParams copyWith({
    String? gameMode,
    int? boardSize,
    int? winCondition,
    String? difficulty,
    String? player1,
    String? player2,
    String? firstMove,
  }) {
    return GameSetupParams(
      gameMode: gameMode ?? this.gameMode,
      boardSize: boardSize ?? this.boardSize,
      winCondition: winCondition ?? this.winCondition,
      difficulty: difficulty ?? this.difficulty,
      player1: player1 ?? this.player1,
      player2: player2 ?? this.player2,
      firstMove: firstMove ?? this.firstMove,
    );
  }
}
