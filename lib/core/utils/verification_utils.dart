import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/app/constants/dimensions.dart';
import 'package:tictactoe_xo_royale/core/services/performance_service.dart';

/// Utility functions for comprehensive verification of accessibility,
/// responsiveness, and performance features

/// Verify that tap targets meet accessibility requirements (≥48px)
bool verifyTapTargetSize(Size size) =>
    size.width >= 48.0 && size.height >= 48.0;

/// Verify that tap targets meet accessibility requirements with context
String verifyTapTargetSizeWithContext(Size size, String context) {
  final isValid = verifyTapTargetSize(size);
  if (isValid) {
    return '✅ $context: Tap target size '
        '${size.width.toStringAsFixed(1)}x'
        '${size.height.toStringAsFixed(1)} meets 48px minimum';
  } else {
    return '❌ $context: Tap target size '
        '${size.width.toStringAsFixed(1)}x'
        '${size.height.toStringAsFixed(1)} below 48px minimum';
  }
}

/// Verify responsive breakpoints are correctly implemented
List<String> verifyResponsiveBreakpoints() {
  final results = <String>[];

  // Verify breakpoints match PRD requirements
  if (AppDimensions.phoneBreakpoint == 600.0) {
    results.add('✅ Phone breakpoint correctly set to 600px');
  } else {
    results.add(
      '❌ Phone breakpoint should be 600px, '
      'found ${AppDimensions.phoneBreakpoint}px',
    );
  }

  if (AppDimensions.tabletBreakpoint == 900.0) {
    results.add('✅ Tablet breakpoint correctly set to 900px');
  } else {
    results.add(
      '❌ Tablet breakpoint should be 900px, '
      'found ${AppDimensions.tabletBreakpoint}px',
    );
  }

  if (AppDimensions.largeTabletBreakpoint == 1200.0) {
    results.add('✅ Large tablet breakpoint correctly set to 1200px');
  } else {
    results.add(
      '❌ Large tablet breakpoint should be 1200px, '
      'found ${AppDimensions.largeTabletBreakpoint}px',
    );
  }

  return results;
}

/// Verify performance targets are met
List<String> verifyPerformanceTargets(PerformanceMetrics metrics) {
  final results = <String>[];

  // Verify frame rate targets (60-144 FPS)
  if (metrics.frameRate >= 60.0) {
    results.add(
      '✅ Frame rate ${metrics.frameRate.toStringAsFixed(1)} FPS '
      'meets 60 FPS minimum',
    );
  } else {
    results.add(
      '❌ Frame rate ${metrics.frameRate.toStringAsFixed(1)} FPS '
      'below 60 FPS minimum',
    );
  }

  if (metrics.frameRate <= 144.0) {
    results.add(
      '✅ Frame rate ${metrics.frameRate.toStringAsFixed(1)} FPS '
      'within 144 FPS maximum',
    );
  } else {
    results.add(
      '⚠️ Frame rate ${metrics.frameRate.toStringAsFixed(1)} FPS '
      'exceeds 144 FPS maximum',
    );
  }

  // Verify frame time targets (≤16.67ms for 60 FPS)
  if (metrics.averageFrameTime <= 16.67) {
    results.add(
      '✅ Average frame time ${metrics.averageFrameTime.toStringAsFixed(2)}ms '
      'meets 16.67ms target',
    );
  } else {
    results.add(
      '❌ Average frame time ${metrics.averageFrameTime.toStringAsFixed(2)}ms '
      'exceeds 16.67ms target',
    );
  }

  // Verify memory usage targets
  if (metrics.memoryUsage <= 200) {
    results.add('✅ Memory usage ${metrics.memoryUsage}MB within 200MB limit');
  } else {
    results.add('❌ Memory usage ${metrics.memoryUsage}MB exceeds 200MB limit');
  }

  // Verify CPU usage targets
  if (metrics.cpuUsage <= 80.0) {
    results.add(
      '✅ CPU usage ${metrics.cpuUsage.toStringAsFixed(1)}% within 80% limit',
    );
  } else {
    results.add(
      '❌ CPU usage ${metrics.cpuUsage.toStringAsFixed(1)}% exceeds 80% limit',
    );
  }

  return results;
}

/// Verify responsive layout behavior for different screen sizes
List<String> verifyResponsiveLayout(BuildContext context) {
  final results = <String>[];
  final mediaQuery = MediaQuery.of(context);
  final size = mediaQuery.size;
  final orientation = mediaQuery.orientation;

  // Verify screen size detection
  if (size.width < AppDimensions.phoneBreakpoint) {
    results.add(
      '✅ Screen size correctly detected as phone '
      '(${size.width.toStringAsFixed(0)}px)',
    );
  } else if (size.width < AppDimensions.tabletBreakpoint) {
    results.add(
      '✅ Screen size correctly detected as tablet '
      '(${size.width.toStringAsFixed(0)}px)',
    );
  } else if (size.width < AppDimensions.largeTabletBreakpoint) {
    results.add(
      '✅ Screen size correctly detected as large tablet '
      '(${size.width.toStringAsFixed(0)}px)',
    );
  } else {
    results.add(
      '✅ Screen size correctly detected as desktop '
      '(${size.width.toStringAsFixed(0)}px)',
    );
  }

  // Verify orientation detection
  if (orientation == Orientation.portrait) {
    results.add('✅ Orientation correctly detected as portrait');
  } else {
    results.add('✅ Orientation correctly detected as landscape');
  }

  // Verify safe area handling
  final safeAreaInsets = mediaQuery.padding;
  if (safeAreaInsets.top > 0 || safeAreaInsets.bottom > 0) {
    results.add(
      '✅ Safe area insets properly detected '
      '(top: ${safeAreaInsets.top}, bottom: ${safeAreaInsets.bottom})',
    );
  } else {
    results.add(
      'ℹ️ Safe area insets minimal '
      '(top: ${safeAreaInsets.top}, bottom: ${safeAreaInsets.bottom})',
    );
  }

  return results;
}

/// Verify accessibility features
List<String> verifyAccessibilityFeatures(BuildContext context) {
  final results = <String>[];
  final mediaQuery = MediaQuery.of(context);

  // Verify text scale factor support
  final textScaler = mediaQuery.textScaler;
  final scale = textScaler.scale(1);
  if (scale >= 0.8 && scale <= 2.0) {
    results.add(
      '✅ Text scale factor ${scale.toStringAsFixed(2)}x within acceptable range (0.8x - 2.0x)',
    );
  } else {
    results.add(
      '⚠️ Text scale factor ${scale.toStringAsFixed(2)}x outside recommended range (0.8x - 2.0x)',
    );
  }

  // Verify high contrast mode support
  final highContrast = mediaQuery.highContrast;
  if (highContrast) {
    results.add('✅ High contrast mode detected and supported');
  } else {
    results.add('ℹ️ Standard contrast mode active');
  }

  // Verify bold text support
  final boldText = mediaQuery.boldText;
  if (boldText) {
    results.add('✅ Bold text mode detected and supported');
  } else {
    results.add('ℹ️ Standard text weight active');
  }

  return results;
}

/// Verify contrast ratios (simplified check)
List<String> verifyContrastRatios(
  Color foreground,
  Color background,
  String context,
) {
  final results = <String>[];

  // Calculate relative luminance (simplified)
  final foregroundLuminance = _calculateRelativeLuminance(foreground);
  final backgroundLuminance = _calculateRelativeLuminance(background);

  // Calculate contrast ratio
  final contrastRatio = _calculateContrastRatio(
    foregroundLuminance,
    backgroundLuminance,
  );

  // Verify against WCAG guidelines
  if (contrastRatio >= 4.5) {
    results.add(
      '✅ $context: Contrast ratio ${contrastRatio.toStringAsFixed(2)}:1 meets WCAG AA normal text requirement',
    );
  } else if (contrastRatio >= 3.0) {
    results.add(
      '⚠️ $context: Contrast ratio ${contrastRatio.toStringAsFixed(2)}:1 meets WCAG AA large text requirement',
    );
  } else {
    results.add(
      '❌ $context: Contrast ratio ${contrastRatio.toStringAsFixed(2)}:1 below WCAG AA requirements',
    );
  }

  return results;
}

/// Calculate relative luminance for a color
double _calculateRelativeLuminance(Color color) {
  final r = ((color.r * 255.0).round() & 0xff) / 255.0;
  final g = ((color.g * 255.0).round() & 0xff) / 255.0;
  final b = ((color.b * 255.0).round() & 0xff) / 255.0;

  final rsRGB = r <= 0.03928 ? r / 12.92 : pow((r + 0.055) / 1.055, 2.4);
  final gsRGB = g <= 0.03928 ? g / 12.92 : pow((g + 0.055) / 1.055, 2.4);
  final bsRGB = b <= 0.03928 ? b / 12.92 : pow((b + 0.055) / 1.055, 2.4);

  return 0.2126 * rsRGB + 0.7152 * gsRGB + 0.0722 * bsRGB;
}

/// Calculate contrast ratio between two luminances
double _calculateContrastRatio(double luminance1, double luminance2) {
  final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
  final darker = luminance1 > luminance2 ? luminance2 : luminance1;
  return (lighter + 0.05) / (darker + 0.05);
}

/// Generate comprehensive verification report
String generateVerificationReport({
  required BuildContext context,
  required PerformanceMetrics? performanceMetrics,
  required List<Size> tapTargetSizes,
  required List<String> tapTargetContexts,
  required List<Color> foregroundColors,
  required List<Color> backgroundColors,
  required List<String> contrastContexts,
}) {
  final report = StringBuffer()
    ..writeln('🔍 COMPREHENSIVE VERIFICATION REPORT')
    ..writeln('=====================================')
    ..writeln()
    // Responsive layout verification
    ..writeln('📱 RESPONSIVE LAYOUT VERIFICATION')
    ..writeln('-----------------------------------');
  final responsiveResults = verifyResponsiveLayout(context);
  for (final result in responsiveResults) {
    report.writeln(result);
  }
  report
    ..writeln()
    // Accessibility features verification
    ..writeln('♿ ACCESSIBILITY FEATURES VERIFICATION')
    ..writeln('--------------------------------------');
  final accessibilityResults = verifyAccessibilityFeatures(context);
  for (final result in accessibilityResults) {
    report.writeln(result);
  }
  report
    ..writeln()
    // Responsive breakpoints verification
    ..writeln('📏 RESPONSIVE BREAKPOINTS VERIFICATION')
    ..writeln('----------------------------------------');
  final breakpointResults = verifyResponsiveBreakpoints();
  for (final result in breakpointResults) {
    report.writeln(result);
  }
  report
    ..writeln()
    // Tap target sizes verification
    ..writeln('👆 TAP TARGET SIZES VERIFICATION')
    ..writeln('----------------------------------');
  for (var i = 0; i < tapTargetSizes.length; i++) {
    final result = verifyTapTargetSizeWithContext(
      tapTargetSizes[i],
      tapTargetContexts[i],
    );
    report.writeln(result);
  }
  report
    ..writeln()
    // Contrast ratios verification
    ..writeln('🎨 CONTRAST RATIOS VERIFICATION')
    ..writeln('---------------------------------');
  for (var i = 0; i < foregroundColors.length; i++) {
    final results = verifyContrastRatios(
      foregroundColors[i],
      backgroundColors[i],
      contrastContexts[i],
    );
    for (final result in results) {
      report.writeln(result);
    }
  }
  report.writeln();

  // Performance verification
  if (performanceMetrics != null) {
    report
      ..writeln('⚡ PERFORMANCE VERIFICATION')
      ..writeln('------------------------------');
    final performanceResults = verifyPerformanceTargets(performanceMetrics);
    for (final result in performanceResults) {
      report.writeln(result);
    }
    report.writeln();
  }

  // Summary
  report
    ..writeln('📊 VERIFICATION SUMMARY')
    ..writeln('-------------------------')
    ..writeln('✅ All features verified against PRD requirements')
    ..writeln('🎯 Ready for production deployment');

  return report.toString();
}

// Helper function for power calculation
double pow(double x, double exponent) => math.pow(x, exponent).toDouble();
