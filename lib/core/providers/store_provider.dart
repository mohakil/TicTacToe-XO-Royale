import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictactoe_xo_royale/core/models/mock_data.dart';
import 'package:tictactoe_xo_royale/core/models/store_item.dart';

// Store state class
@immutable
class StoreState {
  const StoreState({
    required this.items,
    required this.selectedCategory,
    required this.isLoading,
    required this.error,
    required this.purchaseHistory,
    required this.watchAdCooldown,
  });

  final List<StoreItem> items;
  final StoreItemCategory selectedCategory;
  final bool isLoading;
  final String? error;
  final List<String> purchaseHistory;
  final DateTime? watchAdCooldown;

  // Copy with method for immutable updates
  StoreState copyWith({
    List<StoreItem>? items,
    StoreItemCategory? selectedCategory,
    bool? isLoading,
    String? error,
    List<String>? purchaseHistory,
    DateTime? watchAdCooldown,
    bool clearError = false,
  }) => StoreState(
    items: items ?? this.items,
    selectedCategory: selectedCategory ?? this.selectedCategory,
    isLoading: isLoading ?? this.isLoading,
    error: clearError ? null : (error ?? this.error),
    purchaseHistory: purchaseHistory ?? this.purchaseHistory,
    watchAdCooldown: watchAdCooldown ?? this.watchAdCooldown,
  );

  // Initial state
  factory StoreState.initial() => const StoreState(
    items: [],
    selectedCategory: StoreItemCategory.theme,
    isLoading: true,
    error: null,
    purchaseHistory: [],
    watchAdCooldown: null,
  );

  // Success state
  factory StoreState.success(List<StoreItem> items) => StoreState(
    items: items,
    selectedCategory: StoreItemCategory.theme,
    isLoading: false,
    error: null,
    purchaseHistory: const [],
    watchAdCooldown: null,
  );

  // Error state
  factory StoreState.error(String error) => StoreState(
    items: const [],
    selectedCategory: StoreItemCategory.theme,
    isLoading: false,
    error: error,
    purchaseHistory: const [],
    watchAdCooldown: null,
  );

  // Loading state
  factory StoreState.loading() => const StoreState(
    items: [],
    selectedCategory: StoreItemCategory.theme,
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
          isLoading == other.isLoading &&
          error == other.error &&
          purchaseHistory == other.purchaseHistory &&
          watchAdCooldown == other.watchAdCooldown;

  @override
  int get hashCode => Object.hash(
    runtimeType,
    items,
    selectedCategory,
    isLoading,
    error,
    purchaseHistory,
    watchAdCooldown,
  );

  @override
  String toString() =>
      'StoreState(items: ${items.length}, selectedCategory: $selectedCategory, '
      'isLoading: $isLoading, error: $error, '
      'purchaseHistory: ${purchaseHistory.length}, watchAdCooldown: $watchAdCooldown)';
}

// Store notifier with proper disposal
class StoreNotifier extends StateNotifier<StoreState> {
  StoreNotifier() : super(StoreState.initial()) {
    _loadStoreData();
  }

  static const String _purchaseHistoryKey = 'purchase_history';
  static const String _watchAdCooldownKey = 'watch_ad_cooldown';

  // Mounted flag for proper disposal
  bool _mounted = true;

  // Load store data from storage with mounted checks
  Future<void> _loadStoreData() async {
    try {
      if (_mounted) {
        state = StoreState.loading();
      }

      final prefs = await SharedPreferences.getInstance();

      // Load purchase history
      final purchaseHistoryJson =
          prefs.getStringList(_purchaseHistoryKey) ?? [];

      // Load watch ad cooldown
      final watchAdCooldownTimestamp = prefs.getInt(_watchAdCooldownKey);
      final watchAdCooldown = watchAdCooldownTimestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(watchAdCooldownTimestamp)
          : null;

      // Load store items from mock data
      final items = MockData.getAllStoreItems();

      // Update unlocked status based on purchase history
      final updatedItems = items.map((item) {
        if (purchaseHistoryJson.contains(item.id)) {
          return item.copyWith(locked: false);
        }
        return item;
      }).toList();

      if (_mounted) {
        state = StoreState(
          items: updatedItems,
          selectedCategory: StoreItemCategory.theme,
          isLoading: false,
          error: null,
          purchaseHistory: purchaseHistoryJson,
          watchAdCooldown: watchAdCooldown,
        );
      }
    } on Exception catch (e) {
      if (_mounted) {
        state = StoreState.error('Failed to load store data: $e');
      }
    }
  }

  // Save purchase history to storage with mounted checks
  Future<void> _savePurchaseHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_purchaseHistoryKey, state.purchaseHistory);
    } on Exception catch (e) {
      if (_mounted) {
        state = state.copyWith(error: 'Failed to save purchase history: $e');
      }
    }
  }

  // Save watch ad cooldown to storage with mounted checks
  Future<void> _saveWatchAdCooldown() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (state.watchAdCooldown != null) {
        await prefs.setInt(
          _watchAdCooldownKey,
          state.watchAdCooldown!.millisecondsSinceEpoch,
        );
      } else {
        await prefs.remove(_watchAdCooldownKey);
      }
    } on Exception catch (e) {
      if (_mounted) {
        state = state.copyWith(error: 'Failed to save watch ad cooldown: $e');
      }
    }
  }

  // Select category with mounted checks
  void selectCategory(StoreItemCategory category) {
    if (_mounted) {
      state = state.copyWith(selectedCategory: category);
    }
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

      // Add to purchase history
      final newPurchaseHistory = List<String>.from(state.purchaseHistory)
        ..add(itemId);

      // Update item locked status
      final updatedItems = state.items.map((item) {
        if (item.id == itemId) {
          return item.copyWith(locked: false);
        }
        return item;
      }).toList();

      state = state.copyWith(
        items: updatedItems,
        purchaseHistory: newPurchaseHistory,
      );

      await _savePurchaseHistory();
      return true;
    } on Exception catch (e) {
      state = state.copyWith(error: 'Failed to purchase item: $e');
      return false;
    }
  }

  // Watch ad to earn gems
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

      // Set new cooldown
      final newCooldown = now;

      state = state.copyWith(watchAdCooldown: newCooldown);
      await _saveWatchAdCooldown();

      // Return true to indicate successful ad watch
      // The actual gem addition would be handled by profile provider
      return true;
    } on Exception catch (e) {
      state = state.copyWith(error: 'Failed to watch ad: $e');
      return false;
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

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}

// ✅ OPTIMIZED: Main store provider with AutoDispose for better lifecycle management
final storeProvider =
    StateNotifierProvider.autoDispose<StoreNotifier, StoreState>(
      (ref) => StoreNotifier(),
    );

// ✅ OPTIMIZED: Use select for granular rebuilds instead of individual providers
// Individual store data providers for granular rebuilds
final storeItemsProvider = Provider.autoDispose<List<StoreItem>>(
  (ref) => ref.watch(storeProvider.select((state) => state.items)),
);

final storeSelectedCategoryProvider = Provider.autoDispose<StoreItemCategory>(
  (ref) => ref.watch(storeProvider.select((state) => state.selectedCategory)),
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

// ✅ OPTIMIZED: Category-specific providers using select for better performance
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

// ✅ OPTIMIZED: Computed providers using select for better performance
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
    final selectedCategory = ref.watch(
      storeProvider.select((state) => state.selectedCategory),
    );
    final items = ref.watch(storeProvider.select((state) => state.items));

    return items.where((item) => item.category == selectedCategory).toList();
  },
);

final storeCurrentCategoryUnlockedItemsProvider =
    Provider.autoDispose<List<StoreItem>>((ref) {
      final selectedCategory = ref.watch(
        storeProvider.select((state) => state.selectedCategory),
      );
      final items = ref.watch(storeProvider.select((state) => state.items));

      return items
          .where((item) => item.category == selectedCategory && !item.locked)
          .toList();
    });

final storeCurrentCategoryLockedItemsProvider =
    Provider.autoDispose<List<StoreItem>>((ref) {
      final selectedCategory = ref.watch(
        storeProvider.select((state) => state.selectedCategory),
      );
      final items = ref.watch(storeProvider.select((state) => state.items));

      return items
          .where((item) => item.category == selectedCategory && item.locked)
          .toList();
    });

// ✅ OPTIMIZED: Extension methods for easy access with select-based providers
extension StoreProviderExtension on WidgetRef {
  // Get store notifier
  StoreNotifier get storeNotifier => read(storeProvider.notifier);

  // Get individual store data using select for granular rebuilds
  List<StoreItem> get storeItems => watch(storeItemsProvider);
  StoreItemCategory get storeSelectedCategory =>
      watch(storeSelectedCategoryProvider);
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

// ✅ OPTIMIZED: Extension methods for BuildContext with proper error handling
extension StoreContextExtension on BuildContext {
  // Get store state from provider with error handling
  StoreState? get storeState {
    try {
      return ProviderScope.containerOf(this).read(storeProvider);
    } on Exception catch (e) {
      debugPrint('Failed to read store state: $e');
      return null;
    }
  }
}
