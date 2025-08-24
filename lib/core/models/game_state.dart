import 'package:json_annotation/json_annotation.dart';
import 'game_config.dart';

part 'game_state.g.dart';

enum GameStatus { waiting, playing, paused, finished }

enum PlayerMark { X, O, none }

enum GameResult { win, loss, draw, ongoing }

@JsonSerializable()
class GameState {
  const GameState({
    required this.status,
    required this.board,
    required this.currentPlayer,
    required this.players,
    required this.config,
    this.result,
    this.winner,
    this.winningLine,
    required this.startTime,
    this.endTime,
    this.moveCount,
  });

  final GameStatus status;
  final List<List<PlayerMark>> board;
  final PlayerMark currentPlayer;
  final List<String> players;
  final GameConfig config;
  final GameResult? result;
  final String? winner;
  final List<List<int>>? winningLine;
  final DateTime startTime;
  final DateTime? endTime;
  final int? moveCount;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);

  Map<String, dynamic> toJson() => _$GameStateToJson(this);

  factory GameState.initial(GameConfig config) {
    final boardSize = config.boardSize;
    final board = List.generate(
      boardSize,
      (i) => List.generate(boardSize, (j) => PlayerMark.none),
    );

    return GameState(
      status: GameStatus.waiting,
      board: board,
      currentPlayer: PlayerMark.X,
      players: config.players,
      config: config,
      startTime: DateTime.now(),
      moveCount: 0,
    );
  }

  bool get isGameOver => status == GameStatus.finished;
  bool get isPlaying => status == GameStatus.playing;
  bool get hasWinner => result == GameResult.win;
  bool get isDraw => result == GameResult.draw;
  bool get isOngoing => result == GameResult.ongoing;

  int get totalCells => board.length * board[0].length;
  int get filledCells => board
      .expand((row) => row)
      .where((cell) => cell != PlayerMark.none)
      .length;
  bool get isBoardFull => filledCells == totalCells;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          board == other.board &&
          currentPlayer == other.currentPlayer &&
          players == other.players &&
          config == other.config &&
          result == other.result &&
          winner == other.winner &&
          winningLine == other.winningLine &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          moveCount == other.moveCount;

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    board,
    currentPlayer,
    players,
    config,
    result,
    winner,
    winningLine,
    startTime,
    endTime,
    moveCount,
  );

  @override
  String toString() =>
      'GameState(status: $status, board: $board, currentPlayer: $currentPlayer, players: $players, config: $config, result: $result, winner: $winner, winningLine: $winningLine, startTime: $startTime, endTime: $endTime, moveCount: $moveCount)';
}
