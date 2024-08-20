import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthike/pages/settings/subpages/delete_account_warning_page.dart';
import 'package:smarthike/providers/auth_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';
import 'package:smarthike/services/auth_service.dart';

import '../providers/user_providers_test.mocks.dart';

@GenerateMocks([AuthService])
void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();

  late MockAuthService authService;

  setUp(() {
    authService = MockAuthService();
  });

  Widget makeTestableWidget({required Widget child}) {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('fr'), Locale('es')],
      fallbackLocale: const Locale('en'),
      path: 'assets/locales',
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('DeleteAccountWarningPage displays correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: ChangeNotifierProvider(
          create: (_) => AuthProvider(authService: authService),
          child: const MaterialApp(
            home: DeleteAccountWarningPage(),
          ),
        ),
      ),
    );

    // Verify the logo is displayed
    expect(find.byType(Image), findsOneWidget);

    // Verify the warning message is displayed
    expect(find.text(LocaleKeys.settings_delete_account_warning_message.tr()),
        findsOneWidget);

    // Verify the expansion panels are displayed
    expect(find.byType(ExpansionPanelList), findsOneWidget);

    // Verify the delete account button is displayed
    expect(find.text(LocaleKeys.settings_delete_account_confirm_button.tr()),
        findsOneWidget);
  });

  testWidgets('DeleteAccountWarningPage shows confirmation bottom sheet',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authService: authService,
          ),
          child: const MaterialApp(
            home: DeleteAccountWarningPage(),
          ),
        ),
      ),
    );

    // Tap the delete account button
    await tester
        .tap(find.text(LocaleKeys.settings_delete_account_confirm_button.tr()));
    await tester.pumpAndSettle();

    // Verify the bottom sheet is displayed
    expect(
        find.text(LocaleKeys.settings_delete_account_confirmation_message.tr()),
        findsOneWidget);
  });
}
