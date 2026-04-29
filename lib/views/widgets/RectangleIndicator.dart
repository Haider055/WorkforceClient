import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Rectangleindicator extends StatelessWidget {
  final int color;
  final double size;
  const Rectangleindicator(
      {super.key, required this.size, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(bottom: 25.0.h, left: 5.0.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0.r),
          child: Container(
            width: size.toDouble().w,
            height: 6.5.h,
            color: Color(color),
          ),
        ),
      ),
    );
  }
}
