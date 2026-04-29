import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeadingText extends StatelessWidget {
  final String text;
  final bool centerAlign;

  const HeadingText({
    required this.text,
    required this.centerAlign,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Text(
        text,
        textAlign: centerAlign ? TextAlign.center : TextAlign.start,
        style: TextStyle(
          color: Colors.black,
          fontSize: 22.sp, // responsive font
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
