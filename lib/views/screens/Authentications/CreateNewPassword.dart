import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workforceclientapp/Controllers/CreateNewPasswordController.dart';
import 'package:workforceclientapp/Controllers/OPTVerificationController.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/screens/Authentications/OTPVerificationScreen.dart';
import 'package:workforceclientapp/views/widgets/CommonTextField.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButton.dart';
import 'package:get/get.dart';

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
        // Same layout as OTPVerificationScreen: back button and logo fixed
        // at the top, the form centred and scrollable below them.
        body: Column(
          children: [
            SizedBox(
              height: 50.h,
            ),
            GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Get.back();
                if (Get.isRegistered<OTPVerificationController>()) {
                  Get.find<OTPVerificationController>().pinController.clear();
                }
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
            Padding(
              padding: EdgeInsets.only(top: 32.0.h),
              child: SvgPicture.asset(
                "lib/assets/icons/auftragnowRedBalck.svg",
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 20.0.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          "lib/assets/images/createnewpasswordimage.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0.w, right: 20.0.w),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: HeadingTextW600(
                              text: Strings.createNewPasswordText(context),
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
                              text: Strings.createNewPasswordDescText(context),
                              centerAlign: false,
                              size: 15,
                              minSize: 11),
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
                                        value:
                                            controller.passwordStrength.value,
                                        color:
                                            controller.passwordStrength.value <
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
