import 'package:flutter/material.dart';

class ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onClose;
  final bool dense;

  const ErrorBanner({
    super.key,
    required this.message,
    this.onClose,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;
    final bgColor = errorColor.withOpacity(0.12);
    final borderColor = errorColor.withOpacity(0.40);
    final textColor = theme.colorScheme.onErrorContainer;

    return Container(
      padding: EdgeInsets.all(dense ? 8 : 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(dense ? 8 : 12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: errorColor, size: dense ? 18 : 20),
          SizedBox(width: dense ? 6 : 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor),
            ),
          ),
          if (onClose != null) ...[
            SizedBox(width: 8),
            IconButton(
              onPressed: onClose,
              icon: Icon(Icons.close, color: errorColor),
              tooltip: 'Fechar',
            ),
          ],
        ],
      ),
    );
  }
}

