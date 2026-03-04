import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/CreateNewPasswordController.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/widgets/CommonTextFieldWhite.dart';
import 'package:workforceclientapp/views/widgets/FullWidthElevatedButton.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW500.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';

class UpdatePasswordScreen extends GetView<CreateNewPasswordController> {
  const UpdatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width,
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
                    size: 16.0,
                  )),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Align(
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                elevation: 0,
                color: const Color(MyColors.cardGrayColor100),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 12),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: HeadingTextW500(
                            text: Strings.newPasswordText(context),
                            centerAlign: false,
                            size: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
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
                                    _passwordRule(
                                        "At least 12 characters",
                                        controller.passwordTextField.value.text
                                                .length >=
                                            12),
                                    _passwordRule(
                                        "Lowercase",
                                        RegExp(r'[a-z]').hasMatch(controller
                                            .passwordTextField.value.text)),
                                    _passwordRule(
                                        "Uppercase",
                                        RegExp(r'[A-Z]').hasMatch(controller
                                            .passwordTextField.value.text)),
                                    _passwordRule(
                                        "Special Symbols (? # @ ...)",
                                        RegExp(r'[!@#\$&*~]').hasMatch(
                                            controller
                                                .passwordTextField.value.text)),
                                    _passwordRule(
                                        "Numbers",
                                        RegExp(r'[0-9]').hasMatch(controller
                                            .passwordTextField.value.text)),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 12),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: HeadingTextW500(
                            text: Strings.confirmPasswordText(context),
                            centerAlign: false,
                            size: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: CommonTextFieldWhite(
                            hint: Strings.confirmPasswordText(context),
                            errorText: "",
                            controller: controller.confirmPasswordTextField(),
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
                      padding: const EdgeInsets.all(20.0),
                      child: FullWidthElevatedButton(
                          text: Strings.updateText(context),
                          color: MyColors.themeRedColor,
                          onPressed: () async {
                            try {
                              if (controller.passwordTextField.value.text
                                      .isNotEmpty &&
                                  controller.confirmPasswordTextField.value.text
                                      .isNotEmpty) {
                                if (!controller.showPasswordRules.value) {
                                  if (controller.passwordTextField.value.text ==
                                      controller.confirmPasswordTextField.value
                                          .text) {
                                    Commons.showProgressDialog(context);
                                    await controller.pleaseUpdatePassword(
                                        controller.prviousPassword);
                                    Commons.hideProgressDialog();
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: Strings.confirmPasswordErrorText(
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
    );
  }

  Widget _passwordRule(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: [
          isValid
              ? Image.asset("lib/assets/icons/greentick.png",
                  height: 10, width: 10)
              : Image.asset("lib/assets/icons/graytick.png",
                  height: 10, width: 10),
          const SizedBox(width: 5),
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
      controller.passwordStrengthText.value = "Weak";
    } else if (strength < 0.8) {
      controller.passwordStrengthText.value = "Moderate";
    } else if (strength < 1.0) {
      controller.passwordStrengthText.value = "Good";
    } else {
      controller.passwordStrengthText.value = "Strong";
      controller.showPasswordRules.value = false;
    }
  }
}
