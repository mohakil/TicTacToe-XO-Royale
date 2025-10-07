# System Patterns: TicTacToe XO Royale

## System Architecture
The architecture follows a clean, modular pattern inspired by clean architecture principles, with strict separation of concerns (SoC) and comprehensive responsive design integration. Layers are isolated to promote testability and scalability:

- **Presentation Layer** (lib/features/*/presentation/): UI components (widgets/screens). Stateless/ConsumerWidgets react to state via Riverpod selectors. Custom painters for performance-critical rendering (e.g., game board avoids widget rebuilds). Comprehensive responsive mixins for consistent UI adaptation.
- **Domain/Business Layer** (lib/core/services/, lib/features/*/providers/): Logic and state. Services handle domain ops (e.g., game_logic for validation/minimax AI, audio_service for playback). Providers (Riverpod Notifiers/AsyncNotifiers) manage reactive state, depending on services. Animation pooling for memory-efficient effects.
- **Data Layer** (lib/core/models/, lib/core/database/, lib/core/providers/ for persistence): Immutable models (freezed unions like GameState, JSON-serializable like PlayerProfile, Achievement). Local storage via Drift database with full provider migration complete. Type-safe database operations with foreign key relationships and CASCADE DELETE constraints. Code-generated serialization and database operations.
- **Global Layer** (lib/app/): Cross-cutting (router, theme, constants). go_router for navigation, ThemeData for Material 3 with custom extensions. Responsive configuration singleton for global responsive utilities.

No repository layer needed (offline-only); future backend integrations can be added without breaking existing architecture.

## Key Technical Decisions
- **State Management**: Riverpod 3.0 with code gen (@riverpod annotations, .g.dart). Notifiers for mutable state (e.g., GameNotifier updates board/moves), AsyncNotifiers for loading (e.g., profile_provider fetches from storage). autoDispose for ephemeral state, families for parameterized (e.g., store_item(id)).
- **Navigation**: go_router with named/parameterized routes (e.g., /game/:configId). StatefulShellRoute for tab persistence (home/profile/store). Redirects for auth-like guards (e.g., setup if no profile).
- **Data Modeling**: Freezed for unions/immutability (e.g., GameState: Initial | Playing | Won(Draw/Paused)), json_serializable for persistence. Enums (Difficulty, StoreCategory) for type safety.
- **UI/Rendering**: Custom painters (Canvas) for game visuals (cell_painter, winning_line_painter) to optimize draws. flutter_animate for transitions, confetti for effects. Comprehensive responsive system with 244+ extension methods and 8 mixins for consistent UI adaptation.
- **Media/Feedback**: Services for audio (just_audio preloads SFX/music) and haptics (platform channels for iOS patterns). Pooled animations (animation_pool) to avoid allocations. Platform-specific haptic feedback patterns.
- **Error Handling**: Try-catch with fallbacks (e.g., AI timeout -> random move). Custom exceptions (e.g., InsufficientGemsException). Provider-level error boundaries with user-friendly error screens.

## Design Patterns in Use
- **Dependency Inversion (DIP)**: Providers depend on abstract services (e.g., IGameLogic injected via services_provider), enabling mocks in tests.
- **Observer Pattern**: Riverpod's ref.watch/listen for reactive updates (e.g., theme changes propagate via ConsumerWidgets).
- **Factory/Builder**: Code gen for providers/models; app_constants.dart for design tokens (spacing, durations, colors).
- **Singleton Pattern**: Services as providers (e.g., audio_service singleton via Provider((ref) => AudioService())) for global access. ResponsiveConfig singleton for global responsive utilities.
- **Strategy Pattern**: Robot difficulties as strategies in robot_service (easy: random, hard: minimax with alpha-beta pruning).
- **Extension Pattern**: BuildContext extensions for responsive utilities (context.scale(), context.getResponsiveSpacing()).
- **Mixin Pattern**: 8 responsive mixins (ResponsiveCard, ResponsiveButton, etc.) for consistent widget behavior.
- **Immutable State**: Freezed ensures no mutations; equatable for == comparisons in lists.
- **Barrel Export Pattern**: Clean import structure via index files (models.dart, services.dart, providers.dart).
- **Animation Pattern**: Robot thinking animation with AnimationPool, responsive sizing, and player color integration for enhanced gameplay UX.
- **Session Stats Pattern**: Dual stats system with session-based display (resets on fresh game) and lifetime profile tracking (preserves historical data) for optimal user experience.
- **Game History Pattern**: Progressive disclosure history system showing 3 recent games initially with view all functionality for complete 20-game history, focusing on essential game info without time complexity.
- **Database Migration Pattern**: Complete sequential phase-based migration from shared_preferences to Drift across all providers with user confirmation gates, comprehensive testing, and production-ready implementation.
- **Data Integrity Pattern**: Foreign key constraints with CASCADE DELETE for referential consistency and data validation utilities for migration integrity.

## Component Relationships
- **Core to Features**: Core providers/services exported via barrels (providers.dart, services.dart). Features import core (e.g., game_provider uses game_logic, haptic_service).
- **Providers Hierarchy**: Global (theme_provider, achievements_provider) -> Core (profile_provider depends on settings_provider) -> Feature (game_provider watches profile for gems/hints, achievements_provider for achievement state).
- **UI to State**: Widgets watch providers (ref.watch(gameStateProvider.select((s) => s.board))), notify via notifiers (ref.read(gameNotifier).makeMove(row, col)).
- **Services to Data**: Services use models (game_logic takes GameConfig, returns GameState); providers serialize to storage.
- **Navigation Flow**: Router (app_router) -> Features (e.g., /setup -> setup_provider -> /game with params).
- **Game History Flow**: Game completion -> game_provider updates profile_provider history -> achievements_provider checks for achievement unlocks -> UI displays session/lifetime stats.
- **Dependencies Graph**: No cycles; core independent, features depend on core, app on all.

## Critical Implementation Paths
- **App Startup**: main.dart -> ProviderScope (overrides globalEventProvider) -> MainApp (MaterialApp.router + themeModeProvider) -> routerProvider (initial /loading) -> loading_provider (tips carousel) -> home.
- **Game Flow**: Home -> Setup (setup_provider validates config) -> Game (game_provider initializes from config, watches robot_service for AI turns) -> Overlays (result updates profile_provider + checks achievements_provider for unlocks) -> Home (stats refresh).
- **Store/Purchase**: Store screen -> store_provider (loads items) -> watchAd (simulates, adds gems via profile_provider) -> Unlock (updates store state, persists).
- **Theme Switch**: settings -> theme_provider (AsyncNotifier saves mode) -> Rebuilds via themeModeProvider in MainApp.
- **Error Path**: Provider fail (e.g., load error) -> Fallback state (default theme/profile) -> user SnackBar.

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

This document captures architectural patterns for consistent implementation and refactoring.
