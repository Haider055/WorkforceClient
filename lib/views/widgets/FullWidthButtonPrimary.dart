import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FullWidthButtonPrimary extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final int color;
  final double fontsize;

  const FullWidthButtonPrimary(
      {super.key,
      required this.text,
      required this.color,
      required this.fontsize,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Color(color)),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)))),
          child: Padding(
            padding: EdgeInsets.all(6.r),
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fontsize.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500),
            ),
          ),
        ));
  }
}
