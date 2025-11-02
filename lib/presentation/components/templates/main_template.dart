import 'package:flutter/material.dart';
import 'package:feiragreen_flutter/presentation/components/organisms/custom_app_bar.dart';

class MainTemplate extends StatelessWidget {
  final Widget body;
  final String title;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onCartPressed;
  final VoidCallback? onProfilePressed;
  final int cartItemCount;
  final Color? backgroundColor;

  const MainTemplate({
    super.key,
    required this.body,
    required this.title,
    this.onSearchPressed,
    this.onCartPressed,
    this.onProfilePressed,
    this.cartItemCount = 0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title,
        onSearchPressed: onSearchPressed,
        onCartPressed: onCartPressed,
        onProfilePressed: onProfilePressed,
        cartItemCount: cartItemCount,
      ),
      body: body,
      backgroundColor: backgroundColor ?? Colors.grey[50],
    );
  }
}
