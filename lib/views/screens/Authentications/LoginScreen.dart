import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workforceclientapp/Controllers/LoginContoller.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/CommonTextField.dart';
import 'package:workforceclientapp/views/widgets/HeadingText.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButton.dart';
import 'package:get/get.dart';

class LoginScreen extends GetView<LoginContoller> {
  LoginScreen({super.key});
  final data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // if (FocusScope.of(context).hasFocus) {
        //   FocusScope.of(context).unfocus(); // Close keyboard
        //   return false;
        // }
        if (Constants.fromWhere == "SelectServiceScreen") {
          Get.offAllNamed(AppLinks.select_service_screen);
        } else {
          Get.offAllNamed(AppLinks.select_service_screen);
        }
        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(Get.context!).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: AutofillGroup(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: SvgPicture.asset(
                          "lib/assets/icons/auftragnowRedBalck.svg",
                          fit: BoxFit.contain,
                        ),
                      ),
                      Center(
                        child: Image.asset(
                          "lib/assets/images/loginScreenImage.png",
                          fit: BoxFit.contain,
                          height: 305.0.h,
                          width: 227.0.w,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: HeadingText(
                            text: Strings.loginText(context),
                            centerAlign: true),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 25.0.w, top: 10.0.h),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Headingdescription(
                              text: Strings.loginDesc(context),
                              centerAlign: false,
                              size: 13.0.sp),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0.h),
                        child: CommonTextField(
                            hint: Strings.emailAddressText(context),
                            errorText: controller.emailAddressErrorText.value,
                            controller: controller.emailTextField(),
                            inputType: TextInputType.emailAddress,
                            prefixIcon: const Icon(Icons.email_outlined),
                            needPasswordSuffixIcon: false,
                            needprefixIcon: true,
                            onChanged: (value) {
                              controller.emailAddressErrorText.value = "";
                            }),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16.0.h),
                        child: CommonTextField(
                          hint: Strings.passwordText(context),
                          errorText: controller.passwordErrorText.value,
                          inputType: TextInputType.visiblePassword,
                          controller: controller.passwordTextField(),
                          prefixIcon: const Icon(Icons.lock_outline),
                          needPasswordSuffixIcon: true,
                          needprefixIcon: true,
                          onChanged: (value) {
                            if (controller.passwordErrorText.value.isNotEmpty) {
                              controller.passwordErrorText.value = "";
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 22.0.w, top: 8.0.h),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(AppLinks.forgot_password_screen);
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              style: TextStyle(
                                  fontSize: 14.0.sp,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins'),
                              "${Strings.forgotPasswordText(context)} ?",
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40.0.h),
                        child: FullWidthButton(
                          text: Strings.loginText(context),
                          color: MyColors.themeRedColor,
                          onPressed: () async {
                            controller.pleaseValidateData();
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0.h),
                        child: Align(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${Strings.newUserText(Get.context!)}? ",
                                  style: TextStyle(
                                      fontSize: 14.0.sp,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins')),
                              GestureDetector(
                                onTap: () {
                                  controller.emailTextField.value.text = "";
                                  controller.passwordTextField.value.text = "";
                                  Get.toNamed(AppLinks.signup_screen);
                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    style: TextStyle(
                                        color: const Color(0xFFD60107),
                                        fontSize: 14.0.sp,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins'),
                                    Strings.signupText(Get.context!),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
