You are a senior Flutter UI/UX engineer and product designer. Build a modern, sleek, premium Tic Tac Toe mobile game with obsessive attention to motion, color psychology, and Material 3 coherence. Use Flutter for all app functionality including the interactive game canvas, animations, and celebrations. Adhere to best practices for responsiveness, accessibility, and 60–144 FPS performance on Android and iOS (phones and tablets).


Game Naming 
- App Title (store): TicTacToe: XO Royale
- Package Name: com.astrixforge.tictactoe.xoroyale 
- Dart Project Name: tictactoe_xo_royale

Tech stack and architecture
- Flutter (stable), Material 3 (ColorScheme + Typography + component theming).
- CustomPainter and Canvas for the game board, input handling, animations, and visual effects.
- GoRouter for navigation with custom transitions.
- Riverpod (or Bloc) for state management; prefer Riverpod with immutable models.
- Audio: just_audio for low-latency SFX/Music with caching.
- Assets: vector (SVG for icons where possible), raster WebP/PNG, 2x/3x density. Keep draw calls minimal.

- Where to use what
  - CustomPainter + Canvas: Game board rendering/interaction, X/O draw/animate, winning line highlight, particle-like effects for celebrations, subtle idle board effects, in-game hint sparkle, frame-timed animations at 60–144 FPS.
  - Flutter + Material 3: All screens (loading, home, profile, store, settings, setup), navigation bars, app bars, cards, lists, tabs, dialogs, badges, buttons, carousels, text, icons.
  - Flutter Widgets: All popups (win/lose/draw, hint, exit), HUD controls (scoreboard, turn indicator, bottom action bar).
  - CustomPainter: Both static previews in setup and the live interactive game board.

Design language (premium, modern)
- Style: clean, bold accents with deep neutrals, deliberate glow, soft shadows, and micro-interactions. Prefer rounded geometry with 16 px radius on major surfaces, 8 px on controls, 20–24 px on prominent CTA buttons.
- Grid and spacing: 4‑pt base. Spacing tokens: 4, 8, 12, 16, 20, 24, 32, 40.
- Iconography: Material Symbols Rounded (filled for primary actions, outlined for secondary). Consistent optical sizes.
- Elevation: flat by default (elevation 0) with tinted state layers in M3. Use subtle Z-elevation only to indicate interaction or modal layering.

Neuroscience-informed color system (dopamine-positive, high engagement)
Principles
- Use low-chroma, calming surfaces with high-chroma neon accent(s) to create salience and reward moments.
- Limit primary accent to 1–2 hues (azure/cyan + magenta) to avoid fatigue. Use lime only for win/success feedback.
- Maintain contrast: normal text ≥ 4.5:1, large text ≥ 3:1. Never rely on color alone for meaning—pair with icons/text.

Color tokens (Light Mode)
- Neutral surfaces
  - surface: #F7F8FB
  - surfaceContainer: #FFFFFF
  - surfaceDim: #EDEFF5
  - outline: #D6DAE3
  - onSurface: #0F1722
  - onSurfaceVariant: #3C4657
- Accents
  - primary (Electric Azure): #2DD4FF
  - onPrimary: #031318
  - primaryContainer: #C7F3FF
  - secondary (Vivid Magenta): #F43F9D
  - onSecondary: #190912
  - secondaryContainer: #FFD7EC
  - tertiary (Lime Pulse for success): #A3E635
  - onTertiary: #0E1605
- Semantic
  - success: #22C55E
  - warning: #F59E0B
  - error: #EF4444
  - info: #38BDF8
  - gemGold: #FFC24D
  - hintAmber: #FFB020
- Gradients (subtle, 4–8% opacity on surfaces; full on animations/accents)
  - azureMagenta: linear(45°) from #2DD4FF → #F43F9D
  - deepSpace: radial from #F7F8FB → #EDEFF5 with 2% noise

Color tokens (Dark Mode)
- Neutral surfaces
  - surface: #0B0F14
  - surfaceContainer: #111722
  - surfaceDim: #080B10
  - outline: #223041
  - onSurface: #E6ECF7
  - onSurfaceVariant: #9AA6B8
- Accents
  - primary: #7DE9FF
  - onPrimary: #001217
  - primaryContainer: #123847
  - secondary: #FF73C5
  - onSecondary: #1C0514
  - secondaryContainer: #3B1029
  - tertiary: #B6F05A
  - onTertiary: #0B1503
- Semantic
  - success: #34D399
  - warning: #FBBF24
  - error: #F87171
  - info: #7DD3FC
  - gemGold: #FFCF6A
  - hintAmber: #FFC448
- Special effects
  - glowCyan: #00E5FF at 40–60% opacity with 12–24 blur
  - glowMagenta: #FF4D9D at 30–50% opacity with 12–24 blur

Material 3 schemes
- Build full ColorScheme light/dark from the above tokens. Provide ThemeExtensions for:
  - GameColors { win, loss, draw, gem, hint, boardLine, boardCellHover, boardCellPressed }
  - MotionDurations, MotionEasings
  - Elevations for overlays

Typography (premium, legible, game-friendly)
- Fonts
  - Display/Headings + X/O glyphs: Sora Variable
  - UI/Body: Inter Variable
  - Numeric (scoreboard, counters): JetBrains Mono
- Type scale (mobile; scale up by +2–4 pt on tablets)
  - displayLarge: 44/52, Sora w600
  - displayMedium: 36/44, Sora w600
  - headlineLarge: 28/36, Sora w600
  - titleLarge: 22/28, Sora w600
  - titleMedium: 18/24, Sora w600
  - bodyLarge: 16/24, Inter w500
  - bodyMedium: 14/20, Inter w500
  - labelLarge: 14/20, Inter w600 (buttons)
  - labelSmall: 12/16, Inter w600 (badges)
  - scoreboardDigits: 42/48, JetBrains Mono w700
- Typographic rules
  - Tighten letter-spacing slightly on large headings (-0.2 to -0.4 px).
  - Use figure-aligned numerals for scoreboard.

Motion and interaction
- Global durations
  - micro: 90–120 ms
  - standard: 200–240 ms
  - emphasized: 300–400 ms
- Easing
  - standard: cubic(0.2, 0, 0, 1)
  - emphasized: cubic(0.2, 0, 0, 1), with overshoot on celebratory elements cubic(0.34, 1.56, 0.64, 1)
- Haptics (Android/iOS)
  - tap: lightImpact
  - place mark: selectionClick + softTick
  - win: successHeavy
  - loss: softImpact
  - draw: gentleImpact
- Sound cues (short < 150 ms)
  - tap: soft wood/plastic tick
  - place X/O: distinct tones (X lower, O higher)
  - win: arpeggio up; loss: low thud; draw: neutral chord

Navigation
- Bottom navigation with 4 items (Material 3 NavigationBar):
  - Home (icon: home)
  - Store (icon: storefront)
  - Profile (icon: account_circle)
  - Settings (icon: tune)
- GoRouter transitions
  - Push: shared axis X for lateral moves (200 ms)
  - Modal/overlays: fade through (120 ms in, 90 ms out)

Screens and components (acceptance criteria)

1) Loading screen
- Flutter screen with animated background using CustomPainter (low-CPU animated shapes).
- Centered logo "XO" lock-up with subtle pulsating glow (azure → magenta). Accessibility: no more than 30% luminance change.
- Progress indicator: determinate linear bar (M3) with soft gradient.
- Tips carousel below (3–5 tips) with 5 s auto-advance, swipeable.
- Duration target: 1–2 s typical; show skeleton if longer.
- Implementation: Flutter with CustomPainter background; Material 3 for progress bar.

2) Home screen
- Header hero with typewriter animation:
  - small: "Welcome back!"
  - big: "Ready to play?"
  - Typewriter speed ~35–45 ms/char, caret blink 600 ms.
- CTA cards (Material 3 Cards, large):
  - Local Player (icon: groups_2)
  - Robot (Computer) (icon: smart_toy)
  - Each card has hover/press states, slight parallax icon (8 px) on hover.
- Quick stats ribbon: last result, streak, gems count (gem icon), hint count.
- Ambient: subtle floating X/O shapes at 5% opacity using AnimatedBuilder; 0.2–0.3 movement speed.
- Implementation: Flutter (hero, cards, ribbon). Navigation to Setup screen. Background decorative animations using AnimatedBuilder and CustomPainter.

3) Game Setup screen
- Two modes: Local Player, Robot (Computer). Use segmented control at top (ChoiceChips).
- Player Names section:
  - Player 1, Player 2 text fields (auto-capitalize words, max 12 chars). For Robot mode, Player 2 is "CPU."
- First Move selector (Chips):
  - "X", "O", "Random" (default Random)
- Difficulty (Robot mode only): Easy, Medium, Hard (radio chips) with brief descriptions.
- Board Size carousel (3x3, 4x4, 5x5):
  - Horizontal carousel with snapping. Each item shows a visual board preview (static via CustomPainter) and size label.
- Win Condition carousel:
  - Options: "3 in a row", "4 in a row", "5 in a row". Only enable conditions ≤ board size.
  - Preview overlays winning line example.
- Start button (prominent, full-width on phones).
- Implementation detail:
  - Carousels use PageView with viewportFraction ~0.7, card transforms on center.
  - Previews: Flutter CustomPainter for efficiency.
  - Validation: Disable Start if inputs invalid.

4) Game screen (CustomPainter + Flutter overlays)
- Layout
  - Top-left: Exit icon (close) → opens Exit confirm popup.
  - Top-right: Quick settings icon (settings) → overlay for sound/music/vibration.
  - Scoreboard (top center overlay):
    - Big "X" and "O" badges with player names below.
    - Win counts on each side with JetBrains Mono digits.
    - Active player indicator: glowing underline + pulsing dot.
  - Player turn indicator: "Your turn" + symbol chip below scoreboard.
  - Board (center): CustomPainter canvas rendering grid and marks.
    - Cell states: empty (hover shimmer on supported platforms), pressed (scale 0.96 + shadow), filled with animated mark.
    - X/O animation:
      - X: two strokes draw-on using AnimationController, 200 ms each, slight overshoot.
      - O: circle sweep 320° → 360° using AnimationController, 240 ms, luminous edge.
    - Winning line: neon sweep (azure/magenta blend) from first to last cell using AnimationController, 450 ms.
  - Bottom control bar:
    - Hint button with badge (count), disabled at 0.
    - New Game button (restart_alt).
- Performance notes
  - Use CustomPainter with cached Paint objects; avoid per-frame text layout on the canvas.
  - Use AnimationController with proper dispose; limit concurrent animations.
  - Particle-like effects spawn only on win and hint (brief) using AnimatedBuilder.
- Implementation split
  - CustomPainter Widget: board state, input handling, rendering, animated effects.
  - Flutter overlays: scoreboard, indicators, bottom bar, popups.

5) Settings screen
- Toggles:
  - Sound (icon volume_up)
  - Music (icon music_note)
  - Vibration (icon vibration)
  - Theme: Light / Dark switch (icon dark_mode)
- About: version, credits.
- Data: Clear local data (with confirm dialog).
- Implementation: Flutter; Material Switches/Lists; store to local prefs.

6) User profile screen
- Header: Avatar (use Google Play Games if available; else initials), Nickname editable, Login/Link buttons (Google/Apple).
- Stats: Games Played, Wins, Losses, Draws, Win Rate, Longest Streak. Use compact cards with icons:
  - wins: emoji_events
  - losses: heart_broken
  - draws: horizontal_rule
- History list (last 20): opponent type, board size, win condition, result, timestamp; list item CTA to replay highlight (future).
- Achievements grid: badges locked/unlocked, progress ring 0–100%.
- Implementation: Flutter; Material 3 lists/cards; persistence via local storage mock.

7) Store screen (mock data for initial version)
- Tabs: Themes, Board Designs, X/O Symbols, Gems.
- General grid item layout:
  - Preview thumbnail (board or symbol)
  - Title + short descriptor
  - Lock overlay if locked
  - Price chip: "100" with gem icon or premium tag
  - CTA: "Unlock" (enabled for gem-unlock items), "Buy" for premium (disabled mock)
  - "Watch Ad" button near gem balance to earn +10 gems (mock).
- Default: Only Default Theme (light/dark) selectable; all others locked.
- Gems tab: packages (100, 500, 1200) mock, disabled purchases.
- Implementation: Flutter Tabs + GridView; use ThemeExtensions to preview theme swatches. All interactions update mock state only.

8) Popups (Flutter overlays)
- Hint popup
  - If hint count > 0: show animated sparkle path to the recommended cell using AnimatedBuilder; deduct 1 hint.
  - If 0: offer "Get hints" with gem cost or "Watch ad" (mock).
- Exit confirmation
  - "Quit current game?" buttons: "Continue" (primary), "Exit" (secondary). Top-right close (close icon).
- Result popup
  - Win/Loss/Draw
  - Win: emit confetti-like effects using AnimatedBuilder and CustomPainter 1.2 s; show stats summary and CTA: "Play Again," "Home."
  - Loss: subtle fading animation downward using AnimatedBuilder; same CTAs.
  - Draw: no celebration; neutral illustration.
  - All popups use scrim blur (if supported) and strong focus trap.

Robot difficulty behaviors (for reference, not full implementation)
- Easy: random with light heuristics; 10–20% intentional blunders.
- Medium: minimax depth limited; avoid obvious traps.
- Hard: full optimal for chosen board size/condition; optional alpha-beta pruning.

Icons (Material Symbols Rounded)
- Home: home
- Store: storefront
- Profile: account_circle
- Settings: tune
- Sound: volume_up / volume_off
- Music: music_note / music_off
- Vibration: vibration
- Theme: dark_mode / light_mode
- Exit: close
- Hint: lightbulb
- New Game: restart_alt
- CPU: smart_toy
- Players: groups_2
- Achievements: military_tech
- Wins: emoji_events
- Losses: heart_broken
- Draws: horizontal_rule
- Gems: diamond / local_atm (if diamond not available)
- Lock: lock
- Play: play_arrow

Micro-interactions (examples)
- Button press: scale 0.98, elevation +2, 120 ms.
- NavigationBar selection: icon morph + color transition 200 ms.
- Card hover (if mouse/tablet): translateY -4 px, shadow tint toward accent.
- Carousel snap: emphasized decel easing; centered card scale 1.0, sides 0.9.

Accessibility
- Dynamic type support: scale typography with MediaQuery.textScaleFactor; ensure no truncation.
- Contrast: enforce pairs; test under dark/light and grayscale.
- Haptics toggle respects system settings.

Responsive/adaptive rules
- Phones portrait: single-column layouts; FABs avoided; bottom bars compact.
- Phones landscape: two-panel game: sidebar shows scoreboard + controls.
- Tablets/iPads: two-column layouts; enlarge board up to 70% width; increase paddings and type sizes; use NavigationRail instead of bottom bar on wide screens.
- Safe areas: respect notches; ensure top controls are inside safe padding.

Performance requirements
- Target min 60 FPS; allow 120–144 FPS on supported devices.
- Budgets
  - Board draw: <= 0.8 ms/frame on mid-tier devices.
  - Animations: cap concurrent AnimationControllers; pool and reuse.
  - Custom effects: optional; prewarm Paint objects; fallback without complex effects.
- Images: pre-cache; use WebP where feasible; prefer vector for simple assets.
- Avoid expensive blurs on large areas; simulate glow via outer strokes + small blurred containers.
- Use RepaintBoundary and cached CustomPainter; avoid rebuilding overlays per frame.

Data models (mock)
- PlayerProfile { id, nickname, avatarUrlOrProvider, stats: { wins, losses, draws, streak }, gems, hints }
- StoreItem { id, category: [theme|board|symbol|gems], name, desc, priceGems?, priceReal?, premium: bool, locked: bool, previewAsset }
- GameConfig { mode: [local|cpu], firstMove: [X|O|random], difficulty?, boardSize: [3|4|5], winCondition: [3|4|5], players: [p1, p2] }
- Persist locally with JSON using shared_preferences for mock.

Store mock data (examples)
- Themes: [Default Light (selected, unlocked), Default Dark (unlocked), Neon Nights (locked, 300 gems), Retro Glow (locked, premium)]
- Board Designs: [Minimal Grid (default), Holo Lines (locked, 200 gems), Chalkboard (locked, 150 gems)]
- X/O Symbols: [Solid Sora (default), Outline Neon (locked, 120 gems), 3D Gel (premium)]
- Gems: [100, 500, 1200] (disabled purchase; show dialog "Coming soon")
- "Watch Ad" increases gems by +10 (mock).

Game rules and UX principles to follow
- Clear feedback: each action responds with motion, sound, and (if enabled) haptic.
- Low friction: defaults set for quick start (Random first move, 3x3, 3-in-a-row).
- Focus on effects and transitions: prioritize clean motion with color accent glows at key rewards (place mark, win).
- Consistency: reuse timing, curves, shadow styles, badge styles across app.
- Don't over-animate: keep most loops under 800 ms; let attention rest between rounds.

Implementation notes (Flutter specifics)
- Theme setup
  - Build ColorScheme.light/dark with tokens; extend with ThemeExtensions for game-specific colors and motion.
  - Use Material 3 components; turn on useMaterial3 = true.
- Routing
  - go_router with typed routes: /loading, /home, /setup, /game, /store, /profile, /settings
- Game integration
  - Use CustomPainter widget inside the Game screen with GestureDetector for input.
  - Use Stack with positioned overlays: Stack(children: [GameBoard(), ...overlays])
  - Keep board logic in dedicated classes; UI state in Riverpod; communicate via Streams or callbacks.
- Board sizing
  - Board fits min(width, height * 0.64) with paddings; maintain square grid.
  - Cell tap areas >= 48 px.
- Fonts
  - Bundle Sora, Inter, JetBrains Mono; set textTheme accordingly.

Copy-ready UI text
- Loading: "Loading…"
- Home hero: small "Welcome back!", big "Ready to play?"
- Cards: "Local Player", "Robot (Computer)"
- Setup: "First move", "Board size", "Win condition", "Difficulty"
- Buttons: "Start", "Play Again", "New Game", "Exit", "Continue", "Get hints"
- Popups: "You win!", "You lose", "It's a draw", "Quit current game?"

Quality checklist
- All text meets contrast thresholds.
- Tap targets ≥ 48 px.
- Animations respectful, stable frame pacing; no jank.
- Light and Dark themes fully themed (icons, toggles, chips, dialogs).
- Store locks everything except Default Theme; gems balance updates with mock actions.
- Haptics respect user settings toggle.
- Frame times logged in debug mode; animation counts capped.

Deliverables
- Flutter project scaffold with themes, routes, screens, and CustomPainter game board.
- Theme files with ColorScheme and ThemeExtensions.
- Mock data for profile/store.
- Placeholder assets for previews.
- README section listing where CustomPainter vs Flutter vs Material 3 are used, and FPS considerations.