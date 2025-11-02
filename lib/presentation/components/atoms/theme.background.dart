import 'package:flutter/material.dart';

class ThemeBackground extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const ThemeBackground({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: padding,
      child: child,
    );
  }
}
