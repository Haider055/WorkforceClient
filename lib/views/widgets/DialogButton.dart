import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workforceclientapp/Others/MyColors.dart';

class DialogButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final int color;

  const DialogButton(
      {super.key,
      required this.text,
      required this.color,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160.w,
      height: 35.h,
      child: Padding(
        padding: EdgeInsets.only(left: 28.w, right: 28.w),
        child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Color(color)),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          child: AutoSizeText(
            text,
            maxLines: 1,
            minFontSize: 9,
            maxFontSize: 13,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: const Color(MyColors.whiteColor),
                fontSize: 13.0.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
