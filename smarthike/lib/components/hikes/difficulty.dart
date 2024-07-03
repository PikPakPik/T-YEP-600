import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';

class Difficulty extends StatelessWidget {
  final int difficulty;

  const Difficulty({
    super.key,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;
    IconData icon;

    switch (difficulty) {
      case 1:
        color = Colors.green;
        text = LocaleKeys.hike_details_difficulty_easy.tr();
        icon = Icons.looks_one_outlined;
        break;
      case 2:
        color = Colors.orange;
        text = LocaleKeys.hike_details_difficulty_medium.tr();
        icon = Icons.looks_two_outlined;
        break;
      case 3:
        color = Colors.red;
        text = LocaleKeys.hike_details_difficulty_difficult.tr();
        icon = Icons.looks_3_outlined;
        break;
      default:
        color = Colors.grey;
        text = LocaleKeys.hike_details_difficulty_unknown.tr();
        icon = Icons.help_outline;
    }

    return Row(
      children: [
        Icon(
          icon,
          color: color,
          weight: 15,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: color,
          ),
        ),
      ],
    );
  }
}
