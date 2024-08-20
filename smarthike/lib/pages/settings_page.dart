import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/components/button.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';
import 'package:smarthike/providers/auth_provider.dart';

class SettingsPage extends StatelessWidget {
  final VoidCallback onLanguageButtonPressed;
  final VoidCallback onSecurityButtonPressed;

  const SettingsPage(
      {super.key,
      required this.onLanguageButtonPressed,
      required this.onSecurityButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.thirdColor,
        body: Consumer<AuthProvider>(builder: (context, authProvider, child) {
          return Center(
              child: Container(
                  width: 350,
                  height: 600,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Column(children: [
                      // Logo
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Image.asset('assets/images/LogoSmartHike.png'),
                      ),
                      // Boutons
                      CustomButton(
                        key: const Key('language_button'),
                        text: LocaleKeys.settings_modify_language.tr(),
                        backgroundColor: Constants.primaryColor,
                        textColor: Colors.black,
                        fontWeight: FontWeight.w900,
                        onPressed: onLanguageButtonPressed,
                      ),
                      CustomButton(
                        key: const Key('appearance_button'),
                        text: LocaleKeys.settings_modify_appearance.tr(),
                        backgroundColor: Constants.primaryColor,
                        textColor: Colors.black,
                        fontWeight: FontWeight.w900,
                        isEnable: false,
                        onPressed: () {},
                      ),
                      if (authProvider.user != null)
                        CustomButton(
                          key: const Key('security_button'),
                          text: LocaleKeys.settings_privacy_security.tr(),
                          backgroundColor: Constants.primaryColor,
                          textColor: Colors.black,
                          fontWeight: FontWeight.w900,
                          onPressed: onSecurityButtonPressed,
                        )
                    ])
                  ])));
        }));
  }
}
