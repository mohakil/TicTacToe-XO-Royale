import 'package:tictactoe_xo_royale/core/models/models.dart';

class MockData {
  static final List<StoreItem> themes = [
    const StoreItem(
      id: 'default_light',
      category: StoreItemCategory.theme,
      name: 'Default Light',
      desc: 'Clean and modern light theme',
      premium: false,
      locked: false,
    ),
    const StoreItem(
      id: 'default_dark',
      category: StoreItemCategory.theme,
      name: 'Default Dark',
      desc: 'Elegant dark theme for night gaming',
      premium: false,
      locked: false,
    ),
    const StoreItem(
      id: 'neon_nights',
      category: StoreItemCategory.theme,
      name: 'Neon Nights',
      desc: 'Vibrant neon theme with glowing effects',
      priceGems: 300,
      premium: false,
      locked: true,
    ),
    const StoreItem(
      id: 'retro_glow',
      category: StoreItemCategory.theme,
      name: 'Retro Glow',
      desc: 'Nostalgic retro theme with warm glow',
      priceReal: 2.99,
      premium: true,
      locked: true,
    ),
  ];

  static final List<StoreItem> boardDesigns = [
    const StoreItem(
      id: 'minimal_grid',
      category: StoreItemCategory.board,
      name: 'Minimal Grid',
      desc: 'Clean and simple grid design',
      premium: false,
      locked: true,
    ),
    const StoreItem(
      id: 'holo_lines',
      category: StoreItemCategory.board,
      name: 'Holo Lines',
      desc: 'Holographic lines with depth effect',
      priceGems: 200,
      premium: false,
      locked: true,
    ),
    const StoreItem(
      id: 'chalkboard',
      category: StoreItemCategory.board,
      name: 'Chalkboard',
      desc: 'Classic chalkboard style',
      priceGems: 150,
      premium: false,
      locked: true,
    ),
  ];

  static final List<StoreItem> symbols = [
    const StoreItem(
      id: 'solid_sora',
      category: StoreItemCategory.symbol,
      name: 'Solid Sora',
      desc: 'Bold solid X and O symbols',
      premium: false,
      locked: true,
    ),
    const StoreItem(
      id: 'outline_neon',
      category: StoreItemCategory.symbol,
      name: 'Outline Neon',
      desc: 'Neon outline symbols with glow',
      priceGems: 120,
      premium: false,
      locked: true,
    ),
    const StoreItem(
      id: '3d_gel',
      category: StoreItemCategory.symbol,
      name: '3D Gel',
      desc: 'Realistic 3D gel effect symbols',
      priceReal: 1.99,
      premium: true,
      locked: true,
    ),
  ];

  static final List<StoreItem> gemPackages = [
    const StoreItem(
      id: 'gems_100',
      category: StoreItemCategory.gems,
      name: '100 Gems',
      desc: 'Starter gem package',
      priceReal: 0.99,
      premium: false,
      locked: false,
    ),
    const StoreItem(
      id: 'gems_500',
      category: StoreItemCategory.gems,
      name: '500 Gems',
      desc: 'Popular gem package',
      priceReal: 3.99,
      premium: false,
      locked: false,
    ),
    const StoreItem(
      id: 'gems_1200',
      category: StoreItemCategory.gems,
      name: '1200 Gems',
      desc: 'Best value gem package',
      priceReal: 7.99,
      premium: false,
      locked: false,
    ),
  ];

  static final PlayerProfile defaultProfile = PlayerProfile.defaultProfile();

  static final List<GameConfig> defaultConfigs = [
    GameConfig.defaultConfig(),
    GameConfig.cpuConfig(difficulty: Difficulty.easy),
    GameConfig.cpuConfig(difficulty: Difficulty.medium),
    GameConfig.cpuConfig(difficulty: Difficulty.hard),
  ];

  static List<StoreItem> getAllStoreItems() => [
    ...themes,
    ...boardDesigns,
    ...symbols,
    ...gemPackages,
  ];

  static List<StoreItem> getItemsByCategory(StoreItemCategory category) {
    switch (category) {
      case StoreItemCategory.theme:
        return themes;
      case StoreItemCategory.board:
        return boardDesigns;
      case StoreItemCategory.symbol:
        return symbols;
      case StoreItemCategory.gems:
        return gemPackages;
    }
  }

  static StoreItem? getItemById(String id) {
    final allItems = getAllStoreItems();
    try {
      return allItems.firstWhere((item) => item.id == id);
    } on Exception {
      return null;
    }
  }
}
