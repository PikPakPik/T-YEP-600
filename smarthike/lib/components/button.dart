import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final double? width;
  final FontWeight? fontWeight;
  final Color? textColor;
  final VoidCallback? onPressed;
  final IconData? icon;

  const CustomButton(
      {super.key,
      required this.text,
      required this.backgroundColor,
      this.textColor,
      this.onPressed,
      this.icon,
      this.width,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: backgroundColor,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: width ?? 200,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: icon != null
              ? Row(children: [
                  Icon(icon),
                  Text(text,
                      style: TextStyle(
                          color: textColor ?? Colors.white,
                          fontSize: 16,
                          fontWeight: fontWeight ?? FontWeight.bold))
                ])
              : Text(text,
                  style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: 16,
                      fontWeight: fontWeight ?? FontWeight.bold)),
        ),
      ),
    );
  }
}
