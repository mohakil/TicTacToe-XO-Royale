// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
  id: (json['id'] as num).toInt(),
  soundEnabled: json['soundEnabled'] as bool,
  musicEnabled: json['musicEnabled'] as bool,
  vibrationEnabled: json['vibrationEnabled'] as bool,
  hapticFeedbackEnabled: json['hapticFeedbackEnabled'] as bool,
  autoSaveEnabled: json['autoSaveEnabled'] as bool,
  notificationsEnabled: json['notificationsEnabled'] as bool,
);

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'soundEnabled': instance.soundEnabled,
      'musicEnabled': instance.musicEnabled,
      'vibrationEnabled': instance.vibrationEnabled,
      'hapticFeedbackEnabled': instance.hapticFeedbackEnabled,
      'autoSaveEnabled': instance.autoSaveEnabled,
      'notificationsEnabled': instance.notificationsEnabled,
    };
