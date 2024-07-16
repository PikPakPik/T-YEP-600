import 'package:flutter/material.dart';
import 'package:smarthike/components/hike/details_card.dart';
import 'package:smarthike/models/hike.dart';
import 'package:smarthike/models/fav_hike.dart';

class HorizontalCard extends StatelessWidget {
  final dynamic hike;

  const HorizontalCard({super.key, required this.hike});

  @override
  Widget build(BuildContext context) {
    final String imageUrl = hike is Hike ? hike.imageUrl : "assets/images/hikeImageWaiting.jpg";
    final String name = hike is Hike ? hike.name : (hike as HikeFav).name;

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
                    child: Image.asset(imageUrl.isNotEmpty
                        ? imageUrl
                        : "assets/images/hikeImageWaiting.jpg")),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (hike is Hike) ...[
                        DetailsCard(hike: hike),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
