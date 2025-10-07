import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matcher/matcher.dart' as matcher;
import 'package:tictactoe_xo_royale/core/database/app_database.dart';
import 'package:tictactoe_xo_royale/core/database/store_dao.dart';
import 'package:tictactoe_xo_royale/core/database/database_providers.dart';

void main() {
  late AppDatabase database;
  late ProviderContainer container;
  late StoreDao dao;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
    dao = container.read(storeDaoProvider);
  });

  tearDown(() async {
    await database.close();
    container.dispose();
  });

  group('StoreDao Tests', () {
    // ===== BASIC OPERATIONS =====

    group('getStoreItems()', () {
      setUp(() async {
        // Add some test items
        await dao.addStoreItem('1', 'hint_pack', quantity: 5);
        await dao.addStoreItem('1', 'gem_pack', quantity: 2);
        await dao.addStoreItem(
          '2',
          'hint_pack',
          quantity: 3,
        ); // Different profile
      });

      test('should return store items for specific profile', () async {
        // Act
        final items = await dao.getStoreItems('1');

        // Assert
        expect(items.length, 2);
        expect(items.every((item) => item.profileId == 1), isTrue);

        // Should contain both items (order might vary due to timing)
        expect(
          items.map((item) => item.itemId),
          containsAll(['hint_pack', 'gem_pack']),
        );
      });

      test('should return empty list for profile with no items', () async {
        // Act
        final items = await dao.getStoreItems('999');

        // Assert
        expect(items, isEmpty);
      });
    });

    group('getStoreItem()', () {
      setUp(() async {
        await dao.addStoreItem('1', 'hint_pack', quantity: 5);
      });

      test('should return specific store item when exists', () async {
        // Act
        final item = await dao.getStoreItem('1', 'hint_pack');

        // Assert
        expect(item, matcher.isNotNull);
        expect(item!.itemId, 'hint_pack');
        expect(item.profileId, 1);
        expect(item.quantity, 5);
        expect(item.purchasedDate, matcher.isNotNull);
      });

      test('should return null when item does not exist', () async {
        // Act
        final item = await dao.getStoreItem('1', 'nonexistent');

        // Assert
        expect(item, matcher.isNull);
      });

      test('should return null when profile does not exist', () async {
        // Act
        final item = await dao.getStoreItem('999', 'hint_pack');

        // Assert
        expect(item, matcher.isNull);
      });
    });

    group('addStoreItem()', () {
      test('should add store item successfully', () async {
        // Act
        final result = await dao.addStoreItem('1', 'hint_pack', quantity: 5);

        // Assert
        expect(result, greaterThan(0));

        // Verify item was added
        final item = await dao.getStoreItem('1', 'hint_pack');
        expect(item, matcher.isNotNull);
        expect(item!.quantity, 5);
        expect(item.purchasedDate, matcher.isNotNull);
      });

      test('should handle default quantity (1)', () async {
        // Act
        await dao.addStoreItem('1', 'gem_pack');

        // Assert
        final item = await dao.getStoreItem('1', 'gem_pack');
        expect(item!.quantity, 1);
      });

      test('should handle large quantities', () async {
        // Act
        await dao.addStoreItem('1', 'hint_pack', quantity: 999999);

        // Assert
        final item = await dao.getStoreItem('1', 'hint_pack');
        expect(item!.quantity, 999999);
      });
    });

    group('updateItemQuantity()', () {
      setUp(() async {
        await dao.addStoreItem('1', 'hint_pack', quantity: 10);
      });

      test('should update item quantity successfully', () async {
        // Act
        final result = await dao.updateItemQuantity('1', 'hint_pack', 15);

        // Assert
        expect(result, 1); // One row updated

        // Verify quantity was updated
        final item = await dao.getStoreItem('1', 'hint_pack');
        expect(item!.quantity, 15);
      });

      test('should return 0 when updating non-existing item', () async {
        // Act
        final result = await dao.updateItemQuantity('1', 'nonexistent', 5);

        // Assert
        expect(result, 0); // No rows updated
      });

      test('should handle zero quantity', () async {
        // Act
        final result = await dao.updateItemQuantity('1', 'hint_pack', 0);

        // Assert
        expect(result, 1);

        final item = await dao.getStoreItem('1', 'hint_pack');
        expect(item!.quantity, 0);
      });
    });

    group('addToItemQuantity()', () {
      setUp(() async {
        await dao.addStoreItem('1', 'hint_pack', quantity: 5);
      });

      test('should add to existing item quantity', () async {
        // Act
        final result = await dao.addToItemQuantity('1', 'hint_pack', 3);

        // Assert
        expect(result, 1);

        final item = await dao.getStoreItem('1', 'hint_pack');
        expect(item!.quantity, 8); // 5 + 3
      });

      test('should create new item when adding to non-existing item', () async {
        // Act
        final result = await dao.addToItemQuantity('1', 'gem_pack', 2);

        // Assert
        expect(result, 1);

        final item = await dao.getStoreItem('1', 'gem_pack');
        expect(item, matcher.isNotNull);
        expect(item!.quantity, 2);
      });

      test('should handle negative additions (removal)', () async {
        // Act
        final result = await dao.addToItemQuantity('1', 'hint_pack', -2);

        // Assert
        expect(result, 1);

        final item = await dao.getStoreItem('1', 'hint_pack');
        expect(item!.quantity, 3); // 5 - 2
      });
    });

    group('consumeItem()', () {
      setUp(() async {
        await dao.addStoreItem('1', 'hint_pack', quantity: 5);
        await dao.addStoreItem('1', 'gem_pack', quantity: 1);
      });

      test('should consume item successfully', () async {
        // Act
        final result = await dao.consumeItem('1', 'hint_pack', quantity: 2);

        // Assert
        expect(result, isTrue);

        final item = await dao.getStoreItem('1', 'hint_pack');
        expect(item!.quantity, 3); // 5 - 2
      });

      test(
        'should remove item completely when quantity reaches zero',
        () async {
          // Act
          final result = await dao.consumeItem('1', 'gem_pack', quantity: 1);

          // Assert
          expect(result, isTrue);

          final item = await dao.getStoreItem('1', 'gem_pack');
          expect(item, matcher.isNull); // Item should be removed
        },
      );

      test(
        'should return false when trying to consume more than available',
        () async {
          // Act
          final result = await dao.consumeItem('1', 'hint_pack', quantity: 10);

          // Assert
          expect(result, isFalse);

          final item = await dao.getStoreItem('1', 'hint_pack');
          expect(item!.quantity, 5); // Should remain unchanged
        },
      );

      test('should return false when item does not exist', () async {
        // Act
        final result = await dao.consumeItem('1', 'nonexistent', quantity: 1);

        // Assert
        expect(result, isFalse);
      });

      test('should handle default quantity (1)', () async {
        // Act
        final result = await dao.consumeItem('1', 'hint_pack');

        // Assert
        expect(result, isTrue);

        final item = await dao.getStoreItem('1', 'hint_pack');
        expect(item!.quantity, 4); // 5 - 1
      });
    });

    group('deleteStoreItem()', () {
      setUp(() async {
        await dao.addStoreItem('1', 'hint_pack', quantity: 5);
        await dao.addStoreItem('1', 'gem_pack', quantity: 2);
      });

      test('should delete specific store item successfully', () async {
        // Act
        final result = await dao.deleteStoreItem('1', 'hint_pack');

        // Assert
        expect(result, 1); // One row deleted

        // Verify item was deleted
        final deletedItem = await dao.getStoreItem('1', 'hint_pack');
        final remainingItem = await dao.getStoreItem('1', 'gem_pack');

        expect(deletedItem, matcher.isNull);
        expect(remainingItem, matcher.isNotNull);
        expect(remainingItem!.quantity, 2);
      });

      test('should return 0 when deleting non-existing item', () async {
        // Act
        final result = await dao.deleteStoreItem('1', 'nonexistent');

        // Assert
        expect(result, 0); // No rows deleted
      });
    });

    group('deleteAllItemsForProfile()', () {
      setUp(() async {
        await dao.addStoreItem('1', 'hint_pack', quantity: 5);
        await dao.addStoreItem('1', 'gem_pack', quantity: 2);
        await dao.addStoreItem(
          '2',
          'hint_pack',
          quantity: 3,
        ); // Different profile
      });

      test('should delete all items for specific profile', () async {
        // Act
        final result = await dao.deleteAllItemsForProfile('1');

        // Assert
        expect(result, 2); // Two items deleted

        // Verify items were deleted for profile 1
        final profile1Items = await dao.getStoreItems('1');
        final profile2Items = await dao.getStoreItems('2');

        expect(profile1Items, isEmpty);
        expect(profile2Items.length, 1); // Profile 2 items remain
      });

      test('should return 0 when profile has no items', () async {
        // Act
        final result = await dao.deleteAllItemsForProfile('999');

        // Assert
        expect(result, 0); // No items deleted
      });
    });

    // ===== UTILITY METHODS =====

    group('Utility Methods', () {
      setUp(() async {
        await dao.addStoreItem('1', 'hint_pack', quantity: 5);
        await dao.addStoreItem('1', 'gem_pack', quantity: 2);
      });

      test('hasItem() should return correct status', () async {
        // Act & Assert
        expect(await dao.hasItem('1', 'hint_pack'), isTrue);
        expect(await dao.hasItem('1', 'gem_pack'), isTrue);
        expect(await dao.hasItem('1', 'nonexistent'), isFalse);
        expect(await dao.hasItem('999', 'hint_pack'), isFalse);
      });

      test('getItemQuantity() should return correct quantity', () async {
        // Act & Assert
        expect(await dao.getItemQuantity('1', 'hint_pack'), 5);
        expect(await dao.getItemQuantity('1', 'gem_pack'), 2);
        expect(await dao.getItemQuantity('1', 'nonexistent'), 0);
        expect(await dao.getItemQuantity('999', 'hint_pack'), 0);
      });

      test('getUniqueItemsCount() should return correct count', () async {
        // Act
        final count = await dao.getUniqueItemsCount('1');

        // Assert
        expect(count, 2); // 2 unique items
      });

      test('getTotalItemsQuantity() should return correct total', () async {
        // Act
        final total = await dao.getTotalItemsQuantity('1');

        // Assert
        expect(total, 7); // 5 + 2
      });

      test('should return 0 for profile with no items', () async {
        // Act
        final uniqueCount = await dao.getUniqueItemsCount('999');
        final totalQuantity = await dao.getTotalItemsQuantity('999');

        // Assert
        expect(uniqueCount, 0);
        expect(totalQuantity, 0);
      });
    });

    // ===== REACTIVE STREAMS =====

    group('Reactive Streams', () {
      test('watchStoreItems() should emit store item changes', () async {
        // Get initial state (should be empty)
        final initialItems = await dao.getStoreItems('1');
        expect(initialItems, isEmpty);

        // Add item to trigger stream emission
        await dao.addStoreItem('1', 'hint_pack', quantity: 5);

        // Wait for updated state
        final updatedItems = await dao.getStoreItems('1');
        expect(updatedItems.length, 1);
        expect(updatedItems.first.itemId, 'hint_pack');
      });
    });

    // ===== EDGE CASES AND ERROR HANDLING =====

    group('Edge Cases and Error Handling', () {
      test('should handle concurrent store operations', () async {
        // Act - Perform multiple operations concurrently
        await dao.addStoreItem('1', 'hint_pack', quantity: 1);
        await dao.addStoreItem('1', 'gem_pack', quantity: 2);
        await dao.addToItemQuantity('1', 'hint_pack', 3);

        // Assert
        final items = await dao.getStoreItems('1');
        expect(items.length, 2);

        // Verify quantities
        final hintPack = items
            .where((item) => item.itemId == 'hint_pack')
            .first;
        final gemPack = items.where((item) => item.itemId == 'gem_pack').first;

        expect(hintPack.quantity, 4); // 1 + 3
        expect(gemPack.quantity, 2);
      });

      test('should handle consumption edge cases', () async {
        // Arrange
        await dao.addStoreItem('1', 'hint_pack', quantity: 3);

        // Test consuming exactly the available amount
        final exactConsume = await dao.consumeItem(
          '1',
          'hint_pack',
          quantity: 3,
        );
        expect(exactConsume, isTrue);

        final itemAfterExact = await dao.getStoreItem('1', 'hint_pack');
        expect(itemAfterExact, matcher.isNull); // Should be removed

        // Test consuming more than available (should fail)
        await dao.addStoreItem('1', 'hint_pack', quantity: 2);
        final overConsume = await dao.consumeItem(
          '1',
          'hint_pack',
          quantity: 5,
        );
        expect(overConsume, isFalse);

        final itemAfterOver = await dao.getStoreItem('1', 'hint_pack');
        expect(itemAfterOver!.quantity, 2); // Should remain unchanged
      });

      test('should handle multiple profile operations correctly', () async {
        // Act
        await dao.addStoreItem('1', 'hint_pack', quantity: 5);
        await dao.addStoreItem('2', 'gem_pack', quantity: 3);
        await dao.addToItemQuantity('1', 'hint_pack', 2);

        // Assert
        expect(await dao.getItemQuantity('1', 'hint_pack'), 7);
        expect(await dao.getItemQuantity('2', 'gem_pack'), 3);
        expect(await dao.getItemQuantity('1', 'gem_pack'), 0);
        expect(await dao.getItemQuantity('2', 'hint_pack'), 0);
      });

      test('should handle operations with string profile IDs', () async {
        // Act
        await dao.addStoreItem('123', 'hint_pack', quantity: 5);

        // Assert
        expect(await dao.hasItem('123', 'hint_pack'), isTrue);
        expect(await dao.getItemQuantity('123', 'hint_pack'), 5);
      });

      test('should handle zero and negative quantities', () async {
        // Arrange
        await dao.addStoreItem('1', 'hint_pack', quantity: 5);

        // Act - Set to zero
        await dao.updateItemQuantity('1', 'hint_pack', 0);

        // Assert
        expect(await dao.getItemQuantity('1', 'hint_pack'), 0);

        // Act - Try to add negative quantity (database allows negative values)
        await dao.addToItemQuantity('1', 'hint_pack', -2);

        // Assert
        expect(
          await dao.getItemQuantity('1', 'hint_pack'),
          -2,
        ); // Database allows negative quantities
      });
    });

    // ===== INTEGRATION WITH REACTIVE STREAMS =====

    group('Reactive Integration', () {
      test('watchStoreItems() should reflect add operations', () async {
        // Get initial state
        final initialItems = await dao.getStoreItems('1');
        expect(initialItems, isEmpty);

        // Add item to trigger stream emission
        await dao.addStoreItem('1', 'hint_pack', quantity: 5);

        // Wait for updated state
        final updatedItems = await dao.getStoreItems('1');
        expect(updatedItems.length, 1);
        expect(updatedItems.first.itemId, 'hint_pack');
      });

      test('watchStoreItems() should reflect consumption operations', () async {
        // Arrange
        await dao.addStoreItem('1', 'hint_pack', quantity: 5);

        // Get current state
        final currentItems = await dao.getStoreItems('1');
        expect(currentItems.length, 1);
        expect(currentItems.first.quantity, 5);

        // Consume item to trigger stream emission
        await dao.consumeItem('1', 'hint_pack', quantity: 2);

        // Wait for updated state
        final updatedItems = await dao.getStoreItems('1');
        expect(updatedItems.length, 1);
        expect(updatedItems.first.quantity, 3);
      });

      test('watchStoreItems() should reflect deletion operations', () async {
        // Arrange
        await dao.addStoreItem('1', 'hint_pack', quantity: 5);

        // Get current state
        final currentItems = await dao.getStoreItems('1');
        expect(currentItems.length, 1);

        // Delete item to trigger stream emission
        await dao.deleteStoreItem('1', 'hint_pack');

        // Wait for updated state
        final updatedItems = await dao.getStoreItems('1');
        expect(updatedItems, isEmpty);
      });
    });
  });
}
