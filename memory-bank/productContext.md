# Product Context: TicTacToe XO Royale

## Why This Project Exists
TicTacToe XO Royale reimagines the classic Tic Tac Toe game as a premium mobile experience, addressing the limitations of traditional implementations: lack of engagement, no progression, and basic visuals. It solves the problem of "quick-play boredom" by adding depth through AI opponents, customization, achievements, and a store system, turning a simple puzzle into an addictive, replayable game. The project exists to demonstrate modern Flutter development for games, showcasing state management, animations, and UX polish in a fun, accessible format.

## Problems Solved
- **Engagement Gap**: Classic Tic Tac Toe ends too quickly without challenge. Solution: Variable board sizes (3x3-5x5), AI difficulties (easy/medium/hard with minimax), hints, and win streaks/achievements for progression.
- **Lack of Personalization**: No player identity or unlocks. Solution: Profile with stats/history, store for themes/boards/symbols/gems (mock IAP/ads), customizable setup (names, first move).
- **Poor UX in Mobile Games**: Flat UI, no feedback. Solution: Material 3 themes (light/dark), haptic/audio SFX (moves/win/draw), animations (confetti, sparkles, typewriter text), responsive layouts.
- **Offline Accessibility**: Many games require internet. Solution: Fully offline with local persistence (shared_preferences for settings/profile/store).
- **Development Pain Points**: Scalable architecture for games. Solution: Modular features (core shared services/providers), Riverpod for reactive state, go_router for nav, code gen for models.

## How It Works
1. **Onboarding/Loading**: Splash with logo animation, tips carousel, transitions to home.
2. **Home**: Quick stats ribbon, game mode cards (local/robot) with hover/press effects, typewriter welcome text.
3. **Setup**: Select board size/win condition, player names, difficulty/first move via chips/sliders.
4. **Gameplay**: Interactive board with custom painters (cells/marks/winning lines), controls (hint/undo/menu), overlays (results/exit/settings). AI computes moves asynchronously; haptics/audio on interactions.
5. **Post-Game**: Result overlay with confetti/stats, updates profile/achievements.
6. **Profile/Settings/Store**: View history/stats, toggle audio/theme/haptics, browse/unlock items (gems via mock ads), watch ad button with cooldown.
- **Data Flow**: Riverpod providers manage state (e.g., game_provider for board/moves, profile_provider for persistence). Services handle logic (game_logic for validation/AI, audio_service for preloading).
- **Offline Persistence**: JSON-serialized models saved to shared_preferences; loaded on app start.

## User Experience Goals
- **Intuitive & Fun**: Simple nav (bottom tabs via go_router), gesture-friendly (tap cells, swipe menus), immediate feedback (haptics on moves, audio cues).
- **Immersive**: Ambient particles/backgrounds, celebration animations (win confetti), smooth transitions (flutter_animate).
- **Personal & Rewarding**: Progression via gems/achievements, customization (unlockable themes/symbols), session-based stats for current game progress, lifetime profile statistics for historical tracking, game history tracking with progressive disclosure.
- **Accessible**: 48dp tap targets, high contrast themes, potential Semantics for screen readers (add if needed).
- **Performant**: 60+ FPS (custom painters avoid rebuilds), battery-friendly (pooled animations, no heavy loops).
- **Platform Native**: Material 3 for Android, haptic adaptations for iOS/Android.

This context ensures all features enhance user delight while solving core pain points of the genre.
