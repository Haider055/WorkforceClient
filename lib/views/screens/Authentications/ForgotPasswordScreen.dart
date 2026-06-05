import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workforceclientapp/Controllers/ForgotPasswordContoller.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/CommonTextField.dart';
import 'package:workforceclientapp/views/widgets/HeadingText.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';
import 'package:workforceclientapp/views/widgets/RedClickableText.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButton.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordContoller> {
  const ForgotPasswordScreen({super.key});

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: EdgeInsets.only(top: 40.0.h, left: 12.0.w),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "lib/assets/icons/bckTwoarrows.svg",
                      height: 14.h,
                      width: 14.w,
                      fit: BoxFit.contain,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 6.0.w),
                      child: Headingdescription(
                          text: Strings.goBackText(Get.context!),
                          centerAlign: false,
                          size: 12.sp),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "lib/assets/images/forgot_password_image.png",
                        fit: BoxFit.contain,
                        height: 252.0.h,
                        width: 167.5.w,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: HeadingText(
                          text: Strings.forgotPasswordText(context),
                          centerAlign: true),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25.0.w, top: 6.0.h),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Headingdescription(
                          text: Strings.forgotPasswordDescText(context),
                          centerAlign: false,
                          size: 13.8.sp,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25.0.w, top: 25.0.h),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          Strings.pleaseEnterYourEmailText(context),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.5.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0.h),
                      child: CommonTextField(
                          errorText: controller.emailAddressErrorText.value,
                          hint: Strings.emailAddressText(context),
                          inputType: TextInputType.emailAddress,
                          controller: controller.emailTextField(),
                          prefixIcon: const Icon(null),
                          needPasswordSuffixIcon: false,
                          needprefixIcon: false),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40.0.h),
                      child: FullWidthButton(
                        text: Strings.sendCodeText(context),
                        color: MyColors.themeRedColor,
                        onPressed: () async {
                          if (controller.emailTextField.value.text.isNotEmpty) {
                            if (Commons.isValidEmail(
                                controller.emailTextField.value.text)) {
                              Commons.showProgressDialog(context);
                              String res = await controller.pleaseSendOTP(
                                  controller.emailTextField.value.text);
                              Commons.hideProgressDialog();
                              if (res == "success") {
                                Get.toNamed(AppLinks.otp_verification_screen,
                                    arguments: {
                                      "email":
                                          controller.emailTextField.value.text,
                                      "fromWhere": "forgotPassword"
                                    });
                              } else {
                                controller.pleaseShowDialog(res);
                              }
                            } else {
                              controller.emailAddressErrorText.value =
                                  Strings.pleaseEnterValidEmail(Get.context!);
                            }
                          } else {
                            controller.emailAddressErrorText.value =
                                Strings.emailCannotBeEmptyText(Get.context!);
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Headingdescription(
                              text:
                                  "${Strings.rememberPasswordText(context)} + ?",
                              centerAlign: false,
                              size: 14.0.sp),
                          SizedBox(
                            width: 4.0.w,
                          ),
                          RedClickableText(
                            text: Strings.loginText(context),
                            size: 14.0.sp,
                            callback: () {
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
