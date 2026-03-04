import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final int color;

  const DialogButton(
      {super.key,
      required this.text,
      required this.color,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 160.0,
        height: 35.0,
        child: Padding(
          padding: const EdgeInsets.only(left: 28.0, right: 28.0),
          child: TextButton(
            onPressed: onPressed,
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Color(color))),
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.0,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500),
            ),
          ),
        ));
  }
}
