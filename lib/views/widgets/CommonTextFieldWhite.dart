import 'package:flutter/material.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonTextFieldWhite extends StatefulWidget {
  final String hint;
  final Icon prefixIcon;
  final bool needPasswordSuffixIcon;
  final bool needprefixIcon;
  final TextEditingController controller;
  final TextInputType inputType;
  final String errorText;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Function()? onTapOutside;

  const CommonTextFieldWhite({
    super.key,
    required this.hint,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
    required this.errorText,
    required this.controller,
    required this.prefixIcon,
    required this.inputType,
    required this.needPasswordSuffixIcon,
    required this.needprefixIcon,
  });

  @override
  State<CommonTextFieldWhite> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextFieldWhite> {
  late bool _isPasswordHidden;

  @override
  void initState() {
    super.initState();
    _isPasswordHidden = true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 19.w),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.inputType,
        maxLines: 1,
        onChanged: widget.onChanged,
        obscureText: widget.needPasswordSuffixIcon ? _isPasswordHidden : false,
        obscuringCharacter: "*",
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Field cannot be empty!";
          } else if (value.length < 3) {
            return "Must be at least 3 characters long!";
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: widget.hint,
          errorText: widget.errorText.isEmpty ? null : widget.errorText,

          // ERROR BORDER
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              width: 2.w,
              color: Colors.red.withOpacity(0.7),
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              width: 2.w,
              color: Colors.red.withOpacity(0.7),
            ),
          ),

          filled: true,
          fillColor: widget.errorText.isEmpty
              ? const Color(MyColors.whiteColor)
              : Colors.red.withOpacity(0.12),

          // TEXT STYLE
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16.sp,
            color: const Color(0x66000000),
            fontWeight: FontWeight.w400,
          ),

          prefixIcon: widget.needprefixIcon ? widget.prefixIcon : null,
          prefixIconColor: const Color(0x66000000),

          suffixIcon: widget.needPasswordSuffixIcon
              ? IconButton(
                  icon: Icon(
                    _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                    size: 22.sp,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordHidden = !_isPasswordHidden;
                    });
                  },
                )
              : null,
          suffixIconColor: const Color(0x66000000),

          // INNER PADDING
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),

          // NORMAL BORDER
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              width: 2.w,
              color: const Color(MyColors.fieldBorderColor),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              width: 2.w,
              color: const Color(MyColors.fieldBorderColor),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              width: 2.w,
              color: const Color(MyColors.fieldBorderColor),
            ),
          ),
        ),
      ),
    );
  }
}
