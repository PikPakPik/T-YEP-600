import 'package:flutter/material.dart';
import 'package:smarthike/components/auth/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: RegisterForm(),
    );
  }
}
