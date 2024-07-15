import 'package:flutter/material.dart';
import 'package:smarthike/components/hike/details_card.dart';
import 'package:smarthike/models/hike.dart';

class HorizontalCard extends StatelessWidget {
  final Hike hike;
  final bool showStats;

  const HorizontalCard({super.key, required this.hike, this.showStats = true});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          color: Colors.white,
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: constraints.maxWidth * 0.3,
                    height: constraints.maxWidth * 0.3,
                    child: Image.asset(hike.imageUrl.isNotEmpty
                        ? hike.imageUrl
                        : "assets/images/hikeImageWaiting.jpg")),
                const SizedBox(width: 15),
                Expanded(
                  child: DetailsCard(hike: hike, showStats: showStats),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
