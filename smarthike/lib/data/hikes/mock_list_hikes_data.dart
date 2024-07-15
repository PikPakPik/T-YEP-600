// lib/data/mock_hike_data.dart
import 'package:smarthike/models/hike.dart';
import 'package:smarthike/models/paginated_hike.dart';

PaginatedHike getMockHikeData() {
  List<Hike> hikes = [
    Hike(
      name: 'Trail A',
      distance: 10.2,
      elevationGain: 980,
      maxAlt: 1360,
      minAlt: 380,
      difficulty: 1,
      hikingTime: 3,
      imageUrl: 'assets/images/hikeImageWaiting.jpg',
    ),
    Hike(
      name: 'Trail B',
      distance: 6.8,
      elevationGain: 750,
      maxAlt: 1100,
      minAlt: 350,
      difficulty: 3,
      hikingTime: 2,
      imageUrl: 'assets/images/hikeImageWaiting.jpg',
    ),
    Hike(
      name: 'Trail C',
      distance: 8.5,
      elevationGain: 1234,
      maxAlt: 1259,
      minAlt: 25,
      difficulty: 0,
      hikingTime: 2,
      imageUrl: 'assets/images/hikeImageWaiting.jpg',
    ),
    Hike(
      name: 'Trail D',
      distance: 12.0,
      elevationGain: 1500,
      maxAlt: 1800,
      minAlt: 300,
      difficulty: 2,
      hikingTime: 4,
      imageUrl: 'assets/images/hikeImageWaiting.jpg',
    ),
    Hike(
      name: 'Trail E',
      distance: 5.5,
      elevationGain: 600,
      maxAlt: 900,
      minAlt: 300,
      difficulty: 0,
      hikingTime: 1,
      imageUrl: 'assets/images/hikeImageWaiting.jpg',
    ),
    Hike(
      name: 'Trail F',
      distance: 9.3,
      elevationGain: 850,
      maxAlt: 1100,
      minAlt: 250,
      difficulty: 1,
      hikingTime: 3,
      imageUrl: 'assets/images/hikeImageWaiting.jpg',
    ),
    Hike(
      name: 'Trail G',
      distance: 7.7,
      elevationGain: 920,
      maxAlt: 1300,
      minAlt: 380,
      difficulty: 0,
      hikingTime: 2,
      imageUrl: 'assets/images/hikeImageWaiting.jpg',
    ),
    Hike(
      name: 'Trail H',
      distance: 11.5,
      elevationGain: 1350,
      maxAlt: 1600,
      minAlt: 250,
      difficulty: 2,
      hikingTime: 4,
      imageUrl: 'assets/images/hikeImageWaiting.jpg',
    ),
  ];

  return PaginatedHike(
    items: hikes,
    totalItems: hikes.length,
    totalPages: 4,
    currentPage: 2,
    nextPage: 3,
    previousPage: 1,
  );
}
