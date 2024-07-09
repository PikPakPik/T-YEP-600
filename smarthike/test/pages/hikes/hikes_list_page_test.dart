import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  // testWidgets('HikeListPage displays hike details correctly', (WidgetTester tester) async {
  //   await EasyLocalization.ensureInitialized();

  //   await tester.pumpWidget(
  //     EasyLocalization(
  //       supportedLocales: const [Locale('en'), Locale('fr'), Locale('es')],
  //       path: 'assets/locales',
  //       fallbackLocale: const Locale('en'),
  //       child: const MaterialApp(
  //         home: HikeListPage(),
  //       ),
  //     ),
  //   );

  //   // Wait for the widget to build
  //   await tester.pumpAndSettle();

  //   // Check that the first hike details are displayed correctly
  //   expect(find.text('Trail A'), findsOneWidget);
  //   expect(find.text('10.2 km'), findsOneWidget);
  //   expect(find.text('+980 m'), findsOneWidget);
  //   expect(find.text('1360.0 m'), findsOneWidget);
  //   expect(find.text('380.0 m'), findsOneWidget);
  //   expect(find.text(LocaleKeys.hike_details_difficulty_easy.tr()), findsOneWidget);
  //   expect(find.text('3 h'), findsOneWidget);
  // });
}
