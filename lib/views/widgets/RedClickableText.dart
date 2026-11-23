import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return GestureDetector(
      onTap: callback,
      child: AutoSizeText(text,
          textAlign: TextAlign.center,
          minFontSize: 10,
          maxFontSize: size,
          style: TextStyle(
              color: const Color(0xFFD60107),
              fontSize: size,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins')),
    );
  }
}
