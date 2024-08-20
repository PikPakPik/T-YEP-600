import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/components/button.dart';
import 'package:smarthike/components/auth/login_form.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';
import 'package:smarthike/providers/auth_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'register_form_test.mocks.dart';

@GenerateMocks([AuthProvider])
void main() async {
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();

  group('LoginForm Tests', () {
    late MockAuthProvider mockAuthProvider;

    setUp(() {
      mockAuthProvider = MockAuthProvider();
    });

    Widget makeTestableWidget({required Widget child}) {
      return EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('fr')],
        fallbackLocale: const Locale('en'),
        path: 'assets/locales',
        child: MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: child,
          ),
        ),
      );
    }

    testWidgets('invalid email shows an error message',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(makeTestableWidget(child: const LoginForm()));
        await tester.pumpAndSettle();
        await tester.enterText(
            find.byKey(const Key('email_login_field')), 'email');
        await tester.pumpAndSettle();
        expect(find.text(LocaleKeys.login_form_error_email_invalid.tr()),
            findsOneWidget);
      });
    });

    testWidgets('empty password shows an error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(child: const LoginForm()));
      await tester.enterText(
          find.byKey(const Key('password_login_field')), ' ');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('password_login_field')), '');
      await tester.pumpAndSettle();

      expect(find.text(LocaleKeys.login_form_error_password_required.tr()),
          findsOneWidget);
    });

    testWidgets('successful login with valid email and password',
        (WidgetTester tester) async {
      when(mockAuthProvider.login(any, any)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(child: const LoginForm()));
      await tester.enterText(
          find.byKey(const Key('email_login_field')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('password_login_field')), 'password123');
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CustomButton));
      await tester.pumpAndSettle();

      verify(mockAuthProvider.login('test@example.com', 'password123'))
          .called(1);
    });
  });
}
