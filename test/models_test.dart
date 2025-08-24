import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/core/models/models.dart';
import 'package:tictactoe_xo_royale/core/models/mock_data.dart';

void main() {
  group('PlayerProfile Model Tests', () {
    test('should create default profile', () {
      final profile = PlayerProfile.defaultProfile();

      expect(profile.id, 'default_user');
      expect(profile.nickname, 'Player');
      expect(profile.gems, 100);
      expect(profile.hints, 5);
      expect(profile.stats.wins, 0);
      expect(profile.stats.losses, 0);
      expect(profile.stats.draws, 0);
      expect(profile.stats.streak, 0);
    });

    test('should calculate computed properties', () {
      final stats = PlayerStats(wins: 10, losses: 5, draws: 2, streak: 3);

      expect(stats.totalGames, 17);
      expect(stats.winRate, closeTo(10 / 17, 0.01));
    });

    test('should serialize and deserialize', () {
      final profile = PlayerProfile.defaultProfile();
      final json = profile.toJson();
      final restored = PlayerProfile.fromJson(json);

      expect(restored, equals(profile));
    });
  });

  group('StoreItem Model Tests', () {
    test('should create store item with correct properties', () {
      final item = StoreItem(
        id: 'test_theme',
        category: StoreItemCategory.theme,
        name: 'Test Theme',
        desc: 'A test theme',
        priceGems: 100,
        premium: false,
        locked: false,
      );

      expect(item.id, 'test_theme');
      expect(item.category, StoreItemCategory.theme);
      expect(item.isPurchasable, true);
      expect(item.isGemPurchase, true);
      expect(item.isRealMoneyPurchase, false);
    });

    test('should handle locked items correctly', () {
      final lockedItem = StoreItem(
        id: 'locked_theme',
        category: StoreItemCategory.theme,
        name: 'Locked Theme',
        desc: 'A locked theme',
        priceGems: 200,
        premium: false,
        locked: true,
      );

      expect(lockedItem.isPurchasable, false);
      expect(lockedItem.isGemPurchase, false);
    });
  });

  group('GameConfig Model Tests', () {
    test('should create default config', () {
      final config = GameConfig.defaultConfig();

      expect(config.mode, GameMode.local);
      expect(config.firstMove, FirstMove.random);
      expect(config.boardSize, 3);
      expect(config.winCondition, 3);
      expect(config.players, ['Player 1', 'Player 2']);
    });

    test('should create CPU config', () {
      final config = GameConfig.cpuConfig(difficulty: Difficulty.hard);

      expect(config.mode, GameMode.cpu);
      expect(config.difficulty, Difficulty.hard);
      expect(config.isCpuMode, true);
      expect(config.isLocalMode, false);
    });

    test('should handle computed properties', () {
      final config = GameConfig.defaultConfig();

      expect(config.hasRandomFirstMove, true);
      expect(config.isLocalMode, true);
    });
  });

  group('GameState Model Tests', () {
    test('should create initial state', () {
      final config = GameConfig.defaultConfig();
      final state = GameState.initial(config);

      expect(state.status, GameStatus.waiting);
      expect(state.board.length, 3);
      expect(state.board[0].length, 3);
      expect(state.currentPlayer, PlayerMark.X);
      expect(state.moveCount, 0);
    });

    test('should handle computed properties', () {
      final config = GameConfig.defaultConfig();
      final state = GameState.initial(config);

      expect(state.isGameOver, false);
      expect(state.isPlaying, false);
      expect(state.totalCells, 9);
      expect(state.filledCells, 0);
      expect(state.isBoardFull, false);
    });
  });

  group('MockData Tests', () {
    test('should provide default profile', () {
      final profile = MockData.defaultProfile;

      expect(profile.id, 'default_user');
      expect(profile.nickname, 'Player');
    });

    test('should provide store items by category', () {
      final themes = MockData.getItemsByCategory(StoreItemCategory.theme);
      final boards = MockData.getItemsByCategory(StoreItemCategory.board);

      expect(themes.length, 4);
      expect(boards.length, 3);
      expect(themes.first.category, StoreItemCategory.theme);
      expect(boards.first.category, StoreItemCategory.board);
    });

    test('should find item by ID', () {
      final item = MockData.getItemById('default_light');

      expect(item, isNotNull);
      expect(item!.name, 'Default Light');
      expect(item.locked, false);
    });
  });
}
