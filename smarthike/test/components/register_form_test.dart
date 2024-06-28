import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthike/components/auth/register_form.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';
import 'package:smarthike/providers/user_provider.dart';

import 'register_form_test.mocks.dart';

@GenerateMocks([UserProvider])
void main() async {
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();
  group('RegisterForm Tests', () {
    late MockUserProvider mockUserProvider;

    setUp(() {
      mockUserProvider = MockUserProvider();
    });

    Widget makeTestableWidget({required Widget child}) {
      return EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('fr')],
        fallbackLocale: const Locale('en'),
        path: 'assets/locales',
        child: MaterialApp(
          home: ChangeNotifierProvider<UserProvider>(
            create: (_) => mockUserProvider,
            child: child,
          ),
        ),
      );
    }

    testWidgets('empty first name shows error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(child: const RegisterForm()));
      await tester.enterText(
          find.byKey(const Key('firstname_register_field')), '');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('next_button')));
      await tester.pumpAndSettle();

      expect(find.text(LocaleKeys.register_form_error_firstname_required.tr()),
          findsOneWidget);
    });

    testWidgets('invalid email shows error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(child: const RegisterForm()));
      await tester.enterText(
          find.byKey(const Key('email_register_field')), 'email');
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key('next_button')));
      await tester.tap(find.byKey(const Key('next_button')));
      await tester.pumpAndSettle();

      expect(find.text(LocaleKeys.register_form_error_email_invalid.tr()),
          findsOneWidget);
    });

    testWidgets('non-matching passwords show error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(child: const RegisterForm()));
      await tester.enterText(
          find.byKey(const Key('password_register_field')), 'password123');
      await tester.enterText(
          find.byKey(const Key('confirm_password_register_field')),
          'password321');
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key('next_button')));
      await tester.tap(find.byKey(const Key('next_button')));
      await tester.pumpAndSettle();

      expect(
          find.text(LocaleKeys.register_form_error_passwords_do_not_match.tr()),
          findsOneWidget);
    });

    testWidgets('password validation', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(child: const RegisterForm()));
      await tester.enterText(
          find.byKey(const Key('password_register_field')), 'pass');
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key('next_button')));
      await tester.tap(find.byKey(const Key('next_button')));
      await tester.pumpAndSettle();

      expect(find.text(LocaleKeys.register_form_error_password_invalid.tr()),
          findsOneWidget);
    });

    testWidgets('successful registration with valid data',
        (WidgetTester tester) async {
      when(mockUserProvider.register(any, any, any, any))
          .thenAnswer((_) async => Future.value());

      await tester.pumpWidget(makeTestableWidget(child: const RegisterForm()));
      await tester.pumpAndSettle();

      // Check that widgets are present
      expect(find.byKey(const Key('firstname_register_field')), findsOneWidget);
      expect(find.byKey(const Key('lastname_register_field')), findsOneWidget);
      expect(find.byKey(const Key('email_register_field')), findsOneWidget);
      expect(find.byKey(const Key('password_register_field')), findsOneWidget);
      expect(find.byKey(const Key('confirm_password_register_field')),
          findsOneWidget);

      await tester.enterText(
          find.byKey(const Key('firstname_register_field')), 'John');
      await tester.enterText(
          find.byKey(const Key('lastname_register_field')), 'Doe');
      await tester.enterText(
          find.byKey(const Key('email_register_field')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('password_register_field')), 'Password@123');
      await tester.enterText(
          find.byKey(const Key('confirm_password_register_field')),
          'Password@123');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('next_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('age_register_field')), findsOneWidget);
      await tester.enterText(find.byKey(const Key('age_register_field')), '25');

      await tester.tap(find.byKey(const Key('register_button')));
      await tester.pumpAndSettle();

      verify(mockUserProvider.register(
              argThat(contains('John')),
              argThat(contains('Doe')),
              argThat(contains('test@example.com')),
              argThat(contains('Password@123'))))
          .called(1);
    });
  });
}
