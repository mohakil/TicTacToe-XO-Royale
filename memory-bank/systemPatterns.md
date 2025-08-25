# System Patterns: TicTacToe XO Royale

## Architecture Overview

### Clean Architecture Implementation
The project follows a **feature-based clean architecture** pattern with clear separation of concerns:

```
lib/
├── app/                    # Application layer
│   ├── router/           # Navigation and routing
│   ├── theme/            # Design system and theming
│   └── constants/        # Global constants
├── core/                  # Core business logic
│   ├── models/           # Domain entities and data models
│   ├── providers/        # State management
│   ├── services/         # Business logic services
│   └── utils/            # Utility functions
├── features/              # Feature modules
│   ├── loading/          # Loading screen
│   ├── home/             # Home screen
│   ├── game/             # Game play
│   ├── setup/            # Game configuration
│   ├── settings/         # App settings
│   ├── profile/          # User profile
│   └── store/            # In-app store
└── shared/                # Reusable components
```

### Feature Module Pattern
Each feature follows a consistent structure:

```
lib/features/[feature_name]/
├── [feature_name].dart           # Feature barrel export
├── presentation/                  # UI layer
│   ├── screens/                  # Main screens
│   ├── widgets/                  # Feature-specific widgets
│   └── providers/                # UI state providers
├── domain/                       # Business logic (if complex)
└── data/                         # Data layer (if needed)
```

## State Management Patterns

### Riverpod Implementation
The project uses **Riverpod** for state management with immutable models:

```dart
// Provider definition
final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});

// Immutable state updates
class GameNotifier extends StateNotifier<GameState> {
  void makeMove(Position position) {
    state = state.copyWith(
      board: _updateBoard(state.board, position),
      currentPlayer: _getNextPlayer(state.currentPlayer),
    );
  }
}
```

### Provider Organization
- **Global Providers**: Theme, settings, and app-wide state
- **Feature Providers**: Feature-specific state management
- **UI Providers**: Local widget state and animations

## Navigation Architecture

### GoRouter with ShellRoute Pattern
The navigation system uses **GoRouter** with **ShellRoute** for optimal performance:

```dart
// Shell route for main app sections
ShellRoute(
  builder: (context, state, child) => MainAppShell(child: child),
  routes: [
    GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
    GoRoute(path: '/game', builder: (context, state) => GameScreen()),
    GoRoute(path: '/setup', builder: (context, state) => SetupScreen()),
    GoRoute(path: '/store', builder: (context, state) => StoreScreen()),
    GoRoute(path: '/profile', builder: (context, state) => ProfileScreen()),
  ],
)
```

### Navigation Structure
```
/loading → Loading screen (separate route)
Main App Shell (with bottom navigation)
├── /home → Home tab (index 0)
├── /game → Game tab (index 1)
├── /setup → Setup tab (index 2)
├── /store → Store tab (index 3)
├── /profile → Profile tab (index 4)
└── Settings → Floating Action Button
```

### Tab Synchronization
- **Automatic Sync**: Bottom navigation automatically highlights current route
- **State Management**: Local state for current tab index
- **Route Navigation**: Proper navigation between all main app sections

## Theme System Architecture

### Material 3 Implementation
The theme system is fully implemented with **Material 3** compliance:

```dart
// Theme data with extensions
static ThemeData get lightTheme {
  return ThemeData(
    useMaterial3: true,
    colorScheme: AppColorSchemes.light,
    textTheme: AppTypography.textTheme,
    extensions: const [
      GameColors.light,
      MotionDurations.defaultDurations,
      MotionEasings.defaultEasings,
      GameElevations.defaultElevations,
    ],
  );
}
```

### Theme Extensions Pattern
Custom theme extensions for game-specific needs:

```dart
// Game-specific colors
class GameColors extends ThemeExtension<GameColors> {
  final Color win, loss, draw, gem, hint;
  final Color boardLine, cellHover, cellPressed;
  final Color glowCyan, glowMagenta;
  
  // Light and dark variants
  static const GameColors light = GameColors(...);
  static const GameColors dark = GameColors(...);
}

// Motion timing and easing
class MotionDurations extends ThemeExtension<MotionDurations> {
  final Duration micro, standard, emphasized, extended, celebration;
  static const MotionDurations defaultDurations = MotionDurations(...);
}
```

### Color System Architecture
**Neuroscience-informed color system** for high engagement:

- **Primary**: Electric Azure (#2DD4FF) - Main accent color
- **Secondary**: Vivid Magenta (#F43F9D) - Secondary accent
- **Tertiary**: Lime Pulse (#A3E635) - Success and positive feedback
- **Neutral**: Deep space grays with high contrast ratios
- **Semantic**: Success, warning, error, and info colors

## Game Rendering Architecture

### CustomPainter Strategy
The game uses a **hybrid rendering approach** for optimal performance:

```dart
// Main game board widget
class TicTacToeBoard extends ConsumerStatefulWidget {
  // Uses CustomPainter for high-performance rendering
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BoardPainter(
        boardSize: widget.boardSize,
        boardState: widget.boardState,
        // ... other parameters
      ),
    );
  }
}
```

### Painter Hierarchy
```
BoardPainter (main coordinator)
├── Grid rendering
├── Cell rendering
├── Mark rendering (X/O)
├── Winning line effects
└── Special effects
    ├── Ambient effects
    ├── Confetti
    └── Hint sparkles
```

### Performance Optimization Patterns
- **RepaintBoundary**: Isolate expensive painting operations
- **Cached Paint Objects**: Reuse Paint instances across frames
- **Animation Pooling**: Limit concurrent AnimationControllers
- **Efficient Rendering**: Minimal object creation during paint

## Animation Architecture

### Multi-Layer Animation System
The project uses a **coordinated animation approach**:

```dart
// Animation controllers for different effects
late AnimationController _markAnimationController;
late AnimationController _winningLineController;
late AnimationController _hintController;
late AnimationController _ambientController;

// Coordinated animations
void _initializeAnimations() {
  _markAnimationController = AnimationController(
    duration: const Duration(milliseconds: 400),
    vsync: this,
  );
  
  _winningLineController = AnimationController(
    duration: const Duration(milliseconds: 450),
    vsync: this,
  );
}
```

### Animation Coordination Patterns
- **Staggered Timing**: Animations start with delays for smooth flow
- **Curve Coordination**: Different easing curves for different effects
- **Performance Management**: Limited concurrent animations
- **State Synchronization**: Animations tied to game state changes

## Data Model Patterns

### Immutable Model Pattern
All data models use **immutable patterns** with Freezed:

```dart
@immutable
class GameConfig {
  final int boardSize;
  final int winCondition;
  final GameMode gameMode;
  final FirstMove firstMove;
  final Difficulty difficulty;
  final String player1Name;
  final String player2Name;
  final bool isRobotMode;

  const GameConfig({...});

  // Immutable updates
  GameConfig copyWith({...}) {
    return GameConfig(...);
  }
}
```

### Model Organization
- **Game Models**: Game state, configuration, and player data
- **UI Models**: Screen state and presentation data
- **Service Models**: API and storage data structures

## Service Layer Patterns

### Service Interface Pattern
Services follow a **consistent interface pattern**:

```dart
abstract class AudioService {
  Future<void> playSound(SoundEffect effect);
  Future<void> playMusic(MusicTrack track);
  Future<void> setVolume(double volume);
  Future<void> dispose();
}

class JustAudioService implements AudioService {
  // Implementation using just_audio package
}
```

### Service Organization
- **Core Services**: Game logic, audio, haptics
- **Platform Services**: Device-specific implementations
- **Mock Services**: Development and testing implementations

## Testing Architecture

### Test Organization Pattern
Tests follow the **same structure** as the source code:

```
test/
├── game_logic_test.dart      # Core game logic
├── game_screen_test.dart     # Game UI components
├── loading_screen_test.dart  # Loading screen
├── models_test.dart          # Data models
├── profile_provider_test.dart # State management
├── robot_logic_test.dart     # AI logic
├── router_test.dart          # Navigation
├── settings_provider_test.dart # Settings state
├── setup_screen_test.dart    # Setup UI
└── theme_provider_test.dart  # Theme management
```

### Testing Patterns
- **Unit Tests**: Business logic and data models
- **Widget Tests**: UI components and interactions
- **Provider Tests**: State management and data flow
- **Integration Tests**: End-to-end user flows

## Performance Patterns

### Frame Rate Optimization
Target: **60-144 FPS** during active gameplay

```dart
// Performance optimization patterns
class BoardPainter extends CustomPainter {
  // Cached Paint objects
  late final Paint _gridPaint;
  late final Paint _hoverPaint;
  
  @override
  void paint(Canvas canvas, Size size) {
    // Efficient rendering with minimal object creation
    _drawGrid(canvas, size);
    _drawCells(canvas, size);
    _drawEffects(canvas, size);
  }
}
```

### Memory Management Patterns
- **Resource Disposal**: Proper disposal of controllers and resources
- **Asset Caching**: Preload and cache frequently used assets
- **Lazy Loading**: Load assets and effects on demand
- **Memory Pooling**: Reuse objects where possible

## Responsive Design Patterns

### Adaptive Layout System
The project uses **responsive design patterns**:

```dart
// Responsive theme adjustments
static ThemeData getResponsiveTheme(ThemeData baseTheme, double scaleFactor) {
  return baseTheme.copyWith(
    textTheme: baseTheme.textTheme.apply(
      fontSizeFactor: scaleFactor,
    ),
  );
}

// Adaptive sizing
double _calculateCellSize(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final boardDimension = size.width < size.height
      ? size.width * 0.8
      : size.height * 0.64;
  return boardDimension / widget.boardSize;
}
```

### Responsive Patterns
- **4pt Grid System**: Consistent spacing tokens
- **Dynamic Typography**: Scale with MediaQuery.textScaleFactor
- **Adaptive Layouts**: Different layouts for phones vs tablets
- **Touch Targets**: Minimum 48x48px for all interactive elements

## Accessibility Patterns

### Built-in Accessibility
The project implements **comprehensive accessibility**:

```dart
// Semantic labels and hints
Semantics(
  label: 'XO Royale - Home',
  child: Text('XO Royale'),
)

// Proper contrast ratios
colorScheme.primary.withValues(alpha: 0.1)

// Dynamic type support
style: theme.textTheme.titleLarge?.copyWith(
  fontSize: theme.textTheme.titleLarge!.fontSize! * 
    MediaQuery.of(context).textScaleFactor,
)
```

### Accessibility Features
- **Semantic Labels**: Clear descriptions for screen readers
- **Contrast Ratios**: WCAG 2.1 AA compliant colors
- **Touch Targets**: Proper sizing for motor accessibility
- **Dynamic Type**: Support for system font scaling

## Code Generation Patterns

### Automated Code Generation
The project uses **code generation** for repetitive tasks:

```yaml
# pubspec.yaml
dev_dependencies:
  build_runner: ^2.4.13
  freezed: ^3.0.0
  json_serializable: ^6.8.0
  riverpod_generator: ^2.6.5
```

### Generation Commands
```bash
# Generate all code
flutter packages pub run build_runner build

# Watch for changes
flutter packages pub run build_runner watch

# Clean and regenerate
flutter packages pub run build_runner clean
flutter packages pub run build_runner build
```

## Error Handling Patterns

### Graceful Error Handling
The project implements **comprehensive error handling**:

```dart
// Service error handling
try {
  await audioService.playSound(SoundEffect.move);
} catch (e) {
  // Graceful fallback
  debugPrint('Audio playback failed: $e');
}

// UI error handling
if (mounted) {
  setState(() {
    _showError = true;
    _errorMessage = 'Failed to load game';
  });
}
```

### Error Handling Strategies
- **Graceful Degradation**: Continue functionality when possible
- **User Feedback**: Clear error messages and recovery options
- **Logging**: Comprehensive error logging for debugging
- **Fallbacks**: Alternative implementations when primary fails

## Platform Integration Patterns

### Cross-Platform Consistency
The project ensures **identical experience** across platforms:

```dart
// Platform-specific implementations
if (Platform.isAndroid) {
  // Android-specific code
} else if (Platform.isIOS) {
  // iOS-specific code
} else {
  // Web/desktop fallback
}

// Platform-agnostic services
class HapticService {
  Future<void> lightImpact() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.lightImpact();
    }
  }
}
```

### Platform Patterns
- **Native Integration**: Platform-specific APIs where beneficial
- **Consistent UX**: Identical user experience across platforms
- **Performance Optimization**: Platform-specific performance tuning
- **Feature Parity**: Same functionality on all supported platforms