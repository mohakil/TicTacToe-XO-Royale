import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/app/router/routes.dart';

void main() {
  group('Route Generation Tests', () {
    test('buildSetupRoute generates correct robot mode URL', () {
      final result = AppRoutes.buildSetupRoute(gameMode: 'robot');
      expect(result, '/setup?gameMode=robot');
    });

    test('buildSetupRoute generates correct local mode URL', () {
      final result = AppRoutes.buildSetupRoute(gameMode: 'local');
      expect(result, '/setup?gameMode=local');
    });

    test('buildSetupRoute without parameters returns base route', () {
      final result = AppRoutes.buildSetupRoute();
      expect(result, '/setup');
    });
  });
}
