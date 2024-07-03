import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smarthike/components/dropdown.dart';

void main() {
  testWidgets('CustomDropdown displays hint text and items',
      (WidgetTester tester) async {
    // Define the test key.
    const testKey = Key('dropdown');

    // Build the CustomDropdown widget.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomDropdown(
            key: testKey,
            hintText: 'Select an item',
            items: const ['Item 1', 'Item 2', 'Item 3'],
            selectedItem: null,
            onChanged: (value) {},
          ),
        ),
      ),
    );

    // Verify the hint text is displayed.
    expect(find.text('Select an item'), findsOneWidget);

    // Tap the dropdown to open it.
    await tester.tap(find.byKey(testKey));
    await tester.pumpAndSettle();

    // Verify the items are displayed.
    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Item 2'), findsOneWidget);
    expect(find.text('Item 3'), findsOneWidget);
  });

  testWidgets('CustomDropdown calls onChanged when an item is selected',
      (WidgetTester tester) async {
    String? selectedValue;

    // Build the CustomDropdown widget.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomDropdown(
            hintText: 'Select an item',
            items: const ['Item 1', 'Item 2', 'Item 3'],
            selectedItem: null,
            onChanged: (value) {
              selectedValue = value;
            },
          ),
        ),
      ),
    );

    // Tap the dropdown to open it.
    await tester.tap(find.text('Select an item'));
    await tester.pumpAndSettle();

    // Tap the first item.
    await tester.tap(find.text('Item 1').last);
    await tester.pumpAndSettle();

    // Verify the onChanged callback is called with the correct value.
    expect(selectedValue, 'Item 1');
  });
}
