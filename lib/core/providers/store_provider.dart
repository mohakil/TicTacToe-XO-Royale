import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import 'package:tictactoe_xo_royale/core/models/mock_data.dart';
import 'package:tictactoe_xo_royale/core/models/store_item.dart';
import 'package:tictactoe_xo_royale/core/database/database_providers.dart';
import 'package:tictactoe_xo_royale/core/database/store_dao.dart';

part 'store_provider.g.dart';

// Store state class
@immutable
class StoreState {
  const StoreState({
    required this.items,
    required this.selectedCategory,
    required this.tabIndex,
    required this.isLoading,
    required this.error,
    required this.purchaseHistory,
    required this.watchAdCooldown,
  });

  final List<StoreItem> items;
  final StoreItemCategory selectedCategory;
  final int tabIndex;
  final bool isLoading;
  final String? error;
  final List<String> purchaseHistory;
  final DateTime? watchAdCooldown;

  // Copy with method for immutable updates
  StoreState copyWith({
    List<StoreItem>? items,
    StoreItemCategory? selectedCategory,
    int? tabIndex,
    bool? isLoading,
    String? error,
    List<String>? purchaseHistory,
    DateTime? watchAdCooldown,
    bool clearError = false,
  }) => StoreState(
    items: items ?? this.items,
    selectedCategory: selectedCategory ?? this.selectedCategory,
    tabIndex: tabIndex ?? this.tabIndex,
    isLoading: isLoading ?? this.isLoading,
    error: clearError ? null : (error ?? this.error),
    purchaseHistory: purchaseHistory ?? this.purchaseHistory,
    watchAdCooldown: watchAdCooldown ?? this.watchAdCooldown,
  );

  // Initial state
  factory StoreState.initial() => const StoreState(
    items: [],
    selectedCategory: StoreItemCategory.theme,
    tabIndex: 1, // Start on Cosmetics
    isLoading: true,
    error: null,
    purchaseHistory: [],
    watchAdCooldown: null,
  );

  // Success state
  factory StoreState.success(List<StoreItem> items) => StoreState(
    items: items,
    selectedCategory: StoreItemCategory.theme,
    tabIndex: 1,
    isLoading: false,
    error: null,
    purchaseHistory: const [],
    watchAdCooldown: null,
  );

  // Error state
  factory StoreState.error(String error) => StoreState(
    items: const [],
    selectedCategory: StoreItemCategory.theme,
    tabIndex: 1,
    isLoading: false,
    error: error,
    purchaseHistory: const [],
    watchAdCooldown: null,
  );

  // Loading state
  factory StoreState.loading() => const StoreState(
    items: [],
    selectedCategory: StoreItemCategory.theme,
    tabIndex: 1,
    isLoading: true,
    error: null,
    purchaseHistory: [],
    watchAdCooldown: null,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreState &&
          runtimeType == other.runtimeType &&
          items == other.items &&
          selectedCategory == other.selectedCategory &&
          tabIndex == other.tabIndex &&
          isLoading == other.isLoading &&
          error == other.error &&
          purchaseHistory == other.purchaseHistory &&
          watchAdCooldown == other.watchAdCooldown;

  @override
  int get hashCode => Object.hash(
    runtimeType,
    items,
    selectedCategory,
    tabIndex,
    isLoading,
    error,
    purchaseHistory,
    watchAdCooldown,
  );

  @override
  String toString() =>
      'StoreState(items: ${items.length}, selectedCategory: $selectedCategory, tabIndex: $tabIndex, '
      'isLoading: $isLoading, error: $error, '
      'purchaseHistory: ${purchaseHistory.length}, watchAdCooldown: $watchAdCooldown)';
}

// Store notifier with proper disposal
@Riverpod(keepAlive: true)
class StoreNotifier extends _$StoreNotifier {
  // DAO dependencies (initialized in build method)
  late StoreDao _storeDao;

  @override
  StoreState build() {
    ref.onDispose(() {
      _mounted = false;
    });

    // Initialize DAO from ref
    _storeDao = ref.watch(storeDaoProvider);

    _loadStoreData();
    return StoreState.initial();
  }

  // Mounted flag for proper disposal
  bool _mounted = true;

  // Load store data from database with mounted checks
  Future<void> _loadStoreData() async {
    try {
      state = StoreState.loading();

      // Load purchased items from database
      final purchasedItems = await _storeDao.getStoreItems('default_user');

      // Load watch ad cooldown from database
      // Note: For now, we'll use a simple in-memory approach for watch ad cooldown
      // since it's not stored in the database schema yet
      final watchAdCooldown =
          null; // TODO: Add watch ad cooldown to database schema

      // Load store items from mock data
      final items = MockData.getAllStoreItems();

      // Update unlocked status based on purchased items
      final updatedItems = items.map((item) {
        final isPurchased = purchasedItems.any(
          (purchased) => purchased.itemId == item.id,
        );
        if (isPurchased) {
          return item.copyWith(locked: false);
        }
        return item;
      }).toList();

      // Convert purchased items to purchase history format
      final purchaseHistory = purchasedItems
          .map((item) => item.itemId)
          .toList();

      if (_mounted) {
        state = StoreState(
          items: updatedItems,
          selectedCategory: StoreItemCategory.theme,
          tabIndex: 1,
          isLoading: false,
          error: null,
          purchaseHistory: purchaseHistory,
          watchAdCooldown: watchAdCooldown,
        );
      }
    } on DriftWrappedException catch (e) {
      if (_mounted) {
        debugPrint('Database error while loading store data: ${e.message}');
        throw Exception(
          'Database error while loading store data: ${e.message}',
        );
      }
    } catch (error) {
      if (_mounted) {
        debugPrint('Failed to load store data: $error');
        throw Exception('Store operation failed: $error');
      }
    }
  }

  // Select category with mounted checks
  void selectCategory(StoreItemCategory category) {
    if (state.tabIndex == 0 && category != StoreItemCategory.gems) {
      // If on gems tab, switching category doesn't make sense
      return;
    }
    state = state.copyWith(selectedCategory: category);
  }

  void selectTab(int index) {
    StoreItemCategory newCategory;
    if (index == 0) {
      newCategory = StoreItemCategory.gems;
    } else {
      // Default to theme if was gems
      newCategory = state.selectedCategory == StoreItemCategory.gems
          ? StoreItemCategory.theme
          : state.selectedCategory;
    }
    state = state.copyWith(tabIndex: index, selectedCategory: newCategory);
  }

  // Get items by category
  List<StoreItem> getItemsByCategory(StoreItemCategory category) =>
      state.items.where((item) {
        switch (category) {
          case StoreItemCategory.theme:
            return item.category == StoreItemCategory.theme;
          case StoreItemCategory.board:
            return item.category == StoreItemCategory.board;
          case StoreItemCategory.symbol:
            return item.category == StoreItemCategory.symbol;
          case StoreItemCategory.gems:
            return item.category == StoreItemCategory.gems;
        }
      }).toList();

  // Get unlocked items by category
  List<StoreItem> getUnlockedItemsByCategory(StoreItemCategory category) =>
      state.items
          .where((item) => item.category == category && !item.locked)
          .toList();

  // Get locked items by category
  List<StoreItem> getLockedItemsByCategory(StoreItemCategory category) => state
      .items
      .where((item) => item.category == category && item.locked)
      .toList();

  // Check if item is unlocked
  bool isItemUnlocked(String itemId) => state.purchaseHistory.contains(itemId);

  // Purchase item with gems
  Future<bool> purchaseItem(String itemId, int gemCost) async {
    try {
      // Check if item exists and is locked
      final item = state.items.firstWhere((item) => item.id == itemId);
      if (!item.locked) {
        return false; // Already unlocked
      }

      // Check if user has enough gems (this would be handled by profile provider)
      // For now, we'll assume the purchase is successful

      // Add purchase to database using DAO
      await _storeDao.addStoreItem('default_user', itemId, quantity: 1);

      // Reload store data to get updated state
      await _loadStoreData();
      return true;
    } on DriftWrappedException catch (e) {
      debugPrint('Database error while purchasing item: ${e.message}');
      throw Exception('Database error while purchasing item: ${e.message}');
    } catch (error) {
      debugPrint('Failed to purchase item: $error');
      throw Exception('Store operation failed: $error');
    }
  }

  // Watch ad to earn gems (in-memory for now, not persisted to database)
  Future<bool> watchAd() async {
    try {
      // Check cooldown (5 minutes)
      final now = DateTime.now();
      if (state.watchAdCooldown != null) {
        final timeSinceLastAd = now.difference(state.watchAdCooldown!);
        if (timeSinceLastAd.inMinutes < 5) {
          return false; // Still in cooldown
        }
      }

      // Set new cooldown (in-memory only for now)
      final newCooldown = now;

      if (_mounted) {
        state = state.copyWith(watchAdCooldown: newCooldown);
      }

      // Return true to indicate successful ad watch
      // The actual gem addition would be handled by profile provider
      return true;
    } on Exception catch (e) {
      throw Exception('Store operation failed: $e');
    }
  }

  // Check if can watch ad
  bool get canWatchAd {
    if (state.watchAdCooldown == null) {
      return true;
    }

    final now = DateTime.now();
    final timeSinceLastAd = now.difference(state.watchAdCooldown!);
    return timeSinceLastAd.inMinutes >= 5;
  }

  // Get time until next ad
  Duration? get timeUntilNextAd {
    if (state.watchAdCooldown == null) {
      return null;
    }

    final now = DateTime.now();
    final timeSinceLastAd = now.difference(state.watchAdCooldown!);
    final remainingMinutes = 5 - timeSinceLastAd.inMinutes;

    if (remainingMinutes <= 0) {
      return null;
    }
    return Duration(minutes: remainingMinutes);
  }

  // Refresh store data
  Future<void> refreshStoreData() async {
    await _loadStoreData();
  }

  // Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  // Get current items
  List<StoreItem> get currentItems => state.items;

  // Get current category
  StoreItemCategory get currentCategory => state.selectedCategory;

  // Get items for current category
  List<StoreItem> get currentCategoryItems =>
      getItemsByCategory(state.selectedCategory);

  // Get unlocked items for current category
  List<StoreItem> get currentCategoryUnlockedItems =>
      getUnlockedItemsByCategory(state.selectedCategory);

  // Get locked items for current category
  List<StoreItem> get currentCategoryLockedItems =>
      getLockedItemsByCategory(state.selectedCategory);

  // Check if store is loading
  bool get isLoading => state.isLoading;

  // Check if store has error
  bool get hasError => state.error != null;

  // Get error message
  String? get error => state.error;

  // Get purchase history
  List<String> get purchaseHistory => state.purchaseHistory;

  // Add store item (for testing)
  Future<void> addStoreItem(
    String profileId,
    String itemId, {
    int quantity = 1,
  }) async {
    await _storeDao.addStoreItem(profileId, itemId, quantity: quantity);
    await _loadStoreData();
  }

  // Update item quantity (for testing)
  Future<void> updateItemQuantity(
    String profileId,
    String itemId,
    int quantity,
  ) async {
    await _storeDao.updateItemQuantity(profileId, itemId, quantity);
    await _loadStoreData();
  }

  // Refresh store (for testing)
  Future<void> refreshStore() async {
    await refreshStoreData();
  }
}

// Codegen handles provider with keepAlive: true via annotation

// Individual store data providers for granular rebuilds
final storeItemsProvider = Provider.autoDispose<List<StoreItem>>(
  (ref) => ref.watch(storeProvider.select((state) => state.items)),
);

final storeSelectedCategoryProvider = Provider.autoDispose<StoreItemCategory>(
  (ref) => ref.watch(storeProvider.select((state) => state.selectedCategory)),
);

final storeTabIndexProvider = Provider.autoDispose<int>(
  (ref) => ref.watch(storeProvider.select((state) => state.tabIndex)),
);

final storeIsLoadingProvider = Provider.autoDispose<bool>(
  (ref) => ref.watch(storeProvider.select((state) => state.isLoading)),
);

final storeErrorProvider = Provider.autoDispose<String?>(
  (ref) => ref.watch(storeProvider.select((state) => state.error)),
);

final storePurchaseHistoryProvider = Provider.autoDispose<List<String>>(
  (ref) => ref.watch(storeProvider.select((state) => state.purchaseHistory)),
);

final storeWatchAdCooldownProvider = Provider.autoDispose<DateTime?>(
  (ref) => ref.watch(storeProvider.select((state) => state.watchAdCooldown)),
);

// Category-specific providers using select for better performance
final storeThemesProvider = Provider.autoDispose<List<StoreItem>>((ref) {
  final selectedCategory = ref.watch(
    storeProvider.select((state) => state.selectedCategory),
  );
  final items = ref.watch(storeProvider.select((state) => state.items));

  if (selectedCategory == StoreItemCategory.theme) {
    return items
        .where((item) => item.category == StoreItemCategory.theme)
        .toList();
  }
  return [];
});

final storeBoardDesignsProvider = Provider.autoDispose<List<StoreItem>>((ref) {
  final selectedCategory = ref.watch(
    storeProvider.select((state) => state.selectedCategory),
  );
  final items = ref.watch(storeProvider.select((state) => state.items));

  if (selectedCategory == StoreItemCategory.board) {
    return items
        .where((item) => item.category == StoreItemCategory.board)
        .toList();
  }
  return [];
});

final storeSymbolsProvider = Provider.autoDispose<List<StoreItem>>((ref) {
  final selectedCategory = ref.watch(
    storeProvider.select((state) => state.selectedCategory),
  );
  final items = ref.watch(storeProvider.select((state) => state.items));

  if (selectedCategory == StoreItemCategory.symbol) {
    return items
        .where((item) => item.category == StoreItemCategory.symbol)
        .toList();
  }
  return [];
});

final storeGemsProvider = Provider.autoDispose<List<StoreItem>>((ref) {
  final selectedCategory = ref.watch(
    storeProvider.select((state) => state.selectedCategory),
  );
  final items = ref.watch(storeProvider.select((state) => state.items));

  if (selectedCategory == StoreItemCategory.gems) {
    return items
        .where((item) => item.category == StoreItemCategory.gems)
        .toList();
  }
  return [];
});

// Computed providers using select for better performance
final storeCanWatchAdProvider = Provider.autoDispose<bool>((ref) {
  final cooldown = ref.watch(
    storeProvider.select((state) => state.watchAdCooldown),
  );
  if (cooldown == null) {
    return true;
  }

  final now = DateTime.now();
  final timeSinceLastAd = now.difference(cooldown);
  return timeSinceLastAd.inMinutes >= 5;
});

final storeTimeUntilNextAdProvider = Provider.autoDispose<Duration?>((ref) {
  final cooldown = ref.watch(
    storeProvider.select((state) => state.watchAdCooldown),
  );
  if (cooldown == null) {
    return null;
  }

  final now = DateTime.now();
  final timeSinceLastAd = now.difference(cooldown);
  final remainingMinutes = 5 - timeSinceLastAd.inMinutes;

  if (remainingMinutes <= 0) {
    return null;
  }
  return Duration(minutes: remainingMinutes);
});

final storeCurrentCategoryItemsProvider = Provider.autoDispose<List<StoreItem>>(
  (ref) {
    final tabIndex = ref.watch(storeTabIndexProvider);
    final selectedCategory = ref.watch(
      storeProvider.select((state) => state.selectedCategory),
    );
    final items = ref.watch(storeProvider.select((state) => state.items));

    final effectiveCategory = tabIndex == 0
        ? StoreItemCategory.gems
        : selectedCategory;
    return items.where((item) => item.category == effectiveCategory).toList();
  },
);

final storeCurrentCategoryUnlockedItemsProvider =
    Provider.autoDispose<List<StoreItem>>((ref) {
      final tabIndex = ref.watch(storeTabIndexProvider);
      final selectedCategory = ref.watch(
        storeProvider.select((state) => state.selectedCategory),
      );
      final items = ref.watch(storeProvider.select((state) => state.items));

      final effectiveCategory = tabIndex == 0
          ? StoreItemCategory.gems
          : selectedCategory;
      return items
          .where((item) => item.category == effectiveCategory && !item.locked)
          .toList();
    });

final storeCurrentCategoryLockedItemsProvider =
    Provider.autoDispose<List<StoreItem>>((ref) {
      final tabIndex = ref.watch(storeTabIndexProvider);
      final selectedCategory = ref.watch(
        storeProvider.select((state) => state.selectedCategory),
      );
      final items = ref.watch(storeProvider.select((state) => state.items));

      final effectiveCategory = tabIndex == 0
          ? StoreItemCategory.gems
          : selectedCategory;
      return items
          .where((item) => item.category == effectiveCategory && item.locked)
          .toList();
    });

// Extension methods for easy access with select-based providers
extension StoreProviderExtension on WidgetRef {
  // Get store notifier
  StoreNotifier get storeNotifier => read(storeProvider.notifier);

  // Get individual store data using select for granular rebuilds
  List<StoreItem> get storeItems => watch(storeItemsProvider);
  StoreItemCategory get storeSelectedCategory =>
      watch(storeSelectedCategoryProvider);
  int get storeTabIndex => watch(storeTabIndexProvider);
  bool get storeIsLoading => watch(storeIsLoadingProvider);
  String? get storeError => watch(storeErrorProvider);
  List<String> get storePurchaseHistory => watch(storePurchaseHistoryProvider);
  DateTime? get storeWatchAdCooldown => watch(storeWatchAdCooldownProvider);

  // Get category-specific items
  List<StoreItem> get storeThemes => watch(storeThemesProvider);
  List<StoreItem> get storeBoardDesigns => watch(storeBoardDesignsProvider);
  List<StoreItem> get storeSymbols => watch(storeSymbolsProvider);
  List<StoreItem> get storeGems => watch(storeGemsProvider);

  // Get computed store data
  bool get storeCanWatchAd => watch(storeCanWatchAdProvider);
  Duration? get storeTimeUntilNextAd => watch(storeTimeUntilNextAdProvider);
  List<StoreItem> get storeCurrentCategoryItems =>
      watch(storeCurrentCategoryItemsProvider);
  List<StoreItem> get storeCurrentCategoryUnlockedItems =>
      watch(storeCurrentCategoryUnlockedItemsProvider);
  List<StoreItem> get storeCurrentCategoryLockedItems =>
      watch(storeCurrentCategoryLockedItemsProvider);

  // Get all store state
  StoreState get storeState => watch(storeProvider);
}

// Extension methods for BuildContext with proper error handling
extension StoreContextExtension on BuildContext {
  // Get store state from provider with error handling
  StoreState? get storeState {
    try {
      return ProviderScope.containerOf(this).read(storeProvider);
    } catch (e) {
      debugPrint('Failed to read store state: $e');
      return null;
    }
  }
}
