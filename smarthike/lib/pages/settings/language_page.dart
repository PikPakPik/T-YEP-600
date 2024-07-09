import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smarthike/components/button.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';
import 'package:smarthike/utils/shared_preferences_util.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _currentLang = 'en';

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  Future<void> _loadCurrentLanguage() async {
    String? lang = await SharedPreferencesUtil.instance.getString('lang');
    if (lang != null && mounted) {
      setState(() {
        _currentLang = lang;
      });
    }
  }

  Future<void> _setLanguage(BuildContext context, String languageCode,
      String previousLanguageCode) async {
    await SharedPreferencesUtil.instance.setString('lang', languageCode);
    if (!context.mounted) return;
    context.setLocale(Locale(languageCode));
    bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(LocaleKeys.settings_language_modal_title).tr(),
            content:
                const Text(LocaleKeys.settings_language_modal_confirm).tr(),
            actions: [
              TextButton(
                  onPressed: () => {
                        Navigator.of(context).pop(false),
                      },
                  child: const Text(
                          LocaleKeys.settings_language_modal_cancel_modal)
                      .tr()),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                          LocaleKeys.settings_language_modal_confirm_modal)
                      .tr()),
            ],
          );
        });
    if (confirmed == true && context.mounted) {
      // Check if context is still mounted
      await SharedPreferencesUtil.instance.setString('lang', languageCode);
      if (context.mounted) {
        context.setLocale(Locale(languageCode));
      }
    } else {
      await SharedPreferencesUtil.instance
          .setString('lang', previousLanguageCode);
      if (context.mounted) {
        context.setLocale(Locale(previousLanguageCode));
      }
    }
  }

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
                        // Boutons de langue
                        FutureBuilder<String?>(
                          future:
                              SharedPreferencesUtil.instance.getString('lang'),
                          builder: (context, snapshot) {
                            return Column(
                              children: [
                                CustomButton(
                                  key: const Key('french_button'),
                                  text: 'Français',
                                  backgroundColor: Constants.primaryColor,
                                  textColor: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  onPressed: _currentLang == 'fr'
                                      ? null
                                      : () async {
                                          String previousLang =
                                              await SharedPreferencesUtil
                                                      .instance
                                                      .getString('lang') ??
                                                  'en';
                                          if (!context.mounted) return;
                                          setState(() {
                                            _currentLang = 'fr';
                                          });
                                          await _setLanguage(
                                              context, 'fr', previousLang);
                                        },
                                ),
                                CustomButton(
                                  key: const Key('english_button'),
                                  text: 'English',
                                  backgroundColor: Constants.primaryColor,
                                  textColor: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  onPressed: _currentLang == 'en'
                                      ? null
                                      : () async {
                                          String previousLang =
                                              await SharedPreferencesUtil
                                                      .instance
                                                      .getString('lang') ??
                                                  'en';
                                          if (!context.mounted) return;
                                          setState(() {
                                            _currentLang = 'en';
                                          });
                                          await _setLanguage(
                                              context, 'en', previousLang);
                                        },
                                ),
                                CustomButton(
                                  key: const Key('spanish_button'),
                                  text: 'Español',
                                  backgroundColor: Constants.primaryColor,
                                  textColor: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  onPressed: _currentLang == 'es'
                                      ? null
                                      : () async {
                                          String previousLang =
                                              await SharedPreferencesUtil
                                                      .instance
                                                      .getString('lang') ??
                                                  'en';
                                          if (!context.mounted) return;
                                          setState(() {
                                            _currentLang = 'es';
                                          });
                                          await _setLanguage(
                                              context, 'es', previousLang);
                                        },
                                ),
                              ],
                            );
                          },
                        ),
                      ])
                    ])))));
  }
}
