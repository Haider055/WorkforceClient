import 'package:auto_size_text/auto_size_text.dart';
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
        height: 48.h,
        child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Color(color)),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)))),
          child: Padding(
            padding: EdgeInsets.all(5.r),
            child: AutoSizeText(
              text,
              maxLines: 1,
              minFontSize: 8,
              maxFontSize: fontsize,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fontsize,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500),
            ),
          ),
        ));
  }
}
