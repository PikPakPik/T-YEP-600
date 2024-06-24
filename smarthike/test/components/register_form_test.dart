import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/components/button.dart';
import 'package:smarthike/components/auth/register_form.dart';
import 'package:smarthike/providers/user_provider.dart';
import 'package:mockito/mockito.dart';

import 'register_form_test.mocks.dart';

@GenerateMocks([UserProvider])
void main() {
  group('RegisterForm Tests', () {
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

    testWidgets('prénom vide affiche un message d\'erreur',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(child: RegisterForm()));
      await tester.enterText(
          find.byKey(const Key('firstname_register_field')), '');
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CustomButton));
      await tester.pumpAndSettle();

      expect(find.text('Veuillez entrer votre prénom'), findsOneWidget);
    });

    testWidgets('email invalide affiche un message d\'erreur',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(child: RegisterForm()));
      await tester.enterText(
          find.byKey(const Key('email_register_field')), 'email');
      await tester.pumpAndSettle();

      expect(find.text('Email invalide'), findsOneWidget);
    });

    testWidgets('mots de passe non correspondants affiche un message d\'erreur',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(child: RegisterForm()));
      await tester.enterText(
          find.byKey(const Key('password_register_field')), 'password123');
      await tester.enterText(
          find.byKey(const Key('confirm_password_register_field')),
          'password321');
      await tester.pumpAndSettle();

      expect(
          find.text('Les mots de passe ne correspondent pas'), findsOneWidget);
    });

    testWidgets('validation de mot de passe complexe',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(child: RegisterForm()));
      await tester.enterText(
          find.byKey(const Key('password_register_field')), 'pass');
      await tester.pumpAndSettle();

      expect(
          find.text(
              'Le mot de passe doit contenir au moins 8 caractères, \ndont des chiffres, des lettres majuscules et minuscules, \net des symboles spéciaux'),
          findsOneWidget);
    });

    testWidgets('inscription réussie avec données valides',
        (WidgetTester tester) async {
      when(mockUserProvider.register(any, any, any, any))
          .thenAnswer((_) async => Future.value());

      await tester.pumpWidget(makeTestableWidget(child: RegisterForm()));
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
      await tester.tap(find.byType(CustomButton));
      await tester.pumpAndSettle();

      verify(mockUserProvider.register(
              'John', 'Doe', 'test@example.com', 'Password@123'))
          .called(1);
    });
  });
}
