import 'package:flutter/material.dart';

class FullWidthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final int color;

  const FullWidthButton(
      {super.key,
      required this.text,
      required this.color,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 19.0, right: 19.0),
          child: TextButton(
            onPressed: onPressed,
            style: ButtonStyle(
                shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
                padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
                backgroundColor: WidgetStateProperty.all<Color>(Color(color))),
            child: Padding(
              padding: const EdgeInsets.all(1.5),
              child: Text(
                text,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ));
  }
}
