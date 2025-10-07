import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:tictactoe_xo_royale/core/database/app_database.dart' as db;
import 'package:tictactoe_xo_royale/core/database/database_providers.dart';
import 'package:tictactoe_xo_royale/core/providers/store_provider.dart';
import 'package:tictactoe_xo_royale/core/models/store_item.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('StoreProvider Tests', () {
    late ProviderContainer container;
    late db.AppDatabase testDatabase;

    setUp(() {
      // Create in-memory database for testing
      testDatabase = db.AppDatabase(NativeDatabase.memory());

      // Override the database provider with test database
      container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(testDatabase)],
      );
    });

    tearDown(() async {
      // Close the test database
      await testDatabase.close();
      container.dispose();
    });

    group('Store State Provider', () {
      test('should provide store notifier', () {
        final notifier = container.read(storeProvider.notifier);
        expect(notifier, isA<StoreNotifier>());
      });

      test('should provide store state', () {
        final storeState = container.read(storeProvider);
        expect(storeState, isA<StoreState>());
        expect(storeState.selectedCategory, equals(StoreItemCategory.theme));
        expect(storeState.purchaseHistory, isEmpty);
        expect(storeState.watchAdCooldown, isNull);
      });
    });

    group('Individual Store Providers', () {
      test(
        'storeSelectedCategoryProvider should provide selected category',
        () {
          final category = container.read(storeSelectedCategoryProvider);
          expect(category, equals(StoreItemCategory.theme));
        },
      );

      test('storeErrorProvider should provide error state', () {
        final error = container.read(storeErrorProvider);
        expect(error, isNull);
      });

      test('storePurchaseHistoryProvider should provide purchase history', () {
        final purchaseHistory = container.read(storePurchaseHistoryProvider);
        expect(purchaseHistory, isEmpty);
      });

      test('storeWatchAdCooldownProvider should provide watch ad cooldown', () {
        final cooldown = container.read(storeWatchAdCooldownProvider);
        expect(cooldown, isNull);
      });
    });

    group('Store Notifier Methods', () {
      test('should select category', () {
        final notifier = container.read(storeProvider.notifier);

        notifier.selectCategory(StoreItemCategory.board);

        final selectedCategory = container.read(storeSelectedCategoryProvider);
        expect(selectedCategory, equals(StoreItemCategory.board));
      });

      test('should clear error', () {
        final notifier = container.read(storeProvider.notifier);

        notifier.clearError();

        final error = container.read(storeErrorProvider);
        expect(error, isNull);
      });

      test('should check if can watch ad', () {
        final notifier = container.read(storeProvider.notifier);

        final canWatchAd = notifier.canWatchAd;
        expect(canWatchAd, isTrue);
      });

      test('should get time until next ad', () {
        final notifier = container.read(storeProvider.notifier);

        final timeUntilNextAd = notifier.timeUntilNextAd;
        expect(timeUntilNextAd, isNull);
      });
    });

    group('Memory Management', () {
      test('should handle disposal correctly', () {
        final notifier = container.read(storeProvider.notifier);

        notifier.selectCategory(StoreItemCategory.symbol);

        // Dispose the container
        container.dispose();

        // Should throw because notifier is no longer valid
        expect(
          () => notifier.selectCategory(StoreItemCategory.gems),
          throwsException,
        );
      });
    });
  });
}
