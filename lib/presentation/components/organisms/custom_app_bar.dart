import 'package:flutter/material.dart';
import 'package:feiragreen_flutter/main.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showLogo;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onCartPressed;
  final VoidCallback? onProfilePressed;
  final VoidCallback? onAddressPressed;
  final int cartItemCount;
  final bool showThemeToggle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showLogo = true,
    this.onSearchPressed,
    this.onCartPressed,
    this.onProfilePressed,
    this.onAddressPressed,
    this.cartItemCount = 0,
    this.showThemeToggle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          Theme.of(context).appBarTheme.backgroundColor ?? Colors.transparent,
      elevation: 0,
      title: showLogo
          ? Row(
              children: [
                Image.asset(
                  'assets/imagens/LogoFeiraGreen.png',
                  height: 35,
                ),
                const SizedBox(width: 8),
              ],
            )
          : Text(title),
      actions: [
        // Botão de alternância de tema
        if (showThemeToggle)
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

        // Botão de busca
        if (onSearchPressed != null)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: onSearchPressed,
          ),

        // Botão do carrinho com badge
        if (onCartPressed != null)
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: onCartPressed,
              ),
              if (cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      cartItemCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),

        // Botão de perfil
        if (onProfilePressed != null)
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: onProfilePressed,
          ),

        // Botão de endereço
        if (onAddressPressed != null)
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: onAddressPressed,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
