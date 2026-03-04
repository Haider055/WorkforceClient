import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workforceclientapp/Controllers/ForgotPasswordContoller.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/CommonTextField.dart';
import 'package:workforceclientapp/views/widgets/HeadingText.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';
import 'package:workforceclientapp/views/widgets/RedClickableText.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButton.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordContoller> {
  const ForgotPasswordScreen({super.key});

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }

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
                        "lib/assets/images/forgot_password_image.png",
                        fit: BoxFit.contain,
                        height: 252.0,
                        width: 167.5,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: HeadingText(
                          text: Strings.forgotPasswordText(context),
                          centerAlign: true),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, top: 6.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Headingdescription(
                          text: Strings.forgotPasswordDescText(context),
                          centerAlign: false,
                          size: 13.8,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 25.0, top: 25.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Please Enter your Email",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.5,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: CommonTextField(
                          errorText: controller.emailAddressErrorText.value,
                          hint: Strings.emailAddressText(context),
                          inputType: TextInputType.emailAddress,
                          controller: controller.emailTextField(),
                          prefixIcon: const Icon(null),
                          needPasswordSuffixIcon: false,
                          needprefixIcon: false),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: FullWidthButton(
                        text: Strings.sendCodeText(context),
                        color: MyColors.themeRedColor,
                        onPressed: () async {
                          if (controller.emailTextField.value.text.isNotEmpty) {
                            if (Commons.isValidEmail(
                                controller.emailTextField.value.text)) {
                              Commons.showProgressDialog(context);
                              String res = await controller.pleaseSendOTP(
                                  controller.emailTextField.value.text);
                              Commons.hideProgressDialog();
                              if (res == "success") {
                                Get.offAllNamed(
                                    AppLinks.otp_verification_screen,
                                    arguments: {
                                      "email":
                                          controller.emailTextField.value.text,
                                      "fromWhere": "forgotPassword"
                                    });
                              } else {
                                controller.pleaseShowDialog(res);
                              }
                            } else {
                              controller.emailAddressErrorText.value =
                                  "Please enter valid email!";
                            }
                          } else {
                            controller.emailAddressErrorText.value =
                                "Email Cannot be empty!";
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Headingdescription(
                              text:
                                  "${Strings.rememberPasswordText(context)} + ?",
                              centerAlign: false,
                              size: 14.0),
                          const SizedBox(
                            width: 4.0,
                          ),
                          RedClickableText(
                            text: Strings.loginText(context),
                            size: 14.0,
                            callback: () {
                              Get.offAllNamed(AppLinks.login_screen);
                            },
                          ),
                        ],
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
