# Tech Context: TicTacToe XO Royale

## Technologies Used
- **Core Framework**: Flutter (Dart SDK ^3.9.0) for cross-platform UI. Material 3 enabled for modern design (ColorScheme.fromSeed, dynamic colors). Custom fonts (Sora/Inter/JetBrainsMono) via pubspec assets.
- **State Management**: Riverpod 3.0 (flutter_riverpod ^3.0.0, riverpod_annotation ^3.0.0, riverpod_generator ^3.0.0). Code-generated providers (.g.dart) for Notifiers/AsyncNotifiers. No legacy (StateNotifier/ChangeNotifier).
- **Navigation**: go_router ^16.2.1 for declarative routing (named/parameterized paths, StatefulShellRoute for tabs, errorBuilder/redirects).
- **UI & Animations**: flutter_animate ^4.5.2 (transitions), confetti ^0.8.0 (celebrations), shimmer ^3.0.0 (loaders), carousel_slider ^5.1.1 + smooth_page_indicator ^1.2.1 (carousels). Custom Canvas painters for game rendering. Custom responsive system with 244+ extension methods and 8 mixins for consistent UI adaptation.
- **Audio & Haptics**: just_audio ^0.10.5 (SFX/music preloading), vibration ^3.1.3 + HapticFeedback (platform-specific: iOS UIImpactFeedback, Android Vibrator). Platform-adaptive haptic patterns.
- **Data & Persistence**: Drift ^2.28.1 + sqlite3_flutter_libs ^0.5.0 (type-safe database with foreign keys and migrations), path ^1.9.1 (file paths), freezed_annotation ^3.0.0 + json_annotation ^4.9.0 (immutable models/serialization), equatable ^2.0.5 (equality), collection ^1.19.1 (utils). Migrating from shared_preferences to Drift for better data integrity and performance.
- **Utilities**: intl ^0.20.2 (formatting), device_info_plus ^12.1.0 + package_info_plus ^9.0.0 (platform/version info), google_fonts ^6.3.1 (fallback fonts).
- **Dev Tools**: build_runner ^2.7.1 (code gen), freezed ^3.2.3 + json_serializable ^6.11.1 (model gen), drift_dev ^2.28.1 (database code gen), flutter_lints ^6.0.0 + custom_lint ^0.8.0 + riverpod_lint ^3.0.0 (analysis/rules).

## Development Setup
- **Environment**: VSCode with Flutter/Dart extensions. Dart SDK ^3.9.0, Flutter 3.35+ (Impeller for iOS/Android perf). Android Studio/Xcode for platform builds.
- **Build Workflow**: `flutter pub get` -> `dart run build_runner build --delete-conflicting-outputs` (gen .g.dart) -> `flutter analyze` (lints) -> `dart format lib/` (style) -> `dart test` (unit/widget/integration) -> `flutter build apk/ios` (release).
- **Linting & Formatting**: analysis_options.yaml includes flutter_lints/flutter.yaml (120-char lines, no_print). riverpod_lint enforces ref usage/autoDispose. custom_lint for extras. Enforce via VSCode format-on-save.
- **Testing**: flutter_test/integration_test SDK. Mocks via provider overrides. Coverage via coverage package (target >90%). Performance tests with clock mocks.
- **Debugging**: Flutter DevTools for perf/UI inspector. kDebugMode guards for platform prints.
- **Version Control**: Git (commit d69956f8696730bb77386cdc6652167ac0c96c43 latest). .gitignore standard for Flutter.

## Technical Constraints
- **Platform**: Mobile-only (Android/iOS); no web/desktop support needed. Custom responsive system (phone <600px, tablet 600-900px) with type-safe utilities superior to external packages.
- **Offline-First**: No network deps; all data local (Drift SQLite with full provider migration complete provides better storage capacity and performance). Mock ads/data for store with realistic user flows.
- **Performance**: Target 60-144 FPS; custom painters/animation pooling to avoid jank. Minimax AI depth-limited for responsive gameplay. Responsive system <10% overhead with cached calculations.
- **Security**: Local-only; no sensitive data. Input validation (names 1-12 chars, board 3-5). No external API dependencies.
- **Compatibility**: Dart null safety, Flutter 3.35+ breaking changes addressed. Riverpod 3.0 migration complete with code generation.
- **Dependencies**: Strict versions (^); comprehensive test coverage ensures no conflicts. Custom responsive system preferred over external packages for better control and performance. Session stats management and game history system implemented for optimal UX.

## Dependency Relationships
- **Core Deps**: Riverpod -> freezed/json (code gen), Drift (type-safe database), dio (future network).
- **UI Deps**: go_router -> Riverpod (refreshListenable), flutter_animate/confetti/shimmer -> custom painters. Custom responsive system with 244+ extension methods provides superior control to external packages.
- **Platform Deps**: just_audio/vibration -> device_info_plus (platform detection), package_info_plus (app info).
- **Animation Deps**: carousel_slider + smooth_page_indicator for tips carousel, confetti for celebrations.
- **Dev Deps**: build_runner -> riverpod_generator/freezed/json_serializable/drift_dev. Lints (flutter_lints, custom_lint, riverpod_lint) ensure code quality. Comprehensive testing with 35+ test files.

## Tool Usage Patterns
- **Code Gen**: Annotate with @freezed/@riverpod/@DriftDatabase, run build_runner watch in dev.
- **Testing**: Unit (mock providers/services), Widget (pumpWidget with ProviderScope), Integration (flutter drive).
- **Profiling**: DevTools timeline for frames, memory for leaks (dispose in providers).
- **Deployment**: Flutter build (APK/IPA), TestFlight/App Store (future).

This context provides the technical foundation for development decisions and troubleshooting.
