import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/components/button.dart';
import 'package:smarthike/pages/auth/login_page.dart';
import 'package:smarthike/pages/auth/register_page.dart';

import '../providers/user_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.user;
          return user != null
              ? SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Bonjour ${user.firstname} ${user.lastname}'),
                      CustomButton(
                        key: const Key('logout_button'),
                        text: 'Déconnexion',
                        backgroundColor: Colors.red,
                        onPressed: () {
                          userProvider.logout();
                        },
                      ),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Column(
        children: [
          CustomButton(
            key: const Key('login_button'),
            text: 'Connexion',
            backgroundColor: Colors.blue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
          ),
          CustomButton(
            key: const Key('signup_button'),
            text: 'Inscription',
            backgroundColor: Colors.green,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
