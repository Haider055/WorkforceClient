import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
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
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.95,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Center(
                      child: Image.asset(
                        "lib/assets/icons/Logo_black_red.png",
                        fit: BoxFit.fill,
                        height: 27.27,
                        width: 144.0,
                      ),
                    ),
                    const SizedBox(height: 60.0),
                    Align(
                      alignment: Alignment.topLeft,
                      child: HeadingText(
                          text: Strings.registerText(context),
                          centerAlign: true),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 22.0),
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
                      padding: const EdgeInsets.only(top: 16.0),
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
                      padding: const EdgeInsets.only(top: 16.0),
                      child: CommonTextField(
                          errorText: controller.phoneErrorText.value,
                          hint:
                              "${Strings.phoneText(context)} (e.g. +491234567891)",
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
                      padding: const EdgeInsets.only(top: 16.0),
                      child: CommonTextField(
                          errorText: controller.passErrorText.value,
                          hint: Strings.passwordText(context),
                          controller: controller.passwordTextField(),
                          prefixIcon: const Icon(Icons.lock_outline),
                          inputType: TextInputType.text,
                          needPasswordSuffixIcon: true,
                          onChanged: (pass) {
                            controller.passErrorText.value = "";
                            controller.showPasswordRules.value = true;
                            controller.checkPasswordStrength(pass);
                          },
                          needprefixIcon: true),
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
                    // Password Strength Rules
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: CommonTextField(
                          errorText: controller.confirmPassErrorText.value,
                          hint: Strings.confirmPasswordText(context),
                          controller: controller.confirmPasswordTextField(),
                          prefixIcon: const Icon(Icons.lock_outline),
                          inputType: TextInputType.text,
                          onChanged: (value) {
                            controller.confirmPassErrorText.value = "";
                          },
                          needPasswordSuffixIcon: true,
                          needprefixIcon: true),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: FullWidthButton(
                        text: Strings.registerText(context),
                        color: MyColors.themeRedColor,
                        onPressed: () async {
                          pleaseValidateData();
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 18.0),
                      child: Headingdescription(
                          text: "By creating an account, you agree to our",
                          centerAlign: true,
                          size: 13.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RedClickableText(
                          text: "Terms and Conditions",
                          size: 13.5,
                          callback: () {
                            Get.toNamed(AppLinks.terms_and_conditions);
                          },
                        ),
                        const SizedBox(
                          width: 4.0,
                        ),
                        const Headingdescription(
                            text: "and ", centerAlign: false, size: 13.0),
                        const SizedBox(
                          width: 4.0,
                        ),
                        RedClickableText(
                          size: 13.5,
                          text: "Privacy Policy",
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

  Future<void> pleaseValidateData() async {
    if (controller.nameTextField.value.text.isEmpty) {
      controller.nameErrorText.value = "Name cannot be empty!";
    }
    if (controller.emailTextField.value.text.isEmpty) {
      controller.emailAddressErrorText.value = "Email cannot be empty!";
    }
    if (controller.phoneTextField.value.text.isEmpty) {
      controller.phoneErrorText.value = "Phone cannot be empty!";
    }
    if (controller.passwordTextField.value.text.isEmpty) {
      controller.passErrorText.value = "Password cannot be empty!";
    }
    if (controller.confirmPasswordTextField.value.text.isEmpty) {
      controller.confirmPassErrorText.value =
          "Confirm Password cannot be empty!";
    }
    if (controller.nameTextField.value.text.isNotEmpty &&
        controller.emailTextField.value.text.isNotEmpty &&
        controller.phoneTextField.value.text.isNotEmpty &&
        controller.passwordTextField.value.text.isNotEmpty &&
        controller.confirmPasswordTextField.value.text.isNotEmpty) {
      if (controller.nameTextField.value.text.length < 4) {
        controller.nameErrorText.value = "Name must be atleast 4 characters!";
      } else if (!Commons.isValidEmail(
          controller.emailTextField.value.text.toString())) {
        controller.emailAddressErrorText.value = "Please enter valid email!";
      } else if (!controller.phoneTextField.value.text
          .toString()
          .isPhoneNumber) {
        controller.phoneErrorText.value = "Please enter valid Phone Number!";
      } else if (controller.passwordStrength.value < 0.8) {
        controller.passErrorText.value = "Please follow password rules!";
      } else if (controller.confirmPasswordTextField.value.text.toString() !=
          controller.passwordTextField.value.text.toString()) {
        controller.confirmPassErrorText.value = "Password do not match!";
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
                        height: 136.92,
                        width: 123.72,
                      )),
                ),
                HeadingText(
                    text: Strings.failedText(Get.context!), centerAlign: true),
                Headingdescription(
                    text: Strings.somethingWentWrong(Get.context!),
                    centerAlign: true,
                    size: 15.0),
                Headingdescription(text: res, centerAlign: true, size: 15.0),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
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
                        padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                        child: Container(
                          child: Center(
                              child: Text(
                            Strings.tryAgain(Get.context!),
                            style: const TextStyle(color: Colors.white),
                          )),
                        ),
                      )),
                ),
                const SizedBox(height: 16.0)
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
