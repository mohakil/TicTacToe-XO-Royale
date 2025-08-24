import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';

/// Audio service for managing game sounds and music
class AudioService {
  AudioService._();

  static final AudioService _instance = AudioService._();
  static AudioService get instance => _instance;

  // Audio players
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _musicPlayer = AudioPlayer();

  // Audio cache
  final Map<String, AudioSource> _audioCache = {};
  final Map<String, DateTime> _audioCacheTimestamps = {};

  // Current music tracking
  String? _currentMusicId;

  // Cache settings
  static const Duration _cacheExpiry = Duration(hours: 24);
  static const int _maxCacheSize = 50; // Maximum number of cached audio files

  // Volume levels
  static const double _sfxVolume = 0.8;
  static const double _musicVolume = 0.6;

  // Audio file paths
  static const Map<String, String> _sfxPaths = {
    'move': 'assets/audio/sfx/move.mp3',
    'win': 'assets/audio/sfx/win.mp3',
    'lose': 'assets/audio/sfx/lose.mp3',
    'draw': 'assets/audio/sfx/draw.mp3',
    'button_tap': 'assets/audio/sfx/button_tap.mp3',
    'card_flip': 'assets/audio/sfx/card_flip.mp3',
    'gem_collect': 'assets/audio/sfx/gem_collect.mp3',
    'purchase': 'assets/audio/sfx/purchase.mp3',
    'hint': 'assets/audio/sfx/hint.mp3',
    'error': 'assets/audio/sfx/error.mp3',
  };

  static const Map<String, String> _musicPaths = {
    'main_menu': 'assets/audio/music/main_menu.mp3',
    'game_play': 'assets/audio/music/game_play.mp3',
    'victory': 'assets/audio/music/victory.mp3',
    'defeat': 'assets/audio/music/defeat.mp3',
    'store': 'assets/audio/music/store.mp3',
  };

  /// Initialize the audio service
  Future<void> initialize() async {
    try {
      // Set up audio session for better control
      await _sfxPlayer.setAudioSource(
        AudioSource.uri(Uri.parse('asset:///assets/audio/sfx/move.mp3')),
        preload: false,
      );

      await _musicPlayer.setAudioSource(
        AudioSource.uri(Uri.parse('asset:///assets/audio/music/main_menu.mp3')),
        preload: false,
      );

      // Set initial volumes
      await _sfxPlayer.setVolume(_sfxVolume);
      await _musicPlayer.setVolume(_musicVolume);

      // Preload essential audio files
      await _preloadEssentialAudio();

      if (kDebugMode) {
        print('AudioService: Initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('AudioService: Failed to initialize: $e');
      }
    }
  }

  /// Preload essential audio files for better performance
  Future<void> _preloadEssentialAudio() async {
    try {
      // Preload common SFX
      final essentialSfx = ['move', 'button_tap', 'win', 'lose'];
      for (final sfx in essentialSfx) {
        await _preloadAudio(sfx, isMusic: false);
      }

      // Preload main menu music
      await _preloadAudio('main_menu', isMusic: true);

      if (kDebugMode) {
        print('AudioService: Essential audio preloaded');
      }
    } catch (e) {
      if (kDebugMode) {
        print('AudioService: Failed to preload essential audio: $e');
      }
    }
  }

  /// Preload an audio file and cache it
  Future<void> _preloadAudio(String audioId, {required bool isMusic}) async {
    try {
      final paths = isMusic ? _musicPaths : _sfxPaths;
      final path = paths[audioId];

      if (path == null) {
        if (kDebugMode) {
          print('AudioService: Audio path not found for $audioId');
        }
        return;
      }

      // Check if already cached and not expired
      if (_audioCache.containsKey(audioId)) {
        final timestamp = _audioCacheTimestamps[audioId];
        if (timestamp != null &&
            DateTime.now().difference(timestamp) < _cacheExpiry) {
          return; // Already cached and fresh
        }
      }

      // Create audio source
      final audioSource = AudioSource.uri(Uri.parse('asset:///$path'));

      // Cache the audio source
      _audioCache[audioId] = audioSource;
      _audioCacheTimestamps[audioId] = DateTime.now();

      // Manage cache size
      _manageCacheSize();

      if (kDebugMode) {
        print('AudioService: Preloaded $audioId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('AudioService: Failed to preload $audioId: $e');
      }
    }
  }

  /// Manage cache size by removing oldest entries
  void _manageCacheSize() {
    if (_audioCache.length <= _maxCacheSize) return;

    // Sort by timestamp and remove oldest
    final sortedEntries = _audioCacheTimestamps.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    final toRemove = sortedEntries.take(_audioCache.length - _maxCacheSize);

    for (final entry in toRemove) {
      _audioCache.remove(entry.key);
      _audioCacheTimestamps.remove(entry.key);
    }

    if (kDebugMode) {
      print('AudioService: Cache cleaned, removed ${toRemove.length} entries');
    }
  }

  /// Play a sound effect
  Future<void> playSfx(String sfxId, {WidgetRef? ref}) async {
    try {
      // Check if sound is enabled
      if (ref != null) {
        final settings = ref.read(settingsProvider);
        if (!settings.soundEnabled) return;
      }

      // Ensure audio is preloaded
      await _preloadAudio(sfxId, isMusic: false);

      // Get cached audio source or create new one
      AudioSource audioSource;
      if (_audioCache.containsKey(sfxId)) {
        audioSource = _audioCache[sfxId]!;
      } else {
        final path = _sfxPaths[sfxId];
        if (path == null) return;
        audioSource = AudioSource.uri(Uri.parse('asset:///$path'));
      }

      // Play the sound effect
      await _sfxPlayer.setAudioSource(audioSource);
      await _sfxPlayer.play();

      if (kDebugMode) {
        print('AudioService: Playing SFX $sfxId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('AudioService: Failed to play SFX $sfxId: $e');
      }
    }
  }

  /// Play background music
  Future<void> playMusic(
    String musicId, {
    WidgetRef? ref,
    bool loop = true,
  }) async {
    try {
      // Check if music is enabled
      if (ref != null) {
        final settings = ref.read(settingsProvider);
        if (!settings.musicEnabled) return;
      }

      // Stop current music if different
      if (_currentMusicId == musicId) return; // Already playing this music

      // Ensure audio is preloaded
      await _preloadAudio(musicId, isMusic: true);

      // Get cached audio source or create new one
      AudioSource audioSource;
      if (_audioCache.containsKey(musicId)) {
        audioSource = _audioCache[musicId]!;
      } else {
        final path = _musicPaths[musicId];
        if (path == null) return;
        audioSource = AudioSource.uri(Uri.parse('asset:///$path'));
      }

      // Play the music
      await _musicPlayer.setAudioSource(audioSource);
      await _musicPlayer.setLoopMode(loop ? LoopMode.one : LoopMode.off);
      await _musicPlayer.play();

      // Track current music
      _currentMusicId = musicId;

      if (kDebugMode) {
        print('AudioService: Playing music $musicId (loop: $loop)');
      }
    } catch (e) {
      if (kDebugMode) {
        print('AudioService: Failed to play music $musicId: $e');
      }
    }
  }

  /// Stop background music
  Future<void> stopMusic() async {
    try {
      await _musicPlayer.stop();
      _currentMusicId = null;
      if (kDebugMode) {
        print('AudioService: Music stopped');
      }
    } catch (e) {
      if (kDebugMode) {
        print('AudioService: Failed to stop music: $e');
      }
    }
  }

  /// Pause background music
  Future<void> pauseMusic() async {
    try {
      await _musicPlayer.pause();
      if (kDebugMode) {
        print('AudioService: Music paused');
      }
    } catch (e) {
      if (kDebugMode) {
        print('AudioService: Failed to pause music: $e');
      }
    }
  }

  /// Resume background music
  Future<void> resumeMusic() async {
    try {
      await _musicPlayer.play();
      if (kDebugMode) {
        print('AudioService: Music resumed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('AudioService: Failed to resume music: $e');
      }
    }
  }

  /// Set music volume
  Future<void> setMusicVolume(double volume) async {
    try {
      final clampedVolume = volume.clamp(0.0, 1.0);
      await _musicPlayer.setVolume(clampedVolume);
      if (kDebugMode) {
        print('AudioService: Music volume set to $clampedVolume');
      }
    } catch (e) {
      if (kDebugMode) {
        print('AudioService: Failed to set music volume: $e');
      }
    }
  }

  /// Set SFX volume
  Future<void> setSfxVolume(double volume) async {
    try {
      final clampedVolume = volume.clamp(0.0, 1.0);
      await _sfxPlayer.setVolume(clampedVolume);
      if (kDebugMode) {
        print('AudioService: SFX volume set to $clampedVolume');
      }
    } catch (e) {
      if (kDebugMode) {
        print('AudioService: Failed to set SFX volume: $e');
      }
    }
  }

  /// Clear audio cache
  void clearCache() {
    _audioCache.clear();
    _audioCacheTimestamps.clear();
    if (kDebugMode) {
      print('AudioService: Cache cleared');
    }
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    return {
      'cachedFiles': _audioCache.length,
      'maxCacheSize': _maxCacheSize,
      'cacheExpiry': _cacheExpiry.inHours,
    };
  }

  /// Dispose resources
  Future<void> dispose() async {
    try {
      await _sfxPlayer.dispose();
      await _musicPlayer.dispose();
      clearCache();
      if (kDebugMode) {
        print('AudioService: Disposed successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('AudioService: Failed to dispose: $e');
      }
    }
  }
}

/// Provider for AudioService
final audioServiceProvider = Provider<AudioService>((ref) {
  return AudioService.instance;
});

/// Provider for audio settings
final audioSettingsProvider =
    Provider<({bool soundEnabled, bool musicEnabled})>((ref) {
      final settings = ref.watch(settingsProvider);
      return (
        soundEnabled: settings.soundEnabled,
        musicEnabled: settings.musicEnabled,
      );
    });
