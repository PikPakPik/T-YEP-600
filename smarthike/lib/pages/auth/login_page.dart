import 'package:flutter/material.dart';
import 'package:smarthike/components/auth/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: LoginForm(),
    );
  }
}
