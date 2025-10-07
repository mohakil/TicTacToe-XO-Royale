// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerProfile _$PlayerProfileFromJson(Map<String, dynamic> json) =>
    PlayerProfile(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      stats: PlayerStats.fromJson(json['stats'] as Map<String, dynamic>),
      gems: (json['gems'] as num).toInt(),
      hints: (json['hints'] as num).toInt(),
      avatarUrlOrProvider: json['avatarUrlOrProvider'] as String?,
    );

Map<String, dynamic> _$PlayerProfileToJson(PlayerProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'avatarUrlOrProvider': instance.avatarUrlOrProvider,
      'stats': instance.stats.toJson(),
      'gems': instance.gems,
      'hints': instance.hints,
    };

PlayerStats _$PlayerStatsFromJson(Map<String, dynamic> json) => PlayerStats(
  wins: (json['wins'] as num).toInt(),
  losses: (json['losses'] as num).toInt(),
  draws: (json['draws'] as num).toInt(),
  streak: (json['streak'] as num).toInt(),
);

Map<String, dynamic> _$PlayerStatsToJson(PlayerStats instance) =>
    <String, dynamic>{
      'wins': instance.wins,
      'losses': instance.losses,
      'draws': instance.draws,
      'streak': instance.streak,
    };
