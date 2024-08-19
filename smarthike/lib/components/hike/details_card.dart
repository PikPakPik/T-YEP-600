import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smarthike/components/hike/difficulty.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';
import 'package:smarthike/models/hike.dart';
import 'package:smarthike/utils/format_util.dart';

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
          const SizedBox(height: 5),
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
                          : _buildDetailRowUnknown(Icons.earbuds,
                              LocaleKeys.hike_details_distance.tr()),
                      // Second row : Max altitude
                      hike.positiveAltitude != null
                          ? _buildDetailRow(
                              Icons.arrow_circle_up,
                              LocaleKeys.hike_details_max_altitude.tr(),
                              '${hike.positiveAltitude} m',
                            )
                          : _buildDetailRowUnknown(Icons.arrow_circle_up,
                              LocaleKeys.hike_details_max_altitude.tr()),
                      // Third row: hiking time
                      hike.hikingTime != null
                          ? _buildDetailRow(
                              Icons.timer_outlined,
                              LocaleKeys.hike_details_hiking_time.tr(),
                              formatSecondsToHoursAndMinutes(hike.hikingTime),
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
                      // Second row: Min altitude
                      hike.negativeAltitude != null
                          ? _buildDetailRow(
                              Icons.arrow_circle_down,
                              LocaleKeys.hike_details_min_altitude.tr(),
                              '${hike.negativeAltitude} m',
                            )
                          : _buildDetailRowUnknown(Icons.arrow_circle_down,
                              LocaleKeys.hike_details_min_altitude.tr()),
                      // Third row : difficulty
                      Difficulty(difficulty: hike.difficulty),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
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
