import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workforceclientapp/Controllers/CreateNewPasswordController.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/widgets/CommonTextField.dart';
import 'package:workforceclientapp/views/widgets/HeadingText.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButton.dart';
import 'package:get/get.dart';

// ---------------------------------------------------------------------
// Uses the same new field as UpdatePasswordScreen:
//
//     RxString passwordInput = "".obs;
//
// in CreateNewPasswordController. Add it once and both screens work.
// ---------------------------------------------------------------------

class CreateNewPassword extends GetView<CreateNewPasswordController> {
  const CreateNewPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
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
                        "lib/assets/images/createnewpasswordimage.png",
                        fit: BoxFit.contain,
                        height: 304.0.h,
                        width: 190.0.w,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: HeadingText(
                          text: Strings.createNewPasswordText(context),
                          centerAlign: true),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25.0.w, top: 7.0.h),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Headingdescription(
                            text: Strings.createNewPasswordDescText(context),
                            centerAlign: false,
                            size: 14.0.sp),
                      ),
                    ),

                    // errorText read .value with no Obx around it, so it
                    // never repainted.
                    Padding(
                      padding: EdgeInsets.only(top: 40.0.h),
                      child: Obx(() {
                        return CommonTextField(
                          errorText: controller.passErrorText.value,
                          hint: Strings.passwordText(context),
                          controller: controller.passwordTextField(),
                          inputType: TextInputType.visiblePassword,
                          prefixIcon: const Icon(Icons.lock_outline),
                          needPasswordSuffixIcon: true,
                          onChanged: (value) {
                            controller.passErrorText.value = "";
                            controller.showPasswordRules.value = true;

                            // Drives the rules below. Reading
                            // passwordTextField.value.text inside the Obx
                            // does NOT work — that Rx only fires when the
                            // TextEditingController OBJECT is replaced,
                            // never when its text changes.
                            controller.passwordInput.value = value;

                            controller.checkPasswordStrength(value);
                          },
                          needprefixIcon: true,
                        );
                      }),
                    ),

                    // This whole block had no Obx, so showPasswordRules
                    // could never make the rules appear at all.
                    Obx(() {
                      final pass = controller.passwordInput.value;

                      return controller.showPasswordRules.value
                          ? Padding(
                              padding: EdgeInsets.only(left: 18.0.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 8.0.w,
                                        right: 20.0.w,
                                        top: 12.0.h,
                                        bottom: 8.0.h),
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
                                  controller.passwordRule(
                                      Strings.atLeast8CharactersText(
                                          Get.context!),
                                      pass.length >= 10),
                                  controller.passwordRule(
                                      Strings.lowercaseText(Get.context!),
                                      RegExp(r'[a-z]').hasMatch(pass)),
                                  controller.passwordRule(
                                      Strings.uppercaseText(Get.context!),
                                      RegExp(r'[A-Z]').hasMatch(pass)),
                                  controller.passwordRule(
                                      "${Strings.specialSymbols(Get.context!)} (? # @ ...)",
                                      RegExp(r'[!@#\$&*~]').hasMatch(pass)),
                                  // Was labelled Strings.dataNotFound — this
                                  // row checks for digits.
                                  controller.passwordRule(
                                      Strings.numbers(Get.context!),
                                      RegExp(r'[0-9]').hasMatch(pass)),
                                ],
                              ),
                            )
                          : const SizedBox();
                    }),

                    Padding(
                      padding: EdgeInsets.only(top: 16.0.h),
                      child: Obx(() {
                        return CommonTextField(
                          errorText: controller.confirmPassErrorText.value,
                          hint: Strings.confirmPasswordText(context),
                          controller: controller.confirmPasswordTextField(),
                          inputType: TextInputType.visiblePassword,
                          prefixIcon: const Icon(Icons.lock_outline),
                          needPasswordSuffixIcon: true,
                          needprefixIcon: true,
                          onChanged: (value) {
                            controller.confirmPassErrorText.value = "";
                          },
                        );
                      }),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 40.0.h),
                      child: FullWidthButton(
                        text: Strings.createText(context),
                        color: MyColors.themeRedColor,
                        onPressed: () => _onCreate(context),
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

  Future<void> _onCreate(BuildContext context) async {
    final password = controller.passwordTextField.value.text;
    final confirm = controller.confirmPasswordTextField.value.text;

    if (password.isEmpty || confirm.isEmpty) {
      Fluttertoast.showToast(msg: Strings.cannotBeEmpty(context));
      return;
    }

    // There was NO match check here — two different passwords went straight
    // through to the API.
    if (password != confirm) {
      Fluttertoast.showToast(msg: Strings.passwordDoNotMatch(context));
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    try {
      Commons.showProgressDialog(context);
      await controller.pleaseResetPassword(controller.email.value);
    } catch (e) {
      debugPrint('pleaseResetPassword error: $e');
      // Fluttertoast.showToast(msg: Strings.somethingWentWrong(context))
    } finally {
      Commons.hideProgressDialog();
    }
  }
}
