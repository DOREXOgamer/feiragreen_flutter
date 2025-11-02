import 'package:flutter/material.dart';
import 'package:feiragreen_flutter/presentation/pages/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:feiragreen_flutter/infrastructure/logging/logger_service.dart';
import 'package:feiragreen_flutter/infrastructure/di/service_locator.dart';

// Notificador global para armazenar o tema atual
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

Future<void> main() async {
  // 1. Garante que o Flutter e os plugins estejam prontos antes de chamar qualquer código nativo.
  WidgetsFlutterBinding.ensureInitialized();
  // 2. Inicializa o Firebase (AGORA DENTRO da função 'main' que é 'async')
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("Firebase inicializado com sucesso.");
  } catch (e) {
    // Trata erros na inicialização do Firebase, como arquivos de configuração ausentes
    debugPrint("Erro ao inicializar o Firebase: $e");
    // Opcional: Você pode lançar uma exceção ou mostrar um erro de UI aqui se necessário.
  }

  // 3. Inicializa o logger e service locator
  final logger = LoggerService();
  await setupServiceLocator();
  logger.info('Application initialized successfully');

  // 4. Inicia o aplicativo Flutter
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Projeto Integrador',
          // Para remover a faixa de debug
          debugShowCheckedModeBanner: false,
          // Respeita o modo atual (claro/escuro) definido pelo themeNotifier
          themeMode: mode,

          // Tema Claro
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            primarySwatch: Colors.green,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.green,
              elevation: 2,
            ),
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Color(0xFF2E7D32),
              selectionHandleColor: Color(0xFF2E7D32),
              selectionColor: Color(0x332E7D32),
            ),
            dialogTheme: const DialogThemeData(
              // Corrigido: DialogThemeData em vez de DialogTheme
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
            cardTheme: const CardThemeData(
              // Corrigido: CardThemeData em vez de CardTheme
              color: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.black),
              bodyMedium: TextStyle(color: Colors.black87),
            ),
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              secondary: Colors.greenAccent,
              background: Colors.white,
              surface: Colors.white,
              onBackground: Colors.black,
              onSurface: Colors.black,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
            snackBarTheme: const SnackBarThemeData(
              backgroundColor: Colors.black87,
              contentTextStyle: TextStyle(color: Colors.white),
              behavior: SnackBarBehavior.floating,
            ),
          ),

          // Tema Escuro
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            primarySwatch: Colors.green,
            scaffoldBackgroundColor: Colors.grey[900]!,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 2,
            ),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.green[700],
              selectionHandleColor: Colors.green[700],
              selectionColor: Colors.green[700]!.withOpacity(0.35),
            ),
            dialogTheme: DialogThemeData(
              // Corrigido: DialogThemeData em vez de DialogTheme
              backgroundColor: Colors.grey[800],
              surfaceTintColor: Colors.grey[800],
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
            cardTheme: CardThemeData(
              // Corrigido: CardThemeData em vez de CardTheme
              color: Colors.grey[800],
              surfaceTintColor: Colors.grey[800],
              elevation: 2,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                  color: Colors
                      .white), // Corrigido: era Colors.grey[900]! (invisível em dark mode)
              bodyMedium: TextStyle(color: Colors.white70),
            ),
            colorScheme: ColorScheme.dark(
              primary: Colors.green[700]!,
              secondary: Colors.greenAccent,
              background: Colors.grey[900]!,
              surface: Colors.grey[800]!,
              onBackground: Colors.white,
              onSurface: Colors.white,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.green[700]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[600]!),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Color(0xFF2E7D32), width: 1.5),
              ),
            ),
            snackBarTheme: SnackBarThemeData(
              backgroundColor: Colors.grey[800],
              contentTextStyle: const TextStyle(color: Colors.white),
              behavior: SnackBarBehavior.floating,
            ),
          ),

          home: const LoginScreen(),
        );
      },
    );
  }
}

class ThemeSwitcherAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;

  const ThemeSwitcherAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: [
        // Botão de alternância de tema
        IconButton(
          icon: Icon(
            themeNotifier.value == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
          onPressed: () {
            themeNotifier.value = themeNotifier.value == ThemeMode.dark
                ? ThemeMode.light
                : ThemeMode.dark;
          },
        ),
        // Preserva ações passadas (corrigido: não ignorava mais this.actions)
        ...?actions ?? [],
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
