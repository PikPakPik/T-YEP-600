import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthike/components/hike/custom_app_bar.dart';

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
      child: MaterialApp(
        home: Scaffold(
          body: child,
        ),
      ),
    );
  }

  testWidgets('CustomAppBar displays correctly for filter page',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
        child: CustomAppBar(
      isFilterPage: true,
    )));

    expect(find.text('All hikes'), findsOneWidget);
    expect(find.byIcon(Icons.tune), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });

  testWidgets('CustomAppBar displays correctly for hike list page',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
        child: CustomAppBar(
      isHikeListPage: true,
    )));

    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.tune), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });

  testWidgets('CustomAppBar back button navigates correctly',
      (WidgetTester tester) async {
    final navKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(MaterialApp(
      navigatorKey: navKey,
      home: Scaffold(
        appBar: CustomAppBar(
          isFilterPage: true,
        ),
      ),
    ));

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(navKey.currentState?.canPop(), false);
  });
}
