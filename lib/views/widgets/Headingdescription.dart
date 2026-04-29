import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Headingdescription extends StatelessWidget {
  final String text;
  final double size;
  final bool centerAlign;

  const Headingdescription({
    required this.text,
    required this.centerAlign,
    required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: centerAlign ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        color: Colors.black,
        fontSize: size.sp, // responsive font size
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
      ),
    );
  }
}
