import 'dart:io';
import 'package:flutter/material.dart';

class BaseBackIconButton extends StatelessWidget {
  const BaseBackIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: Icon(
        Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
        color: Colors.black,
      ),
    );
  }
}
