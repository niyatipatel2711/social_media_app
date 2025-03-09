import 'package:flutter/material.dart';

void baseError({required String errorText, required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        errorText,
        style: const TextStyle(color: Colors.white),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: Theme.of(context).primaryColor,
    ),
  );
}
