import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tictactoe_xo_royale/features/achievements/services/achievement_data_service.dart';

part 'achievement.g.dart';

/// Achievement rarity levels
enum AchievementRarity { common, rare, epic, legendary }

/// JSON converter for IconData that uses hardcoded achievement data
class IconDataConverter
    implements JsonConverter<IconData, Map<String, dynamic>> {
  const IconDataConverter();

  @override
  IconData fromJson(Map<String, dynamic> json) {
    final String id = json['id'] as String;
    final achievement = AchievementDataService.getAchievementById(id);
    return achievement?.icon ?? Icons.help_outline;
  }

  @override
  Map<String, dynamic> toJson(IconData object) {
    // Don't serialize the icon - it will be reconstructed from hardcoded data
    return {};
  }
}

/// Achievement data model
@JsonSerializable(explicitToJson: true)
@immutable
class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.rarity,
    this.isUnlocked = false,
    this.unlockedDate,
    this.progress = 0,
    this.maxProgress = 1,
  });

  final String id;
  final String title;
  final String description;
  @IconDataConverter()
  final IconData icon;
  final AchievementRarity rarity;
  final bool isUnlocked;
  final DateTime? unlockedDate;
  final int progress;
  final int maxProgress;

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);
  Map<String, dynamic> toJson() => _$AchievementToJson(this);

  /// Check if achievement is completed
  bool get isCompleted => progress >= maxProgress;

  /// Get completion percentage (0.0 to 1.0)
  double get completionPercentage {
    if (maxProgress <= 0) return 0.0;

    // If unlocked, always return 1.0 (100%)
    if (isUnlocked) return 1.0;

    // For locked achievements, ensure progress doesn't exceed 99%
    final percentage = (progress / maxProgress);
    return percentage.clamp(0.0, 0.99);
  }

  /// Get rarity color for UI
  Color getRarityColor() {
    switch (rarity) {
      case AchievementRarity.common:
        return const Color(0xFF9E9E9E); // Grey
      case AchievementRarity.rare:
        return const Color(0xFF2196F3); // Blue
      case AchievementRarity.epic:
        return const Color(0xFF9C27B0); // Purple
      case AchievementRarity.legendary:
        return const Color(0xFFFF9800); // Orange
    }
  }

  /// Get rarity text for UI
  String getRarityText() {
    switch (rarity) {
      case AchievementRarity.common:
        return 'C';
      case AchievementRarity.rare:
        return 'R';
      case AchievementRarity.epic:
        return 'E';
      case AchievementRarity.legendary:
        return 'L';
    }
  }

  /// Format unlocked date for display
  String formatUnlockedDate() {
    if (unlockedDate == null) return '';

    final now = DateTime.now();
    final difference = now.difference(unlockedDate!);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Create a copy of this achievement with updated fields
  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    IconData? icon,
    AchievementRarity? rarity,
    bool? isUnlocked,
    DateTime? unlockedDate,
    int? progress,
    int? maxProgress,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      rarity: rarity ?? this.rarity,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedDate: unlockedDate ?? this.unlockedDate,
      progress: progress ?? this.progress,
      maxProgress: maxProgress ?? this.maxProgress,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Achievement &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          icon == other.icon &&
          rarity == other.rarity &&
          isUnlocked == other.isUnlocked &&
          unlockedDate == other.unlockedDate &&
          progress == other.progress &&
          maxProgress == other.maxProgress;

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    icon,
    rarity,
    isUnlocked,
    unlockedDate,
    progress,
    maxProgress,
  );

  @override
  String toString() =>
      'Achievement(id: $id, title: $title, rarity: $rarity, isUnlocked: $isUnlocked, progress: $progress/$maxProgress)';
}
