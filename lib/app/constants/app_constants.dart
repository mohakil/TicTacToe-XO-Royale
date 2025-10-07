class AppConstants {
  // App information
  static const String appName = 'TicTacToe: XO Royale';
  static const String appVersion = '0.1.0';
  static const String packageName = 'com.astrixforge.tictactoe.xoroyale';

  // Game constants
  static const int minBoardSize = 3;
  static const int maxBoardSize = 5;
  static const int minWinCondition = 3;
  static const int maxWinCondition = 5;
  static const int maxPlayerNameLength = 12;
  static const int maxHintCount = 10;
  static const int maxGemCount = 9999;

  // Default game settings
  static const int defaultBoardSize = 3;
  static const int defaultWinCondition = 3;
  static const String defaultFirstMove = 'random';
  static const String defaultDifficulty = 'medium';

  // Game modes
  static const String gameModeLocal = 'local';
  static const String gameModeRobot = 'robot';

  // Player symbols
  static const String playerX = 'X';
  static const String playerO = 'O';
  static const String playerRandom = 'random';

  // Difficulty levels
  static const String difficultyEasy = 'easy';
  static const String difficultyMedium = 'medium';
  static const String difficultyHard = 'hard';

  // Win conditions
  static const String winCondition3 = '3 in a row';
  static const String winCondition4 = '4 in a row';
  static const String winCondition5 = '5 in a row';

  // Store categories
  static const String storeCategoryThemes = 'themes';
  static const String storeCategoryBoards = 'boards';
  static const String storeCategorySymbols = 'symbols';
  static const String storeCategoryGems = 'gems';

  // Asset paths
  static const String assetsPath = 'assets';
  static const String imagesPath = '$assetsPath/images';
  static const String iconsPath = '$assetsPath/icons';
  static const String audioPath = '$assetsPath/audio';
  static const String fontsPath = '$assetsPath/fonts';

  // Font families
  static const String fontFamilySora = 'Sora';
  static const String fontFamilyInter = 'Inter';
  static const String fontFamilyJetBrainsMono = 'JetBrainsMono';

  // Animation durations (in milliseconds)
  static const int animationMicro = 120;
  static const int animationStandard = 240;
  static const int animationEmphasized = 400;
  static const int animationExtended = 600;
  static const int animationCelebration = 1200;

  // Performance targets
  static const int targetFPS = 60;
  static const int maxFPS = 144;
  static const double maxFrameTime = 16.67; // milliseconds for 60 FPS

  // Spacing tokens (4-pt base system)
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;
  static const double spacing40 = 40;
  static const double spacing48 = 48;
  static const double spacing64 = 64;

  // Border radius tokens
  static const double radius8 = 8;
  static const double radius16 = 16;
  static const double radius20 = 20;
  static const double radius24 = 24;

  // Elevation tokens
  static const double elevation0 = 0;
  static const double elevation1 = 1;
  static const double elevation2 = 2;
  static const double elevation4 = 4;
  static const double elevation8 = 8;
  static const double elevation12 = 12;
  static const double elevation16 = 16;

  // Screen breakpoints
  static const double phoneBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Game board sizing
  static const double boardAspectRatio = 1; // Square board
  static const double boardMaxWidthRatio =
      0.7; // Max 70% of screen width on tablets
  static const double boardMinWidthRatio =
      0.8; // Min 80% of screen width on phones
  static const double cellMinTapSize = 48; // Minimum tap target size

  // Haptic feedback patterns
  static const String hapticLight = 'lightImpact';
  static const String hapticMedium = 'mediumImpact';
  static const String hapticHeavy = 'heavyImpact';
  static const String hapticSelection = 'selectionClick';
  static const String hapticSuccess = 'successHeavy';

  // Sound file names
  static const String soundTap = 'tap.wav';
  static const String soundMarkX = 'mark_x.wav';
  static const String soundMarkO = 'mark_o.wav';
  static const String soundWin = 'win.wav';
  static const String soundLoss = 'loss.wav';
  static const String soundDraw = 'draw.wav';
  static const String soundHint = 'hint.wav';

  // Local storage keys
  static const String storageKeySettings = 'settings';
  static const String storageKeyProfile = 'profile';
  static const String storageKeyGameHistory = 'game_history';
  static const String storageKeyAchievements = 'achievements';
  static const String storageKeyStoreItems = 'store_items';
  static const String storageKeyGems = 'gems';
  static const String storageKeyHints = 'hints';

  // Error messages
  static const String errorInvalidBoardSize =
      'Invalid board size. Must be between 3 and 5.';
  static const String errorInvalidWinCondition =
      'Invalid win condition. Must be between 3 and board size.';
  static const String errorInvalidPlayerName =
      'Invalid player name. Must be between 1 and 12 characters.';
  static const String errorGameInProgress = 'Game is already in progress.';
  static const String errorNoHintsAvailable = 'No hints available.';
  static const String errorInsufficientGems = 'Insufficient gems.';

  // Success messages
  static const String successGameStarted = 'Game started successfully!';
  static const String successHintUsed = 'Hint used successfully!';
  static const String successItemUnlocked = 'Item unlocked successfully!';
  static const String successGemsEarned = 'Gems earned successfully!';

  // Loading messages
  static const String loadingStartingGame = 'Starting game...';
  static const String loadingCalculatingMove = 'Calculating move...';
  static const String loadingSavingGame = 'Saving game...';
  static const String loadingUnlockingItem = 'Unlocking item...';

  // Game tips
  static const List<String> gameTips = [
    'Start with the center cell for better chances',
    'Look for opportunities to create multiple winning paths',
    "Block your opponent's winning moves",
    'Use hints strategically when stuck',
    'Practice on different board sizes to improve',
    "Watch for patterns in your opponent's moves",
    "Don't forget to have fun!",
  ];

  // Achievement descriptions
  static const Map<String, String> achievementDescriptions = {
    'first_win': 'Win your first game',
    'winning_streak': 'Win 5 games in a row',
    'board_master': 'Win on all board sizes',
    'hint_saver': 'Win without using hints',
    'speed_player': 'Win a game in under 2 minutes',
    'comeback_king': 'Win after being behind',
    'perfect_game': 'Win without opponent scoring',
    'versatile_player': 'Win with both X and O',
  };
}
