import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:drift/drift.dart';
import 'package:tictactoe_xo_royale/core/database/app_database.dart' as db;

part 'app_settings.g.dart';

@JsonSerializable(explicitToJson: true)
@immutable
class AppSettings {
  const AppSettings({
    required this.id,
    required this.soundEnabled,
    required this.musicEnabled,
    required this.vibrationEnabled,
    required this.hapticFeedbackEnabled,
    required this.autoSaveEnabled,
    required this.notificationsEnabled,
  });

  final int id;
  final bool soundEnabled;
  final bool musicEnabled;
  final bool vibrationEnabled;
  final bool hapticFeedbackEnabled;
  final bool autoSaveEnabled;
  final bool notificationsEnabled;

  // Convenience getters for testing
  bool get isAudioEnabled => soundEnabled || musicEnabled;
  bool get isHapticEnabled => hapticFeedbackEnabled;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);

  factory AppSettings.fromDatabase(db.AppSettings data) => AppSettings(
    id: (data.id as int),
    soundEnabled: (data.soundEnabled as bool?) ?? true,
    musicEnabled: (data.musicEnabled as bool?) ?? true,
    vibrationEnabled: (data.vibrationEnabled as bool?) ?? true,
    hapticFeedbackEnabled: (data.hapticFeedbackEnabled as bool?) ?? true,
    autoSaveEnabled: (data.autoSaveEnabled as bool?) ?? true,
    notificationsEnabled: (data.notificationsEnabled as bool?) ?? true,
  );

  db.AppSettingsCompanion toCompanion() => db.AppSettingsCompanion(
    id: Value(id),
    soundEnabled: Value(soundEnabled),
    musicEnabled: Value(musicEnabled),
    vibrationEnabled: Value(vibrationEnabled),
    hapticFeedbackEnabled: Value(hapticFeedbackEnabled),
    autoSaveEnabled: Value(autoSaveEnabled),
    notificationsEnabled: Value(notificationsEnabled),
  );
}
