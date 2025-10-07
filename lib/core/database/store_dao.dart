import 'package:drift/drift.dart';
import 'app_database.dart';

part 'store_dao.g.dart';

// ===== STORE DAO =====

@DriftAccessor(tables: [StoreItems])
class StoreDao extends DatabaseAccessor<AppDatabase> with _$StoreDaoMixin {
  StoreDao(super.db);

  // ===== STORE ITEM OPERATIONS =====

  /// Get all store items for a profile
  Future<List<StoreItem>> getStoreItems(String profileId) {
    // For now, we'll use a simple approach - assume 'default_user' corresponds to ID 1
    final intId = profileId == 'default_user' ? 1 : int.parse(profileId);

    return (select(storeItems)
          ..where((s) => s.profileId.equals(intId))
          ..orderBy([(s) => OrderingTerm.desc(s.purchasedDate)]))
        .get();
  }

  /// Watch store items for a profile reactively
  Stream<List<StoreItem>> watchStoreItems(String profileId) {
    // For now, we'll use a simple approach - assume 'default_user' corresponds to ID 1
    final intId = profileId == 'default_user' ? 1 : int.parse(profileId);

    return (select(storeItems)
          ..where((s) => s.profileId.equals(intId))
          ..orderBy([(s) => OrderingTerm.desc(s.purchasedDate)]))
        .watch();
  }

  /// Get a specific store item for a profile
  Future<StoreItem?> getStoreItem(String profileId, String itemId) {
    // For now, we'll use a simple approach - assume 'default_user' corresponds to ID 1
    final intId = profileId == 'default_user' ? 1 : int.parse(profileId);

    return (select(storeItems)
          ..where((s) => s.profileId.equals(intId) & s.itemId.equals(itemId)))
        .getSingleOrNull();
  }

  /// Add a store item (purchase)
  Future<int> addStoreItem(
    String profileId,
    String itemId, {
    int quantity = 1,
  }) {
    // For now, we'll use a simple approach - assume 'default_user' corresponds to ID 1
    final intId = profileId == 'default_user' ? 1 : int.parse(profileId);

    return into(storeItems).insert(
      StoreItemsCompanion(
        profileId: Value(intId),
        itemId: Value(itemId),
        quantity: Value(quantity),
        purchasedDate: Value(DateTime.now()),
      ),
    );
  }

  /// Update item quantity (add or set)
  Future<int> updateItemQuantity(
    String profileId,
    String itemId,
    int quantity,
  ) {
    // For now, we'll use a simple approach - assume 'default_user' corresponds to ID 1
    final intId = profileId == 'default_user' ? 1 : int.parse(profileId);

    return (update(storeItems)
          ..where((s) => s.profileId.equals(intId) & s.itemId.equals(itemId)))
        .write(StoreItemsCompanion(quantity: Value(quantity)));
  }

  /// Add to existing item quantity
  Future<int> addToItemQuantity(
    String profileId,
    String itemId,
    int additionalQuantity,
  ) async {
    final existing = await getStoreItem(profileId, itemId);
    if (existing == null) {
      // Item doesn't exist, create it
      await addStoreItem(profileId, itemId, quantity: additionalQuantity);
      return 1;
    } else {
      // Item exists, update quantity
      final newQuantity = existing.quantity + additionalQuantity;
      return await updateItemQuantity(profileId, itemId, newQuantity);
    }
  }

  /// Remove from item quantity (consume item)
  Future<bool> consumeItem(
    String profileId,
    String itemId, {
    int quantity = 1,
  }) async {
    final existing = await getStoreItem(profileId, itemId);
    if (existing == null || existing.quantity < quantity) {
      return false; // Not enough items or item doesn't exist
    }

    final newQuantity = existing.quantity - quantity;
    if (newQuantity <= 0) {
      // Remove item completely
      await deleteStoreItem(profileId, itemId);
      return true;
    } else {
      // Update quantity
      await updateItemQuantity(profileId, itemId, newQuantity);
      return true;
    }
  }

  /// Delete a specific store item
  Future<int> deleteStoreItem(String profileId, String itemId) {
    // For now, we'll use a simple approach - assume 'default_user' corresponds to ID 1
    final intId = profileId == 'default_user' ? 1 : int.parse(profileId);

    return (delete(
      storeItems,
    )..where((s) => s.profileId.equals(intId) & s.itemId.equals(itemId))).go();
  }

  /// Delete all store items for a profile
  Future<int> deleteAllItemsForProfile(String profileId) {
    // For now, we'll use a simple approach - assume 'default_user' corresponds to ID 1
    final intId = profileId == 'default_user' ? 1 : int.parse(profileId);

    return (delete(storeItems)..where((s) => s.profileId.equals(intId))).go();
  }

  /// Check if profile has item
  Future<bool> hasItem(String profileId, String itemId) async {
    final item = await getStoreItem(profileId, itemId);
    return item != null;
  }

  /// Get item quantity
  Future<int> getItemQuantity(String profileId, String itemId) async {
    final item = await getStoreItem(profileId, itemId);
    return item?.quantity ?? 0;
  }

  /// Get total unique items count for a profile
  Future<int> getUniqueItemsCount(String profileId) async {
    final items = await getStoreItems(profileId);
    return items.length;
  }

  /// Get total items quantity for a profile (sum of all quantities)
  Future<int> getTotalItemsQuantity(String profileId) async {
    final items = await getStoreItems(profileId);
    return items
        .map((item) => item.quantity)
        .fold<int>(0, (previous, element) => previous + element);
  }
}
