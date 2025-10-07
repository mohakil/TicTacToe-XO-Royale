import 'package:flutter/foundation.dart';

/// Game result enumeration for history tracking
enum GameResult { win, loss, draw }

/// Game history item model for tracking completed games
@immutable
class GameHistoryItem {
  final String opponent;
  final GameResult result;
  final String boardSize;
  final DateTime date;
  final Duration duration;
  final String score;

  const GameHistoryItem({
    required this.opponent,
    required this.result,
    required this.boardSize,
    required this.date,
    required this.duration,
    required this.score,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameHistoryItem &&
        other.opponent == opponent &&
        other.result == result &&
        other.boardSize == boardSize &&
        other.date == date &&
        other.duration == duration &&
        other.score == score;
  }

  @override
  int get hashCode =>
      Object.hash(opponent, result, boardSize, date, duration, score);

  @override
  String toString() =>
      'GameHistoryItem(opponent: $opponent, result: $result, boardSize: $boardSize, date: $date, duration: $duration, score: $score)';
}
