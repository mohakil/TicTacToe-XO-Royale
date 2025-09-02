import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A comprehensive error boundary widget that catches and handles errors
/// throughout the widget tree, providing graceful error recovery.
class ErrorBoundary extends StatefulWidget {
  /// The child widget to wrap with error boundary
  final Widget child;

  /// Custom error builder for displaying error UI
  final Widget Function(Object error, StackTrace stackTrace)? errorBuilder;

  /// Callback for error logging
  final void Function(Object error, StackTrace stackTrace)? onError;

  /// Whether to show error details in debug mode
  final bool showErrorDetails;

  /// Custom retry callback
  final VoidCallback? onRetry;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
    this.onError,
    this.showErrorDetails = kDebugMode,
    this.onRetry,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _setupErrorHandling();
  }

  void _setupErrorHandling() {
    // Set up Flutter error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleError(details.exception, details.stack);
    };

    // Set up platform error handling
    PlatformDispatcher.instance.onError = (error, stack) {
      _handleError(error, stack);
      return true;
    };
  }

  void _handleError(Object error, StackTrace? stackTrace) {
    if (mounted) {
      setState(() {
        _error = error;
        _stackTrace = stackTrace;
        _hasError = true;
      });

      // Log error
      widget.onError?.call(error, stackTrace ?? StackTrace.empty);

      // Debug logging
      if (kDebugMode) {
        debugPrint('ErrorBoundary caught error: $error');
        debugPrint('StackTrace: $stackTrace');
      }
    }
  }

  void _retry() {
    if (mounted) {
      setState(() {
        _error = null;
        _stackTrace = null;
        _hasError = false;
      });
      widget.onRetry?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError && _error != null) {
      return widget.errorBuilder?.call(
            _error!,
            _stackTrace ?? StackTrace.empty,
          ) ??
          _DefaultErrorWidget(
            error: _error!,
            stackTrace: _stackTrace,
            showErrorDetails: widget.showErrorDetails,
            onRetry: _retry,
          );
    }

    return widget.child;
  }
}

/// Default error widget that displays error information
class _DefaultErrorWidget extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;
  final bool showErrorDetails;
  final VoidCallback? onRetry;

  const _DefaultErrorWidget({
    required this.error,
    this.stackTrace,
    required this.showErrorDetails,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error icon
              Icon(Icons.error_outline, size: 80, color: colorScheme.error),

              const SizedBox(height: 24),

              // Error title
              Text(
                'Something went wrong',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Error message
              Text(
                'We encountered an unexpected error. Please try again.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Retry button
              if (onRetry != null)
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // Error details (debug mode only)
              if (showErrorDetails && kDebugMode) ...[
                const Divider(),
                const SizedBox(height: 16),

                Text(
                  'Error Details (Debug Mode)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colorScheme.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Error: $error',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.error,
                            fontFamily: 'monospace',
                          ),
                        ),
                        if (stackTrace != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Stack Trace:',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            stackTrace.toString(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.error,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Provider for error logging service
final errorLoggingProvider = Provider<ErrorLoggingService>((ref) {
  return ErrorLoggingService();
});

/// Service for logging errors throughout the application
class ErrorLoggingService {
  /// Log an error with optional context
  void logError(
    Object error,
    StackTrace stackTrace, {
    String? context,
    Map<String, dynamic>? additionalData,
  }) {
    final errorInfo = {
      'error': error.toString(),
      'stackTrace': stackTrace.toString(),
      'timestamp': DateTime.now().toIso8601String(),
      if (context != null) 'context': context,
      if (additionalData != null) ...additionalData,
    };

    // In debug mode, print to console
    if (kDebugMode) {
      debugPrint('=== ERROR LOGGED ===');
      debugPrint('Context: ${context ?? 'Unknown'}');
      debugPrint('Error: $error');
      debugPrint('StackTrace: $stackTrace');
      if (additionalData != null) {
        debugPrint('Additional Data: $additionalData');
      }
      debugPrint('===================');
    }

    // In production, you would send this to a crash reporting service
    // like Firebase Crashlytics, Sentry, etc.
    _sendToCrashReportingService(errorInfo);
  }

  void _sendToCrashReportingService(Map<String, dynamic> errorInfo) {
    // TODO: Implement crash reporting service integration
    // Examples:
    // - Firebase Crashlytics
    // - Sentry
    // - Bugsnag
    // - Custom logging service

    if (kDebugMode) {
      debugPrint('Would send to crash reporting service: $errorInfo');
    }
  }
}

/// Extension to easily wrap widgets with error boundary
extension ErrorBoundaryExtension on Widget {
  /// Wrap this widget with an error boundary
  Widget withErrorBoundary({
    Widget Function(Object error, StackTrace stackTrace)? errorBuilder,
    void Function(Object error, StackTrace stackTrace)? onError,
    bool showErrorDetails = kDebugMode,
    VoidCallback? onRetry,
  }) {
    return ErrorBoundary(
      errorBuilder: errorBuilder,
      onError: onError,
      showErrorDetails: showErrorDetails,
      onRetry: onRetry,
      child: this,
    );
  }
}
