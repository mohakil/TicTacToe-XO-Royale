import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/services/performance_service.dart';
import 'package:tictactoe_xo_royale/core/utils/responsive_builder.dart';
import 'package:tictactoe_xo_royale/core/utils/verification_utils.dart';

/// Comprehensive verification widget for testing accessibility, responsiveness, and performance
class ComprehensiveVerificationWidget extends ConsumerStatefulWidget {
  const ComprehensiveVerificationWidget({super.key});

  @override
  ConsumerState<ComprehensiveVerificationWidget> createState() =>
      _ComprehensiveVerificationWidgetState();
}

class _ComprehensiveVerificationWidgetState
    extends ConsumerState<ComprehensiveVerificationWidget> {
  String _verificationReport = '';
  bool _isGeneratingReport = false;
  final List<Size> _tapTargetSizes = [];
  final List<String> _tapTargetContexts = [];
  final List<Color> _foregroundColors = [];
  final List<Color> _backgroundColors = [];
  final List<String> _contrastContexts = [];

  @override
  void initState() {
    super.initState();
    _initializeTestData();
  }

  void _initializeTestData() {
    // Initialize test data for verification
    _tapTargetSizes.addAll([
      const Size(56, 56), // Button
      const Size(48, 48), // Icon button
      const Size(64, 48), // Text button
      const Size(80, 40), // Small button
    ]);

    _tapTargetContexts.addAll([
      'Primary button',
      'Icon button',
      'Text button',
      'Small button',
    ]);

    _foregroundColors.addAll([
      Colors.black,
      Colors.white,
      Colors.blue,
      Colors.red,
    ]);

    _backgroundColors.addAll([
      Colors.white,
      Colors.black,
      Colors.lightBlue,
      const Color(0xFFFFCDD2), // Light red
    ]);

    _contrastContexts.addAll([
      'Primary text on white',
      'White text on black',
      'Blue text on light blue',
      'Red text on light red',
    ]);
  }

  Future<void> _generateVerificationReport() async {
    setState(() {
      _isGeneratingReport = true;
    });

    try {
      // Get current performance metrics
      final performanceService = ref.read(performanceServiceProvider);
      final performanceMetrics = performanceService.getCurrentMetrics();

      // Generate comprehensive report
      final report = generateVerificationReport(
        context: context,
        performanceMetrics: performanceMetrics,
        tapTargetSizes: _tapTargetSizes,
        tapTargetContexts: _tapTargetContexts,
        foregroundColors: _foregroundColors,
        backgroundColors: _backgroundColors,
        contrastContexts: _contrastContexts,
      );

      setState(() {
        _verificationReport = report;
        _isGeneratingReport = false;
      });
    } on Exception catch (e) {
      setState(() {
        _verificationReport = 'Error generating report: $e';
        _isGeneratingReport = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => ResponsiveBuilder(
    builder: (context, layout) => Scaffold(
      appBar: AppBar(
        title: const Text('Comprehensive Verification'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        padding: layout.responsivePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Accessibility, Responsiveness & Performance Verification',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: layout.responsiveSpacing),

            // Description
            Text(
              'This widget provides comprehensive testing and validation of all accessibility, responsiveness, and performance features against PRD requirements.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: layout.responsiveSpacing * 2),

            // Generate Report Button
            Center(
              child: ElevatedButton.icon(
                onPressed: _isGeneratingReport
                    ? null
                    : _generateVerificationReport,
                icon: _isGeneratingReport
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.assessment),
                label: Text(
                  _isGeneratingReport
                      ? 'Generating...'
                      : 'Generate Verification Report',
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: layout.responsivePadding.left * 2,
                    vertical: layout.responsivePadding.top,
                  ),
                  minimumSize: Size(
                    layout.responsiveButtonHeight * 3,
                    layout.responsiveButtonHeight,
                  ),
                ),
              ),
            ),

            SizedBox(height: layout.responsiveSpacing * 2),

            // Quick Verification Tests
            _buildQuickVerificationTests(context, layout),

            SizedBox(height: layout.responsiveSpacing * 2),

            // Verification Report
            if (_verificationReport.isNotEmpty) ...[
              _buildVerificationReport(context, layout),
            ],
          ],
        ),
      ),
    ),
  );

  Widget _buildQuickVerificationTests(
    BuildContext context,
    ResponsiveLayout layout,
  ) => Card(
    child: Padding(
      padding: layout.responsivePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Verification Tests',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: layout.responsiveSpacing),

          // Responsive breakpoints test
          _buildTestItem(
            context,
            'Responsive Breakpoints',
            verifyResponsiveBreakpoints(),
          ),

          SizedBox(height: layout.responsiveSpacing),

          // Tap target sizes test
          _buildTestItem(
            context,
            'Tap Target Sizes',
            _tapTargetSizes.asMap().entries.map((entry) {
              final index = entry.key;
              final size = entry.value;
              return verifyTapTargetSizeWithContext(
                size,
                _tapTargetContexts[index],
              );
            }).toList(),
          ),

          SizedBox(height: layout.responsiveSpacing),

          // Contrast ratios test
          _buildTestItem(
            context,
            'Contrast Ratios',
            _foregroundColors
                .asMap()
                .entries
                .expand((entry) {
                  final index = entry.key;
                  return verifyContrastRatios(
                    _foregroundColors[index],
                    _backgroundColors[index],
                    _contrastContexts[index],
                  );
                })
                .cast<String>()
                .toList(),
          ),
        ],
      ),
    ),
  );

  Widget _buildTestItem(
    BuildContext context,
    String title,
    List<String> results,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 8),
      ...results.map(
        (result) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(result, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ),
    ],
  );

  Widget _buildVerificationReport(
    BuildContext context,
    ResponsiveLayout layout,
  ) => Card(
    child: Padding(
      padding: layout.responsivePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.assessment,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Verification Report',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: layout.responsiveSpacing),

          Container(
            width: double.infinity,
            padding: layout.responsivePadding,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(
                layout.responsiveBorderRadius,
              ),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: SelectableText(
              _verificationReport,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
              ),
            ),
          ),

          SizedBox(height: layout.responsiveSpacing),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Copy report to clipboard
                  // In a real app, you'd implement clipboard functionality
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copy Report'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Export report to file
                  // In a real app, you'd implement file export
                },
                icon: const Icon(Icons.download),
                label: const Text('Export'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
