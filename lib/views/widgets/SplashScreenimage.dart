import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreenimage extends StatelessWidget {
  final String path;

  const SplashScreenimage({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        path,
        height: 357.0.h,
        width: 287.0.w,
      ),
    );
  }
}
