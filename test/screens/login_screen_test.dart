import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:feiragreen_flutter/presentation/pages/login_screen.dart';

void main() {
  setUpAll(() async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    binding.window.physicalSizeTestValue = const Size(1280, 1024);
    binding.window.devicePixelRatioTestValue = 1.0;
  });

  tearDownAll(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    binding.window.clearPhysicalSizeTestValue();
    binding.window.clearDevicePixelRatioTestValue();
  });

  testWidgets('TW-01: Deve exibir erro ao submeter campos vazios',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(MediaQuery(
      data: const MediaQueryData(textScaleFactor: 0.7),
      child: const MaterialApp(home: LoginScreen()),
    ));

    // Act: Tentar submeter sem preencher campos
    final submitButton = find.byType(ElevatedButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Assert: Verificar mensagens de erro
    expect(find.text('Por favor, insira o email'), findsOneWidget);
    expect(find.text('Por favor, insira a senha'), findsOneWidget);
  });

  testWidgets('TW-02: Deve exibir erro para email inválido',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(MediaQuery(
      data: const MediaQueryData(textScaleFactor: 0.7),
      child: const MaterialApp(home: LoginScreen()),
    ));

    // Act: Preencher email inválido e senha
    await tester.enterText(find.byType(TextFormField).first, 'invalido');
    await tester.enterText(find.byType(TextFormField).last, '123456');
    final submitButton = find.byType(ElevatedButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Assert: Verificar mensagem de erro de email
    expect(find.text('Email inválido'), findsOneWidget);
  });
}
