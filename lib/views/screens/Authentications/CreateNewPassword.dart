import 'package:flutter/material.dart';
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

class CreateNewPassword extends GetView<CreateNewPasswordController> {
  const CreateNewPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0, left: 12.0),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "lib/assets/icons/bckTwoarrows.svg",
                      height: 14,
                      width: 14,
                      fit: BoxFit.contain,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 6.0),
                      child: Headingdescription(
                          text: "Go Back", centerAlign: false, size: 12),
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
                        height: 304.0,
                        width: 190.0,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: HeadingText(
                          text: Strings.createNewPasswordText(context),
                          centerAlign: true),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, top: 7.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Headingdescription(
                            text: Strings.createNewPasswordDescText(context),
                            centerAlign: false,
                            size: 14.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: CommonTextField(
                        errorText: controller.passErrorText.value,
                        hint: Strings.passwordText(context),
                        controller: controller.passwordTextField(),
                        inputType: TextInputType.text,
                        prefixIcon: const Icon(Icons.lock_outline),
                        needPasswordSuffixIcon: true,
                        onChanged: (value) {
                          controller.passErrorText.value = "";
                          controller.showPasswordRules.value = true;
                          controller.checkPasswordStrength(value);
                        },
                        needprefixIcon: true,
                      ),
                    ),
                    controller.showPasswordRules.value
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 23.0, right: 23.0, top: 12.0),
                                child: LinearProgressIndicator(
                                  value: controller.passwordStrength.value,
                                  color: controller.passwordStrength.value < 0.4
                                      ? Colors.red
                                      : controller.passwordStrength.value < 0.8
                                          ? Colors.orange
                                          : Colors.green,
                                  minHeight: 4,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 20.0, top: 4),
                                  child: Text(
                                    controller.passwordStrengthText.value,
                                    style: TextStyle(
                                      color: controller.passwordStrength.value <
                                              0.4
                                          ? Colors.red
                                          : controller.passwordStrength.value <
                                                  0.8
                                              ? Colors.orange
                                              : Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    controller.passwordRule(
                                        "At least 12 characters",
                                        controller.passwordTextField.value.text
                                                .length >=
                                            12),
                                    controller.passwordRule(
                                        "Lowercase",
                                        RegExp(r'[a-z]').hasMatch(controller
                                            .passwordTextField.value.text)),
                                    controller.passwordRule(
                                        "Uppercase",
                                        RegExp(r'[A-Z]').hasMatch(controller
                                            .passwordTextField.value.text)),
                                    controller.passwordRule(
                                        "Special Symbols (? # @ ...)",
                                        RegExp(r'[!@#\$&*~]').hasMatch(
                                            controller
                                                .passwordTextField.value.text)),
                                    controller.passwordRule(
                                        "Numbers",
                                        RegExp(r'[0-9]').hasMatch(controller
                                            .passwordTextField.value.text)),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    // Password Strength Rules
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: CommonTextField(
                        errorText: controller.confirmPassErrorText.value,
                        hint: Strings.confirmPasswordText(context),
                        controller: controller.confirmPasswordTextField(),
                        inputType: TextInputType.text,
                        prefixIcon: const Icon(Icons.lock_outline),
                        needPasswordSuffixIcon: true,
                        needprefixIcon: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: FullWidthButton(
                        text: Strings.createText(context),
                        color: MyColors.themeRedColor,
                        onPressed: () {
                          try {
                            if (controller
                                    .passwordTextField.value.text.isEmpty ||
                                controller.confirmPasswordTextField.value.text
                                    .isEmpty) {
                              Fluttertoast.showToast(
                                  msg: Strings.cannotBeEmpty(context));
                            } else {
                              Commons.showProgressDialog(context);
                              controller
                                  .pleaseResetPassword(controller.email.value);
                              Commons.hideProgressDialog();
                            }
                          } catch (e) {
                            throw Exception(e);
                          }
                        },
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
