import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/core/models/mock_data.dart';
import 'package:tictactoe_xo_royale/core/models/models.dart';

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
      const stats = PlayerStats(wins: 10, losses: 5, draws: 2, streak: 3);

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
      const item = StoreItem(
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
      const lockedItem = StoreItem(
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
      expect(config.boardSizeValue, equals(3));
      expect(config.winConditionValue, equals(3));
      expect(config.gameMode, GameMode.local);
      expect(config.firstMove, FirstMove.player1);
      expect(config.difficulty, Difficulty.medium);
      expect(config.player1Name, equals('Player 1'));
      expect(config.player2Name, equals('Player 2'));
      expect(config.isRobotMode, isFalse);
    });

    test('should create cpu config', () {
      final config = GameConfig.cpuConfig(difficulty: Difficulty.hard);
      expect(config.boardSizeValue, equals(3));
      expect(config.winConditionValue, equals(3));
      expect(config.gameMode, GameMode.robot);
      expect(config.firstMove, FirstMove.player1);
      expect(config.difficulty, Difficulty.hard);
      expect(config.player1Name, equals('You'));
      expect(config.player2Name, equals('CPU'));
      expect(config.isRobotMode, isTrue);
    });

    test('should copy with new values', () {
      final config = GameConfig.defaultConfig();
      final newConfig = config.copyWith(
        boardSize: BoardSize.fourByFour,
        winCondition: WinCondition.fourInRow,
        player1Name: 'Alice',
        player2Name: 'Bob',
      );

      expect(newConfig.boardSizeValue, equals(4));
      expect(newConfig.winConditionValue, equals(4));
      expect(newConfig.player1Name, equals('Alice'));
      expect(newConfig.player2Name, equals('Bob'));
      expect(newConfig.gameMode, equals(config.gameMode));
      expect(newConfig.firstMove, equals(config.firstMove));
      expect(newConfig.difficulty, equals(config.difficulty));
    });
  });

  group('GameState Model Tests', () {
    test('should create initial state', () {
      final state = GameState.initial(3);

      expect(state.status, GameStatus.waiting);
      expect(state.boardState.length, 3);
      expect(state.boardState[0].length, 3);
      expect(state.currentPlayer, 'X');
      expect(state.player1Wins, 0);
    });

    test('should handle computed properties', () {
      final state = GameState.initial(3);

      expect(state.isGameOver, false);
      expect(state.status, GameStatus.waiting);
      expect(state.boardState.length * state.boardState[0].length, 9);
      expect(
        state.boardState.every((row) => row.every((cell) => cell == null)),
        true,
      );
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
