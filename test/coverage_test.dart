import 'dart:io';
import 'package:flutter/foundation.dart';

void main() async {
  debugPrint('Running test coverage analysis...');

  // Run tests with coverage
  final result = await Process.run('flutter', [
    'test',
    '--coverage',
  ], workingDirectory: Directory.current.path);

  if (result.exitCode == 0) {
    debugPrint('✅ All tests passed!');
    debugPrint('📊 Coverage report generated in coverage/lcov.info');

    // Check if coverage file exists
    final coverageFile = File('coverage/lcov.info');
    if (await coverageFile.exists()) {
      final coverageContent = await coverageFile.readAsString();

      // Parse coverage data
      final lines = coverageContent.split('\n');
      int totalLines = 0;
      int coveredLines = 0;

      for (final line in lines) {
        if (line.startsWith('DA:')) {
          final parts = line.split(',');
          if (parts.length >= 2) {
            totalLines++;
            final hitCount = int.tryParse(parts[1]) ?? 0;
            if (hitCount > 0) {
              coveredLines++;
            }
          }
        }
      }

      if (totalLines > 0) {
        final coveragePercentage = (coveredLines / totalLines) * 100;
        debugPrint(
          '📈 Test Coverage: ${coveragePercentage.toStringAsFixed(2)}%',
        );
        debugPrint('   Covered lines: $coveredLines');
        debugPrint('   Total lines: $totalLines');

        if (coveragePercentage >= 80) {
          debugPrint('🎉 Coverage target (80%+) achieved!');
        } else {
          debugPrint('⚠️  Coverage below target (80%+)');
          debugPrint(
            '   Need to cover ${(totalLines * 0.8 - coveredLines).ceil()} more lines',
          );
        }
      }
    }
  } else {
    debugPrint('❌ Tests failed!');
    debugPrint('Error: ${result.stderr}');
  }
}
