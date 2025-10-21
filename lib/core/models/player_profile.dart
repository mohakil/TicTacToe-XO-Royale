import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'player_profile.g.dart';

@JsonSerializable(explicitToJson: true)
@immutable
class PlayerProfile {
  const PlayerProfile({
    required this.id,
    required this.nickname,
    required this.stats,
    required this.gems,
    required this.hints,
    this.avatarUrlOrProvider,
  });

  final String id;
  final String nickname;
  final String? avatarUrlOrProvider;
  final PlayerStats stats;
  final int gems;
  final int hints;

  factory PlayerProfile.fromJson(Map<String, dynamic> json) =>
      _$PlayerProfileFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerProfileToJson(this);

  factory PlayerProfile.defaultProfile() => const PlayerProfile(
    id: 'default_user',
    nickname: 'Player 1',
    stats: PlayerStats(wins: 0, losses: 0, draws: 0, streak: 0),
    gems: 100,
    hints: 5,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerProfile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nickname == other.nickname &&
          avatarUrlOrProvider == other.avatarUrlOrProvider &&
          stats == other.stats &&
          gems == other.gems &&
          hints == other.hints;

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    nickname,
    avatarUrlOrProvider,
    stats,
    gems,
    hints,
  );

  @override
  String toString() =>
      'PlayerProfile(id: $id, nickname: $nickname, avatarUrlOrProvider: $avatarUrlOrProvider, stats: $stats, gems: $gems, hints: $hints)';
}

@JsonSerializable(explicitToJson: true)
@immutable
class PlayerStats {
  const PlayerStats({
    required this.wins,
    required this.losses,
    required this.draws,
    required this.streak,
  });

  final int wins;
  final int losses;
  final int draws;
  final int streak;

  factory PlayerStats.fromJson(Map<String, dynamic> json) =>
      _$PlayerStatsFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerStatsToJson(this);

  int get totalGames => wins + losses + draws;
  double get winRate => totalGames > 0 ? wins / totalGames : 0.0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerStats &&
          runtimeType == other.runtimeType &&
          wins == other.wins &&
          losses == other.losses &&
          draws == other.draws &&
          streak == other.streak;

  @override
  int get hashCode => Object.hash(runtimeType, wins, losses, draws, streak);

  @override
  String toString() =>
      'PlayerStats(wins: $wins, losses: $losses, draws: $draws, streak: $streak)';
}
