import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onConfirmed;

  const ErrorDialog({
    Key? key,
    this.title = 'Erro',
    required this.message,
    this.onConfirmed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onConfirmed != null) {
              onConfirmed!();
            }
          },
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}

void showErrorDialog(BuildContext context, String message,
    {String title = 'Erro', VoidCallback? onConfirmed}) {
  showDialog(
    context: context,
    builder: (context) => ErrorDialog(
      title: title,
      message: message,
      onConfirmed: onConfirmed,
    ),
  );
}
