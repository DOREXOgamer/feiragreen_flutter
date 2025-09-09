import 'package:flutter/material.dart';
import 'package:feiragreen_flutter/screens/login_screen.dart';
import 'package:feiragreen_flutter/database/database_helper.dart';
import 'package:feiragreen_flutter/database/seed_data.dart';

// Notificador global para armazenar o tema atual
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  await SeedData.seedDatabase();
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
          
          //para remover a faixa de debug
          debugShowCheckedModeBanner: false,

          // Tema Claro
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.green,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.green,
              elevation: 2,
            ),
            cardTheme: const CardThemeData(
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
            colorScheme: ColorScheme.light(
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
          ),

          // Tema Escuro
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.green,
            scaffoldBackgroundColor: Colors.grey[900]!,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 2,
            ),
            cardTheme: CardThemeData(
              color: Colors.grey[800],
              surfaceTintColor: Colors.grey[800],
              elevation: 2,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
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
              labelStyle: TextStyle(color: Colors.white70),
              hintStyle: TextStyle(color: Colors.white60),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: Colors.grey[800],
              surfaceTintColor: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          themeMode: mode, // alterna entre claro/escuro

          home: const LoginScreen(),
        );
      },
    );
  }
}

//botão de alternância 
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
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
