import 'package:flutter/material.dart';
import 'package:smarthike/components/button.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';
import 'package:easy_localization/easy_localization.dart';

class SecurityPage extends StatelessWidget {
  final VoidCallback onDeleteAccountPressed;
  final VoidCallback onEditProfilePressed;

  const SecurityPage(
      {super.key,
      required this.onDeleteAccountPressed,
      required this.onEditProfilePressed});

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
                        CustomButton(
                          key: const Key('settings_edit_profile'),
                          text: LocaleKeys.settings_edit_profile.tr(),
                          backgroundColor: Constants.primaryColor,
                          textColor: Colors.black,
                          fontWeight: FontWeight.w900,
                          onPressed: onEditProfilePressed,
                        ),
                        // Boutons
                        CustomButton(
                          key: const Key('change_password_button'),
                          text: LocaleKeys.settings_change_password.tr(),
                          backgroundColor: Constants.primaryColor,
                          textColor: Colors.black,
                          fontWeight: FontWeight.w900,
                          onPressed: () {},
                        ),
                        CustomButton(
                          key: const Key('two_factor_auth_button'),
                          text: LocaleKeys.settings_two_factor_auth.tr(),
                          backgroundColor: Constants.primaryColor,
                          textColor: Colors.black,
                          fontWeight: FontWeight.w900,
                          onPressed: () {},
                        ),
                        CustomButton(
                          key: const Key('delete_account_button'),
                          text: LocaleKeys.settings_delete_account.tr(),
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontWeight: FontWeight.w900,
                          onPressed: onDeleteAccountPressed,
                        ),
                      ])
                    ])))));
  }
}
