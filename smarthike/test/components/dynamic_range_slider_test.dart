import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smarthike/components/dynamic_range_slider.dart';

void main() {
  testWidgets('DynamicRangeSlider changes values when dragged',
      (WidgetTester tester) async {
    RangeValues rangeValues = const RangeValues(0, 100);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Material(
                child: Center(
                  child: SizedBox(
                    width: 400, // Increased width
                    child: DynamicRangeSlider(
                      label: 'Test Slider',
                      currentRangeValues: rangeValues,
                      min: 0,
                      max: 100,
                      onChanged: (RangeValues values) {
                        setState(() {
                          rangeValues = values;
                        });
                      },
                      divisions: 100,
                      initialRangeValues: rangeValues,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final Finder sliderFinder = find.byType(RangeSlider);
    expect(sliderFinder, findsOneWidget);

    // Simuler un glissement du curseur de début
    final Offset topLeft = tester.getTopLeft(sliderFinder);
    final Offset bottomRight = tester.getBottomRight(sliderFinder);
    final double sliderWidth = bottomRight.dx - topLeft.dx;
    final double dragDistance = sliderWidth / 2;

    await tester.dragFrom(topLeft, Offset(dragDistance, 0));
    await tester.pumpAndSettle();

    // Vérifier que la valeur de début a augmenté
    expect(rangeValues.start, greaterThan(0));
    expect(rangeValues.end, equals(100));

    print('New range values: ${rangeValues.start} - ${rangeValues.end}');
  });
}
