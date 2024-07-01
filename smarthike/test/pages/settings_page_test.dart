import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthike/pages/settings_page.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });
  testWidgets('SettingsPage displays buttons with correct text',
      (WidgetTester tester) async {
    await EasyLocalization.ensureInitialized();
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('fr'), Locale('es')],
        path: 'assets/locales',
        fallbackLocale: const Locale('en'),
        child: MaterialApp(
          home: SettingsPage(
            onLanguageButtonPressed: () {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('language_button')), findsOneWidget);
    expect(find.text(LocaleKeys.settings_modify_language.tr()), findsOneWidget);

    expect(find.byKey(const Key('appearance_button')), findsOneWidget);
    expect(
        find.text(LocaleKeys.settings_modify_appearance.tr()), findsOneWidget);

    expect(find.byKey(const Key('security_button')), findsOneWidget);
    expect(
        find.text(LocaleKeys.settings_privacy_security.tr()), findsOneWidget);
  });
}
