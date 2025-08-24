// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameState _$GameStateFromJson(Map<String, dynamic> json) => GameState(
  status: $enumDecode(_$GameStatusEnumMap, json['status']),
  board: (json['board'] as List<dynamic>)
      .map(
        (e) => (e as List<dynamic>)
            .map((e) => $enumDecode(_$PlayerMarkEnumMap, e))
            .toList(),
      )
      .toList(),
  currentPlayer: $enumDecode(_$PlayerMarkEnumMap, json['currentPlayer']),
  players: (json['players'] as List<dynamic>).map((e) => e as String).toList(),
  config: GameConfig.fromJson(json['config'] as Map<String, dynamic>),
  result: $enumDecodeNullable(_$GameResultEnumMap, json['result']),
  winner: json['winner'] as String?,
  winningLine: (json['winningLine'] as List<dynamic>?)
      ?.map((e) => (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
      .toList(),
  startTime: DateTime.parse(json['startTime'] as String),
  endTime: json['endTime'] == null
      ? null
      : DateTime.parse(json['endTime'] as String),
  moveCount: (json['moveCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$GameStateToJson(GameState instance) => <String, dynamic>{
  'status': _$GameStatusEnumMap[instance.status]!,
  'board': instance.board
      .map((e) => e.map((e) => _$PlayerMarkEnumMap[e]!).toList())
      .toList(),
  'currentPlayer': _$PlayerMarkEnumMap[instance.currentPlayer]!,
  'players': instance.players,
  'config': instance.config,
  'result': _$GameResultEnumMap[instance.result],
  'winner': instance.winner,
  'winningLine': instance.winningLine,
  'startTime': instance.startTime.toIso8601String(),
  'endTime': instance.endTime?.toIso8601String(),
  'moveCount': instance.moveCount,
};

const _$GameStatusEnumMap = {
  GameStatus.waiting: 'waiting',
  GameStatus.playing: 'playing',
  GameStatus.paused: 'paused',
  GameStatus.finished: 'finished',
};

const _$PlayerMarkEnumMap = {
  PlayerMark.X: 'X',
  PlayerMark.O: 'O',
  PlayerMark.none: 'none',
};

const _$GameResultEnumMap = {
  GameResult.win: 'win',
  GameResult.loss: 'loss',
  GameResult.draw: 'draw',
  GameResult.ongoing: 'ongoing',
};
