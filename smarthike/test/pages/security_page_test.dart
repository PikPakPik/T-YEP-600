import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';
import 'package:smarthike/pages/settings/security_page.dart';

import 'security_page_test.mocks.dart';

abstract class OnDataReadComplete {
  void call();
}

@GenerateMocks([OnDataReadComplete])
void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();

  late MockOnDataReadComplete onDeleteAccountPressed;

  setUp(() {
    onDeleteAccountPressed = MockOnDataReadComplete();
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

  testWidgets('SecurityPage displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: SecurityPage(
          onDeleteAccountPressed: onDeleteAccountPressed.call,
          onEditProfilePressed: () {},
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify the logo is displayed
    expect(find.byType(Image), findsOneWidget);

    // Verify the buttons are displayed
    expect(find.text(LocaleKeys.settings_change_password.tr()), findsOneWidget);
    expect(find.text(LocaleKeys.settings_two_factor_auth.tr()), findsOneWidget);
    expect(find.text(LocaleKeys.settings_delete_account.tr()), findsOneWidget);
  });

  testWidgets('SecurityPage delete account button triggers callback',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: SecurityPage(
          onDeleteAccountPressed: onDeleteAccountPressed.call,
          onEditProfilePressed: () {},
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Tap the delete account button
    await tester.tap(find.text(LocaleKeys.settings_delete_account.tr()));
    await tester.pumpAndSettle();

    // Verify the callback is triggered
    verify(onDeleteAccountPressed()).called(1);
  });
}
