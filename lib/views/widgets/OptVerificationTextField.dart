import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OptVerificationTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> callback;
  final int outlineTextColor;
  final FocusNode focusNode;

  const OptVerificationTextField(
      {super.key,
      required this.controller,
      required this.outlineTextColor,
      required this.callback,
      required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(4.0.r),
        child: SizedBox(
          width: 45.w, // Set width for rectangular box
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            cursorColor: Colors.black,
            showCursor: true,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1, // Allow only 1 digit
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              counterText: "", // Hide character counter
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0.r), // Rectangular shape
                borderSide:
                    BorderSide(color: Color(outlineTextColor), width: 1.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0.r),
                borderSide:
                    BorderSide(color: Color(outlineTextColor), width: 1.w),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0.r),
                  borderSide:
                      BorderSide(color: Color(outlineTextColor), width: 1.w)),
            ),
            onChanged: callback,
          ),
        ),
      ),
    );
  }
}
