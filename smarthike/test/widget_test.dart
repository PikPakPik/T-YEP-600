import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smarthike/main.dart';

void main() {
  testWidgets('NavigationBarApp has 3 navigation destinations',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SmartHikeApp());

    expect(find.byIcon(Icons.person_outline), findsOneWidget);
  });
}
