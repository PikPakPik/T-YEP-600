import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/components/button.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';

import '../providers/user_provider.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback onRegisterButtonPressed;
  final VoidCallback onSignInButtonPressed;
  const ProfilePage(
      {super.key,
      required this.onRegisterButtonPressed,
      required this.onSignInButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.thirdColor,
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.user;
          return user != null
              ? Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.all(20),
                          constraints: const BoxConstraints(
                            maxHeight: 600,
                            maxWidth: 350,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 5,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 40),
                              Card(
                                color: Constants.secondaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Column(
                                    children: [
                                      Stack(
                                        clipBehavior: Clip.none,
                                        alignment: Alignment.topCenter,
                                        children: [
                                          const Positioned(
                                            top: -50,
                                            child: CircleAvatar(
                                              radius: 50,
                                              backgroundImage: AssetImage(
                                                  'assets/images/LogoSmartHike.png'),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              const SizedBox(height: 50),
                                              Text(
                                                '${user.firstname} ${user.lastname}',
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              const Text(
                                                LocaleKeys.user_title_level_5,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                ),
                                              ).tr(),
                                              const SizedBox(height: 20),
                                              Container(
                                                width: double.infinity,
                                                decoration: const BoxDecoration(
                                                  color: Constants.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    const Expanded(
                                                      child: SizedBox(
                                                        height: 80,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(Icons.map,
                                                                size: 30,
                                                                color: Colors
                                                                    .black),
                                                            SizedBox(height: 5),
                                                            Text('179 km',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          border: Border(
                                                            left: BorderSide(
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                            right: BorderSide(
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                        ),
                                                        child: const SizedBox(
                                                          height: 80,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                  Icons
                                                                      .directions_walk,
                                                                  size: 30,
                                                                  color: Colors
                                                                      .black),
                                                              SizedBox(
                                                                  height: 5),
                                                              Text('69',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const Expanded(
                                                      child: SizedBox(
                                                        height: 80,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .help_outline,
                                                                size: 30,
                                                                color: Colors
                                                                    .black),
                                                            SizedBox(height: 5),
                                                            Text('?',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: CustomButton(
                                  key: const Key('logout_button'),
                                  text: LocaleKeys.auth_logout.tr(),
                                  backgroundColor: Colors.red,
                                  onPressed: () {
                                    userProvider.logout();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                )
              : LoginOrSignupPage(
                  onRegisterButtonPressed: onRegisterButtonPressed,
                  onSignInButtonPressed: onSignInButtonPressed,
                );
        },
      ),
    );
  }
}

class LoginOrSignupPage extends StatelessWidget {
  const LoginOrSignupPage({
    super.key,
    required this.onRegisterButtonPressed,
    required this.onSignInButtonPressed,
  });

  final VoidCallback onRegisterButtonPressed;
  final VoidCallback onSignInButtonPressed;

  @override
  Widget build(BuildContext context) {
    // const List<String> scopes = <String>['email', 'profile', 'openid'];

    // ignore: prefer_typing_uninitialized_variables
    // var googleSignIn;

    // if (Platform.isIOS) {
    //   googleSignIn = GoogleSignIn(
    //     clientId:
    //         '288979728581-7p67fe3pupk83b5rr5nsdcpo9qvfp4o4.apps.googleusercontent.com',
    //     scopes: scopes,
    //   );
    // }

    // Future<void> handleSignIn() async {
    //   try {
    //     await googleSignIn.signIn();
    //   } catch (error) {
    //     // print(error);
    //   }
    // }

    return Center(
      child: Container(
        width: 350,
        height: 600,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Image.asset('assets/images/LogoSmartHike.png'),
            ),
            SizedBox(
              child: CustomButton(
                key: const Key('login_button'),
                text: LocaleKeys.auth_sign_in.tr(),
                backgroundColor: Constants.primaryColor,
                textColor: Colors.black,
                fontWeight: FontWeight.w900,
                onPressed: onSignInButtonPressed,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              child: CustomButton(
                key: const Key('signup_button'),
                text: LocaleKeys.auth_sign_up.tr(),
                textColor: Colors.black,
                backgroundColor: Constants.primaryColor,
                fontWeight: FontWeight.w900,
                onPressed: onRegisterButtonPressed,
              ),
            ),
            // CustomButton(
            //   text: 'Se connecter avec Google',
            //   backgroundColor: Colors.transparent,
            //   onPressed: handleSignIn,
            // ),
          ],
        ),
      ),
    );
  }
}
