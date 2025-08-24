import 'package:json_annotation/json_annotation.dart';

part 'game_config.g.dart';

enum GameMode { local, cpu }

enum FirstMove { X, O, random }

enum Difficulty { easy, medium, hard }

@JsonSerializable()
class GameConfig {
  const GameConfig({
    required this.mode,
    required this.firstMove,
    this.difficulty,
    required this.boardSize,
    required this.winCondition,
    required this.players,
  });

  final GameMode mode;
  final FirstMove firstMove;
  final Difficulty? difficulty;
  final int boardSize;
  final int winCondition;
  final List<String> players;

  factory GameConfig.fromJson(Map<String, dynamic> json) =>
      _$GameConfigFromJson(json);

  Map<String, dynamic> toJson() => _$GameConfigToJson(this);

  factory GameConfig.defaultConfig() => const GameConfig(
    mode: GameMode.local,
    firstMove: FirstMove.random,
    boardSize: 3,
    winCondition: 3,
    players: ['Player 1', 'Player 2'],
  );

  factory GameConfig.cpuConfig({
    Difficulty difficulty = Difficulty.medium,
    int boardSize = 3,
    int winCondition = 3,
  }) => GameConfig(
    mode: GameMode.cpu,
    firstMove: FirstMove.random,
    difficulty: difficulty,
    boardSize: boardSize,
    winCondition: winCondition,
    players: ['Player', 'Computer'],
  );

  bool get isCpuMode => mode == GameMode.cpu;
  bool get isLocalMode => mode == GameMode.local;
  bool get hasRandomFirstMove => firstMove == FirstMove.random;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameConfig &&
          runtimeType == other.runtimeType &&
          mode == other.mode &&
          firstMove == other.firstMove &&
          difficulty == other.difficulty &&
          boardSize == other.boardSize &&
          winCondition == other.winCondition &&
          players == other.players;

  @override
  int get hashCode => Object.hash(
    runtimeType,
    mode,
    firstMove,
    difficulty,
    boardSize,
    winCondition,
    players,
  );

  @override
  String toString() =>
      'GameConfig(mode: $mode, firstMove: $firstMove, difficulty: $difficulty, boardSize: $boardSize, winCondition: $winCondition, players: $players)';
}
