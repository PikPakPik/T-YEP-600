import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smarthike/components/hike/difficulty.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';

void main() {
  group('Difficulty Widget Tests', () {
    testWidgets('displays correct icon and text for difficulty 1',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Difficulty(difficulty: 1),
        ),
      ));

      expect(find.text(LocaleKeys.hike_details_difficulty_steps_easy.tr()),
          findsOneWidget);
      expect(find.byIcon(Icons.looks_one_outlined), findsOneWidget);
    });

    testWidgets('displays correct icon and text for difficulty 2',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Difficulty(difficulty: 2),
        ),
      ));

      expect(find.text(LocaleKeys.hike_details_difficulty_steps_medium.tr()),
          findsOneWidget);
      expect(find.byIcon(Icons.looks_two_outlined), findsOneWidget);
    });

    testWidgets('displays correct icon and text for difficulty 3',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Difficulty(difficulty: 3),
        ),
      ));

      expect(find.text(LocaleKeys.hike_details_difficulty_steps_difficult.tr()),
          findsOneWidget);
      expect(find.byIcon(Icons.looks_3_outlined), findsOneWidget);
    });

    testWidgets('displays default values when difficulty is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Difficulty(difficulty: null),
        ),
      ));

      expect(find.text(LocaleKeys.hike_details_unknown.tr()), findsOneWidget);
      expect(find.byIcon(Icons.help_outline), findsOneWidget);
    });
  });
}
