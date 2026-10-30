import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workforceclientapp/Others/MyColors.dart';

class FullWidthOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final int color;
  final double fontsize;

  const FullWidthOutlineButton(
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
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(MyColors.themeRedColor)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(6.r),
          child: AutoSizeText(
            text,
            maxLines: 1,
            minFontSize: 8,
            maxFontSize: fontsize,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: const Color(MyColors.themeRedColor),
                fontSize: fontsize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
