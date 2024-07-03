import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smarthike/components/button.dart';

void main() {
  testWidgets('CustomButton displays text and uses background color',
      (WidgetTester tester) async {
    const testButton = CustomButton(
      text: "Test Button",
      backgroundColor: Colors.blue,
      onPressed: null,
    );

    await tester.pumpWidget(const MaterialApp(home: testButton));

    expect(find.text('Test Button'), findsOneWidget);
    final MaterialButton materialButton =
        tester.widget(find.byType(MaterialButton));
    expect(materialButton.color, Colors.blue);
  });

  testWidgets('CustomButton displays an icon when provided',
      (WidgetTester tester) async {
    const testButton = CustomButton(
      text: "Test Button",
      backgroundColor: Colors.blue,
      onPressed: null,
      icon: Icons.home,
    );

    await tester.pumpWidget(const MaterialApp(home: testButton));

    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.text('Test Button'), findsOneWidget);
    expect(find.byType(Row), findsOneWidget);
  });

  testWidgets('CustomButton is disabled when isEnable is false',
      (WidgetTester tester) async {
    const testButton = CustomButton(
      text: "Test Button",
      backgroundColor: Colors.blue,
      onPressed: null,
      icon: Icons.home,
      isEnable: false,
    );

    await tester.pumpWidget(const MaterialApp(home: testButton));

    final MaterialButton materialButton =
        tester.widget(find.byType(MaterialButton));
    expect(materialButton.onPressed, null);
    expect(materialButton.disabledColor, Colors.blue.withOpacity(0.5));
  });
}
