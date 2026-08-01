import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/ManageAccountController.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/screens/Profile/EnterPreviousPassword.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class ManageAccountScreen extends GetView<ManageAccountController> {
  const ManageAccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width.w,
        leading: Card(
          color: const Color(MyColors.whiteColor),
          shadowColor: const Color.fromARGB(158, 219, 219, 219),
          elevation: 2,
          shape: const Border(
              bottom: BorderSide(
                  color: Color.fromARGB(147, 203, 203, 203),
                  style: BorderStyle.solid)),
          child: Center(
            child: Stack(
              children: [
                Center(
                    child: HeadingTextW600(
                  text: Strings.manageAccount(context),
                  centerAlign: false,
                  size: 16.0.sp,
                )),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 12.0.w),
                    child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.arrow_back_ios)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color(MyColors.whiteColor),
      body: Obx(() {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 16.0.w, right: 16.0.w, bottom: 16.0.h, top: 16.0.h),
              child: Card(
                elevation: 0,
                color: const Color(MyColors.cardGrayColor100),
                child: Column(
                  children: [
                    // Manage Password
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16.0.w, right: 16.0.w, top: 16.0.h),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(
                            const EnterPreviousPassword(),
                            transition: Transition
                                .rightToLeft, // Left-to-right animation
                            duration: const Duration(
                                milliseconds:
                                    500), // Optional: animation duration
                          );
                        },
                        child: Card(
                          elevation: 0,
                          color: const Color(MyColors.whiteColor),
                          child: Padding(
                            padding: EdgeInsets.all(14.0.r),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "lib/assets/icons/keyIcon.svg",
                                  height: 18,
                                  width: 18,
                                  fit: BoxFit.contain,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0.w),
                                  child: Headingdescription(
                                      text: Strings.managePassword(context),
                                      centerAlign: false,
                                      size: 16.sp),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: const Color(MyColors.blackColor80),
                                      size: 16.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                          left: 16.0.w,
                          right: 16.0.w,
                          bottom: 8.0.h,
                          top: 8.0.h),
                      child: Card(
                        elevation: 0,
                        color: const Color(MyColors.whiteColor),
                        child: Padding(
                          padding: EdgeInsets.all(14.0.r),
                          child: Row(
                            children: [
                              Icon(
                                Icons.verified_user_outlined,
                                size: 18.sp,
                                color: const Color(MyColors.blackColor80),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8.0.w),
                                child: Headingdescription(
                                    text: "Enable 2FA Verification",
                                    centerAlign: false,
                                    size: 14.3.sp),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Switch(
                                    value: controller.isTwoFAEnabled.value,
                                    activeThumbColor:
                                        const Color(MyColors.themeRedColor),
                                    onChanged: (value) async {
                                      controller.isTwoFAEnabled.value = value;
                                      Commons.showProgressDialog(context);
                                      await controller
                                          .pleaseChange2FAStatus(value);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16.0.w,
                          right: 16.0.w,
                          bottom: 16.0.h,
                          top: 8.0.h),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(AppLinks.delete_account_screen);
                        },
                        child: Card(
                          elevation: 0,
                          color: const Color(MyColors.whiteColor),
                          child: Padding(
                            padding: EdgeInsets.all(14.0.r),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "lib/assets/icons/profile_deleteIcon.svg",
                                  height: 20.h,
                                  width: 20.w,
                                  fit: BoxFit.contain,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0.w),
                                  child: Text(Strings.deleteAccount(context),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: const Color(
                                              MyColors.themeRedColor),
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Poppins')),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: const Color(MyColors.blackColor80),
                                      size: 16.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
