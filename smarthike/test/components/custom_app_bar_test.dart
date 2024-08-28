import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthike/components/hike/custom_app_bar.dart';
import 'package:smarthike/providers/filter_provider.dart';

void main() {
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
      child: ChangeNotifierProvider<FilterProvider>(
        create: (_) => FilterProvider(),
        child: MaterialApp(
          home: Scaffold(
            body: child,
          ),
        ),
      ),
    );
  }

  testWidgets('CustomAppBar displays correctly for filter page',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: CustomAppBar(
        isFilterPage: true,
        hasActiveFilters: false,
        onBackPressed: () {},
      ),
    ));

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.tune), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });

  testWidgets('CustomAppBar displays correctly for hike list page',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: CustomAppBar(
        isHikeListPage: true,
        hasActiveFilters: false,
        isFilterPage: false,
        onBackPressed: () {},
      ),
    ));

    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.tune), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });

  testWidgets('CustomAppBar back button navigates correctly',
      (WidgetTester tester) async {
    bool backButtonPressed = false;

    await tester.pumpWidget(createWidgetForTesting(
      child: CustomAppBar(
        isFilterPage: true,
        hasActiveFilters: false,
        onBackPressed: () {
          backButtonPressed = true;
        },
      ),
    ));

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(backButtonPressed, isTrue);
  });
}
