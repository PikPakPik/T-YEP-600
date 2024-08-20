import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:marqueer/marqueer.dart';
import 'package:smarthike/components/hike/details_card.dart';
import 'package:smarthike/models/hike.dart';

class HorizontalCard extends StatelessWidget {
  final dynamic hike;
  final VoidCallback? onPressed;

  const HorizontalCard({super.key, this.onPressed, required this.hike});

  @override
  Widget build(BuildContext context) {
    final String fileLink = hike.files.isNotEmpty
        ? (kDebugMode && !kIsWeb
            ? 'http://localhost:9000${hike.files[0].link}'
            : hike.files[0].link)
        : 'assets/images/hikeImageWaiting.jpg';

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: onPressed,
          child: Card(
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
                    child: fileLink.startsWith("assets")
                        ? Image.asset(fileLink)
                        : Image.network(fileLink),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LayoutBuilder(builder: (context, constraints) {
                          String displayName = hike.name + '      ';
                          return hike.name.length > 22
                              ? SizedBox(
                                  height: 20,
                                  child: Marqueer(
                                    restartAfterInteractionDuration:
                                        const Duration(seconds: 3),
                                    child: Text(
                                      displayName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              : Text(
                                  hike.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                        }),
                        if (hike is Hike) ...[
                          DetailsCard(hike: hike),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
