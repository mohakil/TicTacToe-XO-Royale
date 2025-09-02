import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Performance monitoring service for tracking frame rates and rendering performance
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  // Frame rate tracking
  final List<double> _frameTimes = [];
  final List<DateTime> _frameTimestamps = [];
  static const int _maxFrameHistory = 60; // Keep last 60 frames

  // Performance metrics
  double _averageFrameTime = 0.0;
  double _averageFPS = 0.0;
  double _minFPS = double.infinity;
  double _maxFPS = 0.0;

  // Monitoring state
  bool _isMonitoring = false;
  Timer? _monitoringTimer;

  // Performance thresholds
  static const double _acceptableFrameTime = 20.0; // ms

  /// Start monitoring performance
  void startMonitoring() {
    if (_isMonitoring) return;

    _isMonitoring = true;
    _frameTimes.clear();
    _frameTimestamps.clear();

    // Monitor frame timing
    SchedulerBinding.instance.addPersistentFrameCallback(_onFrame);

    // Periodic performance reporting
    _monitoringTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _reportPerformance(),
    );

    if (kDebugMode) {
      debugPrint('PerformanceMonitor: Started monitoring');
    }
  }

  /// Stop monitoring performance
  void stopMonitoring() {
    if (!_isMonitoring) return;

    _isMonitoring = false;
    // Note: removePersistentFrameCallback is not available in current Flutter version
    // The callback will be ignored when _isMonitoring is false
    _monitoringTimer?.cancel();
    _monitoringTimer = null;

    if (kDebugMode) {
      debugPrint('PerformanceMonitor: Stopped monitoring');
    }
  }

  /// Frame callback for measuring frame times
  void _onFrame(Duration timeStamp) {
    if (!_isMonitoring) return;

    final now = DateTime.now();
    final frameTime =
        timeStamp.inMicroseconds / 1000.0; // Convert to milliseconds

    _frameTimes.add(frameTime);
    _frameTimestamps.add(now);

    // Keep only recent frames
    if (_frameTimes.length > _maxFrameHistory) {
      _frameTimes.removeAt(0);
      _frameTimestamps.removeAt(0);
    }

    _updateMetrics();
  }

  /// Update performance metrics
  void _updateMetrics() {
    if (_frameTimes.isEmpty) return;

    // Calculate average frame time
    _averageFrameTime =
        _frameTimes.reduce((a, b) => a + b) / _frameTimes.length;

    // Calculate FPS metrics
    _averageFPS = 1000.0 / _averageFrameTime;
    _minFPS = min(_minFPS, _averageFPS);
    _maxFPS = max(_maxFPS, _averageFPS);
  }

  /// Report current performance metrics
  void _reportPerformance() {
    if (!kDebugMode || _frameTimes.isEmpty) return;

    final performance = getPerformanceReport();
    debugPrint('''
PerformanceMonitor Report:
  Average FPS: ${performance.averageFPS.toStringAsFixed(1)}
  Min FPS: ${performance.minFPS.toStringAsFixed(1)}
  Max FPS: ${performance.maxFPS.toStringAsFixed(1)}
  Average Frame Time: ${performance.averageFrameTime.toStringAsFixed(2)}ms
  Performance Grade: ${performance.grade}
  Frame Drops: ${performance.frameDrops}
''');
  }

  /// Get current performance report
  PerformanceReport getPerformanceReport() {
    final frameDrops = _frameTimes
        .where((time) => time > _acceptableFrameTime)
        .length;

    String grade;
    if (_averageFPS >= 55) {
      grade = 'Excellent';
    } else if (_averageFPS >= 45) {
      grade = 'Good';
    } else if (_averageFPS >= 30) {
      grade = 'Fair';
    } else {
      grade = 'Poor';
    }

    return PerformanceReport(
      averageFPS: _averageFPS,
      minFPS: _minFPS,
      maxFPS: _maxFPS,
      averageFrameTime: _averageFrameTime,
      frameDrops: frameDrops,
      grade: grade,
      isMonitoring: _isMonitoring,
    );
  }

  /// Check if current performance meets target
  bool meetsTargetFPS(int targetFPS) {
    final targetFrameTime = 1000.0 / targetFPS;
    return _averageFrameTime <= targetFrameTime;
  }

  /// Get performance recommendations
  List<String> getRecommendations() {
    final recommendations = <String>[];

    if (_averageFPS < 30) {
      recommendations.add('Consider reducing visual effects');
      recommendations.add('Optimize CustomPainter operations');
      recommendations.add('Check for memory leaks');
    } else if (_averageFPS < 45) {
      recommendations.add('Consider caching Paint objects');
      recommendations.add('Optimize widget rebuilds');
    } else if (_averageFPS < 55) {
      recommendations.add('Fine-tune animations');
      recommendations.add('Consider RepaintBoundary usage');
    }

    return recommendations;
  }

  /// Reset performance metrics
  void reset() {
    _frameTimes.clear();
    _frameTimestamps.clear();
    _averageFrameTime = 0.0;
    _averageFPS = 0.0;
    _minFPS = double.infinity;
    _maxFPS = 0.0;
  }
}

/// Performance report data class
class PerformanceReport {
  final double averageFPS;
  final double minFPS;
  final double maxFPS;
  final double averageFrameTime;
  final int frameDrops;
  final String grade;
  final bool isMonitoring;

  const PerformanceReport({
    required this.averageFPS,
    required this.minFPS,
    required this.maxFPS,
    required this.averageFrameTime,
    required this.frameDrops,
    required this.grade,
    required this.isMonitoring,
  });

  @override
  String toString() {
    return 'PerformanceReport(averageFPS: ${averageFPS.toStringAsFixed(1)}, '
        'minFPS: ${minFPS.toStringAsFixed(1)}, '
        'maxFPS: ${maxFPS.toStringAsFixed(1)}, '
        'averageFrameTime: ${averageFrameTime.toStringAsFixed(2)}ms, '
        'frameDrops: $frameDrops, '
        'grade: $grade)';
  }
}

/// Performance monitoring widget for debug overlay
class GamePerformanceOverlay extends StatefulWidget {
  final Widget child;
  final bool showOverlay;

  const GamePerformanceOverlay({
    super.key,
    required this.child,
    this.showOverlay = kDebugMode,
  });

  @override
  State<GamePerformanceOverlay> createState() => _GamePerformanceOverlayState();
}

class _GamePerformanceOverlayState extends State<GamePerformanceOverlay> {
  final PerformanceMonitor _monitor = PerformanceMonitor();
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    if (widget.showOverlay) {
      _monitor.startMonitoring();
      _updateTimer = Timer.periodic(
        const Duration(milliseconds: 500),
        (_) => setState(() {}),
      );
    }
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _monitor.stopMonitoring();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showOverlay) {
      return widget.child;
    }

    final report = _monitor.getPerformanceReport();

    return Stack(
      children: [
        widget.child,
        Positioned(
          top: 50,
          right: 10,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'FPS: ${report.averageFPS.toStringAsFixed(1)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  'Frame: ${report.averageFrameTime.toStringAsFixed(1)}ms',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  'Grade: ${report.grade}',
                  style: TextStyle(
                    color: _getGradeColor(report.grade),
                    fontSize: 12,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (report.frameDrops > 0)
                  Text(
                    'Drops: ${report.frameDrops}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'Excellent':
        return Colors.green;
      case 'Good':
        return Colors.lightGreen;
      case 'Fair':
        return Colors.orange;
      case 'Poor':
        return Colors.red;
      default:
        return Colors.white;
    }
  }
}
