import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smarthike/pages/map_page.dart';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/pages/auth/login_page.dart';
import 'package:smarthike/pages/auth/register_page.dart';
import 'package:smarthike/pages/profile_page.dart';
import 'package:smarthike/pages/settings/language_page.dart';
import 'package:smarthike/pages/settings/security_page.dart';
import 'package:smarthike/pages/settings/subpages/delete_account_warning_page.dart';
import 'package:smarthike/pages/settings_page.dart';
import 'package:smarthike/providers/user_provider.dart';
import 'package:smarthike/services/auth_service.dart';
import 'package:smarthike/utils/shared_preferences_util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: ".env");

  Provider.debugCheckInvalidValueType = null;

  final sharedPreferencesUtil = SharedPreferencesUtil.instance;
  String? lang = await sharedPreferencesUtil.getString('lang') ??
      Platform.localeName.split('_')[0];
  if (lang != 'fr' && lang != 'es') {
    lang = 'en';
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('fr'), Locale('es')],
      path: 'assets/locales',
      fallbackLocale: const Locale('en'),
      startLocale: Locale(lang),
      child: const SmartHikeApp(),
    ),
  );
}

const int homePageIndex = 0;
const int mapPageIndex = 1;
const int profilePageIndex = 2;
const int settingsPageIndex = 3;
const int languagePageIndex = 4;
const int registerPageIndex = 5;
const int signInPageIndex = 6;
const int securityPageIndex = 7;
const int deleteAccountPageIndex = 8;

class AppInitializer extends StatefulWidget {
  final Widget child;

  const AppInitializer({super.key, required this.child});

  @override
  AppInitializerState createState() => AppInitializerState();
}

class AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Provider.of<UserProvider>(context, listen: false).loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class SmartHikeApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final navBarKey = GlobalKey<_NavigationExampleState>();

  const SmartHikeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final easyLocalization = EasyLocalization.of(context);
    if (easyLocalization == null) {
      return const SizedBox.shrink();
    }

    final apiUrl = Platform.isAndroid
        ? dotenv.env['API_URL_ANDROID']!
        : dotenv.env['API_URL_OTHER']!;

    final dio = Dio(BaseOptions(
      baseUrl: "$apiUrl/api",
      headers: {
        HttpHeaders.userAgentHeader: 'dio',
        'common-header': 'xx',
        'Content-Type': 'application/json',
      },
    ));
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));

    final sharedPreferencesUtil = SharedPreferencesUtil.instance;
    final authService =
        AuthService(dio: dio, sharedPreferencesUtil: sharedPreferencesUtil);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserProvider(authService: authService)),
      ],
      child: AppInitializer(
        child: MaterialApp(
          builder: FToastBuilder(),
          supportedLocales: easyLocalization.supportedLocales,
          localizationsDelegates: easyLocalization.delegates,
          locale: easyLocalization.locale,
          navigatorKey: navigatorKey,
          theme: ThemeData(
            useMaterial3: true,
            textTheme: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme),
            primaryTextTheme:
                GoogleFonts.rubikTextTheme(Theme.of(context).primaryTextTheme),
          ),
          home: NavigationBarApp(key: navBarKey),
        ),
      ),
    );
  }
}

class NavigationBarApp extends StatefulWidget {
  const NavigationBarApp({super.key});

  @override
  State<NavigationBarApp> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationBarApp> {
  int currentPageIndex = 0;

  void _navigateToPage(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  void navigateToSpecificPage(int index) {
    _navigateToPage(index);
  }

  bool _isSubPageOf(int mainPageIndex) {
    return (mainPageIndex == settingsPageIndex &&
            (currentPageIndex == languagePageIndex ||
                currentPageIndex == securityPageIndex ||
                currentPageIndex == deleteAccountPageIndex)) ||
        (mainPageIndex == profilePageIndex &&
            (currentPageIndex == registerPageIndex ||
                currentPageIndex == signInPageIndex));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    int selectedIndex =
        _isSubPageOf(settingsPageIndex) || _isSubPageOf(profilePageIndex)
            ? (currentPageIndex == languagePageIndex ||
                    currentPageIndex == securityPageIndex ||
                    currentPageIndex == deleteAccountPageIndex)
                ? settingsPageIndex
                : profilePageIndex
            : currentPageIndex;

    if (selectedIndex >= 4) {
      selectedIndex = profilePageIndex;
    }

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _navigateToPage,
        indicatorColor: Constants.navBar,
        backgroundColor: Constants.navBar,
        surfaceTintColor: Constants.navBar,
        selectedIndex: selectedIndex,
        destinations: <Widget>[
          _buildNavItem(
              Icons.home_outlined, homePageIndex, Constants.primaryColor),
          _buildNavItem(
              Icons.map_outlined, mapPageIndex, Constants.fourthColor),
          _buildNavItem(
              Icons.person_outline, profilePageIndex, Constants.primaryColor),
          _buildNavItem(Icons.settings_outlined, settingsPageIndex,
              Constants.primaryColor),
        ],
      ),
      body: <Widget>[
        _buildPage('Home page', theme),
        const MapPage(),
        ProfilePage(
          onRegisterButtonPressed: () {
            _navigateToPage(registerPageIndex);
          },
          onSignInButtonPressed: () {
            _navigateToPage(signInPageIndex);
          },
        ),

        /// Settings page
        SettingsPage(
          onLanguageButtonPressed: () {
            _navigateToPage(languagePageIndex);
          },
          onSecurityButtonPressed: () {
            _navigateToPage(securityPageIndex);
          },
        ),
        const LanguagePage(),
        const RegisterPage(),
        const LoginPage(),
        SecurityPage(
          onDeleteAccountPressed: () {
            _navigateToPage(deleteAccountPageIndex);
          },
        ),
        const DeleteAccountWarningPage(),
      ][currentPageIndex],
    );
  }

  Widget _buildNavItem(IconData icon, int index, Color selectedColor) {
    return SizedBox(
      height: 60,
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: FloatingActionButton(
          heroTag: index.toString(),
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightElevation: 0.0,
          onPressed: () {
            _navigateToPage(index);
          },
          backgroundColor: Constants.navBar,
          elevation: 0.0,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: (currentPageIndex == index ||
                        (_isSubPageOf(index) && index == settingsPageIndex))
                    ? selectedColor
                    : Constants.navButtonNotSelected,
              ),
              Positioned(
                bottom: -3,
                child: Container(
                  height: 4,
                  width: 4,
                  decoration: const BoxDecoration(
                    color: Constants.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(String text, ThemeData theme) {
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: SizedBox.expand(
        child: Center(
          child: Text(
            text,
            style: theme.textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
