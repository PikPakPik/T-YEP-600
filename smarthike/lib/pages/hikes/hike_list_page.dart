import 'package:flutter/material.dart';
import 'package:smarthike/components/hikes/horizontal_card.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/models/hike.dart'; // Assurez-vous que le chemin du fichier est correct

class HikeListPage extends StatefulWidget {
  const HikeListPage({super.key});
  @override
  HikeListPageState createState() => HikeListPageState();
}

class HikeListPageState extends State<HikeListPage> {
  List<Hike> hikes = [
    Hike(
      name: 'Trail A',
      distance: 10.2,
      heightDiff: 980,
      maxAlt: 1360,
      minAlt: 380,
      difficulty: 1,
      hikingTime: 3,
      imageUrl: 'assets/images/hikeImageWaiting.jpg',
    ),
    Hike(
      name: 'Trail B',
      distance: 6.8,
      heightDiff: 750,
      maxAlt: 1100,
      minAlt: 350,
      difficulty: 3,
      hikingTime: 2,
      imageUrl: 'assets/images/hikeImageWaiting.jpg',
    ),
    Hike(
      name: 'Trail C',
      distance: 8.5,
      heightDiff: -1234,
      maxAlt: 1259,
      minAlt: 25,
      difficulty: 0,
      hikingTime: 2,
      imageUrl: 'assets/images/hikeImageWaiting.jpg',
    ),
    Hike(
      name: 'Trail D',
      distance: 12.0,
      heightDiff: 1500,
      maxAlt: 1800,
      minAlt: 300,
      difficulty: 2,
      hikingTime: 4,
      imageUrl: 'assets/images/hikeImageWaiting.jpg',
    ),
    Hike(
      name: 'Trail E',
      distance: 5.5,
      heightDiff: 600,
      maxAlt: 900,
      minAlt: 300,
      difficulty: 0,
      hikingTime: 1,
      imageUrl: 'assets/images/hikeImageWaiting.jpg',
    ),
    Hike(
      name: 'Trail F',
      distance: 9.3,
      heightDiff: 850,
      maxAlt: 1100,
      minAlt: 250,
      difficulty: 1,
      hikingTime: 3,
      imageUrl: 'assets/images/hikeImageWaiting.jpg',
    ),
    Hike(
      name: 'Trail G',
      distance: 7.7,
      heightDiff:-920,
      maxAlt: 1300,
      minAlt: 380,
      difficulty: 0,
      hikingTime: 2,
      imageUrl: 'assets/images/hikeImageWaiting.jpg',
    ),
    Hike(
      name: 'Trail H',
      distance: 11.5,
      heightDiff: 1350,
      maxAlt: 1600,
      minAlt: 250,
      difficulty: 2,
      hikingTime: 4,
      imageUrl: 'assets/images/hikeImageWaiting.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.thirdColor,
      appBar: AppBar(
        title: const Text('Hike List'),
      ),
      body: ListView.builder(
        itemCount: hikes.length,
        itemBuilder: (context, index) {
          final hike = hikes[index];
          return HorizontalCard(hike: hike);
        },
      ),
    );
  }
}
