import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthike/api/smarthike_api.dart';
import 'package:smarthike/main.dart';
import 'package:smarthike/services/auth_service.dart';
import 'package:smarthike/utils/shared_preferences_util.dart';

void main() {
  testWidgets('NavigationBarApp has 3 navigation destinations',
      (WidgetTester tester) async {
    await dotenv.load();
    SharedPreferences.setMockInitialValues({});

    await EasyLocalization.ensureInitialized();

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('fr')],
        path: 'assets/locales',
        fallbackLocale: const Locale('en'),
        child: MultiProvider(
          providers: [
            Provider<AuthService>(
                create: (_) => AuthService(
                    apiService: ApiService(token: ''),
                    sharedPreferencesUtil: SharedPreferencesUtil.instance)),
            Provider<ApiService>(create: (_) => ApiService(token: '')),
          ],
          child: const SmartHikeApp(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.person_outline), findsOneWidget);
  });
}
