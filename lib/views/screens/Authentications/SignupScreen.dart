import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/SignupContoller.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/CommonTextField.dart';
import 'package:workforceclientapp/views/widgets/HeadingText.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';
import 'package:workforceclientapp/views/widgets/RedClickableText.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButton.dart';

class SignupScreen extends GetView<SignUpContoller> {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: GestureDetector(
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
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.95.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Center(
                      child: Image.asset(
                        "lib/assets/icons/Logo_black_red.png",
                        fit: BoxFit.fill,
                        height: 27.27.h,
                        width: 144.0.w,
                      ),
                    ),
                    SizedBox(height: 60.0.h),
                    Align(
                      alignment: Alignment.topLeft,
                      child: HeadingText(
                          text: Strings.registerText(context),
                          centerAlign: true),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 22.0.h),
                      child: CommonTextField(
                          errorText: controller.nameErrorText.value,
                          hint: Strings.fullNameAddressText(context),
                          controller: controller.nameTextField(),
                          inputType: TextInputType.name,
                          prefixIcon: const Icon(Icons.person_2_outlined),
                          needPasswordSuffixIcon: false,
                          onChanged: (value) {
                            controller.nameErrorText.value = "";
                          },
                          needprefixIcon: true),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0.h),
                      child: CommonTextField(
                          errorText: controller.emailAddressErrorText.value,
                          hint: Strings.emailAddressText(context),
                          controller: controller.emailTextField(),
                          inputType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.email_outlined),
                          needPasswordSuffixIcon: false,
                          onChanged: (value) {
                            controller.emailAddressErrorText.value = "";
                          },
                          needprefixIcon: true),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0.h),
                      child: CommonTextField(
                          errorText: controller.phoneErrorText.value,
                          hint:
                              "${Strings.phoneText(context)} (e.g. +491234567891",
                          controller: controller.phoneTextField(),
                          prefixIcon: const Icon(Icons.phone),
                          inputType: TextInputType.phone,
                          needPasswordSuffixIcon: false,
                          onChanged: (value) {
                            controller.phoneErrorText.value = "";
                          },
                          needprefixIcon: true),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0.h),
                      child: CommonTextField(
                          errorText: controller.passErrorText.value,
                          hint: Strings.passwordText(context),
                          controller: controller.passwordTextField(),
                          prefixIcon: const Icon(Icons.lock_outline),
                          inputType: TextInputType.visiblePassword,
                          needPasswordSuffixIcon: true,
                          onChanged: (pass) {
                            controller.passErrorText.value = "";
                            controller.showPasswordRules.value = true;
                            controller.checkPasswordStrength(pass);
                          },
                          needprefixIcon: true),
                    ),
                    Obx(() {
                      return controller.showPasswordRules.value
                          ? Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 23.0.w, right: 23.0.w, top: 12.0.h),
                                  child: LinearProgressIndicator(
                                    value: controller.passwordStrength.value,
                                    color: controller.passwordStrength.value <
                                            0.4
                                        ? Colors.red
                                        : controller.passwordStrength.value <
                                                0.8
                                            ? Colors.orange
                                            : Colors.green,
                                    minHeight: 4,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: 20.0.w, top: 4.0.h),
                                    child: Text(
                                      controller.passwordStrengthText.value,
                                      style: TextStyle(
                                        color:
                                            controller.passwordStrength.value <
                                                    0.4
                                                ? Colors.red
                                                : controller.passwordStrength
                                                            .value <
                                                        0.8
                                                    ? Colors.orange
                                                    : Colors.green,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 18.0.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _passwordRule(
                                          Strings.atLeast12CharactersText(
                                              Get.context!),
                                          controller.passwordTextField.value
                                                  .text.length >=
                                              12),
                                      _passwordRule(
                                          Strings.lowercaseText(Get.context!),
                                          RegExp(r'[a-z]').hasMatch(controller
                                              .passwordTextField.value.text)),
                                      _passwordRule(
                                          Strings.uppercaseText(Get.context!),
                                          RegExp(r'[A-Z]').hasMatch(controller
                                              .passwordTextField.value.text)),
                                      _passwordRule(
                                          "${Strings.specialSymbols(Get.context!)} (? # @ ...)",
                                          RegExp(r'[!@#\$&*~]').hasMatch(
                                              controller.passwordTextField.value
                                                  .text)),
                                      _passwordRule(
                                          Strings.numbers(Get.context!),
                                          RegExp(r'[0-9]').hasMatch(controller
                                              .passwordTextField.value.text)),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox();
                    }),
                    // Password Strength Rules
                    Padding(
                      padding: EdgeInsets.only(top: 16.0.h),
                      child: CommonTextField(
                          errorText: controller.confirmPassErrorText.value,
                          hint: Strings.confirmPasswordText(context),
                          controller: controller.confirmPasswordTextField(),
                          prefixIcon: const Icon(Icons.lock_outline),
                          inputType: TextInputType.visiblePassword,
                          onChanged: (value) {
                            controller.confirmPassErrorText.value = "";
                          },
                          needPasswordSuffixIcon: true,
                          needprefixIcon: true),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40.0.h),
                      child: FullWidthButton(
                        text: Strings.registerText(context),
                        color: MyColors.themeRedColor,
                        onPressed: () async {
                          pleaseValidateData();
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 18.0.h),
                      child: Headingdescription(
                          text: Strings.bycreatingaccountyouAgreetoourText(
                              Get.context!),
                          centerAlign: true,
                          size: 13.0.sp),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RedClickableText(
                          text: Strings.termsAndConditionText(Get.context!),
                          size: 13.5.sp,
                          callback: () {
                            Get.toNamed(AppLinks.terms_and_conditions);
                          },
                        ),
                        const SizedBox(
                          width: 4.0,
                        ),
                        Headingdescription(
                            text: "${Strings.and(Get.context!)} ",
                            centerAlign: false,
                            size: 13.0.sp),
                        SizedBox(
                          width: 4.0.w,
                        ),
                        RedClickableText(
                          size: 13.5.sp,
                          text: Strings.privacyPolicy(Get.context!),
                          callback: () {
                            Get.toNamed(AppLinks.privacy_policy);
                          },
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordRule(String text, bool isValid) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0.w),
      child: Row(
        children: [
          isValid
              ? Image.asset("lib/assets/icons/greentick.png",
                  height: 10.h, width: 10.w)
              : Image.asset("lib/assets/icons/graytick.png",
                  height: 10.h, width: 10.w),
          SizedBox(width: 5.w),
          Text(text,
              style: TextStyle(color: isValid ? Colors.green : Colors.grey)),
        ],
      ),
    );
  }

  Future<void> pleaseValidateData() async {
    if (controller.nameTextField.value.text.isEmpty) {
      controller.nameErrorText.value =
          Strings.nameCannotBeEmptyText(Get.context!);
    }
    if (controller.emailTextField.value.text.isEmpty) {
      controller.emailAddressErrorText.value =
          Strings.emailCannotBeEmptyText(Get.context!);
    }
    if (controller.phoneTextField.value.text.isEmpty) {
      controller.phoneErrorText.value =
          Strings.phoneCannotBeEmptyText(Get.context!);
    }
    if (controller.passwordTextField.value.text.isEmpty) {
      controller.passErrorText.value =
          Strings.passwordCannotBeEmptyText(Get.context!);
    }
    if (controller.confirmPasswordTextField.value.text.isEmpty) {
      controller.confirmPassErrorText.value =
          Strings.confirmPasswordCannotBeEmptyText(Get.context!);
    }
    if (controller.nameTextField.value.text.isNotEmpty &&
        controller.emailTextField.value.text.isNotEmpty &&
        controller.phoneTextField.value.text.isNotEmpty &&
        controller.passwordTextField.value.text.isNotEmpty &&
        controller.confirmPasswordTextField.value.text.isNotEmpty) {
      if (controller.nameTextField.value.text.length < 4) {
        controller.nameErrorText.value =
            Strings.nameMustBeAtLeast(Get.context!);
      } else if (!Commons.isValidEmail(
          controller.emailTextField.value.text.toString())) {
        controller.emailAddressErrorText.value =
            Strings.pleaseEnterValidEmail(Get.context!);
      } else if (!controller.phoneTextField.value.text
          .toString()
          .isPhoneNumber) {
        controller.phoneErrorText.value =
            Strings.pleaseEnterValidPhoneText(Get.context!);
      } else if (controller.passwordStrength.value < 0.8) {
        controller.passErrorText.value =
            Strings.pleaseFollowPasswordRules(Get.context!);
      } else if (controller.confirmPasswordTextField.value.text.toString() !=
          controller.passwordTextField.value.text.toString()) {
        controller.confirmPassErrorText.value =
            Strings.passwordDoNotMatch(Get.context!);
      } else {
        Commons.showProgressDialog(Get.context!);
        String res = await controller.pleaseRegisterUser();
        if (res != "") {
          Commons.hideProgressDialog();
          Get.defaultDialog(
            titleStyle: null,
            title: "",
            content: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        controller.dialogIconsUrl.value,
                        fit: BoxFit.contain,
                        height: 136.92.h,
                        width: 123.72.w,
                      )),
                ),
                HeadingText(
                    text: Strings.failedText(Get.context!), centerAlign: true),
                Headingdescription(
                    text: Strings.somethingWentWrong(Get.context!),
                    centerAlign: true,
                    size: 15.0.sp),
                Headingdescription(text: res, centerAlign: true, size: 15.0.sp),
                Padding(
                  padding: EdgeInsets.only(top: 18.0.h),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: const WidgetStatePropertyAll(
                              Color(MyColors.themeRedColor)),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)))),
                      onPressed: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 50.0.w, right: 50.0.w),
                        child: Container(
                          child: Center(
                              child: Text(
                            Strings.tryAgain(Get.context!),
                            style: const TextStyle(color: Colors.white),
                          )),
                        ),
                      )),
                ),
                SizedBox(height: 16.0.h)
              ],
            ),
          );
        } else {
          Commons.hideProgressDialog();
        }
      }
    }
  }
}
