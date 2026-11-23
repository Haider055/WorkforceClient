import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/SignupContoller.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/CommonTextField.dart';
import 'package:workforceclientapp/views/widgets/HeadingText.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';
import 'package:workforceclientapp/views/widgets/RedClickableText.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButton.dart';

class SignupScreen extends GetView<SignUpContoller> {
  const SignupScreen({super.key});

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
                  child: Obx(() {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.0.w),
                            child: HeadingTextW600(
                                text: Strings.registerText(context),
                                centerAlign: false,
                                size: 24,
                                minSize: 20),
                          ),
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
                          padding: EdgeInsetsGeometry.only(
                              top: 16.0.h, left: 19.0.w, right: 19.0.w),
                          child: TextFormField(
                            autofillHints: const [
                              AutofillHints.telephoneNumber
                            ],
                            controller: controller.phoneTextField(),
                            keyboardType: TextInputType.phone,
                            maxLines: 1,
                            maxLength: 10,
                            onChanged: (value) {
                              controller.phoneErrorText.value = "";
                            },
                            decoration: InputDecoration(
                              hintText: Strings.phoneText(context),
                              errorText: controller.phoneErrorText.value,
                              counterText: "",
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide(
                                    width: 2.w,
                                    color:
                                        const Color(MyColors.fieldBorderColor)),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide(
                                    width: 2.w,
                                    color:
                                        const Color(MyColors.fieldBorderColor)),
                              ),
                              filled: true,
                              fillColor: const Color(MyColors.lightSilverColor),
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14.sp,
                                color: const Color(0x66000000),
                                fontWeight: FontWeight.w400,
                              ),

                              // Country code picker on the left
                              prefixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Hardcoded to Germany (+49) for now.
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 16.w, right: 8.w),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "🇩🇪",
                                          style: TextStyle(fontSize: 18.sp),
                                        ),
                                        SizedBox(width: 6.w),
                                        Text(
                                          "+49",
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 24.h,
                                    width: 1,
                                    color: const Color(0x33000000),
                                  ),
                                  SizedBox(width: 8.w),
                                ],
                              ),
                              prefixIconConstraints: const BoxConstraints(
                                  minWidth: 0, minHeight: 0),

                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 14.h),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide(
                                    width: 2.w,
                                    color:
                                        const Color(MyColors.fieldBorderColor)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide(
                                    width: 2.w,
                                    color:
                                        const Color(MyColors.fieldBorderColor)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide(
                                    width: 2.w,
                                    color:
                                        const Color(MyColors.fieldBorderColor)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 0.0.h),
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
                                          left: 23.0.w,
                                          right: 23.0.w,
                                          top: 12.0.h),
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
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 20.0.w, top: 4.0.h),
                                        child: Text(
                                          controller.passwordStrengthText.value,
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
                                              Strings.atLeast8CharactersText(
                                                  Get.context!),
                                              controller.passwordTextField.value
                                                      .text.length >=
                                                  10),
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
                                              Strings.numbers(Get.context!),
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
                          padding: EdgeInsets.only(top: 18.0.h, left: 23.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Obx(() => SizedBox(
                                    width: 24.w,
                                    height: 24.h,
                                    child: Checkbox(
                                      value: controller.agreeToTerms.value,
                                      activeColor:
                                          const Color(MyColors.themeRedColor),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                      ),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      onChanged: (val) => controller
                                          .agreeToTerms.value = val ?? false,
                                    ),
                                  )),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 8.0.w),
                                      child: AutoSizeText(
                                        '${Strings.bycreatingaccountyouAgreetoourText(Get.context!)}',
                                        maxLines: 2,
                                        minFontSize: 10,
                                        maxFontSize: 15,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    RedClickableText(
                                      text: Strings.termsAndConditionText(
                                          Get.context!),
                                      size: 15,
                                      callback: () {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        Get.toNamed(
                                            AppLinks.legal_detail_screen,
                                            arguments: {
                                              'slug': 'terms-services',
                                              'title':
                                                  Strings.termsAndConditionText(
                                                      context),
                                              'url':
                                                  '${Constants.baseUrl}/legal/terms-services',
                                            });
                                      },
                                    ),
                                    AutoSizeText(
                                      ' ${Strings.and(Get.context!)} ',
                                      maxLines: 1,
                                      minFontSize: 10,
                                      maxFontSize: 15,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    RedClickableText(
                                      size: 15,
                                      text: Strings.privacyPolicy(Get.context!),
                                      callback: () {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        Get.toNamed(
                                            AppLinks.legal_detail_screen,
                                            arguments: {
                                              'slug': 'privacy-policy',
                                              'title': Strings.privacyPolicy(
                                                  Get.context!),
                                              'url':
                                                  '${Constants.baseUrl}/legal/privacy-policy',
                                            });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0.h),
                          child: FullWidthButton(
                            text: Strings.registerText(context),
                            color: MyColors.themeRedColor,
                            onPressed: () async {
                              pleaseValidateData();
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoSizeText(
                                ' ${Strings.alreadyHaveAnAccountText(Get.context!)} ',
                                maxLines: 1,
                                minFontSize: 10,
                                maxFontSize: 14,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 15),
                              ),
                              RedClickableText(
                                size: 14,
                                text: Strings.loginText(Get.context!),
                                callback: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
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
      Fluttertoast.showToast(msg: Strings.nameCannotBeEmptyText(Get.context!));
      return;
    }
    if (controller.emailTextField.value.text.isEmpty) {
      Fluttertoast.showToast(msg: Strings.emailCannotBeEmptyText(Get.context!));
      return;
    }
    if (controller.phoneTextField.value.text.isEmpty) {
      Fluttertoast.showToast(msg: Strings.phoneCannotBeEmptyText(Get.context!));
      return;
    }
    if (controller.passwordTextField.value.text.isEmpty) {
      Fluttertoast.showToast(
          msg: Strings.passwordCannotBeEmptyText(Get.context!));
      return;
    }
    if (controller.confirmPasswordTextField.value.text.isEmpty) {
      Fluttertoast.showToast(
          msg: Strings.confirmPasswordCannotBeEmptyText(Get.context!));
      return;
    }
    if (controller.passwordTextField.value.text.length < 8) {
      Fluttertoast.showToast(
          msg: Strings.passwordCannotBeLessthan8charactersText(Get.context!));
      return;
    }
    if (controller.nameTextField.value.text.isNotEmpty &&
        controller.emailTextField.value.text.isNotEmpty &&
        controller.phoneTextField.value.text.isNotEmpty &&
        controller.passwordTextField.value.text.isNotEmpty &&
        controller.confirmPasswordTextField.value.text.isNotEmpty) {
      if (controller.nameTextField.value.text.length < 4) {
        Fluttertoast.showToast(msg: Strings.nameMustBeAtLeast(Get.context!));
      } else if (!Commons.isValidEmail(
          controller.emailTextField.value.text.toString())) {
        Fluttertoast.showToast(
            msg: Strings.pleaseEnterValidEmail(Get.context!));
      } else if (!controller.phoneTextField.value.text
          .toString()
          .isPhoneNumber) {
        Fluttertoast.showToast(
            msg: Strings.pleaseEnterValidPhoneText(Get.context!));
      } else if (controller.passwordStrength.value < 0.8) {
        Fluttertoast.showToast(
            msg: Strings.pleaseFollowPasswordRules(Get.context!));
      } else if (controller.confirmPasswordTextField.value.text.toString() !=
          controller.passwordTextField.value.text.toString()) {
        Fluttertoast.showToast(msg: Strings.passwordDoNotMatch(Get.context!));
      } else {
        if (!controller.agreeToTerms.value) {
          Fluttertoast.showToast(
              msg:
                  Strings.pleaseagreeToOurTermsAndConditionsText(Get.context!));
          return;
        }

        FocusManager.instance.primaryFocus?.unfocus();
        Commons.showProgressDialog(Get.context!);
        String res = await controller.pleaseRegisterUser();
        if (res != "") {
          Commons.hideProgressDialog();
          // Plain Dialog, not Get.defaultDialog: AlertDialog's IntrinsicWidth
          // can't measure Headingdescription (AutoSizeText -> LayoutBuilder),
          // which broke the dialog and made the screen look frozen.
          Get.dialog(
            Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0.w, 24.0.h, 16.0.w, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                        text: Strings.failedText(Get.context!),
                        centerAlign: true),
                    Headingdescription(
                        text: Strings.somethingWentWrong(Get.context!),
                        centerAlign: true,
                        size: 15,
                        minSize: 12),
                    Headingdescription(
                        text: res, centerAlign: true, size: 15, minSize: 12),
                    Padding(
                      padding: EdgeInsets.only(top: 18.0.h),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: const WidgetStatePropertyAll(
                                  Color(MyColors.themeRedColor)),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12)))),
                          onPressed: () {
                            Get.back();
                          },
                          child: Container(
                            child: Center(
                                child: Text(
                              Strings.cancelText(Get.context!),
                              style: const TextStyle(color: Colors.white),
                            )),
                          )),
                    ),
                    SizedBox(height: 16.0.h)
                  ],
                ),
              ),
            ),
          );
        } else {
          Commons.hideProgressDialog();
        }
      }
    }
  }
}
