import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Performance monitoring service that tracks frame rates, memory usage,
/// and provides optimization recommendations for maintaining 60-144 FPS
class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  // Performance metrics
  final List<double> _frameTimes = [];
  final List<int> _memoryUsage = [];
  final List<double> _cpuUsage = [];

  // Monitoring state
  bool _isMonitoring = false;
  Timer? _monitoringTimer;
  DateTime? _lastFrameTime;

  // Performance thresholds
  static const int _maxFrameTimeMs = 16; // 60 FPS threshold
  static const int _maxMemoryMB = 200;
  static const int _maxCpuPercent = 80;

  // Callbacks for performance events
  final List<Function(PerformanceMetrics)> _performanceCallbacks = [];

  /// Start performance monitoring
  void startMonitoring() {
    if (_isMonitoring) {
      return;
    }

    _isMonitoring = true;
    _lastFrameTime = DateTime.now();

    // Monitor frame times using WidgetsBinding
    WidgetsBinding.instance.addPersistentFrameCallback(_onFrameCallback);

    // Periodic monitoring for memory and CPU
    _monitoringTimer = Timer.periodic(
      const Duration(seconds: 1),
      _onPeriodicCheck,
    );

    developer.log('Performance monitoring started', name: 'PerformanceService');
  }

  /// Stop performance monitoring
  void stopMonitoring() {
    if (!_isMonitoring) {
      return;
    }

    _isMonitoring = false;
    // Note: Flutter doesn't provide removePersistentFrameCallback,
    // but we can stop monitoring by setting the flag
    _monitoringTimer?.cancel();
    _monitoringTimer = null;

    developer.log('Performance monitoring stopped', name: 'PerformanceService');
  }

  /// Frame callback for monitoring frame times
  void _onFrameCallback(Duration timeStamp) {
    if (!_isMonitoring) {
      return;
    }

    final now = DateTime.now();
    if (_lastFrameTime != null) {
      final frameTime =
          now.difference(_lastFrameTime!).inMicroseconds /
          1000.0; // Convert to ms
      _frameTimes.add(frameTime);

      // Keep only last 100 frame times for rolling average
      if (_frameTimes.length > 100) {
        _frameTimes.removeAt(0);
      }

      // Check for performance issues
      if (frameTime > _maxFrameTimeMs) {
        _reportPerformanceIssue(PerformanceIssueType.frameTime, frameTime);
      }
    }

    _lastFrameTime = now;
  }

  /// Periodic check for memory and CPU usage
  void _onPeriodicCheck(Timer timer) {
    if (!_isMonitoring) {
      return;
    }

    // Get memory usage
    final memoryInfo = _getMemoryInfo();
    _memoryUsage.add(memoryInfo);

    if (_memoryUsage.length > 60) {
      // Keep last minute
      _memoryUsage.removeAt(0);
    }

    // Check memory threshold
    if (memoryInfo > _maxMemoryMB) {
      _reportPerformanceIssue(
        PerformanceIssueType.memoryUsage,
        memoryInfo.toDouble(),
      );
    }

    // Get CPU usage (simplified - in real app you'd use platform channels)
    final cpuUsage = _getCpuUsage();
    _cpuUsage.add(cpuUsage);

    if (_cpuUsage.length > 60) {
      _cpuUsage.removeAt(0);
    }

    if (cpuUsage > _maxCpuPercent) {
      _reportPerformanceIssue(PerformanceIssueType.cpuUsage, cpuUsage);
    }
  }

  /// Get current memory usage in MB
  int _getMemoryInfo() {
    try {
      // This is a simplified approach - in production you'd use platform channels
      // to get actual memory usage from the OS
      return 50; // Placeholder value
    } on Exception catch (e) {
      if (kDebugMode) {
        developer.log(
          'Failed to get memory info: $e',
          name: 'PerformanceService',
        );
      }
      return 0;
    }
  }

  /// Get current CPU usage percentage
  double _getCpuUsage() {
    try {
      // This is a simplified approach - in production you'd use platform channels
      // to get actual CPU usage from the OS
      return 30; // Placeholder value
    } on Exception catch (e) {
      if (kDebugMode) {
        developer.log('Failed to get CPU info: $e', name: 'PerformanceService');
      }
      return 0;
    }
  }

  /// Report performance issues
  void _reportPerformanceIssue(PerformanceIssueType type, double value) {
    final issue = PerformanceIssue(
      type: type,
      value: value,
      timestamp: DateTime.now(),
      severity: _getIssueSeverity(type, value),
    );

    developer.log(
      'Performance issue detected: $issue',
      name: 'PerformanceService',
    );

    // Notify listeners
    for (final callback in _performanceCallbacks) {
      try {
        callback(
          PerformanceMetrics(
            frameRate: getCurrentFrameRate(),
            averageFrameTime: getAverageFrameTime(),
            memoryUsage: getCurrentMemoryUsage(),
            cpuUsage: getCurrentCpuUsage(),
            issues: [issue],
          ),
        );
      } on Exception catch (e) {
        if (kDebugMode) {
          developer.log(
            'Error in performance callback: $e',
            name: 'PerformanceService',
          );
        }
      }
    }
  }

  /// Get issue severity based on type and value
  PerformanceIssueSeverity _getIssueSeverity(
    PerformanceIssueType type,
    double value,
  ) {
    switch (type) {
      case PerformanceIssueType.frameTime:
        if (value > 33) {
          return PerformanceIssueSeverity.critical; // < 30 FPS
        }
        if (value > 20) {
          return PerformanceIssueSeverity.high; // < 50 FPS
        }
        if (value > 16) {
          return PerformanceIssueSeverity.medium; // < 60 FPS
        }
        return PerformanceIssueSeverity.low;

      case PerformanceIssueType.memoryUsage:
        if (value > 300) {
          return PerformanceIssueSeverity.critical;
        }
        if (value > 250) {
          return PerformanceIssueSeverity.high;
        }
        if (value > 200) {
          return PerformanceIssueSeverity.medium;
        }
        return PerformanceIssueSeverity.low;

      case PerformanceIssueType.cpuUsage:
        if (value > 95) {
          return PerformanceIssueSeverity.critical;
        }
        if (value > 85) {
          return PerformanceIssueSeverity.high;
        }
        if (value > 80) {
          return PerformanceIssueSeverity.medium;
        }
        return PerformanceIssueSeverity.low;
    }
  }

  /// Get current frame rate
  double getCurrentFrameRate() {
    if (_frameTimes.isEmpty) {
      return 0;
    }

    final avgFrameTime = getAverageFrameTime();
    return avgFrameTime > 0 ? 1000.0 / avgFrameTime : 0.0;
  }

  /// Get average frame time
  double getAverageFrameTime() {
    if (_frameTimes.isEmpty) {
      return 0;
    }

    final sum = _frameTimes.reduce((a, b) => a + b);
    return sum / _frameTimes.length;
  }

  /// Get current memory usage
  int getCurrentMemoryUsage() {
    if (_memoryUsage.isEmpty) {
      return 0;
    }
    return _memoryUsage.last;
  }

  /// Get current CPU usage
  double getCurrentCpuUsage() {
    if (_cpuUsage.isEmpty) {
      return 0;
    }
    return _cpuUsage.last;
  }

  /// Add performance callback
  void addPerformanceCallback(Function(PerformanceMetrics) callback) {
    _performanceCallbacks.add(callback);
  }

  /// Remove performance callback
  void removePerformanceCallback(Function(PerformanceMetrics) callback) {
    _performanceCallbacks.remove(callback);
  }

  /// Get current performance metrics
  PerformanceMetrics getCurrentMetrics() => PerformanceMetrics(
    frameRate: getCurrentFrameRate(),
    averageFrameTime: getAverageFrameTime(),
    memoryUsage: getCurrentMemoryUsage(),
    cpuUsage: getCurrentCpuUsage(),
    issues: [], // No current issues
  );

  /// Get performance recommendations based on current metrics
  List<PerformanceRecommendation> getRecommendations() {
    final recommendations = <PerformanceRecommendation>[];
    final metrics = getCurrentMetrics();

    // Frame rate recommendations
    if (metrics.frameRate < 60) {
      if (metrics.frameRate < 30) {
        recommendations.add(
          const PerformanceRecommendation(
            type: RecommendationType.critical,
            title: 'Critical Frame Rate Issue',
            description:
                'Frame rate is below 30 FPS. This will severely impact user experience.',
            action:
                'Reduce animation complexity, optimize CustomPainter, add RepaintBoundary',
          ),
        );
      } else {
        recommendations.add(
          const PerformanceRecommendation(
            type: RecommendationType.high,
            title: 'Frame Rate Below Target',
            description:
                'Frame rate is below 60 FPS target. Consider optimization.',
            action: 'Review animation controllers, optimize widget rebuilds',
          ),
        );
      }
    }

    // Memory recommendations
    if (metrics.memoryUsage > 150) {
      recommendations.add(
        const PerformanceRecommendation(
          type: RecommendationType.medium,
          title: 'High Memory Usage',
          description: 'Memory usage is elevated. Monitor for memory leaks.',
          action: 'Check for disposed resources, optimize image caching',
        ),
      );
    }

    // CPU recommendations
    if (metrics.cpuUsage > 70) {
      recommendations.add(
        const PerformanceRecommendation(
          type: RecommendationType.medium,
          title: 'High CPU Usage',
          description:
              'CPU usage is elevated. Consider reducing computational load.',
          action: 'Optimize calculations, reduce animation complexity',
        ),
      );
    }

    return recommendations;
  }

  /// Dispose resources
  void dispose() {
    stopMonitoring();
    _performanceCallbacks.clear();
    _frameTimes.clear();
    _memoryUsage.clear();
    _cpuUsage.clear();
  }
}

/// Performance metrics data class
class PerformanceMetrics {
  final double frameRate;
  final double averageFrameTime;
  final int memoryUsage;
  final double cpuUsage;
  final List<PerformanceIssue> issues;

  const PerformanceMetrics({
    required this.frameRate,
    required this.averageFrameTime,
    required this.memoryUsage,
    required this.cpuUsage,
    required this.issues,
  });

  @override
  String toString() =>
      'PerformanceMetrics(frameRate: ${frameRate.toStringAsFixed(1)} FPS, '
      'avgFrameTime: ${averageFrameTime.toStringAsFixed(2)}ms, '
      'memory: ${memoryUsage}MB, cpu: ${cpuUsage.toStringAsFixed(1)}%, '
      'issues: ${issues.length})';
}

/// Performance issue data class
class PerformanceIssue {
  final PerformanceIssueType type;
  final double value;
  final DateTime timestamp;
  final PerformanceIssueSeverity severity;

  const PerformanceIssue({
    required this.type,
    required this.value,
    required this.timestamp,
    required this.severity,
  });

  @override
  String toString() =>
      'PerformanceIssue(${type.name}: ${value.toStringAsFixed(2)}, '
      'severity: ${severity.name}, time: $timestamp)';
}

/// Performance issue types
enum PerformanceIssueType { frameTime, memoryUsage, cpuUsage }

/// Performance issue severity levels
enum PerformanceIssueSeverity { low, medium, high, critical }

/// Performance recommendation data class
class PerformanceRecommendation {
  final RecommendationType type;
  final String title;
  final String description;
  final String action;

  const PerformanceRecommendation({
    required this.type,
    required this.title,
    required this.description,
    required this.action,
  });
}

/// Recommendation types
enum RecommendationType { info, low, medium, high, critical }

/// Performance service provider
final performanceServiceProvider = Provider<PerformanceService>((ref) {
  final service = PerformanceService();

  // Auto-start monitoring when the service is first accessed
  WidgetsBinding.instance.addPostFrameCallback((_) {
    service.startMonitoring();
  });

  ref.onDispose(service.dispose);

  return service;
});

/// Performance metrics provider
final performanceMetricsProvider = StreamProvider<PerformanceMetrics>((ref) {
  final service = ref.watch(performanceServiceProvider);
  final controller = StreamController<PerformanceMetrics>();

  service.addPerformanceCallback(controller.add);

  ref.onDispose(() {
    service.removePerformanceCallback(controller.add);
    controller.close();
  });

  return controller.stream;
});

/// Performance recommendations provider
final performanceRecommendationsProvider =
    Provider<List<PerformanceRecommendation>>((ref) {
      final service = ref.watch(performanceServiceProvider);
      return service.getRecommendations();
    });
