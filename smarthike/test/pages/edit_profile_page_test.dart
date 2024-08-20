import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';
import 'package:smarthike/models/user.dart';
import 'package:smarthike/pages/edit_profile_page.dart';
import 'package:smarthike/providers/auth_provider.dart';

import 'profile_page_test.mocks.dart';

@GenerateMocks([AuthProvider])
void main() async {
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();
  late MockAuthProvider mockAuthProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
  });

  Widget makeTestableWidget({required Widget child}) {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('fr'), Locale('es')],
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

  testWidgets('EditProfilePage shows user info in form fields',
      (WidgetTester tester) async {
    final user = User(
        id: 1,
        firstname: 'John',
        lastname: 'Doe',
        email: 'john.doe@example.com');

    when(mockAuthProvider.user).thenReturn(user);

    await tester.pumpWidget(makeTestableWidget(child: EditProfilePage()));

    expect(find.text('John'), findsOneWidget);
    expect(find.text('Doe'), findsOneWidget);
    expect(find.text('john.doe@example.com'), findsOneWidget);
  });

  testWidgets('EditProfilePage updates user info on save',
      (WidgetTester tester) async {
    final user = User(
        id: 1,
        firstname: 'John',
        lastname: 'Doe',
        email: 'john.doe@example.com');

    when(mockAuthProvider.user).thenReturn(user);
    when(mockAuthProvider.updateUser(any)).thenAnswer((_) async {});

    await tester.pumpWidget(makeTestableWidget(child: EditProfilePage()));

    await tester.enterText(find.byType(TextFormField).at(0), 'Jane');
    await tester.enterText(find.byType(TextFormField).at(1), 'Doe');
    await tester.enterText(
        find.byType(TextFormField).at(2), 'jane.doe@example.com');

    await tester.tap(find.text(LocaleKeys.register_form_form_save.tr()));
    await tester.pumpAndSettle();

    verify(mockAuthProvider.updateUser(any)).called(1);
  });
}
