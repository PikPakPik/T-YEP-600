import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smarthike/components/hike/details_card.dart';
import 'package:smarthike/components/hike/horizontal_card.dart';
import 'package:smarthike/models/hike.dart';
import 'package:smarthike/models/fav_hike.dart';

void main() {
  group('HorizontalCard Tests', () {
    testWidgets('Displays correct image and name for Hike object',
        (WidgetTester tester) async {
      final Hike testHike = Hike(
          id: 1,
          osmId: 123,
          name: 'Mountain Trail',
          files: [],
          firstNodeLat: '45.521563',
          firstNodeLon: '45.521563',
          lastNodeLat: '45.521563',
          lastNodeLon: '45.521563');
      await tester
          .pumpWidget(MaterialApp(home: HorizontalCard(hike: testHike)));

      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Mountain Trail'), findsOneWidget);
      expect(find.byType(DetailsCard), findsOneWidget);
    });

    testWidgets(
        'Displays fallback image and name for HikeFav object when imageUrl is empty',
        (WidgetTester tester) async {
      final HikeFav testHikeFav = HikeFav(id: 1, osmId: 123, name: 'Lake View');
      await tester
          .pumpWidget(MaterialApp(home: HorizontalCard(hike: testHikeFav)));

      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Lake View'), findsOneWidget);
      expect(find.byType(DetailsCard), findsNothing);
    });
  });
}
