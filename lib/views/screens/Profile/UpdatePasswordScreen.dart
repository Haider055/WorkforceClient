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
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
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
            FocusManager.instance.primaryFocus?.unfocus();
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
                          child: Obx(() {
                            return CommonTextFieldWhite(
                                hint: Strings.passwordText(context),
                                errorText: controller.passErrorText.value,
                                controller: controller.passwordTextField(),
                                inputType: TextInputType.visiblePassword,
                                prefixIcon: const Icon(Icons.lock_outline),
                                needPasswordSuffixIcon: true,
                                needprefixIcon: true,
                                onChanged: (value) {
                                  controller.passErrorText.value = "";
                                  controller.showPasswordRules.value = true;

                                  // This is what makes the rules below
                                  // repaint. Reading passwordTextField.value
                                  // in the Obx does NOT work: that Rx only
                                  // fires when the TextEditingController
                                  // OBJECT is replaced, never when its text
                                  // changes.
                                  controller.passwordInput.value = value;

                                  _checkPasswordStrength(value);
                                });
                          }),
                        ),
                        Obx(() {
                          final pass = controller.passwordInput.value;

                          return controller.showPasswordRules.value
                              ? Padding(
                                  padding: EdgeInsets.only(left: 18.0.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Label said 10 while the check is 12,
                                      // which is what _checkPasswordStrength
                                      // uses too.
                                      _passwordRule(
                                          Strings.atLeast10CharactersText(
                                              Get.context!),
                                          pass.length >= 12),
                                      _passwordRule(
                                          Strings.lowercaseText(Get.context!),
                                          RegExp(r'[a-z]').hasMatch(pass)),
                                      _passwordRule(
                                          Strings.uppercaseText(Get.context!),
                                          RegExp(r'[A-Z]').hasMatch(pass)),
                                      _passwordRule(
                                          "${Strings.specialSymbols(Get.context!)} (? # @ ...)",
                                          RegExp(r'[!@#\$&*~]').hasMatch(pass)),
                                      // Checks digits — was labelled
                                      // "special symbols".
                                      _passwordRule(
                                          Strings.numbers(Get.context!),
                                          RegExp(r'[0-9]').hasMatch(pass)),
                                    ],
                                  ),
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
                                inputType: TextInputType.visiblePassword,
                                prefixIcon: const Icon(Icons.lock_outline),
                                needPasswordSuffixIcon: true,
                                needprefixIcon: true,
                                onChanged: (value) {}),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0.r),
                          child: FullWidthElevatedButton(
                              text: Strings.updateText(context),
                              color: MyColors.themeRedColor,
                              onPressed: () => _onUpdate(context),
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
    );
  }

  Future<void> _onUpdate(BuildContext context) async {
    final password = controller.passwordTextField.value.text;
    final confirm = controller.confirmPasswordTextField.value.text;

    if (password.isEmpty || confirm.isEmpty) {
      Fluttertoast.showToast(msg: Strings.cannotBeEmpty(context));
      return;
    }

    if (controller.showPasswordRules.value) {
      Fluttertoast.showToast(msg: Strings.pleaseFollowPasswordRules(context));
      return;
    }

    if (password != confirm) {
      Fluttertoast.showToast(msg: Strings.confirmPasswordErrorText(context));
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    try {
      Commons.showProgressDialog(context);
      var res =
          await controller.pleaseUpdatePassword(controller.prviousPassword);
      if (res) {
        Get.offAllNamed(AppLinks.select_service_screen);
      }
    } catch (e) {
      debugPrint('pleaseUpdatePassword error: $e');
      // Fluttertoast.showToast(msg: Strings.somethingWentWrong(context))
    } finally {
      // Was only hidden on the happy path — a throw left it stuck on screen.
      Commons.hideProgressDialog();
    }
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
    if (password.length >= 10) strength += 0.2;
    if (RegExp(r'[a-z]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[!@#\$&*~]').hasMatch(password)) strength += 0.2;

    controller.passwordStrength.value = strength;

    // The strength label is commented out in your version, so the only
    // thing left to do is hide the rules once every one of them passes.
    // (The stray `Strings.moderateText(Get.context!);` line that was here
    // evaluated a string and threw it away.)
    controller.showPasswordRules.value = strength < 1.0;
  }
}
