import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workforceclientapp/Controllers/ForgotPasswordContoller.dart';
import 'package:workforceclientapp/Controllers/LoginContoller.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/CommonTextField.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW500.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';
import 'package:workforceclientapp/views/widgets/RedClickableText.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButton.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordContoller> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(
              height: 50.h,
            ),
            GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Get.back();
              },
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 12.0.w),
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 5.w, right: 5.w, top: 2.5.w, bottom: 2.5.w),
                    decoration: BoxDecoration(
                      color: const Color(MyColors.lightSilverColor)
                          .withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: SvgPicture.asset(
                      "lib/assets/icons/goback_button.svg",
                      height: 19.h,
                      width: 30.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 20.0.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "lib/assets/images/forgot_password_image.png",
                        fit: BoxFit.contain,
                        height: 220.0.h,
                        width: 167.5.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20.0.w, right: 20.0.w, top: 16.0.h),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: HeadingTextW600(
                              text: Strings.forgotPasswordText(context),
                              centerAlign: false,
                              size: 24,
                              minSize: 20),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20.0.w, right: 20.0.w, top: 6.0.h),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Headingdescription(
                            text: Strings.forgotPasswordDescText(context),
                            centerAlign: false,
                            size: 13,
                            minSize: 10,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20.0.w, right: 20.0.w, top: 22.0.h),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            Strings.pleaseEnterYourEmailText(context),
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Obx(() {
                        return Padding(
                          padding: EdgeInsets.only(top: 12.0.h),
                          child: CommonTextField(
                              errorText: controller.emailAddressErrorText.value,
                              hint: Strings.emailAddressText(context),
                              inputType: TextInputType.emailAddress,
                              controller: controller.emailTextField(),
                              prefixIcon: const Icon(Icons.email_outlined),
                              needPasswordSuffixIcon: false,
                              onChanged: (value) {
                                controller.emailAddressErrorText.value = "";
                              },
                              needprefixIcon: true),
                        );
                      }),
                      Padding(
                        padding: EdgeInsets.only(top: 28.0.h),
                        child: FullWidthButton(
                          text: Strings.sendCodeText(context),
                          color: MyColors.themeRedColor,
                          onPressed: () async {
                            // Release the email field first, otherwise it
                            // still owns the keyboard when the OTP screen is
                            // pushed and it flashes open there.
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (controller
                                .emailTextField.value.text.isNotEmpty) {
                              if (Commons.isValidEmail(
                                  controller.emailTextField.value.text)) {
                                Commons.showProgressDialog(context);
                                String res = await controller.pleaseSendOTP(
                                    controller.emailTextField.value.text);
                                Commons.hideProgressDialog();
                                if (res == "success") {
                                  Get.toNamed(AppLinks.otp_verification_screen,
                                      arguments: {
                                        "email": controller
                                            .emailTextField.value.text,
                                        "fromWhere": "forgotPassword",
                                        "resend_available_at":
                                            Constants.resendAvailableAt
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
                            HeadingTextW500(
                                text:
                                    "${Strings.rememberPasswordText(Get.context!)}? ",
                                centerAlign: false,
                                size: 15,
                                minSize: 11),
                            SizedBox(
                              width: 4.0.w,
                            ),
                            GestureDetector(
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (Get.isRegistered<LoginContoller>()) {
                                  Get.find<LoginContoller>()
                                      .emailTextField
                                      .value
                                      .clear();
                                  Get.find<LoginContoller>()
                                      .passwordTextField
                                      .value
                                      .clear();
                                }
                                Get.back();
                              },
                              child: AutoSizeText(Strings.loginText(context),
                                  maxFontSize: 15,
                                  minFontSize: 11,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
