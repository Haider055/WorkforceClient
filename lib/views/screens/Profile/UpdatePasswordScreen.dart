import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/CreateNewPasswordController.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/CommonTextFieldWhite.dart';
import 'package:workforceclientapp/views/widgets/FullWidthElevatedButton.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW500.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';

class UpdatePasswordScreen extends GetView<CreateNewPasswordController> {
  const UpdatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(Get.context!).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            leadingWidth: MediaQuery.of(context).size.width.w,
            leading: Card(
              color: const Color(MyColors.whiteColor),
              shadowColor: const Color.fromARGB(158, 219, 219, 219),
              elevation: 0,
              shape: const Border(
                  bottom: BorderSide(
                      color: Color.fromARGB(147, 203, 203, 203),
                      style: BorderStyle.solid)),
              child: Center(
                child: Stack(
                  children: [
                    Center(
                        child: HeadingTextW600(
                      text: Strings.updatePassword(context),
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
          body: GestureDetector(
            onTap: () {
              FocusScope.of(Get.context!).unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(12.0.r),
                    child: Card(
                      elevation: 0,
                      color: const Color(MyColors.cardGrayColor100),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.0.w, top: 12.h),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: HeadingTextW500(
                                  text: Strings.newPasswordText(context),
                                  centerAlign: false,
                                  size: 16.sp),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12.0.h),
                            child: CommonTextFieldWhite(
                                hint: Strings.passwordText(context),
                                errorText: controller.passErrorText.value,
                                controller: controller.passwordTextField(),
                                inputType: TextInputType.text,
                                prefixIcon: const Icon(Icons.lock_outline),
                                needPasswordSuffixIcon: true,
                                needprefixIcon: true,
                                onChanged: (value) {
                                  controller.passErrorText.value = "";
                                  controller.showPasswordRules.value = true;
                                  _checkPasswordStrength(value);
                                }),
                          ),
                          Obx(() {
                            return controller.showPasswordRules.value
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 23.0.w,
                                            right: 23.0.w,
                                            top: 12.0.h),
                                        child: LinearProgressIndicator(
                                          value:
                                              controller.passwordStrength.value,
                                          color: controller
                                                      .passwordStrength.value <
                                                  0.4
                                              ? Colors.red
                                              : controller.passwordStrength
                                                          .value <
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
                                              right: 20.0.w, top: 4.h),
                                          child: Text(
                                            controller
                                                .passwordStrengthText.value,
                                            style: TextStyle(
                                              color: controller.passwordStrength
                                                          .value <
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
                                                controller.passwordTextField
                                                        .value.text.length >=
                                                    12),
                                            _passwordRule(
                                                Strings.lowercaseText(
                                                    Get.context!),
                                                RegExp(r'[a-z]').hasMatch(
                                                    controller.passwordTextField
                                                        .value.text)),
                                            _passwordRule(
                                                Strings.uppercaseText(
                                                    Get.context!),
                                                RegExp(r'[A-Z]').hasMatch(
                                                    controller.passwordTextField
                                                        .value.text)),
                                            _passwordRule(
                                                "${Strings.specialSymbols(Get.context!)} (? # @ ...)",
                                                RegExp(r'[!@#\$&*~]').hasMatch(
                                                    controller.passwordTextField
                                                        .value.text)),
                                            _passwordRule(
                                                Strings.specialSymbols(
                                                    Get.context!),
                                                RegExp(r'[0-9]').hasMatch(
                                                    controller.passwordTextField
                                                        .value.text)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox();
                          }),
                          Padding(
                            padding: EdgeInsets.only(left: 20.0.w, top: 12.h),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: HeadingTextW500(
                                  text: Strings.confirmPasswordText(context),
                                  centerAlign: false,
                                  size: 16.sp),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12.0.h),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: CommonTextFieldWhite(
                                  hint: Strings.confirmPasswordText(context),
                                  errorText: "",
                                  controller:
                                      controller.confirmPasswordTextField(),
                                  inputType: TextInputType.text,
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  needPasswordSuffixIcon: true,
                                  needprefixIcon: true,
                                  onChanged: (value) {
                                    // setState(() {
                                    //   emailAddressErrorText = "";
                                    // });
                                  }),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(20.0.r),
                            child: FullWidthElevatedButton(
                                text: Strings.updateText(context),
                                color: MyColors.themeRedColor,
                                onPressed: () async {
                                  try {
                                    if (controller.passwordTextField.value.text
                                            .isNotEmpty &&
                                        controller.confirmPasswordTextField
                                            .value.text.isNotEmpty) {
                                      if (!controller.showPasswordRules.value) {
                                        if (controller
                                                .passwordTextField.value.text ==
                                            controller.confirmPasswordTextField
                                                .value.text) {
                                          Commons.showProgressDialog(context);
                                          var res = await controller
                                              .pleaseUpdatePassword(
                                                  controller.prviousPassword);
                                          Commons.hideProgressDialog();
                                          if (res) {
                                            Get.offAllNamed(
                                                AppLinks.select_service_screen);
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: Strings
                                                  .confirmPasswordErrorText(
                                                      context));
                                        }
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: Strings.cannotBeEmpty(context));
                                    }
                                  } catch (e) {
                                    throw Exception(e);
                                  }
                                },
                                textColor: MyColors.whiteColor),
                          )
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

  void _checkPasswordStrength(String password) {
    double strength = 0;
    if (password.length >= 12) strength += 0.2;
    if (RegExp(r'[a-z]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[!@#\$&*~]').hasMatch(password)) strength += 0.2;

    controller.passwordStrength.value = strength;
    if (strength < 0.4) {
      controller.passwordStrengthText.value = Strings.weakText(Get.context!);
    } else if (strength < 0.8) {
      controller.passwordStrengthText.value =
          Strings.moderateText(Get.context!);
    } else if (strength < 1.0) {
      controller.passwordStrengthText.value = Strings.goodText(Get.context!);
    } else {
      controller.passwordStrengthText.value = Strings.strongText(Get.context!);
      controller.showPasswordRules.value = false;
    }
  }
}
