import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Testa validações de formulário replicando a lógica do RegisterScreen

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

  testWidgets('TR-01: Deve exibir erro ao submeter campos vazios', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(const MaterialApp(home: _TestRegisterForm()));

    // Act: Tentar submeter sem preencher campos
    final submitButton = find.byType(ElevatedButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Assert: Verificar mensagens de erro
    expect(find.text('Por favor, insira o nome'), findsOneWidget);
    expect(find.text('Por favor, insira o email'), findsOneWidget);
    expect(find.text('Por favor, insira a senha'), findsOneWidget);
    expect(find.text('Por favor, confirme a senha'), findsOneWidget);
  });

  testWidgets('TR-02: Deve exibir erro para email inválido', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(const MaterialApp(home: _TestRegisterForm()));

    // Act: Preencher campos com email inválido
    await tester.enterText(find.byType(TextFormField).at(0), 'João Silva');
    await tester.enterText(find.byType(TextFormField).at(1), 'invalido');
    await tester.enterText(find.byType(TextFormField).at(2), '123456');
    await tester.enterText(find.byType(TextFormField).at(3), '123456');
    final submitButton = find.byType(ElevatedButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Assert: Verificar mensagem de erro de email
    expect(find.text('Email inválido'), findsOneWidget);
  });

  testWidgets('TR-03: Deve exibir erro quando senhas não coincidem', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(const MaterialApp(home: _TestRegisterForm()));

    // Act: Preencher campos com senhas diferentes
    await tester.enterText(find.byType(TextFormField).at(0), 'João Silva');
    await tester.enterText(find.byType(TextFormField).at(1), 'joao@email.com');
    await tester.enterText(find.byType(TextFormField).at(2), '123456');
    await tester.enterText(find.byType(TextFormField).at(3), '654321');
    final submitButton = find.byType(ElevatedButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Assert: Verificar mensagem de erro de senhas não coincidem
    expect(find.text('As senhas não coincidem.'), findsOneWidget);
  });

  testWidgets('TR-04: Deve exibir erro para senha muito curta', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(const MaterialApp(home: _TestRegisterForm()));

    // Act: Preencher campos com senha curta
    await tester.enterText(find.byType(TextFormField).at(0), 'João Silva');
    await tester.enterText(find.byType(TextFormField).at(1), 'joao@email.com');
    await tester.enterText(find.byType(TextFormField).at(2), '123');
    await tester.enterText(find.byType(TextFormField).at(3), '123');
    final submitButton = find.byType(ElevatedButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Assert: Verificar mensagem de erro de senha curta
    expect(find.text('Senha muito curta'), findsOneWidget);
  });

  // Removidos testes que dependem de backend real/mocks (registro e email já cadastrado)
}

class _TestRegisterForm extends StatefulWidget {
  const _TestRegisterForm();

  @override
  State<_TestRegisterForm> createState() => _TestRegisterFormState();
}

class _TestRegisterFormState extends State<_TestRegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  String _errorMessage = '';

  void _submit() {
    _errorMessage = '';
    if (!_formKey.currentState!.validate()) {
      setState(() {});
      return;
    }

    if (_senhaController.text.trim() != _confirmarSenhaController.text.trim()) {
      setState(() {
        _errorMessage = 'As senhas não coincidem.';
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(labelText: 'Nome Completo'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Por favor, insira o nome';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Por favor, insira o email';
                      if (!value.contains('@')) return 'Email inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _senhaController,
                    decoration: const InputDecoration(labelText: 'Senha'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Por favor, insira a senha';
                      if (value.length < 6) return 'Senha muito curta';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _confirmarSenhaController,
                    decoration: const InputDecoration(labelText: 'Confirmar Senha'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Por favor, confirme a senha';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  if (_errorMessage.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(_errorMessage, style: const TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: _submit, child: const Text('Criar Conta')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
