import 'package:flutter/material.dart';

void showSnack(BuildContext context, String message,
    {Color? backgroundColor}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ),
  );
}

