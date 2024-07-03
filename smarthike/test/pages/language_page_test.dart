import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthike/pages/settings/language_page.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('LanguagePage displays language buttons',
      (WidgetTester tester) async {
    await EasyLocalization.ensureInitialized();
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('fr'), Locale('es')],
        path: 'assets/locales',
        fallbackLocale: const Locale('en'),
        child: const MaterialApp(
          home: LanguagePage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('french_button')), findsOneWidget);
    expect(find.text('Français'), findsOneWidget);

    expect(find.byKey(const Key('english_button')), findsOneWidget);
    expect(find.text('English'), findsOneWidget);

    expect(find.byKey(const Key('spanish_button')), findsOneWidget);
    expect(find.text('Español'), findsOneWidget);
  });

  testWidgets('LanguagePage changes language on button press',
      (WidgetTester tester) async {
    await EasyLocalization.ensureInitialized();
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('fr'), Locale('es')],
        path: 'assets/locales',
        fallbackLocale: const Locale('en'),
        child: const MaterialApp(
          home: LanguagePage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('french_button')));
    await tester.pumpAndSettle();

    expect(
        EasyLocalization.of(tester.element(find.byType(LanguagePage)))
            ?.locale
            .languageCode,
        'fr');
  });
}
