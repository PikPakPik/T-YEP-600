import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthike/components/hike/details_card.dart';
import 'package:smarthike/components/hike/difficulty.dart';
import 'package:smarthike/models/hike.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();

  group('DetailsCard Widget Tests', () {
    final Hike testHike = Hike(
      id: 1,
      osmId: 123,
      name: 'Test Hike',
      firstNodeLat: '45.521563',
      firstNodeLon: '45.521563',
      lastNodeLat: '45.521563',
      lastNodeLon: '45.521563',
      distance: 10,
      maxAlt: 1500,
      minAlt: 200,
      elevationGain: 1300,
      hikingTime: 5,
      difficulty: 2,
    );

    testWidgets('DetailsCard shows correct text when showStats is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EasyLocalization(
              supportedLocales: const [Locale('en')],
              path: 'resources/langs',
              fallbackLocale: Locale('en'),
              child: DetailsCard(hike: testHike, showStats: true),
            ),
          ),
        ),
      );

      expect(find.text('10.0 km'), findsOneWidget);
      expect(find.text('1500.0 m'), findsOneWidget);
      expect(find.text('5 h'), findsOneWidget);
      expect(find.text('1300.0'), findsOneWidget);
      expect(find.byType(Difficulty), findsOneWidget);
    });

    testWidgets('DetailsCard does not show stats when showStats is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EasyLocalization(
              supportedLocales: const [Locale('en')],
              path: 'resources/langs',
              fallbackLocale: Locale('en'),
              child: DetailsCard(hike: testHike, showStats: false),
            ),
          ),
        ),
      );

      expect(find.text('10 km'), findsNothing);
      expect(find.text('1500 m'), findsNothing);
      expect(find.text('5 h'), findsNothing);
      expect(find.text('1300'), findsNothing);
      expect(find.byType(Difficulty), findsNothing);
    });
  });
}
