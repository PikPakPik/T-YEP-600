import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smarthike/components/dynamic_range_slider.dart';

void main() {
  // Création d'un widget pour les tests
  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  testWidgets('DynamicRangeSlider displays correctly',
      (WidgetTester tester) async {
    // Définir les valeurs initiales de la plage
    const RangeValues currentRangeValues = RangeValues(10, 50);
    const double min = 0;
    const double max = 100;

    // Créer le widget DynamicRangeSlider pour les tests
    await tester.pumpWidget(createWidgetForTesting(
      child: DynamicRangeSlider(
        label: 'Test Slider',
        currentRangeValues: currentRangeValues,
        min: min,
        max: max,
        onChanged: (RangeValues values) {},
      ),
    ));

    // Vérifier que le texte du label est affiché
    expect(find.text('Test Slider'), findsOneWidget);

    // Vérifier que les valeurs de la plage sont affichées correctement
    expect(find.text('10 - 50'), findsOneWidget);

    // Vérifier que les valeurs min et max sont affichées
    expect(find.text('min: 0'), findsOneWidget);
    expect(find.text('max: 100'), findsOneWidget);
  });

  testWidgets('DynamicRangeSlider changes values when dragged',
      (WidgetTester tester) async {
    RangeValues rangeValues = const RangeValues(10, 50);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DynamicRangeSlider(
                label: 'Test Slider',
                currentRangeValues: rangeValues,
                min: 0,
                max: 100,
                onChanged: (RangeValues values) {
                  setState(() {
                    rangeValues = values;
                  });
                },
              );
            },
          ),
        ),
      ),
    );

    // Vérifier que les valeurs initiales de la plage sont correctes
    expect(find.text('10 - 50'), findsOneWidget);

    // Trouver le RangeSlider
    final Finder slider = find.byType(RangeSlider);
    expect(slider, findsOneWidget);

    final RangeSlider sliderWidget = tester.widget<RangeSlider>(slider);
    final double startPosition = tester.getTopLeft(slider).dx +
        (sliderWidget.values.start / sliderWidget.max) *
            tester.getSize(slider).width;

    // Faire glisser le curseur de départ
    await tester.dragFrom(Offset(startPosition, tester.getTopLeft(slider).dy),
        const Offset(20, 0));
    await tester.pumpAndSettle();

    // Vérifier que les valeurs de la plage ont changé
    final Finder updatedValueFinder = find.byWidgetPredicate((Widget widget) =>
        widget is Text &&
        widget.data!.contains(' - ') &&
        widget.data != '10 - 50');

    expect(updatedValueFinder, findsOneWidget,
        reason: 'Updated value text should be found');

    final String newValueText =
        (updatedValueFinder.evaluate().first.widget as Text).data!;
    final List<String> newValues = newValueText.split(' - ');

    expect(int.parse(newValues[0]) != 10, isTrue,
        reason: 'Start value should have changed');
    expect(int.parse(newValues[1]) == 50, isTrue,
        reason: 'End value should remain the same');
  });
}
