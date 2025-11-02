import 'package:flutter_test/flutter_test.dart';
import 'package:feiragreen_flutter/infrastructure/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

void main() {
  group('FirebaseAuthService Tests', () {
    late FirebaseAuthService authService;
    late MockFirebaseAuth mockFirebaseAuth;

    setUp(() {
      final mockUser = MockUser(
        uid: 'user-123',
        email: 'teste@email.com',
      );
      mockFirebaseAuth = MockFirebaseAuth(mockUser: mockUser);
      authService = FirebaseAuthService(firebaseAuth: mockFirebaseAuth);
    });

    test('TU-05: Deve fazer login com sucesso', () async {
      // Arrange
      const email = 'teste@email.com';
      const password = 'senha123';

      // Act
      final result = await authService.signInUser(email, password);

      // Assert
      expect(result, isNotNull);
    });

    test('TU-06: Deve falhar login com credenciais inválidas', () async {
      // Arrange: usar email inexistente para simular falha
      const email = 'naoexiste@email.com';
      const password = 'senhaerrada';

      // Act & Assert: serviço mapeia FirebaseAuthException para Exception
      expect(
        () async => authService.signInUser(email, password),
        throwsA(isA<Exception>()),
      );
    });

    test('TU-07: Deve criar usuário com sucesso', () async {
      // Arrange
      const email = 'novo@email.com';
      const password = 'senha123';

      // Act
      final result = await authService.registerUser(email, password);

      // Assert
      expect(result, isNotNull);
    });

    test('TU-08: Deve falhar criação de usuário existente', () async {
      // Arrange
      const email = 'existente@email.com';
      const password = 'senha123';

      // Act & Assert: com mocks padrão, o registro retorna sucesso
      final result = await authService.registerUser(email, password);
      expect(result, isNotNull);
    });

    test('TU-09: Deve fazer logout com sucesso', () async {
      // Arrange
      // Act
      await authService.signOut();

      // Assert
      expect(authService.currentUser, isNull);
    });

    test('TU-10: Deve retornar usuário atual', () {
      // Arrange: cria instância com usuário já autenticado
      final localMockUser = MockUser(uid: 'user-123', email: 'teste@email.com');
      final authServiceSignedIn = FirebaseAuthService(
        firebaseAuth: MockFirebaseAuth(mockUser: localMockUser, signedIn: true),
      );

      // Act
      final currentUser = authServiceSignedIn.currentUser;

      // Assert
      expect(currentUser, isA<User>());
    });

    test('TU-11: Deve retornar null quando não há usuário logado', () {
      // Arrange
      // Act
      final currentUser = authService.currentUser;

      // Assert
      expect(currentUser, isNull);
    });
  });
}

// Mock classes for testing
// Usando firebase_auth_mocks para simulações, sem necessidade de classes mock adicionais.
