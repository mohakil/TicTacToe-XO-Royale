# Project Brief: TicTacToe XO Royale

## Project Overview
TicTacToe XO Royale is a premium mobile game built with Flutter, offering an enhanced Tic Tac Toe experience with modern UI/UX, Material 3 design, comprehensive responsive system, and engaging features like AI opponents, customizable boards, in-app store, player profiles, and achievements. The project demonstrates advanced Flutter development with a custom responsive design system (244+ extension methods), clean architecture, and production-ready code quality, targeting Android and iOS platforms.

## Core Requirements
- **Gameplay**: Standard Tic Tac Toe on 3x3 to 5x5 boards, with win conditions (3-5 in a row). Support local play and vs. robot AI (easy/medium/hard difficulties using minimax algorithm).
- **Features**:
  - Setup screen for board size, win condition, player names, first move.
  - Game screen with board, controls, hints, overlays (results, settings, exit).
  - Home screen with quick stats, game modes.
  - Profile with history, achievements, stats.
  - Settings for theme, audio, haptics.
  - Store for themes/boards/symbols/gems (mock purchases, ad rewards).
  - Loading screen with tips carousel.
- **UX Goals**: Smooth 60-120 FPS animations (confetti, sparkles, winning lines), audio/haptic feedback, responsive design (phone/tablet), dark/light themes.
- **Technical Constraints**: Offline-only (local storage via Drift database with full provider migration complete), no backend. Dart SDK ^3.9.0, Flutter 3.35+ compatible. Code generation for models/providers/responsive utilities/database operations.
- **Scope**: MVP complete with comprehensive responsive system (100% migrated), custom animation pooling, and advanced AI strategies. Future: Real ads, multiplayer, cloud sync.
- **Success Metrics**: >90% test coverage, 60+ FPS performance, <10% responsive overhead, zero linting issues, type-safe responsive API, production-ready code quality.

## Key Decisions
- **Architecture**: Clean/modular (core shared, features domain-specific) with strict separation of concerns and dependency inversion.
- **State Management**: Riverpod 3.0 with code generation for type-safe reactive providers and optimal rebuilds.
- **Navigation**: go_router for type-safe routing with ShellRoute for bottom navigation and comprehensive error handling.
- **Data Layer**: Immutable models (freezed/json_serializable) with Drift database integration complete and automatic serialization/equality.
- **Responsive Design**: Custom responsive system with 244+ extension methods, 8 mixins, and type-safe API (superior to external packages).
- **Performance**: CustomPainter rendering for game visuals, animation pooling, and provider optimization for 60+ FPS.
- **Code Generation**: Comprehensive code generation for models, providers, JSON serialization, responsive utilities, and Drift database operations.
- **Stats Management**: Dual stats system (session display + lifetime profile tracking) with intelligent reset logic for optimal user experience.
- **Game History**: Progressive disclosure system showing 3 recent games with view all functionality for complete 20-game history tracking.

This brief serves as the source of truth for scope and guides all development decisions.
