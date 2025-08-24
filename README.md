# TicTacToe: XO Royale

A premium Tic Tac Toe mobile game with modern UI/UX and Material 3 design, built with Flutter.

## 🎮 Features

- **Modern Material 3 Design**: Clean, bold accents with deep neutrals and deliberate glow effects
- **Custom Game Engine**: CustomPainter-based game board with 60-144 FPS performance
- **Multiple Game Modes**: Local multiplayer and AI opponents with adjustable difficulty
- **Flexible Board Sizes**: Support for 3x3, 4x4, and 5x5 boards
- **Adaptive Win Conditions**: Configurable win conditions (3, 4, or 5 in a row)
- **Premium Visual Effects**: Animated X/O marks, winning line effects, and particle celebrations
- **Responsive Design**: Optimized for phones and tablets with adaptive layouts
- **Accessibility**: Dynamic type support, semantic labels, and high contrast ratios

## 🏗️ Architecture

### Technology Stack
- **Flutter**: Cross-platform mobile development framework
- **Material 3**: Latest Material Design system with custom theming
- **CustomPainter**: High-performance game board rendering and animations
- **GoRouter**: Type-safe navigation with custom transitions
- **Riverpod**: State management with immutable models
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
│   ├── providers/        # State management providers
│   ├── services/         # Business logic services
│   └── utils/            # Utility functions and helpers
├── features/              # Feature-based modules
│   ├── loading/          # Loading screen with animations
│   ├── home/             # Main home screen
│   ├── setup/            # Game configuration
│   ├── game/             # Game play screen
│   ├── store/            # In-app store
│   ├── profile/          # User profile
│   └── settings/         # App settings
├── shared/                # Reusable components
│   ├── widgets/          # Common UI components
│   ├── animations/       # Reusable animations
│   └── layouts/          # Responsive layout helpers
└── l10n/                  # Localization
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
- **Utilities**: Helper functions and calculations

### Widget Tests
- **Screens**: UI rendering and user interactions
- **Components**: Reusable widget behavior
- **Navigation**: Route transitions and state changes
- **Responsiveness**: Layout adaptation to screen sizes

### Integration Tests
- **Game Flow**: Complete game scenarios
- **State Persistence**: Data saving and loading
- **Performance**: Frame rate and memory usage
- **Accessibility**: Screen reader and navigation support

## 📦 Dependencies

### Core Dependencies
- `flutter_riverpod`: State management
- `go_router`: Navigation and routing
- `just_audio`: Audio playback
- `shared_preferences`: Local data storage
- `flutter_animate`: UI animations

### Development Dependencies
- `build_runner`: Code generation
- `freezed`: Immutable data classes
- `json_serializable`: JSON serialization
- `riverpod_generator`: Provider code generation
- `flutter_lints`: Code quality rules

## 🔧 Configuration

### Environment Variables
- `FLUTTER_TARGET`: Target platform (android/ios/web)
- `FLUTTER_MODE`: Build mode (debug/release/profile)

### Build Configuration
- **Android**: Minimum SDK 21, target SDK 34
- **iOS**: Minimum iOS 12.0, target iOS 17.0
- **Web**: Modern browser support with fallbacks

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
