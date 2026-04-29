import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Skipandnexttext extends StatelessWidget {
  final String text;
  const Skipandnexttext({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(8.0.r),
        child: Text(text,
            style: TextStyle(
                color: Colors.black,
                fontSize: 16.0.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins')),
      ),
    );
  }
}
