# Audio Files for Tic Tac Toe XO Royale

This directory contains the audio files for the game. The placeholder files have been created with specifications for each sound effect and music track.

## Sound Effects (SFX)

### Required Files
- `move.mp3` - Sound when a player makes a move
- `win.mp3` - Victory celebration sound
- `lose.mp3` - Defeat sound (gentle and encouraging)
- `draw.mp3` - Draw game sound
- `button_tap.mp3` - Button interaction sound
- `hint.mp3` - Hint system sound

### Specifications
- **Format**: MP3
- **Sample Rate**: 44.1kHz
- **Bitrate**: 128kbps
- **Duration**: 50ms - 1200ms (see individual files for specific durations)

## Background Music

### Required Files
- `main_menu.mp3` - Main menu ambient music
- `game_play.mp3` - Gameplay background music
- `victory.mp3` - Victory celebration music

### Specifications
- **Format**: MP3
- **Sample Rate**: 44.1kHz
- **Bitrate**: 128kbps
- **Duration**: 60-180 seconds (loopable)

## Implementation Notes

1. **Replace Placeholders**: Replace all placeholder files with actual audio files
2. **Quality**: Ensure audio quality is consistent across all files
3. **Volume**: Normalize audio levels for consistent playback
4. **Looping**: Music files should loop seamlessly
5. **Performance**: Keep file sizes reasonable for mobile devices

## Audio Service Integration

The game automatically:
- Starts gameplay music when a game begins
- Plays victory music on wins
- Resumes gameplay music after defeats
- Stops music when appropriate
- Integrates with user settings for sound/music preferences

## Haptic Feedback

Haptic feedback is already implemented and includes:
- Platform-specific optimizations for iOS and Android
- Game-specific patterns (move, win, lose, draw, hint)
- Integration with user settings
- Performance optimizations
