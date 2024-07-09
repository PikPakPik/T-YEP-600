import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smarthike/components/hikes/difficulty.dart';
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
                      _buildDetailRow(
                        Icons.earbuds,
                        LocaleKeys.hike_details_distance.tr(),
                        '${hike.distance}km',
                      ),
                      // Second row : Max altitude
                      _buildDetailRow(
                        Icons.arrow_circle_up,
                        LocaleKeys.hike_details_max_altitude.tr(),
                        '${hike.maxAlt}m',
                      ),
                      // Third row: hiking time
                      _buildDetailRow(
                        Icons.timer_outlined,
                        LocaleKeys.hike_details_hiking_time.tr(),
                        '${hike.hikingTime}h',
                      ),
                    ],
                  ),
                ),
                // Second column (right)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // First row : Height difference
                      _buildDetailRow(
                        _getHeightDifferenceIcon(hike.heightDiff),
                        LocaleKeys.hike_details_height_diff.tr(),
                        _formatHeightDifference(hike.heightDiff),
                      ),
                      // Second rox: Min altitude
                      _buildDetailRow(
                        Icons.arrow_circle_down,
                        LocaleKeys.hike_details_min_altitude.tr(),
                        '${hike.minAlt}m',
                      ),
                      Row(
                        children: [
                          Difficulty(difficulty: hike.difficulty),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  IconData _getHeightDifferenceIcon(int heightDiff) {
    return heightDiff >= 0 ? Icons.trending_up : Icons.trending_down;
  }

  String _formatHeightDifference(int heightDiff) {
    return heightDiff > 0 ? '+$heightDiff m' : '$heightDiff m';
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
}
