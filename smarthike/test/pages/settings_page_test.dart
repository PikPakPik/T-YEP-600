import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';
import 'package:smarthike/pages/settings_page.dart';
import 'package:smarthike/providers/auth_provider.dart';

@GenerateMocks([AuthProvider])
import 'settings_page_test.mocks.dart';

void main() async {
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();
  late MockAuthProvider authProvider;

  setUp(() {
    authProvider = MockAuthProvider();
  });

  Widget makeTestableWidget({required Widget child}) {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('fr'), Locale('es')],
      fallbackLocale: const Locale('en'),
      path: 'assets/locales',
      child: MaterialApp(
        home: ChangeNotifierProvider<AuthProvider>(
          create: (_) => authProvider,
          child: child,
        ),
      ),
    );
  }

  testWidgets('SettingsPage displays buttons with correct text',
      (WidgetTester tester) async {
    when(authProvider.user).thenReturn(null);

    await EasyLocalization.ensureInitialized();
    await tester.pumpWidget(
      makeTestableWidget(
        child: SettingsPage(
          onLanguageButtonPressed: () {},
          onSecurityButtonPressed: () {},
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('language_button')), findsOneWidget);
    expect(find.text(LocaleKeys.settings_modify_language.tr()), findsOneWidget);

    expect(find.byKey(const Key('appearance_button')), findsOneWidget);
    expect(
        find.text(LocaleKeys.settings_modify_appearance.tr()), findsOneWidget);
  });
}
