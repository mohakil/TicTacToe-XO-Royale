import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/app/router/routes.dart';

/// Simple deep linking configuration for the app
class DeepLinkingConfig {
  /// URL scheme for the app
  static const String urlScheme = 'xotictactoe';

  /// Host for web deep links
  static const String webHost = 'xotictactoe.com';

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
            return '${AppRoutes.game}?gameId=$gameId';
          }
          break;
        case 'store':
          if (segments.length >= 2) {
            final category = segments[1];
            return '${AppRoutes.store}?category=$category';
          }
          break;
        case 'profile':
          if (segments.length >= 2) {
            final userId = segments[1];
            return '${AppRoutes.profile}?userId=$userId';
          }
          break;
        case 'challenge':
          if (segments.length >= 2) {
            final challengeId = segments[1];
            return '${AppRoutes.setup}?challengeId=$challengeId';
          }
          break;
      }

      // Default fallback
      return AppRoutes.home;
    } on Exception catch (e) {
      debugPrint('Deep link parsing error: $e');
      return AppRoutes.home;
    }
  }

  /// Generate shareable link for content
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
}
