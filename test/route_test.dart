import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/app/router/routes.dart';

void main() {
  group('Route Generation Tests', () {
    test('getSetupRoute generates correct robot mode URL', () {
      final result = AppRoutes.getSetupRoute(gameMode: 'robot');
      expect(result, '/setup?gameMode=robot');
    });

    test('getSetupRoute generates correct local mode URL', () {
      final result = AppRoutes.getSetupRoute(gameMode: 'local');
      expect(result, '/setup?gameMode=local');
    });

    test('getSetupRoute without parameters returns base route', () {
      final result = AppRoutes.getSetupRoute();
      expect(result, '/setup');
    });
  });
}
