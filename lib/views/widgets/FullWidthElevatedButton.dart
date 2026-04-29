import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FullWidthElevatedButton extends StatelessWidget {
  final String text;
  final int color;
  final int textColor;
  final VoidCallback onPressed;

  const FullWidthElevatedButton(
      {super.key,
      required this.text,
      required this.color,
      required this.onPressed,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Color(color), // Button color
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(8.r), // Optional rounded corners
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp, // Adjust font size to fit inside
            color: Color(textColor), // Text color
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
