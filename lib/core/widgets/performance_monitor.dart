import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/services/performance_service.dart';

/// Widget that displays performance metrics and recommendations
class PerformanceMonitor extends ConsumerWidget {
  const PerformanceMonitor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsAsync = ref.watch(performanceMetricsProvider);
    final recommendations = ref.watch(performanceRecommendationsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.speed, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Performance Monitor',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Performance Metrics
            metricsAsync.when(
              data: (metrics) => _buildMetricsSection(context, metrics),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),

            const SizedBox(height: 16),

            // Performance Recommendations
            if (recommendations.isNotEmpty) ...[
              Text(
                'Recommendations',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              ...recommendations.map(
                (rec) => _buildRecommendation(context, rec),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsSection(
    BuildContext context,
    PerformanceMetrics metrics,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine frame rate color
    Color frameRateColor;
    if (metrics.frameRate >= 60) {
      frameRateColor = colorScheme.tertiary; // Green for good performance
    } else if (metrics.frameRate >= 30) {
      frameRateColor = colorScheme.secondary; // Orange for moderate
    } else {
      frameRateColor = colorScheme.error; // Red for poor performance
    }

    return Column(
      children: [
        _buildMetricRow(
          context,
          'Frame Rate',
          '${metrics.frameRate.toStringAsFixed(1)} FPS',
          frameRateColor,
        ),
        _buildMetricRow(
          context,
          'Avg Frame Time',
          '${metrics.averageFrameTime.toStringAsFixed(2)} ms',
          colorScheme.onSurfaceVariant,
        ),
        _buildMetricRow(
          context,
          'Memory Usage',
          '${metrics.memoryUsage} MB',
          colorScheme.onSurfaceVariant,
        ),
        _buildMetricRow(
          context,
          'CPU Usage',
          '${metrics.cpuUsage.toStringAsFixed(1)}%',
          colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }

  Widget _buildMetricRow(
    BuildContext context,
    String label,
    String value,
    Color valueColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendation(
    BuildContext context,
    PerformanceRecommendation rec,
  ) {
    final theme = Theme.of(context);
    Color severityColor;

    switch (rec.type) {
      case RecommendationType.critical:
        severityColor = theme.colorScheme.error;
        break;
      case RecommendationType.high:
        severityColor = theme.colorScheme.secondary;
        break;
      case RecommendationType.medium:
        severityColor = theme.colorScheme.tertiary;
        break;
      case RecommendationType.low:
        severityColor = theme.colorScheme.outline;
        break;
      case RecommendationType.info:
        severityColor = theme.colorScheme.primary;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: severityColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: severityColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getRecommendationIcon(rec.type),
                color: severityColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  rec.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: severityColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(rec.description, style: theme.textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(
            'Action: ${rec.action}',
            style: theme.textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getRecommendationIcon(RecommendationType type) {
    switch (type) {
      case RecommendationType.critical:
        return Icons.error;
      case RecommendationType.high:
        return Icons.warning;
      case RecommendationType.medium:
        return Icons.info;
      case RecommendationType.low:
        return Icons.check_circle;
      case RecommendationType.info:
        return Icons.info;
    }
  }
}
