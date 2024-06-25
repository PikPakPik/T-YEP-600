import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/components/button.dart';
import 'package:smarthike/components/auth/login_form.dart';
import 'package:smarthike/providers/user_provider.dart';
import 'package:mockito/mockito.dart';

import 'register_form_test.mocks.dart';

@GenerateMocks([UserProvider])
void main() {
  group('LoginForm Tests', () {
    late MockUserProvider mockUserProvider;

    setUp(() {
      mockUserProvider = MockUserProvider();
    });

    Widget makeTestableWidget({required Widget child}) {
      return MaterialApp(
        home: ChangeNotifierProvider<UserProvider>(
          create: (_) => mockUserProvider,
          child: child,
        ),
      );
    }

    testWidgets('email invalide affiche un message d\'erreur',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(child: const LoginForm()));
      await tester.enterText(
          find.byKey(const Key('email_login_field')), 'email');
      await tester.pumpAndSettle();

      expect(find.text('Email invalide'), findsOneWidget);
    });

    testWidgets('mot de passe vide affiche un message d\'erreur',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(child: const LoginForm()));
      await tester.enterText(
          find.byKey(const Key('password_login_field')), ' ');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('password_login_field')), '');
      await tester.pumpAndSettle();

      expect(find.text('Veuillez entrer votre mot de passe'), findsOneWidget);
    });

    testWidgets('connexion réussie avec email et mot de passe valides',
        (WidgetTester tester) async {
      when(mockUserProvider.login(any, any)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(child: const LoginForm()));
      await tester.enterText(
          find.byKey(const Key('email_login_field')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('password_login_field')), 'password123');
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CustomButton));
      await tester.pumpAndSettle();

      verify(mockUserProvider.login('test@example.com', 'password123'))
          .called(1);
    });
  });
}
