import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tictactoe_xo_royale/core/providers/services_provider.dart';

/// Audio service for managing game sounds and music
class AudioService {
  late final AudioPlayer _sfxPlayer;
  late final AudioPlayer _musicPlayer;

  AudioService({
    required this.ref,
    AudioPlayer? sfxPlayer,
    AudioPlayer? musicPlayer,
  }) {
    _sfxPlayer = sfxPlayer ?? AudioPlayer();
    _musicPlayer = musicPlayer ?? AudioPlayer();
  }

  final Ref ref;

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

  /// Initialize the audio service with platform-specific optimizations
  Future<void> initialize() async {
    try {
      // Platform-specific audio session setup (using defaults)
      await _configurePlatformAudioSession();

      // Set up audio players with platform-specific optimizations
      await _initializeAudioPlayers();

      // Set initial volumes with platform-specific considerations
      await _setPlatformVolumes();

      // Preload essential audio files
      await _preloadEssentialAudio();
    } catch (e) {
      // Audio service initialization failed silently
    }
  }

  /// Configure platform-specific audio session
  Future<void> _configurePlatformAudioSession() async {
    // Platform-specific configuration skipped; using just_audio defaults
  }

  /// Initialize audio players with platform-specific settings
  Future<void> _initializeAudioPlayers() async {
    try {
      // Configure SFX player for low latency
      await _sfxPlayer.setAudioSource(
        AudioSource.uri(Uri.parse('asset:///assets/audio/sfx/move.mp3')),
        preload: false,
      );

      // Configure music player for streaming
      await _musicPlayer.setAudioSource(
        AudioSource.uri(Uri.parse('asset:///assets/audio/music/main_menu.mp3')),
        preload: false,
      );

      // Platform-specific player optimizations
      if (Platform.isAndroid) {
        // Android-specific optimizations - PlayerMode is not available in current just_audio version
        // These will use default modes optimized for each platform
      } else if (Platform.isIOS) {
        // iOS-specific optimizations
      }
    } catch (e) {
      // Audio players initialization failed silently
    }
  }

  /// Set platform-specific volumes
  Future<void> _setPlatformVolumes() async {
    try {
      var sfxVol = _sfxVolume;
      var musicVol = _musicVolume;

      // Adjust volumes based on platform
      if (Platform.isAndroid) {
        // Android typically needs slightly lower volumes
        sfxVol *= 0.9;
        musicVol *= 0.85;
      } else if (Platform.isIOS) {
        // iOS can handle higher volumes
        sfxVol *= 1.0;
        musicVol *= 0.9;
      }

      await _sfxPlayer.setVolume(sfxVol);
      await _musicPlayer.setVolume(musicVol);
    } catch (e) {
      // Volume setting failed silently
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
    } on Exception catch (e) {
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
    } catch (e) {
      // Audio preload failed silently
    }
  }

  /// Manage cache size by removing oldest entries
  void _manageCacheSize() {
    if (_audioCache.length <= _maxCacheSize) {
      return;
    }

    // Sort by timestamp and remove oldest
    final sortedEntries = _audioCacheTimestamps.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    final toRemove = sortedEntries.take(_audioCache.length - _maxCacheSize);

    for (final entry in toRemove) {
      _audioCache.remove(entry.key);
      _audioCacheTimestamps.remove(entry.key);
    }
  }

  /// Play a sound effect
  Future<void> playSfx(String sfxId) async {
    try {
      // Check if sound is enabled
      final audioSettings = ref.read(audioSettingsProvider);
      if (!audioSettings.soundEnabled) {
        return;
      }

      // Ensure audio is preloaded
      await _preloadAudio(sfxId, isMusic: false);

      // Get cached audio source or create new one
      AudioSource audioSource;
      if (_audioCache.containsKey(sfxId)) {
        audioSource = _audioCache[sfxId]!;
      } else {
        final path = _sfxPaths[sfxId];
        if (path == null) {
          return;
        }
        audioSource = AudioSource.uri(Uri.parse('asset:///$path'));
      }

      // Play the sound effect
      await _sfxPlayer.setAudioSource(audioSource);
      await _sfxPlayer.play();
    } catch (e) {
      // SFX playback failed silently
    }
  }

  /// Play background music
  Future<void> playMusic(String musicId, {bool loop = true}) async {
    try {
      // Check if music is enabled
      final audioSettings = ref.read(audioSettingsProvider);
      if (!audioSettings.musicEnabled) {
        return;
      }

      // Stop current music if different
      if (_currentMusicId == musicId) {
        return; // Already playing this music
      }

      // Ensure audio is preloaded
      await _preloadAudio(musicId, isMusic: true);

      // Get cached audio source or create new one
      AudioSource audioSource;
      if (_audioCache.containsKey(musicId)) {
        audioSource = _audioCache[musicId]!;
      } else {
        final path = _musicPaths[musicId];
        if (path == null) {
          return;
        }
        audioSource = AudioSource.uri(Uri.parse('asset:///$path'));
      }

      // Play the music
      await _musicPlayer.setAudioSource(audioSource);
      await _musicPlayer.setLoopMode(loop ? LoopMode.one : LoopMode.off);
      await _musicPlayer.play();

      // Track current music
      _currentMusicId = musicId;
    } catch (e) {
      // Music playback failed silently
    }
  }

  /// Stop background music
  Future<void> stopMusic() async {
    try {
      await _musicPlayer.stop();
      _currentMusicId = null;
    } catch (e) {
      // Music stop failed silently
    }
  }

  /// Pause background music
  Future<void> pauseMusic() async {
    try {
      await _musicPlayer.pause();
    } catch (e) {
      // Music pause failed silently
    }
  }

  /// Resume background music
  Future<void> resumeMusic() async {
    try {
      await _musicPlayer.play();
    } catch (e) {
      // Music resume failed silently
    }
  }

  /// Set music volume
  Future<void> setMusicVolume(double volume) async {
    try {
      final clampedVolume = volume.clamp(0.0, 1.0);
      await _musicPlayer.setVolume(clampedVolume);
    } catch (e) {
      // Music volume setting failed silently
    }
  }

  /// Set SFX volume
  Future<void> setSfxVolume(double volume) async {
    try {
      final clampedVolume = volume.clamp(0.0, 1.0);
      await _sfxPlayer.setVolume(clampedVolume);
    } catch (e) {
      // SFX volume setting failed silently
    }
  }

  /// Clear audio cache
  void clearCache() {
    _audioCache.clear();
    _audioCacheTimestamps.clear();
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() => {
    'cachedFiles': _audioCache.length,
    'maxCacheSize': _maxCacheSize,
    'cacheExpiry': _cacheExpiry.inHours,
  };

  /// Dispose resources
  Future<void> dispose() async {
    try {
      await _sfxPlayer.dispose();
      await _musicPlayer.dispose();
      clearCache();
    } catch (e) {
      // Audio service disposal failed silently
    }
  }
}
