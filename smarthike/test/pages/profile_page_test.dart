import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthike/api/smarthike_api.dart';
import 'package:smarthike/models/user.dart';
import 'package:smarthike/pages/profile_page.dart';
import 'package:smarthike/providers/user_provider.dart';

import 'profile_page_test.mocks.dart';

@GenerateMocks([UserProvider, ApiService])
void main() async {
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();
  late MockUserProvider userProvider;
  late MockApiService apiService;

  setUp(() {
    userProvider = MockUserProvider();
    apiService = MockApiService();
  });

  Widget makeTestableWidget({required Widget child}) {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('fr'), Locale('es')],
      fallbackLocale: const Locale('en'),
      path: 'assets/locales',
      child: MultiProvider(
        providers: [
          Provider<ApiService>(create: (_) => apiService),
          ChangeNotifierProvider<UserProvider>(create: (_) => userProvider),
        ],
        child: MaterialApp(
          home: child,
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
    when(apiService.get("/hike/favorites")).thenAnswer((_) async => {
          "items": [
            {"id": 1, "name": "Hike 1", "osmId" : 1},
            {"id": 2, "name": "Hike 2", "osmId" : 2}
          ]
        });

    await tester.pumpWidget(makeTestableWidget(
        child: ProfilePage(
      onRegisterButtonPressed: () {},
      onSignInButtonPressed: () {},
    )));

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.byType(LoginOrSignupPage), findsNothing);
  });

  testWidgets('ProfilePage shows login page when not logged in',
      (WidgetTester tester) async {
    when(userProvider.user).thenReturn(null);
    when(apiService.get("/hike/favorites")).thenAnswer((_) async => {
          "items": [
            {"id": 1, "name": "Hike 1", "osmId" : 1},
            {"id": 2, "name": "Hike 2", "osmId" : 2}
          ]
        });
    await tester.pumpWidget(makeTestableWidget(
        child: ProfilePage(
      onRegisterButtonPressed: () {},
      onSignInButtonPressed: () {},
    )));

    expect(find.byType(LoginOrSignupPage), findsOneWidget);
  });
}
