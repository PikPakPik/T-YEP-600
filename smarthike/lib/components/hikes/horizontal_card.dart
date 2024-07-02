import 'package:flutter/material.dart';
import 'package:smarthike/components/hikes/details_card.dart';
import 'package:smarthike/models/hike.dart';

class HorizontalCard extends StatelessWidget {
  final Hike hike;

  const HorizontalCard({super.key, required this.hike});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Image.asset(hike.imageUrl),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: DetailsCard(hike: hike),
            ),
          ],
        ),
      ),
    );
  }
}
