lib/features/game/presentation/widgets/
├── game_interface/           # Main game UI components
│   ├── game_header.dart      # Player info, scores, VS indicator
│   ├── game_status.dart      # Turn indicator, game state
│   └── game_controls.dart    # Hint, new game, settings buttons
├── game_board/               # Board-related components
│   ├── game_board.dart       # Main board widget
│   ├── board_cell.dart       # Individual cell widget
│   └── board_grid.dart       # Grid layout wrapper
├── visual_effects/           # Painters and animations
│   ├── painters/
│   │   ├── board_painter.dart
│   │   ├── cell_painter.dart
│   │   ├── mark_painter.dart
│   │   └── winning_line_painter.dart
│   └── effects/
│       ├── hint_effect.dart
│       ├── victory_effect.dart
│       └── ambient_effect.dart
└── overlays/                 # Modal overlays
    ├── game_result_overlay.dart
    ├── game_settings_overlay.dart
    └── exit_confirmation_overlay.dart