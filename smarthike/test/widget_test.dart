import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthike/main.dart';

void main() {
  testWidgets('NavigationBarApp has 3 navigation destinations',
      (WidgetTester tester) async {
    await dotenv.load();
    SharedPreferences.setMockInitialValues({});

    await EasyLocalization.ensureInitialized();

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('fr')],
        path: 'assets/locales',
        fallbackLocale: const Locale('en'),
        child: const SmartHikeApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.person_outline), findsOneWidget);
  });
}
