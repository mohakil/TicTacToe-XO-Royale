// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameSetup _$GameSetupFromJson(Map<String, dynamic> json) => _GameSetup(
  mode: $enumDecodeNullable(_$GameModeEnumMap, json['mode']) ?? GameMode.local,
  player1Name: json['player1Name'] as String? ?? 'Player 1',
  player2Name: json['player2Name'] as String? ?? 'Player 2',
  firstMove:
      $enumDecodeNullable(_$FirstMoveEnumMap, json['firstMove']) ??
      FirstMove.random,
  difficulty:
      $enumDecodeNullable(_$DifficultyEnumMap, json['difficulty']) ??
      Difficulty.medium,
  boardSize:
      $enumDecodeNullable(_$BoardSizeEnumMap, json['boardSize']) ??
      BoardSize.threeByThree,
  winCondition:
      $enumDecodeNullable(_$WinConditionEnumMap, json['winCondition']) ??
      WinCondition.threeInRow,
);

Map<String, dynamic> _$GameSetupToJson(_GameSetup instance) =>
    <String, dynamic>{
      'mode': _$GameModeEnumMap[instance.mode]!,
      'player1Name': instance.player1Name,
      'player2Name': instance.player2Name,
      'firstMove': _$FirstMoveEnumMap[instance.firstMove]!,
      'difficulty': _$DifficultyEnumMap[instance.difficulty]!,
      'boardSize': _$BoardSizeEnumMap[instance.boardSize]!,
      'winCondition': _$WinConditionEnumMap[instance.winCondition]!,
    };

const _$GameModeEnumMap = {GameMode.local: 'local', GameMode.robot: 'robot'};

const _$FirstMoveEnumMap = {
  FirstMove.x: 'x',
  FirstMove.o: 'o',
  FirstMove.random: 'random',
};

const _$DifficultyEnumMap = {
  Difficulty.easy: 'easy',
  Difficulty.medium: 'medium',
  Difficulty.hard: 'hard',
};

const _$BoardSizeEnumMap = {
  BoardSize.threeByThree: 'threeByThree',
  BoardSize.fourByFour: 'fourByFour',
  BoardSize.fiveByFive: 'fiveByFive',
};

const _$WinConditionEnumMap = {
  WinCondition.threeInRow: 'threeInRow',
  WinCondition.fourInRow: 'fourInRow',
  WinCondition.fiveInRow: 'fiveInRow',
};
