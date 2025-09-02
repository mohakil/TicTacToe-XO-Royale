import 'dart:io';
import 'package:flutter/foundation.dart';

void main() async {
  debugPrint('🧪 Running Comprehensive Test Suite for TicTacToe XO Royale');
  debugPrint('=' * 60);

  final testResults = <String, bool>{};

  // Run unit tests
  debugPrint('\n📋 Running Unit Tests...');
  testResults['Unit Tests'] = await runTestSuite('Unit Tests', [
    'test/game_provider_test.dart',
    'test/setup_provider_test.dart',
    'test/home_provider_test.dart',
    'test/loading_provider_test.dart',
    'test/store_provider_test.dart',
  ]);

  // Run simple widget tests
  debugPrint('\n🎨 Running Widget Tests...');
  testResults['Widget Tests'] = await runTestSuite('Widget Tests', [
    'test/simple_widget_test.dart',
  ]);

  // Run integration tests
  debugPrint('\n🔗 Running Integration Tests...');
  testResults['Integration Tests'] = await runTestSuite('Integration Tests', [
    'test/integration_test.dart',
  ]);

  // Run performance tests
  debugPrint('\n⚡ Running Performance Tests...');
  testResults['Performance Tests'] = await runTestSuite('Performance Tests', [
    'test/performance_test.dart',
  ]);

  // Run coverage analysis
  debugPrint('\n📊 Running Coverage Analysis...');
  testResults['Coverage Analysis'] = await runCoverageAnalysis();

  // Print summary
  debugPrint('\n${'=' * 60}');
  debugPrint('📋 TEST SUMMARY');
  debugPrint('=' * 60);

  int passedTests = 0;
  int totalTests = testResults.length;

  for (final entry in testResults.entries) {
    final status = entry.value ? '✅ PASSED' : '❌ FAILED';
    debugPrint('${entry.key}: $status');
    if (entry.value) passedTests++;
  }

  debugPrint('\nOverall: $passedTests/$totalTests test suites passed');

  if (passedTests == totalTests) {
    debugPrint('🎉 All tests passed! The app is ready for production.');
  } else {
    debugPrint('⚠️  Some tests failed. Please review and fix the issues.');
  }
}

Future<bool> runTestSuite(String suiteName, List<String> testFiles) async {
  try {
    for (final testFile in testFiles) {
      final file = File(testFile);
      if (await file.exists()) {
        debugPrint('  Running $testFile...');
        final result = await Process.run('flutter', [
          'test',
          testFile,
        ], workingDirectory: Directory.current.path);

        if (result.exitCode != 0) {
          debugPrint('  ❌ $testFile failed');
          debugPrint('  Error: ${result.stderr}');
          return false;
        } else {
          debugPrint('  ✅ $testFile passed');
        }
      } else {
        debugPrint('  ⚠️  $testFile not found, skipping...');
      }
    }
    return true;
  } catch (e) {
    debugPrint('  ❌ Error running $suiteName: $e');
    return false;
  }
}

Future<bool> runCoverageAnalysis() async {
  try {
    debugPrint('  Running coverage analysis...');
    final result = await Process.run('flutter', [
      'test',
      '--coverage',
    ], workingDirectory: Directory.current.path);

    if (result.exitCode == 0) {
      debugPrint('  ✅ Coverage analysis completed');

      // Check coverage file
      final coverageFile = File('coverage/lcov.info');
      if (await coverageFile.exists()) {
        final coverageContent = await coverageFile.readAsString();
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
            '  📈 Coverage: ${coveragePercentage.toStringAsFixed(2)}%',
          );

          if (coveragePercentage >= 80) {
            debugPrint('  🎉 Coverage target (80%+) achieved!');
            return true;
          } else {
            debugPrint('  ⚠️  Coverage below target (80%+)');
            return false;
          }
        }
      }
      return true;
    } else {
      debugPrint('  ❌ Coverage analysis failed');
      debugPrint('  Error: ${result.stderr}');
      return false;
    }
  } catch (e) {
    debugPrint('  ❌ Error running coverage analysis: $e');
    return false;
  }
}
