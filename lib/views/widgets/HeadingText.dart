import 'package:flutter/material.dart';

class HeadingText extends StatelessWidget {
  final String text;
  final bool centerAlign;
  const HeadingText({required this.text, required this.centerAlign, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Text(text,
            textAlign: centerAlign ? TextAlign.center : TextAlign.start,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins')),
      ),
    );
  }
}
