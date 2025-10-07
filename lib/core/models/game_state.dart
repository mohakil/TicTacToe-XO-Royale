import 'package:flutter/foundation.dart';

enum GameStatus { waiting, playing, finished }

enum PlayerMark { x, o }

@immutable
class GameState {
  final List<List<String?>> boardState;
  final String currentPlayer;
  final bool isGameOver;
  final List<int>? winningLine;
  final GameStatus status;
  final int player1Wins;
  final int player2Wins;
  final int draws;

  const GameState({
    required this.boardState,
    required this.currentPlayer,
    required this.isGameOver,
    required this.status,
    required this.player1Wins,
    required this.player2Wins,
    required this.draws,
    this.winningLine,
  });

  factory GameState.initial(int boardSize) => GameState(
    boardState: List.generate(boardSize, (_) => List.filled(boardSize, null)),
    currentPlayer: 'X',
    isGameOver: false,
    status: GameStatus.waiting,
    player1Wins: 0,
    player2Wins: 0,
    draws: 0,
  );

  GameState copyWith({
    List<List<String?>>? boardState,
    String? currentPlayer,
    bool? isGameOver,
    List<int>? winningLine,
    GameStatus? status,
    int? player1Wins,
    int? player2Wins,
    int? draws,
  }) => GameState(
    boardState: boardState ?? this.boardState,
    currentPlayer: currentPlayer ?? this.currentPlayer,
    isGameOver: isGameOver ?? this.isGameOver,
    winningLine: winningLine ?? this.winningLine,
    status: status ?? this.status,
    player1Wins: player1Wins ?? this.player1Wins,
    player2Wins: player2Wins ?? this.player2Wins,
    draws: draws ?? this.draws,
  );

  bool get isDraw => isGameOver && winningLine == null;
  bool get hasWinner => winningLine != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is GameState &&
        listEquals(other.boardState, boardState) &&
        other.currentPlayer == currentPlayer &&
        other.isGameOver == isGameOver &&
        listEquals(other.winningLine, winningLine) &&
        other.status == status &&
        other.player1Wins == player1Wins &&
        other.player2Wins == player2Wins &&
        other.draws == draws;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(boardState),
    currentPlayer,
    isGameOver,
    Object.hashAll(winningLine ?? []),
    status,
    player1Wins,
    player2Wins,
    draws,
  );

  @override
  String toString() =>
      'GameState(boardState: $boardState, currentPlayer: $currentPlayer, isGameOver: $isGameOver, winningLine: $winningLine, status: $status, player1Wins: $player1Wins, player2Wins: $player2Wins, draws: $draws)';
}
