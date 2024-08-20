import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smarthike/models/user.dart';
import 'package:smarthike/providers/auth_provider.dart';
import 'package:smarthike/services/auth_service.dart';

import 'user_providers_test.mocks.dart';

@GenerateMocks([AuthService])
void main() {
  late AuthProvider authProvider;
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
    authProvider = AuthProvider(authService: mockAuthService);
  });

  group('AuthProvider', () {
    test('login success', () async {
      final user = User(
          id: 1, firstname: 'John', lastname: 'Doe', email: 'test@example.com');

      when(mockAuthService.login('test@example.com', 'password'))
          .thenAnswer((_) async => user);

      await authProvider.login('test@example.com', 'password');

      expect(authProvider.user, user);
      verify(mockAuthService.login('test@example.com', 'password')).called(1);
    });

    test('register success', () async {
      final user = User(
          id: 1, firstname: 'John', lastname: 'Doe', email: 'test@example.com');

      when(mockAuthService.register(
              'John', 'Doe', 'test@example.com', 'password'))
          .thenAnswer((_) async => user);

      await authProvider.register(
          'John', 'Doe', 'test@example.com', 'password');

      expect(authProvider.user, user);
      verify(mockAuthService.register(
              'John', 'Doe', 'test@example.com', 'password'))
          .called(1);
    });

    test('logout', () async {
      when(mockAuthService.logout()).thenAnswer((_) async => null);
      await authProvider.logout();
      expect(authProvider.user, isNull);
      verify(mockAuthService.logout()).called(1);
    });
  });
}
