import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthike/pages/hike/filter_page.dart';
import 'package:smarthike/components/hike/custom_app_bar.dart';
import 'package:smarthike/components/dynamic_range_slider.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';

void main() {
  // Configuration de EasyLocalization et SharedPreferences pour les tests
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  Widget createWidgetForTesting({required Widget child}) {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('es'), Locale('fr')],
      path: 'assets/locales',
      fallbackLocale: Locale('en'),
      child: MaterialApp(
        home: Scaffold(
          body: child,
        ),
      ),
    );
  }

  testWidgets('FilterPage displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: FilterPage()));

    // Vérifie que le CustomAppBar est affiché
    expect(find.byType(CustomAppBar), findsOneWidget);
    expect(find.text(tr(LocaleKeys.hike_all_hikes)), findsOneWidget);

    // Vérifie que les sliders sont affichés
    expect(find.text(tr(LocaleKeys.filter_distance)), findsOneWidget);
    expect(find.text(tr(LocaleKeys.filter_time)), findsOneWidget);

    // Vérifie que le dropdown est affiché
    expect(
        find.widgetWithText(DropdownButtonFormField<String>,
            tr(LocaleKeys.filter_difficulty_levels_difficulty)),
        findsOneWidget);

    // Vérifie que le champ de texte est affiché
    final locationTextField = find.byKey(Key('locationField'));
    expect(locationTextField, findsOneWidget);

    // Vérifie que le bouton "Appliquer les filtres" est affiché
    expect(find.text(tr(LocaleKeys.filter_apply_filters)), findsOneWidget);
  });

  testWidgets('FilterPage sliders work correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: FilterPage()));

    // Vérifie que les sliders peuvent être déplacés
    expect(find.byType(DynamicRangeSlider), findsNWidgets(2));

    final distanceSlider = find.byWidgetPredicate(
      (widget) =>
          widget is DynamicRangeSlider &&
          widget.label == tr(LocaleKeys.filter_distance),
    );

    final timeSlider = find.byWidgetPredicate(
      (widget) =>
          widget is DynamicRangeSlider &&
          widget.label == tr(LocaleKeys.filter_time),
    );

    expect(distanceSlider, findsOneWidget);
    expect(timeSlider, findsOneWidget);

    // Interagir avec le slider de distance
    await tester.drag(distanceSlider, Offset(100, 0));
    await tester.pump();

    // Interagir avec le slider de temps
    await tester.drag(timeSlider, Offset(100, 0));
    await tester.pump();
  });

  testWidgets('FilterPage dropdown works correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: FilterPage()));

    // Vérifie que le dropdown est affiché et peut être interagi
    final difficultyDropdown = find.byType(DropdownButtonFormField<String>);
    expect(difficultyDropdown, findsOneWidget);

    await tester.tap(difficultyDropdown);
    await tester.pumpAndSettle();

    expect(find.text(tr(LocaleKeys.filter_difficulty_levels_easy)),
        findsOneWidget);
    expect(find.text(tr(LocaleKeys.filter_difficulty_levels_medium)),
        findsOneWidget);
    expect(find.text(tr(LocaleKeys.filter_difficulty_levels_difficult)),
        findsOneWidget);

    await tester
        .tap(find.text(tr(LocaleKeys.filter_difficulty_levels_easy)).last);
    await tester.pumpAndSettle();

    expect(find.text(tr(LocaleKeys.filter_difficulty_levels_easy)),
        findsOneWidget);
  });

  testWidgets('FilterPage text field works correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: FilterPage()));

    // Trouver le TextField en utilisant la clé
    final locationTextField = find.byKey(Key('locationField'));
    expect(locationTextField, findsOneWidget);

    // Entrer du texte dans le TextField
    await tester.enterText(locationTextField, 'New Location');
    await tester.pump();

    // Vérifier que le texte a été saisi correctement en utilisant le widget EditableText
    final editableText = find.descendant(
      of: locationTextField,
      matching: find.byType(EditableText),
    );
    expect(editableText, findsOneWidget);
    expect(
        (editableText.evaluate().single.widget as EditableText).controller.text,
        'New Location');
  });

  testWidgets('FilterPage apply filters button works correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: FilterPage()));

    // Vérifie que le bouton "Appliquer les filtres" est affiché et peut être interagi
    final applyFiltersButton = find.text(tr(LocaleKeys.filter_apply_filters));
    expect(applyFiltersButton, findsOneWidget);

    // Faire défiler jusqu'au bouton "Appliquer les filtres" si nécessaire
    await tester.dragUntilVisible(
      applyFiltersButton, // Ce que nous cherchons
      find.byType(SingleChildScrollView), // Où nous cherchons
      const Offset(0, 50), // La quantité à faire défiler
    );

    // Interagir avec le bouton "Appliquer les filtres"
    await tester.tap(applyFiltersButton);
    await tester.pump();
  });
}
