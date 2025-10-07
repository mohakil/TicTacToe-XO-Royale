import 'package:flutter/material.dart';

/// Utility class for migrating existing widgets to the new responsive system
class ResponsiveMigrationHelper {
  /// Migrates a LayoutBuilder widget to use the responsive system
  static Widget migrateLayoutBuilder({
    required Widget layoutBuilderWidget,
    required BuildContext context,
  }) {
    // This is a simplified migration helper
    // In a real implementation, you might need more sophisticated analysis

    final layoutBuilder = layoutBuilderWidget as LayoutBuilder;
    final constraints = MediaQuery.of(context).size;

    // Simple heuristic: if breakpoint is 600, convert to phone/tablet check
    return layoutBuilder.builder(context, BoxConstraints.tight(constraints));
  }

  /// Analyzes a widget for responsive issues and suggests improvements
  static List<ResponsiveIssue> analyzeWidgetForResponsiveIssues(Widget widget) {
    final issues = <ResponsiveIssue>[];

    // Check for hardcoded breakpoints
    if (_containsHardcodedBreakpoint(widget)) {
      issues.add(
        ResponsiveIssue(
          type: ResponsiveIssueType.hardcodedBreakpoint,
          message: 'Hardcoded breakpoint detected',
          suggestion:
              'Use context.isPhone or context.isTablet instead of hardcoded values',
          severity: ResponsiveIssueSeverity.medium,
        ),
      );
    }

    // Check for hardcoded spacing
    if (_containsHardcodedSpacing(widget)) {
      issues.add(
        ResponsiveIssue(
          type: ResponsiveIssueType.hardcodedSpacing,
          message: 'Hardcoded spacing values detected',
          suggestion:
              'Use context.getResponsiveSpacing() for consistent spacing',
          severity: ResponsiveIssueSeverity.low,
        ),
      );
    }

    // Check for hardcoded text sizes
    if (_containsHardcodedTextSizes(widget)) {
      issues.add(
        ResponsiveIssue(
          type: ResponsiveIssueType.hardcodedTextSize,
          message: 'Hardcoded text sizes detected',
          suggestion:
              'Use context.getResponsiveTextStyle() for system-aware text scaling',
          severity: ResponsiveIssueSeverity.low,
        ),
      );
    }

    return issues;
  }

  /// Batch migrates multiple widgets
  static List<Widget> migrateWidgets({
    required List<Widget> widgets,
    required BuildContext context,
  }) {
    return widgets.map((widget) {
      // Simple migration logic - in practice, you'd need more sophisticated analysis
      if (widget is LayoutBuilder) {
        return migrateLayoutBuilder(
          layoutBuilderWidget: widget,
          context: context,
        );
      }
      return widget;
    }).toList();
  }

  /// Generates migration code suggestions
  static String generateMigrationSuggestion(ResponsiveIssue issue) {
    switch (issue.type) {
      case ResponsiveIssueType.hardcodedBreakpoint:
        return '''
// Instead of:
if (constraints.maxWidth < 600) {
  return MobileLayout();
}

// Use:
if (context.isPhone) {
  return MobileLayout();
}
''';

      case ResponsiveIssueType.hardcodedSpacing:
        return '''
// Instead of:
const SizedBox(height: 24)

// Use:
SizedBox(height: context.getResponsiveSpacing(
  phoneSpacing: 20.0,
  tabletSpacing: 24.0,
))
''';

      case ResponsiveIssueType.hardcodedTextSize:
        return '''
// Instead of:
Text('Title', style: TextStyle(fontSize: 24))

// Use:
Text(
  'Title',
  style: context.getResponsiveTextStyle(
    TextStyle(fontSize: 24),
    phoneSize: 20.0,
    tabletSize: 24.0,
  ),
)
''';

      default:
        return 'Consider using the responsive system for better consistency.';
    }
  }

  // Helper methods for analysis
  static bool _containsHardcodedBreakpoint(Widget widget) {
    // This is a simplified check - in practice, you'd need AST analysis
    // For now, just return false as a placeholder
    return false;
  }

  static bool _containsHardcodedSpacing(Widget widget) {
    // Placeholder for spacing analysis
    return false;
  }

  static bool _containsHardcodedTextSizes(Widget widget) {
    // Placeholder for text size analysis
    return false;
  }
}

/// Represents a responsive issue found during analysis
class ResponsiveIssue {
  final ResponsiveIssueType type;
  final String message;
  final String suggestion;
  final ResponsiveIssueSeverity severity;

  const ResponsiveIssue({
    required this.type,
    required this.message,
    required this.suggestion,
    required this.severity,
  });

  @override
  String toString() {
    return '$severity: $message\nSuggestion: $suggestion';
  }
}

/// Types of responsive issues
enum ResponsiveIssueType {
  hardcodedBreakpoint,
  hardcodedSpacing,
  hardcodedTextSize,
  missingSafeArea,
  inconsistentTouchTargets,
}

/// Severity levels for responsive issues
enum ResponsiveIssueSeverity { low, medium, high, critical }

/// Extension to add responsive migration methods to common widgets
extension ResponsiveWidgetMigration on Widget {
  /// Gets migration suggestions for this widget
  List<ResponsiveIssue> getResponsiveIssues() {
    return ResponsiveMigrationHelper.analyzeWidgetForResponsiveIssues(this);
  }

  /// Migrates this widget to use responsive system (if applicable)
  Widget migrateToResponsive(BuildContext context) {
    return ResponsiveMigrationHelper.migrateLayoutBuilder(
      layoutBuilderWidget: this,
      context: context,
    );
  }
}
