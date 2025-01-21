import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show(BuildContext context, String message,
      {bool isError = true}) {
    final color = isError ? Colors.red : Colors.green;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
