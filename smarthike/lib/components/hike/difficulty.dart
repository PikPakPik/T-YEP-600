import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';
import 'package:badges/badges.dart' as badges;

class Difficulty extends StatelessWidget {
  final int? difficulty;

  const Difficulty({
    super.key,
    this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (difficulty) {
      case 1:
      case 2:
      case 3:
      case 4: // Difficulté facile
        color = Colors.green;
        text = LocaleKeys.hike_details_difficulty_steps_easy.tr();
        break;
      case 5:
      case 6:
      case 7: // Difficulté moyenne
        color = Colors.orange;
        text = LocaleKeys.hike_details_difficulty_steps_medium.tr();
        break;
      case 8:
      case 9: // Difficulté difficile
        color = Colors.red;
        text = LocaleKeys.hike_details_difficulty_steps_difficult.tr();
        break;
      case 10: // Très difficile
        color = Colors.redAccent;
        text = LocaleKeys.hike_details_difficulty_steps_very_difficult.tr();
        break;
      default:
        color = Colors.grey;
        text = LocaleKeys.hike_details_unknown.tr();
    }

    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            badges.Badge(
                badgeContent: Text(
                  difficulty.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                badgeStyle: badges.BadgeStyle(
                  badgeColor: color,
                  padding: difficulty.toString().length < 2
                      ? EdgeInsets.all(8)
                      : EdgeInsets.all(4),
                )),
          ],
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.hike_details_difficulty.tr(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis, // Ajout de l'overflow
              ),
            ],
          ),
        ),
      ],
    );
  }
}
