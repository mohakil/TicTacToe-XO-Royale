import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/app/router/routes.dart';

void main() {
  group('Router Tests', () {
    test('should have all required routes defined', () {
      final requiredRoutes = [
        AppRoutes.loading,
        AppRoutes.home,
        AppRoutes.setup,
        AppRoutes.game,
        AppRoutes.store,
        AppRoutes.profile,
        AppRoutes.settings,
      ];

      // Verify all routes are properly defined as constants
      for (final route in requiredRoutes) {
        expect(route, isA<String>());
        expect(route.startsWith('/'), isTrue);
      }
    });

    test('should have all required route names defined', () {
      final requiredRouteNames = [
        AppRoutes.loadingName,
        AppRoutes.homeName,
        AppRoutes.setupName,
        AppRoutes.gameName,
        AppRoutes.storeName,
        AppRoutes.profileName,
        AppRoutes.settingsName,
      ];

      // Verify all route names are properly defined as constants
      for (final routeName in requiredRouteNames) {
        expect(routeName, isA<String>());
        expect(routeName.isNotEmpty, isTrue);
      }
    });
  });
}
