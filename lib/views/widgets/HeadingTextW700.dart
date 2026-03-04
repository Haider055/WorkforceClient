import 'package:flutter/material.dart';

class HeadingTextW700 extends StatelessWidget {
  final String text;
  final bool centerAlign;
  final double size;
  const HeadingTextW700(
      {required this.text, required this.centerAlign, required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Text(text,
            textAlign: centerAlign ? TextAlign.center : TextAlign.start,
            style: TextStyle(
                color: Colors.black,
                fontSize: size,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins')),
      ),
    );
  }
}
