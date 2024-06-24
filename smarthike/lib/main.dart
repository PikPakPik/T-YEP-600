import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/pages/profile_page.dart';
import 'package:smarthike/providers/user_provider.dart';
import 'package:smarthike/services/auth_service.dart';
import 'package:smarthike/utils/shared_preferences_util.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(const SmartHikeApp());
}

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
  const SmartHikeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = Dio(BaseOptions(
      baseUrl: "http://localhost:5000/api",
      headers: {
        HttpHeaders.userAgentHeader: 'dio',
        'common-header': 'xx',
        'Content-Type': 'application/json',
      },
    ));
    final sharedPreferencesUtil = SharedPreferencesUtil.instance;
    final authService =
        AuthService(dio: dio, sharedPreferencesUtil: sharedPreferencesUtil);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserProvider(
                authService: authService)), // Ensure UserProvider is here
      ],
      child: AppInitializer(
        child: MaterialApp(
          builder: FToastBuilder(),
          navigatorKey: navigatorKey,
          theme: ThemeData(
              useMaterial3: true, textTheme: GoogleFonts.rubikTextTheme()),
          home:
              const NavigationBarApp(), // Ensure LoginForm is a descendant of this structure
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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Constants.navBar,
        backgroundColor: Constants.navBar,
        surfaceTintColor: Constants.navBar,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          SizedBox(
            height: 60,
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: FloatingActionButton(
                heroTag: 'home',
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightElevation: 0.0,
                onPressed: () {
                  setState(() {
                    currentPageIndex = 0;
                  });
                },
                backgroundColor: Constants.navBar,
                elevation: 0.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.home_outlined,
                      color: currentPageIndex == 0
                          ? Constants.primaryColor
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
          ),
          SizedBox(
            height: 60,
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: FloatingActionButton(
                heroTag: 'map',
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightElevation: 0.0,
                onPressed: () {
                  setState(() {
                    currentPageIndex = 1;
                  });
                },
                backgroundColor: Constants.navBar,
                elevation: 0.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.map_outlined,
                      color: currentPageIndex == 1
                          ? Constants.primaryColor
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
          ),
          SizedBox(
            height: 60,
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: FloatingActionButton(
                heroTag: 'profile',
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightElevation: 0.0,
                onPressed: () {
                  setState(() {
                    currentPageIndex = 2;
                  });
                },
                backgroundColor: Constants.navBar,
                elevation: 0.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.person_outline,
                      color: currentPageIndex == 2
                          ? Constants.primaryColor
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
          ),
          SizedBox(
            height: 60,
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: FloatingActionButton(
                heroTag: 'settings',
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightElevation: 0.0,
                onPressed: () {
                  setState(() {
                    currentPageIndex = 3;
                  });
                },
                backgroundColor: Constants.navBar,
                elevation: 0.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.settings_outlined,
                      color: currentPageIndex == 3
                          ? Constants.primaryColor
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
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Home page',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),

        /// Map page
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Map page',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),

        /// Profile page
        const ProfilePage(),

        /// Settings page
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Settings page',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),
      ][currentPageIndex],
    );
  }
}
