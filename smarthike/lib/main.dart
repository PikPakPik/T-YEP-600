import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smarthike/pages/hike/hike_list_page.dart';
import 'package:smarthike/pages/map_page.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/api/smarthike_api.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/pages/auth/login_page.dart';
import 'package:smarthike/pages/auth/register_page.dart';
import 'package:smarthike/pages/edit_profile_page.dart';
import 'package:smarthike/pages/profile_page.dart';
import 'package:smarthike/pages/settings/language_page.dart';
import 'package:smarthike/pages/settings/security_page.dart';
import 'package:smarthike/pages/settings/subpages/delete_account_warning_page.dart';
import 'package:smarthike/pages/settings_page.dart';
import 'package:smarthike/providers/hike_provider.dart';
import 'package:smarthike/providers/user_provider.dart';
import 'package:smarthike/services/auth_service.dart';
import 'package:smarthike/services/hike_service.dart';
import 'package:smarthike/utils/shared_preferences_util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final sharedPreferencesUtil = SharedPreferencesUtil.instance;
  String? lang = await sharedPreferencesUtil.getString('lang') ??
      Platform.localeName.split('_')[0];
  lang = (lang == 'fr' || lang == 'es') ? lang : 'en';

  try {
    await FMTCObjectBoxBackend().initialise();
  } catch (error) {
    throw Exception('Error initializing FMTCObjectBoxBackend: $error');
  }
  await const FMTCStore('mapStore').manage.create();

  final apiService = ApiService(token: '');

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => apiService),
        Provider<AuthService>(
          create: (context) => AuthService(
            apiService: apiService,
            sharedPreferencesUtil: sharedPreferencesUtil,
          ),
        ),
        Provider<HikeService>(
          create: (context) => HikeService(apiService: apiService),
        ),
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('fr'), Locale('es')],
        path: 'assets/locales',
        fallbackLocale: const Locale('en'),
        startLocale: Locale(lang),
        child: const SmartHikeApp(),
      ),
    ),
  );
}

const int mapPageIndex = 0;
const int profilePageIndex = 1;
const int settingsPageIndex = 2;
const int languagePageIndex = 3;
const int registerPageIndex = 4;
const int signInPageIndex = 5;
const int securityPageIndex = 6;
const int deleteAccountPageIndex = 7;
const int editProfilePageIndex = 8;
const int hikeListPageIndex = 9;

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
    final apiService = Provider.of<ApiService>(context);
    if (easyLocalization == null) {
      return const SizedBox.shrink();
    }

    final authService = Provider.of<AuthService>(context);
    final hikeService = Provider.of<HikeService>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserProvider(authService: authService)),
        ChangeNotifierProvider(
            create: (_) => HikeProvider(hikeService: hikeService)),
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
          home: NavigationBarApp(key: navBarKey, apiService: apiService),
        ),
      ),
    );
  }
}

class NavigationBarApp extends StatefulWidget {
  const NavigationBarApp({super.key, required this.apiService});

  final ApiService apiService;

  @override
  State<NavigationBarApp> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationBarApp> {
  int currentPageIndex = 0;

  void navigateToPage(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  bool _isSubPageOf(int parentPage) {
    return (parentPage == settingsPageIndex &&
            currentPageIndex >= languagePageIndex &&
            currentPageIndex <= deleteAccountPageIndex) ||
        (parentPage == profilePageIndex &&
            (currentPageIndex == registerPageIndex ||
                currentPageIndex == signInPageIndex)) ||
        (parentPage == hikeListPageIndex &&
            currentPageIndex == editProfilePageIndex);
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = _isSubPageOf(settingsPageIndex)
        ? settingsPageIndex
        : (_isSubPageOf(profilePageIndex)
            ? profilePageIndex
            : currentPageIndex);

    selectedIndex = selectedIndex.clamp(0, 2);

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: navigateToPage,
        indicatorColor: Constants.navBar,
        backgroundColor: Constants.navBar,
        surfaceTintColor: Constants.navBar,
        selectedIndex: selectedIndex,
        destinations: <Widget>[
          _buildNavItem(Icons.map_outlined, mapPageIndex),
          _buildNavItem(Icons.person_outline, profilePageIndex),
          _buildNavItem(Icons.settings_outlined, settingsPageIndex),
        ],
      ),
      body: <Widget>[
        const MapPage(),
        ProfilePage(
          onRegisterButtonPressed: () => navigateToPage(registerPageIndex),
          onSignInButtonPressed: () => navigateToPage(signInPageIndex),
        ),
        SettingsPage(
          onLanguageButtonPressed: () => navigateToPage(languagePageIndex),
          onSecurityButtonPressed: () => navigateToPage(securityPageIndex),
        ),
        const LanguagePage(),
        const RegisterPage(),
        const LoginPage(),
        SecurityPage(
          onDeleteAccountPressed: () => navigateToPage(deleteAccountPageIndex),
          onEditProfilePressed: () => navigateToPage(editProfilePageIndex),
        ),
        const DeleteAccountWarningPage(),
        const EditProfilePage(),
        const HikeListPage(),
      ][currentPageIndex],
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = currentPageIndex == index || _isSubPageOf(index);
    return SizedBox(
      height: 60,
      child: FloatingActionButton(
        heroTag: index.toString(),
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightElevation: 0.0,
        onPressed: () => navigateToPage(index),
        backgroundColor: Constants.navBar,
        elevation: 0.0,
        child: Icon(
          icon,
          color: isSelected
              ? Constants.primaryColor
              : Constants.navButtonNotSelected,
        ),
      ),
    );
  }
}
