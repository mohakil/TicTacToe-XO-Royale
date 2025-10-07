import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/models/achievement.dart';

/// Service for managing achievement definitions and unlocking logic
class AchievementDataService {
  /// Get all available achievements
  static List<Achievement> getAllAchievements() {
    return [
      // Gameplay Achievements
      const Achievement(
        id: 'first_win',
        title: 'First Victory',
        description: 'Win your first game',
        icon: Icons.emoji_events,
        rarity: AchievementRarity.common,
      ),
      const Achievement(
        id: 'win_streak_3',
        title: 'Winning Streak',
        description: 'Win 3 games in a row',
        icon: Icons.local_fire_department,
        rarity: AchievementRarity.common,
      ),
      const Achievement(
        id: 'win_streak_5',
        title: 'Hot Streak',
        description: 'Win 5 games in a row',
        icon: Icons.local_fire_department,
        rarity: AchievementRarity.rare,
      ),
      const Achievement(
        id: 'win_streak_10',
        title: 'Unstoppable',
        description: 'Win 10 games in a row',
        icon: Icons.local_fire_department,
        rarity: AchievementRarity.epic,
      ),
      const Achievement(
        id: 'perfect_game',
        title: 'Perfect Game',
        description: 'Win without losing a single piece',
        icon: Icons.star,
        rarity: AchievementRarity.legendary,
      ),

      // Robot AI Achievements
      const Achievement(
        id: 'robot_easy',
        title: 'Easy Victory',
        description: 'Beat a robot on Easy difficulty',
        icon: Icons.smart_toy,
        rarity: AchievementRarity.common,
      ),
      const Achievement(
        id: 'robot_medium',
        title: 'Strategic Mind',
        description: 'Beat a robot on Medium difficulty',
        icon: Icons.smart_toy,
        rarity: AchievementRarity.rare,
      ),
      const Achievement(
        id: 'robot_hard',
        title: 'Robot Master',
        description: 'Beat a robot on Hard difficulty',
        icon: Icons.smart_toy,
        rarity: AchievementRarity.epic,
      ),
      const Achievement(
        id: 'robot_legendary',
        title: 'AI Conqueror',
        description: 'Beat a robot on Legendary difficulty',
        icon: Icons.smart_toy,
        rarity: AchievementRarity.legendary,
      ),

      // Board Size Achievements
      const Achievement(
        id: 'board_explorer',
        title: 'Board Explorer',
        description: 'Play on 3 different board sizes',
        icon: Icons.grid_on,
        rarity: AchievementRarity.common,
      ),
      const Achievement(
        id: 'board_master',
        title: 'Board Master',
        description: 'Play on all board sizes (3x3 to 5x5)',
        icon: Icons.grid_on,
        rarity: AchievementRarity.rare,
      ),

      // Win Condition Achievements
      const Achievement(
        id: 'win_condition_explorer',
        title: 'Win Explorer',
        description: 'Play with 3 different win conditions',
        icon: Icons.flag,
        rarity: AchievementRarity.common,
      ),
      const Achievement(
        id: 'win_condition_master',
        title: 'Win Master',
        description: 'Play with all win conditions (3-5 in a row)',
        icon: Icons.flag,
        rarity: AchievementRarity.rare,
      ),

      // Social/Game Mode Achievements
      const Achievement(
        id: 'local_player',
        title: 'Local Champion',
        description: 'Win 10 local multiplayer games',
        icon: Icons.people,
        rarity: AchievementRarity.rare,
      ),

      // Stats Achievements
      const Achievement(
        id: 'centurion',
        title: 'Centurion',
        description: 'Win 100 games total',
        icon: Icons.looks_3,
        rarity: AchievementRarity.epic,
      ),
      const Achievement(
        id: 'legend',
        title: 'Legend',
        description: 'Win 500 games total',
        icon: Icons.workspace_premium,
        rarity: AchievementRarity.legendary,
      ),

      // Special Achievements
      const Achievement(
        id: 'comeback_kid',
        title: 'Comeback Kid',
        description: 'Win after being 2 pieces behind',
        icon: Icons.trending_up,
        rarity: AchievementRarity.epic,
      ),
      const Achievement(
        id: 'underdog',
        title: 'Underdog',
        description: 'Win against a higher-rated opponent',
        icon: Icons.trending_up,
        rarity: AchievementRarity.rare,
      ),
    ];
  }

  /// Check if an achievement should be unlocked based on game state
  static String? checkForAchievementUnlock(
    int wins,
    int streak,
    Set<int> boardSizesPlayed,
    Set<int> winConditionsPlayed,
    bool isRobotGame,
    int? robotDifficulty,
    bool isPerfectGame,
    bool isComeback,
  ) {
    // First win
    if (wins >= 1) {
      return 'first_win';
    }

    // Win streaks
    if (streak >= 3) {
      return 'win_streak_3';
    }
    if (streak >= 5) {
      return 'win_streak_5';
    }
    if (streak >= 10) {
      return 'win_streak_10';
    }

    // Perfect game
    if (isPerfectGame) {
      return 'perfect_game';
    }

    // Robot achievements
    if (isRobotGame && robotDifficulty != null) {
      if (robotDifficulty >= 1) return 'robot_easy';
      if (robotDifficulty >= 2) return 'robot_medium';
      if (robotDifficulty >= 3) return 'robot_hard';
      if (robotDifficulty >= 4) return 'robot_legendary';
    }

    // Board size achievements
    if (boardSizesPlayed.length >= 3) {
      return 'board_explorer';
    }
    if (boardSizesPlayed.length >= 3) {
      // All sizes: 3, 4, 5
      return 'board_master';
    }

    // Win condition achievements
    if (winConditionsPlayed.length >= 3) {
      return 'win_condition_explorer';
    }
    if (winConditionsPlayed.length >= 3) {
      // All conditions: 3, 4, 5
      return 'win_condition_master';
    }

    // Stats achievements
    if (wins >= 100) {
      return 'centurion';
    }
    if (wins >= 500) {
      return 'legend';
    }

    // Special achievements
    if (isComeback) {
      return 'comeback_kid';
    }

    return null; // No achievement unlocked
  }

  /// Get achievement by ID
  static Achievement? getAchievementById(String id) {
    return getAllAchievements()
        .where((achievement) => achievement.id == id)
        .firstOrNull;
  }

  /// Get achievements by rarity
  static List<Achievement> getAchievementsByRarity(AchievementRarity rarity) {
    return getAllAchievements()
        .where((achievement) => achievement.rarity == rarity)
        .toList();
  }

  /// Get recently unlocked achievements (for preview)
  static List<Achievement> getRecentlyUnlockedAchievements(
    List<Achievement> allAchievements,
  ) {
    return allAchievements
        .where(
          (achievement) =>
              achievement.isUnlocked && achievement.unlockedDate != null,
        )
        .toList()
      ..sort((a, b) => b.unlockedDate!.compareTo(a.unlockedDate!));
  }
}
