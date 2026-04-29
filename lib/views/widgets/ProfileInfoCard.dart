import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class ProfileInfoCard extends StatelessWidget {
  final String text;
  final String icon;
  final VoidCallback onPressed;

  const ProfileInfoCard(
      {super.key,
      required this.text,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 0,
        color: const Color(MyColors.whiteColor),
        child: Padding(
          padding: EdgeInsets.all(12.0.r),
          child: Center(
              child: Row(
            children: [
              SvgPicture.asset(
                icon,
                height: 20.h,
                width: 20.w,
                fit: BoxFit.contain,
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: 12.0.r),
                child: Headingdescription(
                    text: text, centerAlign: false, size: 14.sp),
              )),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 18.0.sp,
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
