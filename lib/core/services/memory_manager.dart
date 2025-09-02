import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Memory management service for monitoring and optimizing memory usage
class MemoryManager {
  static final MemoryManager _instance = MemoryManager._internal();
  factory MemoryManager() => _instance;
  MemoryManager._internal();

  final Map<String, int> _providerMemoryUsage = {};
  final Map<String, DateTime> _providerLastAccess = {};
  final Map<String, bool> _providerKeepAlive = {};
  Timer? _cleanupTimer;
  bool _isMonitoring = false;

  /// Start memory monitoring
  void startMonitoring() {
    if (_isMonitoring) return;

    _isMonitoring = true;
    _cleanupTimer = Timer.periodic(
      const Duration(minutes: 5), // Check every 5 minutes
      (_) => _performCleanup(),
    );

    if (kDebugMode) {
      developer.log('Memory monitoring started', name: 'MemoryManager');
    }
  }

  /// Stop memory monitoring
  void stopMonitoring() {
    _isMonitoring = false;
    _cleanupTimer?.cancel();
    _cleanupTimer = null;

    if (kDebugMode) {
      developer.log('Memory monitoring stopped', name: 'MemoryManager');
    }
  }

  /// Register a provider for memory tracking
  void registerProvider(String providerName, {bool keepAlive = false}) {
    _providerMemoryUsage[providerName] = 0;
    _providerLastAccess[providerName] = DateTime.now();
    _providerKeepAlive[providerName] = keepAlive;

    if (kDebugMode) {
      developer.log(
        'Registered provider: $providerName (keepAlive: $keepAlive)',
        name: 'MemoryManager',
      );
    }
  }

  /// Update provider access time
  void updateProviderAccess(String providerName) {
    _providerLastAccess[providerName] = DateTime.now();
  }

  /// Update provider memory usage
  void updateProviderMemoryUsage(String providerName, int bytes) {
    _providerMemoryUsage[providerName] = bytes;
  }

  /// Get memory usage statistics
  Map<String, dynamic> getMemoryStats() {
    final totalMemory = _providerMemoryUsage.values.fold<int>(
      0,
      (sum, usage) => sum + usage,
    );
    final providerCount = _providerMemoryUsage.length;
    final keepAliveCount = _providerKeepAlive.values
        .where((keep) => keep)
        .length;
    final autoDisposeCount = providerCount - keepAliveCount;

    return {
      'totalMemoryBytes': totalMemory,
      'totalMemoryMB': (totalMemory / (1024 * 1024)).toStringAsFixed(2),
      'providerCount': providerCount,
      'keepAliveCount': keepAliveCount,
      'autoDisposeCount': autoDisposeCount,
      'providers': _providerMemoryUsage.map(
        (name, usage) => MapEntry(name, {
          'memoryBytes': usage,
          'memoryMB': (usage / (1024 * 1024)).toStringAsFixed(2),
          'lastAccess': _providerLastAccess[name]?.toIso8601String(),
          'keepAlive': _providerKeepAlive[name] ?? false,
        }),
      ),
    };
  }

  /// Perform memory cleanup
  void _performCleanup() {
    final now = DateTime.now();
    final cutoffTime = now.subtract(
      const Duration(minutes: 10),
    ); // 10 minutes idle

    final providersToCleanup = <String>[];

    for (final entry in _providerLastAccess.entries) {
      final providerName = entry.key;
      final lastAccess = entry.value;
      final keepAlive = _providerKeepAlive[providerName] ?? false;

      // Only cleanup auto-dispose providers that haven't been accessed recently
      if (!keepAlive && lastAccess.isBefore(cutoffTime)) {
        providersToCleanup.add(providerName);
      }
    }

    if (providersToCleanup.isNotEmpty && kDebugMode) {
      developer.log(
        'Cleaning up ${providersToCleanup.length} idle providers: $providersToCleanup',
        name: 'MemoryManager',
      );
    }

    // Remove cleaned up providers from tracking
    for (final providerName in providersToCleanup) {
      _providerMemoryUsage.remove(providerName);
      _providerLastAccess.remove(providerName);
      _providerKeepAlive.remove(providerName);
    }
  }

  /// Force cleanup of all auto-dispose providers
  void forceCleanup() {
    final autoDisposeProviders = _providerKeepAlive.entries
        .where((entry) => !entry.value)
        .map((entry) => entry.key)
        .toList();

    for (final providerName in autoDisposeProviders) {
      _providerMemoryUsage.remove(providerName);
      _providerLastAccess.remove(providerName);
      _providerKeepAlive.remove(providerName);
    }

    if (kDebugMode) {
      developer.log(
        'Force cleaned up ${autoDisposeProviders.length} providers',
        name: 'MemoryManager',
      );
    }
  }

  /// Dispose the memory manager
  void dispose() {
    stopMonitoring();
    _providerMemoryUsage.clear();
    _providerLastAccess.clear();
    _providerKeepAlive.clear();
  }
}

/// ✅ OPTIMIZED: Memory manager provider with keepAlive for persistent memory management
final memoryManagerProvider = Provider<MemoryManager>((ref) {
  ref.keepAlive(); // Keep alive since memory manager should persist
  final manager = MemoryManager();

  // Start monitoring when provider is created
  manager.startMonitoring();

  // Stop monitoring when provider is disposed
  ref.onDispose(() {
    manager.dispose();
  });

  return manager;
});

/// ✅ OPTIMIZED: Memory statistics provider with keepAlive for persistent monitoring
final memoryStatsProvider = StreamProvider<Map<String, dynamic>>((ref) {
  ref.keepAlive(); // Keep alive since memory stats should persist
  final manager = ref.watch(memoryManagerProvider);
  final controller = StreamController<Map<String, dynamic>>();

  // Emit stats every 30 seconds
  Timer.periodic(const Duration(seconds: 30), (_) {
    if (!controller.isClosed) {
      controller.add(manager.getMemoryStats());
    }
  });

  // Initial stats
  controller.add(manager.getMemoryStats());

  ref.onDispose(() {
    controller.close();
  });

  return controller.stream;
});

/// Extension for easy memory tracking
extension MemoryTracking on Ref {
  /// Track provider memory usage
  void trackMemory(String providerName, {bool keepAlive = false}) {
    final manager = read(memoryManagerProvider);
    manager.registerProvider(providerName, keepAlive: keepAlive);
  }

  /// Update provider access
  void updateAccess(String providerName) {
    final manager = read(memoryManagerProvider);
    manager.updateProviderAccess(providerName);
  }
}
