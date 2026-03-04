import 'package:flutter/material.dart';

class HeadingTextW500 extends StatelessWidget {
  final String text;
  final bool centerAlign;
  final double size;
  const HeadingTextW500(
      {required this.text, required this.centerAlign, required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(text,
          textAlign: centerAlign ? TextAlign.center : TextAlign.start,
          style: TextStyle(
              color: Colors.black,
              fontSize: size,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins')),
    );
  }
}
