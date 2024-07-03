import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smarthike/models/user.dart';
import 'package:smarthike/providers/user_provider.dart';
import 'package:smarthike/services/auth_service.dart';

import 'user_providers_test.mocks.dart';

@GenerateMocks([AuthService])
void main() {
  late UserProvider userProvider;
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
    userProvider = UserProvider(authService: mockAuthService);
  });

  group('UserProvider', () {
    test('login success', () async {
      final user = User(
          id: 1, firstname: 'John', lastname: 'Doe', email: 'test@example.com');

      when(mockAuthService.login('test@example.com', 'password'))
          .thenAnswer((_) async => user);

      await userProvider.login('test@example.com', 'password');

      expect(userProvider.user, user);
      verify(mockAuthService.login('test@example.com', 'password')).called(1);
    });

    test('register success', () async {
      final user = User(
          id: 1, firstname: 'John', lastname: 'Doe', email: 'test@example.com');

      when(mockAuthService.register(
              'John', 'Doe', 'test@example.com', 'password'))
          .thenAnswer((_) async => user);

      await userProvider.register(
          'John', 'Doe', 'test@example.com', 'password');

      expect(userProvider.user, user);
      verify(mockAuthService.register(
              'John', 'Doe', 'test@example.com', 'password'))
          .called(1);
    });

    test('logout', () async {
      when(mockAuthService.logout()).thenAnswer((_) async => null);
      await userProvider.logout();
      expect(userProvider.user, isNull);
      verify(mockAuthService.logout()).called(1);
    });
  });
}
