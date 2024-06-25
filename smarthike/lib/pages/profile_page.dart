import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/components/button.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/pages/auth/login_page.dart';
import 'package:smarthike/pages/auth/register_page.dart';

import '../providers/user_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.thirdColor,
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.user;
          return user != null
              ? Center(
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
                                            backgroundImage: NetworkImage(
                                              'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png',
                                            ),
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
                                              'Gourou de la randonnée',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Container(
                                              width: double.infinity,
                                              decoration: const BoxDecoration(
                                                color: Constants.primaryColor,
                                                borderRadius: BorderRadius.only(
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
                                                              color:
                                                                  Colors.black),
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
                                                            color: Colors.black,
                                                            width: 1.0,
                                                          ),
                                                          right: BorderSide(
                                                            color: Colors.black,
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
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            SizedBox(height: 5),
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
                                                              color:
                                                                  Colors.black),
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
                                text: 'Déconnexion',
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
                )
              : const LoginOrSignupPage();
        },
      ),
    );
  }
}

class LoginOrSignupPage extends StatelessWidget {
  const LoginOrSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                text: 'Se connecter',
                backgroundColor: Constants.primaryColor,
                textColor: Colors.black,
                fontWeight: FontWeight.w900,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              child: CustomButton(
                key: const Key('signup_button'),
                text: 'S\'inscrire',
                textColor: Colors.black,
                backgroundColor: Constants.primaryColor,
                fontWeight: FontWeight.w900,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
