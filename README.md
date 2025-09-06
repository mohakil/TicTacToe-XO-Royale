# TicTacToe: XO Royale

A premium Tic Tac Toe mobile game with modern UI/UX and Material 3 design, built with Flutter. Features a robust robot AI system with multiple difficulty levels and a clean, maintainable architecture.

## 🎮 Features

- **Modern Material 3 Design**: Clean, bold accents with deep neutrals and deliberate glow effects
- **Custom Game Engine**: CustomPainter-based game board with 60-144 FPS performance
- **Intelligent Robot AI**: Three difficulty levels (Easy, Medium, Hard) with strategic gameplay
- **Multiple Game Modes**: Local multiplayer and AI opponents with adjustable difficulty
- **Flexible Board Sizes**: Support for 3x3, 4x4, and 5x5 boards
- **Adaptive Win Conditions**: Configurable win conditions (3, 4, or 5 in a row)
- **Premium Visual Effects**: Animated X/O marks, winning line effects, and particle celebrations
- **Responsive Design**: Optimized for phones and tablets with adaptive layouts
- **Accessibility**: Dynamic type support, semantic labels, and high contrast ratios

## 🏗️ Architecture

### Technology Stack
- **Flutter 3.35.1**: Cross-platform mobile development framework
- **Material 3**: Latest Material Design system with custom theming
- **CustomPainter**: High-performance game board rendering and animations
- **GoRouter 16.2.0**: Type-safe navigation with custom transitions
- **Riverpod 2.6.1**: State management with immutable models
- **just_audio**: Low-latency audio for sound effects and music

### Project Structure
```
lib/
├── app/                    # App-level configuration
│   ├── constants/         # Global constants and configuration
│   ├── router/           # Navigation and routing
│   └── theme/            # Material 3 theming system
├── core/                  # Core business logic
│   ├── models/           # Data models and entities
│   │   ├── game_config.dart      # Game configuration
│   │   ├── game_enums.dart       # Centralized enums
│   │   ├── game_state.dart       # Game state management
│   │   ├── robot_config.dart     # Robot AI configuration
│   │   ├── player_profile.dart   # User profile data
│   │   └── store_item.dart       # In-app store items
│   ├── providers/        # State management providers
│   │   ├── profile_provider.dart
│   │   ├── settings_provider.dart
│   │   ├── store_provider.dart
│   │   └── theme_provider.dart
│   └── services/         # Business logic services
│       ├── animation_pool.dart   # Animation controller pooling
│       ├── audio_service.dart    # Audio management
│       ├── game_logic.dart       # Core game logic
│       ├── haptic_service.dart   # Haptic feedback
│       └── robot_service.dart    # AI robot logic
├── features/              # Feature-based modules
│   ├── loading/          # Loading screen with animations
│   ├── home/             # Main home screen
│   ├── setup/            # Game configuration
│   ├── game/             # Game play screen
│   ├── store/            # In-app store
│   ├── profile/          # User profile
│   └── settings/         # App settings
└── l10n/                  # Localization
```

## 🤖 Robot AI System

### Architecture
The robot AI system uses a **Strategy Pattern** for clean, maintainable code:

- **`RobotConfig`**: Configuration class with difficulty settings
- **`RobotService`**: Main service that coordinates AI decisions
- **`RobotStrategy`**: Interface for different AI behaviors
- **Strategy Implementations**:
  - `EasyRobotStrategy`: Random moves with basic blocking
  - `MediumRobotStrategy`: Strategic play with pattern recognition
  - `HardRobotStrategy`: Advanced tactics with lookahead

### Difficulty Levels
- **Easy**: Random moves, occasionally blocks obvious wins
- **Medium**: Strategic positioning, blocks wins, creates threats
- **Hard**: Advanced tactics, multiple move lookahead, optimal play

### Configuration
```dart
// Easy robot
final easyConfig = RobotConfig.forDifficulty(Difficulty.easy);

// Medium robot with custom settings
final mediumConfig = RobotConfig(
  difficulty: Difficulty.medium,
  thinkTime: Duration(milliseconds: 500),
  useHints: true,
);

// Hard robot
final hardConfig = RobotConfig.forDifficulty(Difficulty.hard);
```

## 🎨 Design System

### Color Palette
- **Primary**: Electric Azure (#2DD4FF) - Main accent color
- **Secondary**: Vivid Magenta (#F43F9D) - Secondary accent
- **Tertiary**: Lime Pulse (#A3E635) - Success and positive feedback
- **Neutral**: Deep space grays with high contrast ratios
- **Semantic**: Success, warning, error, and info colors

### Typography
- **Display/Headings**: Sora Variable (600 weight)
- **UI/Body**: Inter Variable (500 weight)
- **Numeric**: JetBrains Mono (700 weight) with tabular figures

### Motion
- **Micro**: 120ms for subtle interactions
- **Standard**: 240ms for typical animations
- **Emphasized**: 400ms for celebratory effects
- **Easing**: Custom cubic curves for natural motion

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.9.0 or higher
- Dart SDK 3.9.0 or higher
- Android Studio / Xcode for mobile development
- VS Code with Flutter extensions (recommended)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/tictactoe_xo_royale.git
   cd tictactoe_xo_royale
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Development Setup

1. **Code Generation** (for models and providers)
   ```bash
   flutter packages pub run build_runner build
   ```

2. **Linting and Analysis**
   ```bash
   flutter analyze
   ```

3. **Testing**
   ```bash
   flutter test
   ```

## 🎯 CustomPainter vs Flutter vs Material 3 Usage

### CustomPainter (Game Performance)
- **Game Board Rendering**: High-performance grid drawing with cached Paint objects
- **X/O Mark Animations**: Smooth drawing animations with AnimationController
- **Winning Line Effects**: Neon sweep effects with custom painting
- **Particle Systems**: Confetti and celebration effects
- **Touch Input Handling**: Direct canvas interaction for game controls

### Flutter Widgets (UI Structure)
- **Screen Layouts**: Scaffold, AppBar, and navigation structure
- **Form Controls**: Text fields, buttons, and input validation
- **Lists and Grids**: Game history, achievements, and store items
- **Overlays and Dialogs**: Popups, modals, and game state displays
- **Responsive Layouts**: Adaptive sizing for different screen sizes

### Material 3 (Design System)
- **Component Theming**: Cards, buttons, and form controls
- **Color Schemes**: Light/dark mode with semantic color tokens
- **Typography**: Consistent text styles and scaling
- **Motion**: Standardized animation durations and easing
- **Accessibility**: Built-in accessibility features and contrast ratios

## 📱 Performance Considerations

### Frame Rate Targets
- **Minimum**: 60 FPS on all devices
- **Target**: 120-144 FPS on supported devices
- **Budget**: ≤0.8ms per frame for board rendering

### Optimization Strategies
- **RepaintBoundary**: Isolate expensive painting operations
- **Cached Paint Objects**: Reuse Paint instances across frames
- **Animation Pooling**: Limit concurrent AnimationControllers
- **Lazy Loading**: Load assets and effects on demand
- **Memory Management**: Proper disposal of resources

### Platform Considerations
- **Android**: Optimize for various GPU capabilities
- **iOS**: Leverage Metal for hardware acceleration
- **Tablets**: Scale UI elements and increase touch targets
- **Landscape**: Optimize layout for horizontal orientation

## 🧪 Testing

### Unit Tests
- **Models**: Data validation and business logic
- **Providers**: State management and data flow
- **Services**: Audio, storage, and game logic
- **Robot AI**: Strategy testing and move validation
- **Utilities**: Helper functions and calculations

### Widget Tests
- **Screens**: UI rendering and user interactions
- **Components**: Reusable widget behavior
- **Navigation**: Route transitions and state changes
- **Responsiveness**: Layout adaptation to screen sizes

### Integration Tests
- **Game Flow**: Complete game scenarios
- **Robot AI**: Full game against different difficulty levels
- **State Persistence**: Data saving and loading
- **Performance**: Frame rate and memory usage
- **Accessibility**: Screen reader and navigation support

## 📦 Dependencies

### Core Dependencies
- `flutter_riverpod: ^2.6.1` - State management
- `go_router: ^16.2.0` - Navigation and routing
- `just_audio: ^0.10.4` - Audio playback
- `shared_preferences: ^2.5.3` - Local data storage
- `flutter_animate: ^4.5.2` - UI animations
- `google_fonts: ^6.3.0` - Typography
- `vibration: ^3.1.3` - Haptic feedback

### Development Dependencies
- `build_runner: ^2.4.13` - Code generation
- `json_serializable: ^6.8.0` - JSON serialization
- `riverpod_generator: ^2.6.5` - Provider code generation
- `flutter_lints: ^5.0.0` - Code quality rules
- `custom_lint: ^0.7.0` - Custom linting rules

## 🔧 Configuration

### Environment Variables
- `FLUTTER_TARGET`: Target platform (android/ios/web)
- `FLUTTER_MODE`: Build mode (debug/release/profile)

### Build Configuration
- **Android**: Minimum SDK 21, target SDK 34
- **iOS**: Minimum iOS 12.0, target iOS 17.0
- **Web**: Modern browser support with fallbacks

## 🏆 Recent Improvements

### Codebase Cleanup (Latest)
- ✅ **Removed unused files**: Eliminated 10+ unused utility files and widgets
- ✅ **Simplified architecture**: Streamlined robot configuration system
- ✅ **Centralized enums**: Consolidated all game enums into single source
- ✅ **Clean dependencies**: All dependencies properly used and optimized
- ✅ **Zero linting issues**: Complete code quality compliance
- ✅ **Optimized performance**: Animation pooling and memory management

### Robot AI Refactoring
- ✅ **Strategy Pattern**: Clean, maintainable AI architecture
- ✅ **Difficulty Levels**: Three distinct AI behaviors
- ✅ **Configuration System**: Flexible robot settings
- ✅ **Performance**: Optimized move calculation and decision making

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/tictactoe_xo_royale/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/tictactoe_xo_royale/discussions)
- **Documentation**: [Wiki](https://github.com/yourusername/tictactoe_xo_royale/wiki)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for the design system
- Open source community for inspiration and tools
- Beta testers for feedback and bug reports

---

**Built with ❤️ using Flutter and Material 3**