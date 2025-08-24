// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameConfig _$GameConfigFromJson(Map<String, dynamic> json) => GameConfig(
  mode: $enumDecode(_$GameModeEnumMap, json['mode']),
  firstMove: $enumDecode(_$FirstMoveEnumMap, json['firstMove']),
  difficulty: $enumDecodeNullable(_$DifficultyEnumMap, json['difficulty']),
  boardSize: (json['boardSize'] as num).toInt(),
  winCondition: (json['winCondition'] as num).toInt(),
  players: (json['players'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$GameConfigToJson(GameConfig instance) =>
    <String, dynamic>{
      'mode': _$GameModeEnumMap[instance.mode]!,
      'firstMove': _$FirstMoveEnumMap[instance.firstMove]!,
      'difficulty': _$DifficultyEnumMap[instance.difficulty],
      'boardSize': instance.boardSize,
      'winCondition': instance.winCondition,
      'players': instance.players,
    };

const _$GameModeEnumMap = {GameMode.local: 'local', GameMode.cpu: 'cpu'};

const _$FirstMoveEnumMap = {
  FirstMove.X: 'X',
  FirstMove.O: 'O',
  FirstMove.random: 'random',
};

const _$DifficultyEnumMap = {
  Difficulty.easy: 'easy',
  Difficulty.medium: 'medium',
  Difficulty.hard: 'hard',
};
