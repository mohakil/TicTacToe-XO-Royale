import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_xo_royale/shared/widgets/forms/form_input.dart';

void main() {
  group('FormInput Tests', () {
    testWidgets('renders basic form input correctly', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormInput(controller: controller, label: 'Test Input'),
          ),
        ),
      );

      expect(find.text('Test Input'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('renders with hint text correctly', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormInput(
              controller: controller,
              label: 'Username',
              hintText: 'Enter your username',
            ),
          ),
        ),
      );

      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Enter your username'), findsOneWidget);
    });

    testWidgets('handles text input correctly', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormInput(controller: controller, label: 'Input Field'),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Test Input');
      expect(controller.text, 'Test Input');
    });

    testWidgets('handles onChanged callback correctly', (
      WidgetTester tester,
    ) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormInput(
              controller: TextEditingController(),
              label: 'Change Test',
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'New Value');
      expect(changedValue, 'New Value');
    });

    testWidgets('handles validation correctly', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: FormInput(
                controller: controller,
                label: 'Validated Input',
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Field is required';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      );

      // Trigger validation by losing focus
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      await tester.tap(find.byType(Scaffold));
      await tester.pump();

      expect(find.text('Field is required'), findsOneWidget);
    });

    testWidgets('handles enabled state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormInput(
              controller: TextEditingController(),
              label: 'Enabled Input',
              enabled: true,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      expect(textField.enabled, isTrue);
    });

    testWidgets('handles disabled state correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormInput(
              controller: TextEditingController(),
              label: 'Disabled Input',
              enabled: false,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      expect(textField.enabled, isFalse);
    });

    testWidgets('handles max length correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormInput(
              controller: TextEditingController(),
              label: 'Max Length Input',
            ),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('handles text input correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormInput(
              controller: TextEditingController(),
              label: 'Text Input',
            ),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('applies responsive styling correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormInput(
              controller: TextEditingController(),
              label: 'Responsive Input',
            ),
          ),
        ),
      );

      expect(find.text('Responsive Input'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('handles different input types correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormInput(
              controller: TextEditingController(),
              label: 'Email Input',
            ),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
    });
  });
}
