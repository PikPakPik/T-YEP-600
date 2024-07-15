import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smarthike/components/hike/difficulty.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';
import 'package:smarthike/models/hike.dart';

class DetailsCard extends StatelessWidget {
  final Hike hike;
  final bool showStats;

  const DetailsCard({super.key, required this.hike, this.showStats = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hike title
        Text(
          hike.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        // Hike details
        
        if (showStats)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First column (left)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First row: distance
                  hike.distance != null
                      ? _buildDetailRow(
                          Icons.earbuds,
                          LocaleKeys.hike_details_distance.tr(),
                          '${hike.distance} km',
                        )
                      : _buildDetailRowUnknown(
                          Icons.earbuds, LocaleKeys.hike_details_distance.tr()),
                  // Second row : Max altitude
                  hike.maxAlt != null
                      ? _buildDetailRow(
                          Icons.arrow_circle_up,
                          LocaleKeys.hike_details_max_altitude.tr(),
                          '${hike.maxAlt} m',
                        )
                      : _buildDetailRowUnknown(Icons.arrow_circle_up,
                          LocaleKeys.hike_details_max_altitude.tr()),
                  // Third row: hiking time
                  hike.hikingTime != null
                      ? _buildDetailRow(
                          Icons.timer_outlined,
                          LocaleKeys.hike_details_hiking_time.tr(),
                          '${hike.hikingTime} h',
                        )
                      : _buildDetailRowUnknown(Icons.timer_outlined,
                          LocaleKeys.hike_details_hiking_time.tr()),
                ],
              ),
            ),
            // Second column (right)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First row : Elevation gainerence
                  hike.elevationGain != null
                      ? _buildDetailRow(
                          Icons.trending_up,
                          LocaleKeys.hike_details_elevation_gain.tr(),
                          '${hike.elevationGain}',
                        )
                      : _buildDetailRowUnknown(Icons.trending_up,
                          LocaleKeys.hike_details_elevation_gain.tr()),
                  // Second row: Min altitude
                  hike.minAlt != null
                      ? _buildDetailRow(
                          Icons.arrow_circle_down,
                          LocaleKeys.hike_details_min_altitude.tr(),
                          '${hike.minAlt} m',
                        )
                      : _buildDetailRowUnknown(Icons.arrow_circle_down,
                          LocaleKeys.hike_details_min_altitude.tr()),
                  // Third row : difficulty
                  Text(
                    LocaleKeys.hike_details_difficulty.tr(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                  Difficulty(difficulty: hike.difficulty),
                ],
              ),
            ),
          ],
        ),
      ],
    ),);
  }

  Widget _buildDetailRow(IconData iconData, String title, String text) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: Constants.secondaryColor,
              size: 22,
            ),
          ],
        ),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailRowUnknown(IconData iconData, String title) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: Constants.secondaryColor,
              size: 22,
            ),
          ],
        ),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
            Text(
              LocaleKeys.hike_details_unknown.tr(),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ],
    );
  }
}
