// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  VoidCallback buttonFunction;
  String buttonText;
  bool isLoading;
  bool isPressed;
  int pageNumber;
  CustomElevatedButton({
    super.key,
    required this.buttonFunction,
    required this.buttonText,
    required this.isPressed,
    required this.isLoading,
    required this.pageNumber
  });

  @override
  Widget build(BuildContext context) {

    bool disabled = (buttonText == "Back" && pageNumber == 1);

    return ElevatedButton(
      onPressed: buttonFunction,
      style: ButtonStyle(
        elevation: WidgetStatePropertyAll((isLoading || !isPressed) ? 1 : 0),
        backgroundColor: WidgetStatePropertyAll(disabled ? Colors.grey.shade600 : Colors.greenAccent.shade100)
      ),
      child: Text(buttonText),
    );
  }
}
