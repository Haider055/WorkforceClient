import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/AccountSuspendedController.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class AccountSuspendedScreen extends GetView<AccountSuspendedController> {
  const AccountSuspendedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        // Block system back — user must use the Login button.
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Icon(
                  Icons.block,
                  size: 90.sp,
                  color: const Color(MyColors.themeRedColor),
                ),
                SizedBox(height: 24.h),
                HeadingTextW600(
                  text: "Account Suspended",
                  centerAlign: true,
                  size: 20.sp,
                ),
                SizedBox(height: 12.h),
                Headingdescription(
                  text:
                      "Your account has been suspended due to a violation of our terms of service. If you believe this is a mistake, please contact our support team.",
                  centerAlign: true,
                  size: 14.sp,
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0.h),
                  child: FullWidthButtonPrimary(
                    text: "Login",
                    fontsize: 15.0.sp,
                    color: MyColors.themeRedColor,
                    onPressed: () {
                      controller.goToLogin();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
