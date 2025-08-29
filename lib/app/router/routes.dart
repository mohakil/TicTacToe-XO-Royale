// Route constants for the app
// ignore: avoid_classes_with_only_static_members
class AppRoutes {
  // Base routes
  static const String loading = '/loading';
  static const String home = '/home';
  static const String setup = '/setup';
  static const String game = '/game';
  static const String store = '/store';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Route names for navigation
  static const String loadingName = 'loading';
  static const String homeName = 'home';
  static const String setupName = 'setup';
  static const String gameName = 'game';
  static const String storeName = 'store';
  static const String profileName = 'profile';
  static const String settingsName = 'settings';

  // Route parameters
  static const String boardSizeParam = 'boardSize';
  static const String winConditionParam = 'winCondition';
  static const String gameModeParam = 'gameMode';
  static const String difficultyParam = 'difficulty';
  static const String player1Param = 'player1';
  static const String player2Param = 'player2';
  static const String firstMoveParam = 'firstMove';

  // Route builders
  static String getSetupRoute({
    String? gameMode,
    int? boardSize,
    int? winCondition,
    String? difficulty,
    String? player1,
    String? player2,
    String? firstMove,
    String? challengeId,
    String? tournamentId,
  }) {
    final queryParams = <String, String>{};

    if (gameMode != null) {
      queryParams[gameModeParam] = gameMode;
    }
    if (boardSize != null) {
      queryParams[boardSizeParam] = boardSize.toString();
    }
    if (winCondition != null) {
      queryParams[winConditionParam] = winCondition.toString();
    }
    if (difficulty != null) {
      queryParams[difficultyParam] = difficulty;
    }
    if (player1 != null) {
      queryParams[player1Param] = player1;
    }
    if (player2 != null) {
      queryParams[player2Param] = player2;
    }
    if (firstMove != null) {
      queryParams[firstMoveParam] = firstMove;
    }
    if (challengeId != null) {
      queryParams['challengeId'] = challengeId;
    }
    if (tournamentId != null) {
      queryParams['tournamentId'] = tournamentId;
    }

    if (queryParams.isEmpty) {
      return setup;
    }

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    final result = '$setup?$queryString';
    // print('DEBUG: getSetupRoute called with gameMode=$gameMode, result=$result');
    return result;
  }

  static String getGameRoute({
    int? boardSize,
    int? winCondition,
    String? gameMode,
    String? difficulty,
    String? player1,
    String? player2,
    String? firstMove,
  }) {
    final queryParams = <String, String>{};

    if (boardSize != null) {
      queryParams[boardSizeParam] = boardSize.toString();
    }
    if (winCondition != null) {
      queryParams[winConditionParam] = winCondition.toString();
    }
    if (gameMode != null) {
      queryParams[gameModeParam] = gameMode;
    }
    if (difficulty != null) {
      queryParams[difficultyParam] = difficulty;
    }
    if (player1 != null) {
      queryParams[player1Param] = player1;
    }
    if (player2 != null) {
      queryParams[player2Param] = player2;
    }
    if (firstMove != null) {
      queryParams[firstMoveParam] = firstMove;
    }

    if (queryParams.isEmpty) {
      return game;
    }

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '$game?$queryString';
  }

  // Route validation
  static bool isValidRoute(String route) =>
      [loading, home, setup, game, store, profile, settings].contains(route);

  // Route grouping
  static const List<String> mainRoutes = [home, store, profile, settings];

  static const List<String> gameRoutes = [setup, game];

  static const List<String> utilityRoutes = [loading];

  // Route metadata
  static const Map<String, Map<String, dynamic>> routeMetadata = {
    loading: {
      'title': 'Loading',
      'icon': 'hourglass_empty',
      'requiresAuth': false,
      'showInNav': false,
    },
    home: {
      'title': 'Home',
      'icon': 'home',
      'requiresAuth': false,
      'showInNav': true,
    },
    setup: {
      'title': 'Game Setup',
      'icon': 'settings',
      'requiresAuth': false,
      'showInNav': false,
    },
    game: {
      'title': 'Game',
      'icon': 'sports_esports',
      'requiresAuth': false,
      'showInNav': false,
    },
    store: {
      'title': 'Store',
      'icon': 'storefront',
      'requiresAuth': false,
      'showInNav': true,
    },
    profile: {
      'title': 'Profile',
      'icon': 'account_circle',
      'requiresAuth': false,
      'showInNav': true,
    },
    settings: {
      'title': 'Settings',
      'icon': 'tune',
      'requiresAuth': false,
      'showInNav': true,
    },
  };

  // Get route title
  static String getRouteTitle(String route) =>
      routeMetadata[route]?['title'] ?? 'Unknown';

  // Get route icon
  static String getRouteIcon(String route) =>
      routeMetadata[route]?['icon'] ?? 'help';

  // Check if route requires auth
  static bool requiresAuth(String route) =>
      routeMetadata[route]?['requiresAuth'] ?? false;

  // Check if route should show in navigation
  static bool showInNavigation(String route) =>
      routeMetadata[route]?['showInNav'] ?? false;

  // Get navigation routes
  static List<String> getNavigationRoutes() => routeMetadata.entries
      .where((entry) => entry.value['showInNav'] == true)
      .map((entry) => entry.key)
      .toList();
}
