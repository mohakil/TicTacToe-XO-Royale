import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tictactoe_xo_royale/core/models/game_enums.dart';
import 'package:tictactoe_xo_royale/core/models/robot_config.dart';

part 'setup_provider.g.dart';

/// Simplified game setup state
class GameSetup {
  static const String defaultLocalPlayerName = 'Player 2';

  final GameMode mode;
  final String player1Name;
  final String player2Name;
  final String localPlayer2Name;
  final String robotPlayerName;
  final FirstMove firstMove;
  final Difficulty difficulty;
  final BoardSize boardSize;
  final WinCondition winCondition;

  const GameSetup({
    this.mode = GameMode.local,
    this.player1Name = 'Player 1',
    this.player2Name = defaultLocalPlayerName,
    this.localPlayer2Name = defaultLocalPlayerName,
    this.robotPlayerName = RobotConfig.defaultPlayerName,
    this.firstMove = FirstMove.random,
    this.difficulty = Difficulty.medium,
    this.boardSize = BoardSize.threeByThree,
    this.winCondition = WinCondition.threeInRow,
  });

  GameSetup copyWith({
    GameMode? mode,
    String? player1Name,
    String? player2Name,
    String? localPlayer2Name,
    String? robotPlayerName,
    FirstMove? firstMove,
    Difficulty? difficulty,
    BoardSize? boardSize,
    WinCondition? winCondition,
  }) {
    return GameSetup(
      mode: mode ?? this.mode,
      player1Name: player1Name ?? this.player1Name,
      player2Name: player2Name ?? this.player2Name,
      localPlayer2Name: localPlayer2Name ?? this.localPlayer2Name,
      robotPlayerName: robotPlayerName ?? this.robotPlayerName,
      firstMove: firstMove ?? this.firstMove,
      difficulty: difficulty ?? this.difficulty,
      boardSize: boardSize ?? this.boardSize,
      winCondition: winCondition ?? this.winCondition,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameSetup &&
        other.mode == mode &&
        other.player1Name == player1Name &&
        other.player2Name == player2Name &&
        other.localPlayer2Name == localPlayer2Name &&
        other.robotPlayerName == robotPlayerName &&
        other.firstMove == firstMove &&
        other.difficulty == difficulty &&
        other.boardSize == boardSize &&
        other.winCondition == winCondition;
  }

  @override
  int get hashCode => Object.hash(
    mode,
    player1Name,
    player2Name,
    localPlayer2Name,
    robotPlayerName,
    firstMove,
    difficulty,
    boardSize,
    winCondition,
  );
}

/// Simplified setup notifier without over-engineering
@riverpod
class SetupNotifier extends _$SetupNotifier {
  @override
  GameSetup build() => const GameSetup();

  void setMode(GameMode mode) {
    if (state.mode == mode) return;

    if (mode == GameMode.robot) {
      final localSnapshot = state.player2Name.trim().isEmpty
          ? GameSetup.defaultLocalPlayerName
          : state.player2Name;
      // Set robot name based on current difficulty
      final robotName = _getRobotNameForDifficulty(state.difficulty);

      state = state.copyWith(
        mode: GameMode.robot,
        localPlayer2Name: localSnapshot,
        player2Name: robotName,
        robotPlayerName: robotName,
      );
      return;
    }

    final restoredLocalName = state.localPlayer2Name.trim().isEmpty
        ? GameSetup.defaultLocalPlayerName
        : state.localPlayer2Name;

    state = state.copyWith(
      mode: GameMode.local,
      player2Name: restoredLocalName,
      localPlayer2Name: restoredLocalName,
    );
  }

  void setPlayer1Name(String name) {
    if (name.trim().isNotEmpty) {
      state = state.copyWith(player1Name: name.trim());
    }
  }

  void setPlayer2Name(String name) {
    final trimmedName = name.trim();

    // In robot mode, player2 name is auto-generated and not editable
    if (state.mode == GameMode.robot) {
      // Ignore manual changes in robot mode
      return;
    }

    state = state.copyWith(
      player2Name: trimmedName,
      localPlayer2Name: trimmedName,
    );
  }

  void setFirstMove(FirstMove firstMove) {
    state = state.copyWith(firstMove: firstMove);
  }

  void setDifficulty(Difficulty difficulty) {
    state = state.copyWith(difficulty: difficulty);

    // Update robot name when difficulty changes in robot mode
    if (state.mode == GameMode.robot) {
      final robotName = _getRobotNameForDifficulty(difficulty);
      state = state.copyWith(
        player2Name: robotName,
        robotPlayerName: robotName,
      );
    }
  }

  void setBoardSize(BoardSize boardSize) {
    state = state.copyWith(boardSize: boardSize);

    // Auto-adjust win condition if invalid
    if (!state.winCondition.isValidForBoardSize(boardSize)) {
      final newWinCondition = _getValidWinCondition(boardSize);
      state = state.copyWith(winCondition: newWinCondition);
    }
  }

  void setWinCondition(WinCondition winCondition) {
    if (winCondition.isValidForBoardSize(state.boardSize)) {
      state = state.copyWith(winCondition: winCondition);
    }
  }

  /// Get a valid win condition for the given board size
  WinCondition _getValidWinCondition(BoardSize boardSize) {
    switch (boardSize) {
      case BoardSize.threeByThree:
        return WinCondition.threeInRow;
      case BoardSize.fourByFour:
        return WinCondition.threeInRow;
      case BoardSize.fiveByFive:
        return WinCondition.threeInRow;
    }
  }

  /// Check if the current setup is valid
  bool get isValid {
    if (state.player1Name.trim().isEmpty) return false;
    if (state.mode == GameMode.local && state.player2Name.trim().isEmpty) {
      return false;
    }
    return state.winCondition.isValidForBoardSize(state.boardSize);
  }

  /// Get robot configuration if in robot mode
  RobotConfig? get robotConfig {
    if (state.mode == GameMode.robot) {
      final robotName = _getRobotNameForDifficulty(state.difficulty);
      return RobotConfig.custom(
        difficulty: state.difficulty,
        playerName: robotName,
      );
    }
    return null;
  }

  /// Get robot name based on difficulty
  String _getRobotNameForDifficulty(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return 'Robot Easy';
      case Difficulty.medium:
        return 'Robot Medium';
      case Difficulty.hard:
        return 'Robot Hard';
    }
  }

  /// Get the display name for player 2 - always use the actual player name
  String get player2DisplayName {
    return state.player2Name;
  }

  /// Check if player 2 name is editable - only in local mode
  bool get isPlayer2NameEditable {
    return state.mode == GameMode.local;
  }

  /// Reset to default values
  void reset() {
    state = const GameSetup();
  }

  @override
  bool updateShouldNotify(GameSetup previous, GameSetup next) =>
      previous != next;
}

/// Computed provider for validation
final setupIsValidProvider = Provider<bool>((ref) {
  final state = ref.watch(setupProvider);
  if (state.player1Name.trim().isEmpty) return false;
  if (state.mode == GameMode.local && state.player2Name.trim().isEmpty) {
    return false;
  }
  return state.winCondition.isValidForBoardSize(state.boardSize);
});

/// Computed provider for robot configuration
final setupRobotConfigProvider = Provider<RobotConfig?>((ref) {
  final state = ref.watch(setupProvider);
  if (state.mode == GameMode.robot) {
    final robotName = _getRobotNameForDifficulty(state.difficulty);
    return RobotConfig.custom(
      difficulty: state.difficulty,
      playerName: robotName,
    );
  }
  return null;
});

/// Extension for easy access to setup data
extension SetupProviderExtension on WidgetRef {
  SetupNotifier get setupNotifier => read(setupProvider.notifier);
  GameSetup get setupState => watch(setupProvider);
  bool get setupIsValid => watch(setupIsValidProvider);
  RobotConfig? get setupRobotConfig => watch(setupRobotConfigProvider);
}

/// Helper function to get robot name based on difficulty
String _getRobotNameForDifficulty(Difficulty difficulty) {
  switch (difficulty) {
    case Difficulty.easy:
      return 'Robot Easy';
    case Difficulty.medium:
      return 'Robot Medium';
    case Difficulty.hard:
      return 'Robot Hard';
  }
}
