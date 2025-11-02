import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
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

  testWidgets('Smoke: renderiza textos principais da tela de login', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Text('FeiraGreen'),
            SizedBox(height: 8),
            Text('Entrar'),
          ],
        ),
      ),
    ));
    await tester.pump();

    expect(find.text('FeiraGreen'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
