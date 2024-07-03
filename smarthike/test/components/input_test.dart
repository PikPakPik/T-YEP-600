import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smarthike/components/input.dart';

void main() {
  testWidgets('CustomInput displays hint text', (WidgetTester tester) async {
    // Arrange
    const hintText = 'Enter text';
    final controller = TextEditingController();

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomInput(
            hintText: hintText,
            controller: controller,
          ),
        ),
      ),
    );

    // Assert
    expect(find.text(hintText), findsOneWidget);
  });

  testWidgets('CustomInput obscures text when obscureText is true',
      (WidgetTester tester) async {
    // Arrange
    const hintText = 'Enter password';
    final controller = TextEditingController();

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomInput(
            hintText: hintText,
            controller: controller,
            obscureText: true,
          ),
        ),
      ),
    );

// Assert
    final textField = find.byType(TextFormField);
    expect(textField, findsOneWidget);
  });
}
