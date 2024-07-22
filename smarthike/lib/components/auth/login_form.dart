import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/components/button.dart';
import 'package:smarthike/components/input.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';
import 'package:smarthike/main.dart'; // Added this line to import the main.dart file
import 'package:smarthike/providers/user_provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Material(
      color: Colors.transparent,
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(
          children: [
            CustomInput(
              key: const Key('email_login_field'),
              hintText: LocaleKeys.login_form_email.tr(),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.login_form_error_email_required.tr();
                }
                if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                    .hasMatch(value)) {
                  return LocaleKeys.login_form_error_email_invalid.tr();
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomInput(
              key: const Key('password_login_field'),
              hintText: LocaleKeys.login_form_password.tr(),
              controller: _passwordController,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.login_form_error_password_required.tr();
                }
                return null;
              },
            ),
            const SizedBox(height: 50),
            CustomButton(
              key: const Key('login_button'),
              text: LocaleKeys.auth_sign_in.tr(),
              backgroundColor: Constants.primaryColor,
              textColor: Colors.black,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    await userProvider.login(
                        _emailController.text, _passwordController.text);
                    if (context.mounted) {
                      SmartHikeApp.navBarKey.currentState?.navigateToPage(1);
                    }
                  } catch (e) {
                    if (e is Exception) {
                      if (e
                          .toString()
                          .contains("security.login.invalid_credentials")) {
                        Fluttertoast.showToast(
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          msg: LocaleKeys.api_security_login_invalid_credentials
                              .tr(),
                          toastLength: Toast.LENGTH_SHORT,
                        );
                      } else {
                        Fluttertoast.showToast(
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          msg: e.toString(),
                          toastLength: Toast.LENGTH_SHORT,
                        );
                      }
                    } else if (e is DioException) {
                      Fluttertoast.showToast(
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        msg: e.error?.toString() ??
                            LocaleKeys.api_error_unknown.tr(),
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
