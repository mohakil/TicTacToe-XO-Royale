// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Achievement _$AchievementFromJson(Map<String, dynamic> json) => Achievement(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  icon: const IconDataConverter().fromJson(
    json['icon'] as Map<String, dynamic>,
  ),
  rarity: $enumDecode(_$AchievementRarityEnumMap, json['rarity']),
  isUnlocked: json['isUnlocked'] as bool? ?? false,
  unlockedDate: json['unlockedDate'] == null
      ? null
      : DateTime.parse(json['unlockedDate'] as String),
  progress: (json['progress'] as num?)?.toInt() ?? 0,
  maxProgress: (json['maxProgress'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$AchievementToJson(Achievement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'icon': const IconDataConverter().toJson(instance.icon),
      'rarity': _$AchievementRarityEnumMap[instance.rarity]!,
      'isUnlocked': instance.isUnlocked,
      'unlockedDate': instance.unlockedDate?.toIso8601String(),
      'progress': instance.progress,
      'maxProgress': instance.maxProgress,
    };

const _$AchievementRarityEnumMap = {
  AchievementRarity.common: 'common',
  AchievementRarity.rare: 'rare',
  AchievementRarity.epic: 'epic',
  AchievementRarity.legendary: 'legendary',
};
