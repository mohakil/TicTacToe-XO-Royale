import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes.dart';

/// Deep linking configuration for the Tic Tac Toe XO Royale app
class DeepLinkingConfig {
  /// URL scheme for the app
  static const String urlScheme = 'xotictactoe';

  /// Host for web deep links
  static const String webHost = 'xotictactoe.com';

  /// App store URLs for different platforms
  static const Map<String, String> appStoreUrls = {
    'ios': 'https://apps.apple.com/app/xo-tictactoe-royale/id123456789',
    'android':
        'https://play.google.com/store/apps/details?id=com.astrixforge.tictactoe_xo_royale',
    'web': 'https://xotictactoe.com',
  };

  /// Supported deep link patterns
  static const List<String> supportedPatterns = [
    '/game/:gameId',
    '/store/:category/:itemId',
    '/profile/:userId',
    '/challenge/:challengeId',
    '/leaderboard/:boardId',
    '/tournament/:tournamentId',
  ];

  /// Handle incoming deep links
  static String? handleDeepLink(Uri uri) {
    try {
      // Validate URI scheme
      if (uri.scheme != urlScheme && uri.host != webHost) {
        return null;
      }

      // Parse deep link path
      final path = uri.path;
      final segments = path.split('/').where((s) => s.isNotEmpty).toList();

      if (segments.isEmpty) {
        return AppRoutes.home;
      }

      // Handle different deep link patterns
      switch (segments[0]) {
        case 'game':
          if (segments.length >= 2) {
            final gameId = segments[1];
            return _buildGameDeepLink(gameId, uri.queryParameters);
          }
          break;

        case 'store':
          if (segments.length >= 3) {
            final category = segments[1];
            final itemId = segments[2];
            return _buildStoreDeepLink(category, itemId);
          } else if (segments.length >= 2) {
            final category = segments[1];
            return _buildStoreCategoryDeepLink(category);
          }
          break;

        case 'profile':
          if (segments.length >= 2) {
            final userId = segments[1];
            return _buildProfileDeepLink(userId);
          }
          break;

        case 'challenge':
          if (segments.length >= 2) {
            final challengeId = segments[1];
            return _buildChallengeDeepLink(challengeId);
          }
          break;

        case 'leaderboard':
          if (segments.length >= 2) {
            final boardId = segments[1];
            return _buildLeaderboardDeepLink(boardId);
          }
          break;

        case 'tournament':
          if (segments.length >= 2) {
            final tournamentId = segments[1];
            return _buildTournamentDeepLink(tournamentId);
          }
          break;

        case 'share':
          return _buildShareDeepLink(uri.queryParameters);
      }

      // Default fallback
      return AppRoutes.home;
    } catch (e) {
      debugPrint('Deep link parsing error: $e');
      return AppRoutes.home;
    }
  }

  /// Build game deep link with parameters
  static String _buildGameDeepLink(
    String gameId,
    Map<String, String> queryParams,
  ) {
    const baseRoute = AppRoutes.game;

    if (queryParams.isEmpty) {
      return '$baseRoute?gameId=$gameId';
    }

    final allParams = Map<String, String>.from(queryParams);
    allParams['gameId'] = gameId;

    final queryString = allParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '$baseRoute?$queryString';
  }

  /// Build store deep link
  static String _buildStoreDeepLink(String category, String itemId) {
    return '${AppRoutes.store}?category=$category&itemId=$itemId';
  }

  /// Build store category deep link
  static String _buildStoreCategoryDeepLink(String category) {
    return '${AppRoutes.store}?category=$category';
  }

  /// Build profile deep link
  static String _buildProfileDeepLink(String userId) {
    return '${AppRoutes.profile}?userId=$userId';
  }

  /// Build challenge deep link
  static String _buildChallengeDeepLink(String challengeId) {
    return '${AppRoutes.setup}?challengeId=$challengeId';
  }

  /// Build leaderboard deep link
  static String _buildLeaderboardDeepLink(String boardId) {
    return '${AppRoutes.profile}?leaderboardId=$boardId';
  }

  /// Build tournament deep link
  static String _buildTournamentDeepLink(String tournamentId) {
    return '${AppRoutes.setup}?tournamentId=$tournamentId';
  }

  /// Build share deep link
  static String _buildShareDeepLink(Map<String, String> queryParams) {
    final type = queryParams['type'] ?? 'game';
    final id = queryParams['id'];

    if (id == null) return AppRoutes.home;

    switch (type) {
      case 'game':
        return _buildGameDeepLink(id, queryParams);
      case 'store':
        final category = queryParams['category'] ?? 'general';
        return _buildStoreDeepLink(category, id);
      case 'profile':
        return _buildProfileDeepLink(id);
      default:
        return AppRoutes.home;
    }
  }

  /// Generate shareable links for different content types
  static String generateShareLink({
    required String type,
    required String id,
    Map<String, String>? additionalParams,
  }) {
    final params = <String, String>{
      'type': type,
      'id': id,
      ...?additionalParams,
    };

    final queryString = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '$urlScheme://share?$queryString';
  }

  /// Generate web share links
  static String generateWebShareLink({
    required String type,
    required String id,
    Map<String, String>? additionalParams,
  }) {
    final params = <String, String>{
      'type': type,
      'id': id,
      ...?additionalParams,
    };

    final queryString = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return 'https://$webHost/share?$queryString';
  }

  /// Validate deep link parameters
  static bool validateDeepLinkParams(Map<String, String> params) {
    // Add validation logic for different parameter types
    for (final entry in params.entries) {
      if (!_isValidParameter(entry.key, entry.value)) {
        return false;
      }
    }
    return true;
  }

  /// Check if a parameter is valid
  static bool _isValidParameter(String key, String value) {
    if (value.isEmpty) return false;

    switch (key) {
      case 'gameId':
      case 'challengeId':
      case 'tournamentId':
        return _isValidId(value);
      case 'userId':
        return _isValidUserId(value);
      case 'category':
        return _isValidCategory(value);
      case 'itemId':
        return _isValidItemId(value);
      case 'boardSize':
        return _isValidBoardSize(value);
      case 'winCondition':
        return _isValidWinCondition(value);
      case 'difficulty':
        return _isValidDifficulty(value);
      default:
        return true; // Allow unknown parameters
    }
  }

  /// Validate ID format
  static bool _isValidId(String id) {
    return RegExp(r'^[a-zA-Z0-9_-]{3,50}$').hasMatch(id);
  }

  /// Validate user ID format
  static bool _isValidUserId(String userId) {
    return RegExp(r'^[a-zA-Z0-9_-]{3,30}$').hasMatch(userId);
  }

  /// Validate category format
  static bool _isValidCategory(String category) {
    final validCategories = ['themes', 'boards', 'symbols', 'gems'];
    return validCategories.contains(category.toLowerCase());
  }

  /// Validate item ID format
  static bool _isValidItemId(String itemId) {
    return RegExp(r'^[a-zA-Z0-9_-]{3,30}$').hasMatch(itemId);
  }

  /// Validate board size
  static bool _isValidBoardSize(String boardSize) {
    final size = int.tryParse(boardSize);
    return size != null && size >= 3 && size <= 10;
  }

  /// Validate win condition
  static bool _isValidWinCondition(String winCondition) {
    final condition = int.tryParse(winCondition);
    return condition != null && condition >= 3 && condition <= 10;
  }

  /// Validate difficulty level
  static bool _isValidDifficulty(String difficulty) {
    final validDifficulties = ['easy', 'medium', 'hard'];
    return validDifficulties.contains(difficulty.toLowerCase());
  }
}

/// Deep link handler provider
final deepLinkHandlerProvider = Provider<DeepLinkHandler>((ref) {
  return DeepLinkHandler();
});

/// Deep link handler class
class DeepLinkHandler {
  /// Process incoming deep link
  Future<String?> processDeepLink(Uri uri) async {
    try {
      // Log deep link for debugging
      debugPrint('Processing deep link: $uri');

      // Handle the deep link
      final route = DeepLinkingConfig.handleDeepLink(uri);

      if (route != null) {
        debugPrint('Deep link resolved to: $route');
        return route;
      } else {
        debugPrint('Deep link could not be resolved');
        return null;
      }
    } catch (e) {
      debugPrint('Error processing deep link: $e');
      return null;
    }
  }

  /// Handle app state restoration from deep link
  Future<void> restoreAppState(String route) async {
    try {
      debugPrint('Restoring app state to: $route');

      // Add any additional state restoration logic here
      // For example, loading user preferences, game state, etc.
    } catch (e) {
      debugPrint('Error restoring app state: $e');
    }
  }

  /// Generate shareable link for current content
  String generateCurrentShareLink({
    required String type,
    required String id,
    Map<String, String>? additionalParams,
  }) {
    return DeepLinkingConfig.generateShareLink(
      type: type,
      id: id,
      additionalParams: additionalParams,
    );
  }

  /// Generate web share link for current content
  String generateCurrentWebShareLink({
    required String type,
    required String id,
    Map<String, String>? additionalParams,
  }) {
    return DeepLinkingConfig.generateWebShareLink(
      type: type,
      id: id,
      additionalParams: additionalParams,
    );
  }
}

/// Deep link state provider
final deepLinkStateProvider =
    StateNotifierProvider<DeepLinkStateNotifier, DeepLinkState>((ref) {
      return DeepLinkStateNotifier();
    });

/// Deep link state notifier
class DeepLinkStateNotifier extends StateNotifier<DeepLinkState> {
  DeepLinkStateNotifier() : super(DeepLinkState.initial());

  void setLastDeepLink(Uri uri) {
    state = state.copyWith(lastDeepLink: uri, lastDeepLinkTime: DateTime.now());
  }

  void setDeepLinkError(String error) {
    state = state.copyWith(lastError: error, lastErrorTime: DateTime.now());
  }

  void clearDeepLinkError() {
    state = state.copyWith(lastError: null, lastErrorTime: null);
  }

  void incrementDeepLinkCount() {
    state = state.copyWith(totalDeepLinks: state.totalDeepLinks + 1);
  }
}

/// Deep link state data class
class DeepLinkState {
  final Uri? lastDeepLink;
  final DateTime? lastDeepLinkTime;
  final String? lastError;
  final DateTime? lastErrorTime;
  final int totalDeepLinks;

  const DeepLinkState({
    this.lastDeepLink,
    this.lastDeepLinkTime,
    this.lastError,
    this.lastErrorTime,
    required this.totalDeepLinks,
  });

  factory DeepLinkState.initial() {
    return const DeepLinkState(totalDeepLinks: 0);
  }

  DeepLinkState copyWith({
    Uri? lastDeepLink,
    DateTime? lastDeepLinkTime,
    String? lastError,
    DateTime? lastErrorTime,
    int? totalDeepLinks,
  }) {
    return DeepLinkState(
      lastDeepLink: lastDeepLink ?? this.lastDeepLink,
      lastDeepLinkTime: lastDeepLinkTime ?? this.lastDeepLinkTime,
      lastError: lastError ?? this.lastError,
      lastErrorTime: lastErrorTime ?? this.lastErrorTime,
      totalDeepLinks: totalDeepLinks ?? this.totalDeepLinks,
    );
  }
}
