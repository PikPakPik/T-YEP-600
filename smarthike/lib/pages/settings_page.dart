import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smarthike/components/button.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';
import 'package:smarthike/pages/settings/language_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.thirdColor,
        body: Center(
            child: Center(
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
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LanguagePage()));
                          },
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
                        CustomButton(
                          key: const Key('security_button'),
                          text: LocaleKeys.settings_privacy_security.tr(),
                          backgroundColor: Constants.primaryColor,
                          textColor: Colors.black,
                          fontWeight: FontWeight.w900,
                          onPressed: () {},
                        )
                      ])
                    ])))));
  }
}
