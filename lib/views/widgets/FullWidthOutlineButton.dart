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
          child: Text(
            text,
            style: TextStyle(
                color: const Color(MyColors.themeRedColor),
                fontSize: fontsize.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
