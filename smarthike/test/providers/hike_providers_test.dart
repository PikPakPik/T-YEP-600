import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smarthike/providers/hike_provider.dart';
import 'package:smarthike/services/hike_service.dart';

import 'hike_providers_test.mocks.dart';

@GenerateMocks([HikeService])
void main() {
  late HikeProvider hikeProvider;
  late MockHikeService mockHikeService;

  setUp(() {
    mockHikeService = MockHikeService();
    hikeProvider = HikeProvider(hikeService: mockHikeService);
  });

  group('HikeProvider', () {
    test('loadPaginatedHikesData', () async {
      when(mockHikeService.getListHikes(1)).thenAnswer((_) async => null);

      await hikeProvider.loadPaginatedHikesData(1);

      expect(hikeProvider.hikes, isEmpty);
      verify(mockHikeService.getListHikes(1)).called(1);
    });
  });
}
