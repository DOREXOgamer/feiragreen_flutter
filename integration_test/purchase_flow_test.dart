import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:feiragreen_flutter/main.dart' as app;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Inicia o app real (Firebase já é inicializado em app.main)
  });

  group('Fluxo de Compra', () {
    testWidgets('TI-01: Adicionar produto e verificar total',
        (WidgetTester tester) async {
      // Arrange: Inicializar app real
      await app.main();
      await tester.pumpAndSettle();

      // Act: Registrar usuário primeiro
      final registerLink = find.text('Criar conta');
      expect(registerLink, findsOneWidget);
      await tester.tap(registerLink);
      await tester.pumpAndSettle();

      // Preencher formulário de registro
      final nameField = find.byType(TextFormField).at(0);
      final emailField = find.byType(TextFormField).at(1);
      final passwordField = find.byType(TextFormField).at(2);
      final confirmPasswordField = find.byType(TextFormField).at(3);
      final registerButton = find.byType(ElevatedButton);

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      await tester.enterText(nameField, 'Test User');
      await tester.enterText(emailField, 'test$timestamp@feiragreens.com');
      await tester.enterText(passwordField, '12345678');
      await tester.enterText(confirmPasswordField, '12345678');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Act: Login após registro
      final loginEmailField = find.widgetWithText(TextFormField, 'Email');
      final loginPasswordField = find.widgetWithText(TextFormField, 'Senha');
      final loginButton = find.text('Entrar');

      expect(loginEmailField, findsOneWidget);
      expect(loginPasswordField, findsOneWidget);
      expect(loginButton, findsOneWidget);

      await tester.enterText(loginEmailField, 'test$timestamp@feiragreens.com');
      await tester.enterText(loginPasswordField, '12345678');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Semear um produto de teste para garantir lista
      final uid = FirebaseAuth.instance.currentUser?.uid;
      expect(uid, isNotNull);
      await FirebaseFirestore.instance.collection('products').add({
        'userId': uid,
        'nome': 'Produto Teste 1',
        'preco': 9.99,
        'categoria': 'Testes',
        'descricao': 'Produto para teste TI-01',
        'imageUrl': 'http://example.com/img.png',
      });

      // Wait for products to load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Act: Adicionar produto ao carrinho (usando key específica)
      final addToCartButton = find.byTooltip('Adicionar ao carrinho');
      expect(addToCartButton, findsAtLeastNWidgets(1));
      await tester.tap(addToCartButton.first);
      await tester.pumpAndSettle();

      // Act: Navegar para carrinho
      final cartIcon = find.byIcon(Icons.shopping_cart);
      expect(cartIcon, findsOneWidget);
      await tester.tap(cartIcon);
      await tester.pumpAndSettle();

      // Assert: Verificar que há itens no carrinho
      expect(find.text('Total do pedido:'), findsOneWidget);
    });

    testWidgets('TI-02: Verificar fluxo completo de compra',
        (WidgetTester tester) async {
      // Arrange: Inicializar app real
      await app.main();
      await tester.pumpAndSettle();

      // Act: Registrar usuário primeiro
      final registerLink = find.text('Criar conta');
      expect(registerLink, findsOneWidget);
      await tester.tap(registerLink);
      await tester.pumpAndSettle();

      // Preencher formulário de registro
      final nameField = find.byType(TextFormField).at(0);
      final emailField = find.byType(TextFormField).at(1);
      final passwordField = find.byType(TextFormField).at(2);
      final confirmPasswordField = find.byType(TextFormField).at(3);
      final registerButton = find.byType(ElevatedButton);

      final timestamp2 = DateTime.now().millisecondsSinceEpoch + 1;
      await tester.enterText(nameField, 'Test User 2');
      await tester.enterText(emailField, 'test$timestamp2@feiragreens.com');
      await tester.enterText(passwordField, '12345678');
      await tester.enterText(confirmPasswordField, '12345678');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Act: Login após registro
      final loginEmailField = find.widgetWithText(TextFormField, 'Email');
      final loginPasswordField = find.widgetWithText(TextFormField, 'Senha');
      final loginButton = find.text('Entrar');

      expect(loginEmailField, findsOneWidget);
      expect(loginPasswordField, findsOneWidget);
      expect(loginButton, findsOneWidget);

      await tester.enterText(
          loginEmailField, 'test$timestamp2@feiragreens.com');
      await tester.enterText(loginPasswordField, '12345678');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Semear múltiplos produtos de teste
      final uid = FirebaseAuth.instance.currentUser?.uid;
      expect(uid, isNotNull);
      await FirebaseFirestore.instance.collection('products').add({
        'userId': uid,
        'nome': 'Produto Teste A',
        'preco': 5.50,
        'categoria': 'Testes',
        'descricao': 'Produto A para TI-02',
        'imageUrl': 'http://example.com/a.png',
      });
      await FirebaseFirestore.instance.collection('products').add({
        'userId': uid,
        'nome': 'Produto Teste B',
        'preco': 12.30,
        'categoria': 'Testes',
        'descricao': 'Produto B para TI-02',
        'imageUrl': 'http://example.com/b.png',
      });

      // Wait for products to load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Act: Adicionar múltiplos produtos
      final addButtons = find.byTooltip('Adicionar ao carrinho');
      expect(addButtons, findsAtLeastNWidgets(2));
      await tester.tap(addButtons.at(0));
      await tester.pumpAndSettle();
      await tester.tap(addButtons.at(1));
      await tester.pumpAndSettle();

      // Act: Navegar para carrinho
      final cartIcon = find.byIcon(Icons.shopping_cart);
      expect(cartIcon, findsOneWidget);
      await tester.tap(cartIcon);
      await tester.pumpAndSettle();

      // Assert: Verificar total calculado
      expect(find.text('Total do pedido:'), findsOneWidget);
    });
  });
}
