import 'package:flutter_test/flutter_test.dart';
import 'package:feiragreen_flutter/infrastructure/services/auth_service.dart';

void main() {
  group('AuthService', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    test('TU-01: Deve retornar false para e-mail inválido', () {
      // Arrange
      const invalidEmail = 'invalido@';

      // Act
      final result = authService.validateEmail(invalidEmail);

      // Assert
      expect(result, isFalse);
    });

    test('TU-02: Deve retornar true para e-mail válido', () {
      // Arrange
      const validEmail = 'usuario@exemplo.com';

      // Act
      final result = authService.validateEmail(validEmail);

      // Assert
      expect(result, isTrue);
    });
  });
}
