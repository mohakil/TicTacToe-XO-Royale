/// Simple route constants for the app
class AppRoutes {
  // Route paths
  static const String loading = '/loading';
  static const String home = '/home';
  static const String setup = '/setup';
  static const String game = '/game';
  static const String store = '/store';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Route names
  static const String loadingName = 'loading';
  static const String homeName = 'home';
  static const String setupName = 'setup';
  static const String gameName = 'game';
  static const String storeName = 'store';
  static const String profileName = 'profile';
  static const String settingsName = 'settings';

  /// Build game route with parameters
  static String buildGameRoute({
    int? boardSize,
    int? winCondition,
    String? gameMode,
    String? difficulty,
    String? player1,
    String? player2,
    String? firstMove,
  }) {
    final params = <String, String>{};

    if (boardSize != null) params['boardSize'] = boardSize.toString();
    if (winCondition != null) params['winCondition'] = winCondition.toString();
    if (gameMode != null) params['gameMode'] = gameMode;
    if (difficulty != null) params['difficulty'] = difficulty;
    if (player1 != null) params['player1'] = player1;
    if (player2 != null) params['player2'] = player2;
    if (firstMove != null) params['firstMove'] = firstMove;

    if (params.isEmpty) return game;

    final queryString = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '$game?$queryString';
  }

  /// Build setup route with parameters
  static String buildSetupRoute({
    String? gameMode,
    int? boardSize,
    int? winCondition,
    String? difficulty,
    String? player1,
    String? player2,
    String? firstMove,
  }) {
    final params = <String, String>{};

    if (gameMode != null) params['gameMode'] = gameMode;
    if (boardSize != null) params['boardSize'] = boardSize.toString();
    if (winCondition != null) params['winCondition'] = winCondition.toString();
    if (difficulty != null) params['difficulty'] = difficulty;
    if (player1 != null) params['player1'] = player1;
    if (player2 != null) params['player2'] = player2;
    if (firstMove != null) params['firstMove'] = firstMove;

    if (params.isEmpty) return setup;

    final queryString = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '$setup?$queryString';
  }
}
