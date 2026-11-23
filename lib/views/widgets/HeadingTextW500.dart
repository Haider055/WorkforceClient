import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeadingTextW500 extends StatelessWidget {
  final String text;
  final bool centerAlign;
  final double size;
  final double minSize;
  const HeadingTextW500(
      {required this.text,
      required this.centerAlign,
      required this.size,
      required this.minSize,
      super.key});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(text,
        minFontSize: minSize,
        maxFontSize: size,
        textAlign: centerAlign ? TextAlign.center : TextAlign.start,
        style: TextStyle(
            color: Colors.black,
            fontSize: size.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins'));
  }
}
