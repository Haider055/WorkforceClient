import 'package:flutter/material.dart';

class RedClickableText extends StatelessWidget {
  final String text;
  final double size;
  final GestureTapCallback callback;
  const RedClickableText(
      {super.key,
      required this.text,
      required this.size,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: callback,
        child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: const Color(0xFFD60107),
                fontSize: size,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins')),
      ),
    );
  }
}
