import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthike/components/hike/details_card.dart';
import 'package:smarthike/components/hike/difficulty.dart';
import 'package:smarthike/models/hike.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();

  group('DetailsCard Widget Tests', () {
    final Hike testHike = Hike(
      id: 1,
      osmId: BigInt.from(123).toInt(),
      name: 'Test Hike',
      firstNodeLat: '45.521563',
      firstNodeLon: '45.521563',
      lastNodeLat: '45.521563',
      lastNodeLon: '45.521563',
      distance: 10.0,
      positiveAltitude: '1500',
      negativeAltitude: '200',
      hikingTime: 60,
      difficulty: 2,
    );

    Widget createWidgetForTesting({required Widget child}) {
      return MaterialApp(
        home: Scaffold(
          body: EasyLocalization(
            supportedLocales: const [Locale('en')],
            path: 'assets/locales',
            fallbackLocale: Locale('en'),
            child: child,
          ),
        ),
      );
    }

    testWidgets('DetailsCard shows correct text when showStats is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting(
        child: DetailsCard(hike: testHike, showStats: true),
      ));

      await tester.pumpAndSettle();

      // Vérifier la présence de la distance
      expect(
          find.byWidgetPredicate(
              (widget) => widget is Text && widget.data == '10.0 km'),
          findsOneWidget);

      // Vérifier la présence de l'altitude
      expect(
          find.byWidgetPredicate(
              (widget) => widget is Text && widget.data == '1500 m'),
          findsOneWidget);

      // Vérifier la présence du temps de randonnée
      expect(
          find.byWidgetPredicate(
              (widget) => widget is Text && widget.data == '0h 1m'),
          findsOneWidget);

      expect(find.byType(Difficulty), findsOneWidget);
    });

    testWidgets('DetailsCard does not show stats when showStats is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting(
        child: DetailsCard(hike: testHike, showStats: false),
      ));

      await tester.pumpAndSettle();

      expect(find.text('10.0 km'), findsNothing);
      expect(find.text('1500 m'), findsNothing);
      expect(find.text('0h 1m'), findsNothing);
      expect(find.byType(Difficulty), findsNothing);
    });
  });
}
