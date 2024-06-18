import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smarthike/main.dart';

void main() {
  testWidgets('NavigationBarApp has 3 navigation destinations',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SmartHikeApp());

    // Verify that the app has 3 navigation destinations.
    expect(find.byIcon(Icons.home), findsOneWidget);
  });
}
