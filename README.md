# TicTacToe: XO Royale

A premium Tic Tac Toe mobile game with modern UI/UX and Material 3 design, built with Flutter. Features a robust robot AI system with multiple difficulty levels, comprehensive responsive design system, and a clean, maintainable architecture using Riverpod 3.0.

## 🎮 Features

- **Modern Material 3 Design**: Clean, bold accents with deep neutrals and deliberate glow effects
- **Custom Game Engine**: CustomPainter-based game board with 60-144 FPS performance
- **Intelligent Robot AI**: Three difficulty levels (Easy, Medium, Hard) using minimax algorithm
- **Multiple Game Modes**: Local multiplayer and AI opponents with adjustable difficulty
- **Flexible Board Sizes**: Support for 3x3, 4x4, and 5x5 boards with adaptive win conditions
- **Premium Visual Effects**: Animated X/O marks, winning line effects, confetti celebrations, and particle systems
- **Advanced Responsive System**: Custom responsive design with 244+ extension methods and 8 comprehensive mixins
- **Audio & Haptics**: Immersive sound effects, background music, and platform-specific haptic feedback
- **Accessibility**: Dynamic type support, semantic labels, 48dp touch targets, and high contrast ratios
- **Offline-First**: Fully functional without internet connection with local data persistence

## 🏗️ Architecture

### Technology Stack
- **Flutter 3.35.1**: Cross-platform mobile development framework with Dart 3.9.0
- **Material 3**: Latest Material Design system with dynamic color support
- **CustomPainter**: High-performance game board rendering and animations (60-144 FPS)
- **GoRouter 16.2.0**: Type-safe navigation with custom transitions and error handling
- **Riverpod 3.0**: Modern state management with code generation and reactive providers
- **just_audio**: Low-latency audio for sound effects and background music
- **Custom Responsive System**: 244+ extension methods with type-safe responsive utilities


## 📐 Codebase Structure Template

This project implements a comprehensive structure template that serves as a reference for Flutter application organization:

```
your_flutter_project/
├── 📁 android/                      # Android platform configuration
│   ├── app/build.gradle.kts        # App-level build script
│   ├── app/src/main/               # Main source directory
│   │   ├── AndroidManifest.xml     # Android manifest
│   │   ├── java/.../MainActivity.kt # Main activity (Kotlin)
│   │   └── res/                    # Android resources (icons, layouts)
│   └── settings.gradle.kts         # Project-level Gradle config
├── 📁 ios/                         # iOS platform configuration
│   ├── Runner.xcodeproj/           # Xcode project
│   ├── Runner/AppDelegate.swift    # iOS app delegate
│   ├── Runner/Info.plist           # iOS configuration
│   └── RunnerTests/                # iOS unit tests
├── 📁 assets/                      # Static assets
│   ├── audio/music/                # Background music files
│   ├── audio/sfx/                  # Sound effect files
│   └── fonts/                      # Custom font files (TTF)
├── 📁 lib/                         # Main application code
│   ├── main.dart                    # App entry point
│   ├── app/                        # App-level configuration
│   │   ├── app.dart                # Main app widget with ProviderScope
│   │   ├── constants/              # Global constants & design tokens
│   │   ├── router/                # Navigation with go_router
│   │   └── theme/                 # Material 3 theming system
│   ├── core/                      # Core business logic (Clean Architecture)
│   │   ├── database/              # drift local database
│   │   ├── exceptions/            # Custom exception classes
│   │   ├── extensions/            # BuildContext responsive extensions (244+ methods)
│   │   ├── models/               # Immutable data models with code generation
│   │   ├── providers/            # Riverpod providers with code generation
│   │   ├── services/            # Business logic services with dependency injection
│   │   └── utils/               # Utility classes for responsive system
│   └── features/                  # Feature-based modules (Domain layer)
│       ├── game/              # Game play feature
│       │   ├── game.dart                     # Barrel exports
│       │   ├── presentation/screens/         # Game screen
│       │   │   └── game_screen.dart
│       │   ├── presentation/widgets/        # Game-specific widgets
│       │   │   ├── game_board/             # Game board components
│       │   │   │   ├── board_cell.dart
│       │   │   │   ├── board_grid.dart
│       │   │   │   └── game_board.dart
│       │   │   ├── game_interface/         # Game UI components
│       │   │   │   ├── game_controls.dart
│       │   │   │   ├── game_header.dart
│       │   │   │   └── game_status.dart
│       │   │   ├── overlays/               # Game overlays & dialogs
│       │   │   │   ├── exit_confirmation_overlay.dart
│       │   │   │   ├── game_result_overlay.dart
│       │   │   │   └── game_settings_overlay.dart
│       │   │   └── visual_effects/         # Visual effects & painters
│       │   │       ├── effects/            # Particle effects
│       │   │       │   ├── ambient_painter.dart
│       │   │       │   ├── confetti_painter.dart
│       │   │       │   └── hint_sparkle_painter.dart
│       │   │       └── painters/           # Custom painters
│       │   │           ├── board_painter.dart
│       │   │           ├── cell_painter.dart
│       │   │           ├── mark_painter.dart
│       │   │           └── winning_line_painter.dart
│       │   └── providers/                  # Game state providers
│       │       ├── game_provider.dart
│       │       └── game_provider.g.dart
│       ├── achievements/           # Achievements feature module
│       ├── home/                  # Home screen feature module
│       ├── loading/               # Loading screen feature module
│       ├── profile/               # User profile feature module
│       ├── settings/              # App settings feature module
│       ├── setup/                 # Game setup feature module
│       ├── shared/                # Shared components (responsive mixins)
│       └── store/                 # In-app store feature module
├── 📁 test/                       # Comprehensive test suite (35+ files)
│   ├── *_test.dart                # Unit tests for all components
│   ├── *_widget_test.dart         # Widget behavior tests
│   ├── integration_test.dart      # End-to-end integration tests
│   └── performance_test.dart      # Performance and optimization tests
├── 📄 pubspec.yaml                # Dependencies & asset configuration
├── 📄 analysis_options.yaml       # Code quality & linting rules
└── 📄 README.md                   # Project documentation
```

### Template Implementation Principles

1. **🏗️ Feature-Based Architecture**: Each feature module is self-contained with clear boundaries and responsibilities
2. **📦 Clean Architecture**: Strict separation of concerns across Presentation, Domain, and Data layers
3. **🔧 Code Generation Integration**: Automated generation of models, providers, and serialization code
4. **📚 Documentation System**: Memory-bank approach for maintaining project context and institutional knowledge
5. **🧪 Testing Strategy**: Comprehensive test coverage across unit, widget, integration, and performance dimensions
6. **📱 Cross-Platform Optimization**: Platform-specific configurations and optimizations for Android/iOS deployment

This structure template ensures maintainability, scalability, and consistency across Flutter projects.


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
- **Primary**: Electric Azure (#2DD4FF) - Main accent color for interactive elements
- **Secondary**: Vivid Magenta (#F43F9D) - Secondary accent for highlights
- **Tertiary**: Lime Pulse (#A3E635) - Success and positive feedback states
- **Neutral**: Deep space grays with WCAG-compliant contrast ratios
- **Semantic**: Success, warning, error, and info colors with proper accessibility

### Typography Scale
- **Display/Headings**: Sora Variable (600 weight) - Modern, readable headlines
- **UI/Body**: Inter Variable (500 weight) - Clean, legible body text
- **Numeric**: JetBrains Mono (700 weight) - Monospace for scores and data
- **System Integration**: Automatic text scaling support for accessibility

### Responsive Design System
- **Custom Implementation**: 244+ responsive extension methods via BuildContext
- **8 Comprehensive Mixins**: Card, Button, Spacing, Layout, Text, Icon, Container, AppBar
- **Type-Safe API**: Compile-time detection of responsive issues
- **Performance Optimized**: <10% overhead with cached calculations
- **Breakpoint System**: 600px (phone) and 900px (tablet) breakpoints

### Motion Design
- **Micro**: 120ms for subtle interactions and feedback
- **Standard**: 240ms for typical animations and transitions
- **Emphasized**: 400ms for celebratory effects and state changes
- **Celebration**: 1200ms for win states with confetti and particles
- **Easing**: Custom cubic-bezier curves for natural, fluid motion
- **Animation Pooling**: Memory-efficient animation controller management

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

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Code Generation** (for models, providers, and serialization)
   ```bash
   # Generate all code (models, providers, JSON serialization)
   dart run build_runner build --delete-conflicting-outputs

   # Watch mode for development (auto-regenerate on changes)
   dart run build_runner watch
   ```

3. **Linting and Code Quality**
   ```bash
   # Analyze code for issues and style
   flutter analyze

   # Format code according to Dart style guide
   dart format lib/

   # Run all tests with coverage
   flutter test --coverage
   ```

4. **Testing**
   ```bash
   # Run all tests
   flutter test

   # Run specific test categories
   flutter test test/*_test.dart

   # Run performance tests
   flutter test test/*performance_test.dart
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
- **Minimum**: 60 FPS on all devices (16.67ms frame budget)
- **Target**: 120-144 FPS on supported devices (8.33ms-6.94ms frame budget)
- **Game Rendering**: ≤8ms per frame for board rendering and animations

### Optimization Strategies
- **CustomPainter Rendering**: High-performance Canvas-based game board with cached Paint objects
- **RepaintBoundary**: Isolate expensive painting operations for game visuals
- **Animation Pooling**: Limit concurrent AnimationControllers with shared resource pool
- **Memory Management**: Proper disposal of controllers, streams, and animations in dispose()
- **Provider Optimization**: Selective rebuilds using `.select()` and `updateShouldNotify`
- **Asset Preloading**: Audio and visual assets loaded during app initialization
- **Code Generation**: Reduced runtime reflection with generated immutable models

### Platform-Specific Optimizations
- **Android**: Custom responsive system optimized for various GPU capabilities and screen densities
- **iOS**: Leverages Metal rendering engine with platform-specific haptic patterns
- **Cross-Platform**: Unified responsive API that adapts to platform conventions
- **Device Orientation**: Responsive layouts optimize for both portrait and landscape modes

### Responsive System Performance
- **Overhead**: <10% performance impact with cached calculations
- **Memory Usage**: No significant memory increase from responsive utilities
- **Build Time**: No regression in compilation performance
- **Runtime**: Singleton pattern with lazy evaluation for optimal performance

## 🧪 Testing Strategy

### Comprehensive Test Coverage (>90%)
- **35+ Test Files**: Unit, widget, integration, and performance tests
- **Test Categories**: Models, providers, services, UI components, and end-to-end flows
- **Performance Tests**: Frame rate monitoring, memory usage, and optimization validation

### Unit Tests
- **Models**: Data validation, serialization, and business logic with freezed models
- **Providers**: State management, data flow, and provider lifecycle with Riverpod
- **Services**: Audio playback, haptic feedback, game logic, and AI strategies
- **Robot AI**: Minimax algorithm, difficulty strategies, and move validation
- **Utilities**: Responsive calculations, helper functions, and configuration logic

### Widget Tests
- **Screens**: UI rendering, user interactions, and state management integration
- **Components**: Reusable widget behavior, animations, and responsive layouts
- **Navigation**: Route transitions, deep linking, and state persistence
- **Responsiveness**: Layout adaptation across device sizes and orientations
- **Accessibility**: Screen reader compatibility and touch target validation

### Integration Tests
- **Game Flow**: Complete gameplay scenarios from setup to completion
- **Robot AI**: Full games against all difficulty levels with strategy validation
- **State Persistence**: Data saving, loading, and cross-session consistency
- **Performance**: Real-time frame rate monitoring and memory leak detection
- **Cross-Platform**: Platform-specific behavior validation

### Specialized Tests
- **Animation Pool Tests**: Memory management and controller lifecycle
- **Responsive System Tests**: Breakpoint accuracy and scaling validation
- **Provider Disposal Tests**: Memory leak prevention and cleanup verification
- **Performance Optimization Tests**: Custom painter efficiency and bundle size

## 📦 Dependencies

### Core Dependencies
- `flutter_riverpod: ^3.0.0` - Modern state management with code generation
- `riverpod_annotation: ^3.0.0` - Riverpod code generation annotations
- `go_router: ^16.2.1` - Type-safe navigation and routing
- `just_audio: ^0.10.5` - Low-latency audio playback for SFX and music
- `shared_preferences: ^2.5.3` - Local data persistence
- `flutter_animate: ^4.5.2` - UI animations and transitions
- `google_fonts: ^6.3.1` - Typography with custom font support
- `vibration: ^3.1.3` - Platform-specific haptic feedback
- `dio: ^5.9.0` - HTTP client for future network features
- `device_info_plus: ^12.1.0` - Device information and capabilities
- `package_info_plus: ^9.0.0` - App version and package information

### UI & Animation Dependencies
- `shimmer: ^3.0.0` - Loading shimmer effects
- `confetti: ^0.8.0` - Celebration particle effects
- `carousel_slider: ^5.1.1` - Tips carousel component
- `smooth_page_indicator: ^1.2.1` - Carousel page indicators

### Development Dependencies
- `build_runner: ^2.7.1` - Code generation orchestration
- `freezed: ^3.2.3` - Immutable model generation
- `json_serializable: ^6.11.1` - JSON serialization code generation
- `riverpod_generator: ^3.0.0` - Riverpod provider code generation
- `flutter_lints: ^6.0.0` - Code quality and style rules
- `custom_lint: ^0.8.0` - Custom linting rules
- `riverpod_lint: ^3.0.0` - Riverpod-specific linting rules

### Code Generation Features
- **Freezed Models**: Immutable data classes with copyWith and equality
- **JSON Serialization**: Automatic to/from JSON conversion
- **Riverpod Providers**: Type-safe state management providers
- **Custom Extensions**: BuildContext responsive utility extensions

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