import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final IconData? icon;

  const CustomButton(
      {super.key,
      required this.text,
      required this.backgroundColor,
      this.onPressed,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: backgroundColor,
      onPressed: onPressed,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child:
            icon != null ? Row(children: [Icon(icon), Text(text)]) : Text(text),
      ),
    );
  }
}
