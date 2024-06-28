import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthike/models/user.dart';
import 'package:smarthike/pages/profile_page.dart';
import 'package:smarthike/providers/user_provider.dart';

import '../components/register_form_test.mocks.dart';

@GenerateMocks([UserProvider])
void main() async {
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();
  late MockUserProvider userProvider;

  setUp(() {
    userProvider = MockUserProvider();
  });

  Widget makeTestableWidget({required Widget child}) {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('fr')],
      fallbackLocale: const Locale('en'),
      path: 'assets/locales',
      child: MaterialApp(
        home: ChangeNotifierProvider<UserProvider>(
          create: (_) => userProvider,
          child: child,
        ),
      ),
    );
  }

  testWidgets('ProfilePage shows user info when logged in',
      (WidgetTester tester) async {
    final user = User(
        id: 1,
        firstname: 'John',
        lastname: 'Doe',
        email: 'john.doe@example.com');

    when(userProvider.user).thenReturn(user);

    await tester.pumpWidget(makeTestableWidget(child: const ProfilePage()));

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.byType(LoginOrSignupPage), findsNothing);
  });

  testWidgets('ProfilePage shows login page when not logged in',
      (WidgetTester tester) async {
    when(userProvider.user).thenReturn(null);
    await tester.pumpWidget(makeTestableWidget(child: const ProfilePage()));

    expect(find.byType(LoginOrSignupPage), findsOneWidget);
  });
}
