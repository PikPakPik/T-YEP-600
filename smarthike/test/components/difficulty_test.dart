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
    });

    testWidgets('displays correct icon and text for difficulty 2',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Difficulty(difficulty: 5),
        ),
      ));

      expect(find.text(LocaleKeys.hike_details_difficulty_steps_medium.tr()),
          findsOneWidget);
    });

    testWidgets('displays correct icon and text for difficulty 3',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Difficulty(difficulty: 8),
        ),
      ));

      expect(find.text(LocaleKeys.hike_details_difficulty_steps_difficult.tr()),
          findsOneWidget);
    });

    testWidgets('displays default values when difficulty is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Difficulty(difficulty: null),
        ),
      ));

      expect(find.text(LocaleKeys.hike_details_unknown.tr()), findsOneWidget);
    });
  });
}
