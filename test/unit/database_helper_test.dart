import 'package:flutter_test/flutter_test.dart';
import 'package:feiragreen_flutter/infrastructure/database/firebase_database_helper.dart';
// Testa apenas aspectos públicos do DatabaseHelper sem dependências externas

void main() {
  group('DatabaseHelper Tests', () {
    late DatabaseHelper dbHelper;

    setUp(() {
      dbHelper = DatabaseHelper.instance;
    });

    // Removidos testes que acessavam métodos privados

    test('TU-04: Deve retornar instância singleton', () {
      // Act
      final instance1 = DatabaseHelper.instance;
      final instance2 = DatabaseHelper.instance;

      // Assert
      expect(instance1, same(instance2));
    });
  });
}
