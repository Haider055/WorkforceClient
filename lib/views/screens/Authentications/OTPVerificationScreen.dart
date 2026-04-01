import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:workforceclientapp/Controllers/OPTVerificationController.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/screens/ClientJobPosting/JobPostCompletedScreen.dart';
import 'package:workforceclientapp/views/widgets/HeadingText.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';
import 'package:workforceclientapp/views/widgets/RedClickableText.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButton.dart';
import 'package:get/get.dart';

class OTPVerificationScreen extends GetView<OTPVerificationController> {
  const OTPVerificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 47,
      height: 50,
      textStyle: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w600,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(controller.outlineBorderColor.value)),
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          Get.back();
          return true;
          // Closes the app in Android
        } else if (Platform.isIOS) {
          Get.back();
          return true;
        }
        return false;
      },
      child: Scaffold(
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
                  child: Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Text(
                                Strings.otpVerification(context),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 28.0,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, top: 6.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Headingdescription(
                                text:
                                    Strings.otpVerificationScreenText(context),
                                centerAlign: false,
                                size: 15.0,
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Form(
                                    key: controller.formKey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Directionality(
                                          // Specify direction if desired
                                          textDirection: TextDirection.ltr,
                                          child: Pinput(
                                            length: 6,
                                            // You can pass your own SmsRetriever implementation based on any package
                                            // in this example we are using the SmartAuth
                                            // smsRetriever: smsRetriever,
                                            controller:
                                                controller.pinController,
                                            focusNode: controller.focusNode,
                                            defaultPinTheme: defaultPinTheme,
                                            separatorBuilder: (index) =>
                                                const SizedBox(width: 8),
                                            // validator: (value) {
                                            //   return value == '2222'
                                            //       ? null
                                            //       : 'Pin is incorrect';
                                            // },
                                            hapticFeedbackType:
                                                HapticFeedbackType.lightImpact,
                                            onCompleted: (pin) {
                                              controller.middleText.value =
                                                  Strings.pleaseVerify(context)
                                                      .obs();
                                              controller
                                                      .verifyButtonColor.value =
                                                  MyColors.themeRedColor.obs();
                                              controller.pinCode.value =
                                                  pin.toString();
                                              debugPrint('onCompleted: $pin');
                                            },
                                            onChanged: (value) {
                                              controller.middleText.value =
                                                  Strings.enterCode(context)
                                                      .obs();
                                              controller.verifyButtonColor
                                                  .value = 0xffDDDDDD.obs();
                                              debugPrint('onChanged: $value');
                                            },
                                            cursor: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 9),
                                                  width: 22,
                                                  height: 1,
                                                  color: Color(controller
                                                      .completeBorderColor
                                                      .value),
                                                ),
                                              ],
                                            ),
                                            focusedPinTheme:
                                                defaultPinTheme.copyWith(
                                              decoration: defaultPinTheme
                                                  .decoration!
                                                  .copyWith(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                          color: Color(controller
                                                              .completeBorderColor
                                                              .value))),
                                            ),
                                            submittedPinTheme:
                                                defaultPinTheme.copyWith(
                                              decoration: defaultPinTheme
                                                  .decoration!
                                                  .copyWith(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    color: Color(controller
                                                        .completeBorderColor
                                                        .value)),
                                              ),
                                            ),
                                            errorPinTheme:
                                                defaultPinTheme.copyBorderWith(
                                              border: Border.all(
                                                  color: Colors.redAccent),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 55.0),
                            child: Text(controller.middleText.value,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color:
                                        Color(controller.middleTextCode.value),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins')),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Headingdescription(
                                    text: Strings.didNotReceiveCode(context),
                                    centerAlign: false,
                                    size: 16.0),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                RedClickableText(
                                  text: Strings.resend(context),
                                  size: 16.0,
                                  callback: () {
                                    Get.offAllNamed(AppLinks.login_screen);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 25.0, left: 8.0, right: 8.0),
                            child: FullWidthButton(
                              text: Strings.verify(context),
                              color: controller.verifyButtonColor.value,
                              onPressed: () async {
                                if (controller.middleText.value ==
                                    Strings.pleaseVerify(context)) {
                                  Commons.showProgressDialog(context);
                                  String res = await controller.pleaseVerifyOTP(
                                      controller.pinCode.value,
                                      controller.email.value,
                                      context);
                                  Commons.hideProgressDialog();
                                  if (res == "done") {
                                    try {
                                      if (Constants.fromWhere ==
                                          "JobPostCompletedScreen") {
                                        Get.to(
                                          const JobPostCompletedScreen(),
                                          transition: Transition
                                              .rightToLeft, // Left-to-right animation
                                          duration: const Duration(
                                              milliseconds:
                                                  500), // Optional: animation duration
                                        );
                                      } else {
                                        // Get.offAllNamed(
                                        //     AppLinks.select_service_screen);
                                      }
                                    } catch (e) {
                                      e.printError();
                                    }
                                  } else if (res == "success") {
                                    // need to remove else if
                                    Commons.hideProgressDialog();
                                    if (controller.fromWhere.value ==
                                            "signup" ||
                                        controller.fromWhere.value == "login") {
                                      Fluttertoast.showToast(
                                          msg: "You can now login!");
                                      Get.offAllNamed(AppLinks.login_screen);
                                    } else {
                                      Get.toNamed(
                                          AppLinks.create_new_password_screen,
                                          arguments: {
                                            "email": controller.email.value
                                                .toString()
                                          });
                                    }
                                  } else {
                                    pleaseShowDialog(res);
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pleaseShowDialog(String msg) {
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
                  "lib/assets/images/signuperrorimage.png",
                  fit: BoxFit.contain,
                  height: 136.0,
                  width: 123.0,
                )),
          ),
          HeadingText(
              text: Strings.failedText(Get.context!), centerAlign: true),
          Headingdescription(
              text: Strings.somethingWentWrong(Get.context!),
              centerAlign: true,
              size: 15.0),
          Headingdescription(
              text: Strings.wrongPin(Get.context!),
              centerAlign: true,
              size: 15.0),
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
  }

  // Future<void> pleaseValidateData() async {
  //   if (controller.emailTextField.value.text.isEmpty) {
  //     setState(() {
  //       emailAddressErrorText = "Email cannot be empty!";
  //     });
  //     return;
  //   }
  //   if (controller.passwordTextField.value.text.isEmpty) {
  //     setState(() {
  //       passwordErrorText = "Password cannot be empty!";
  //     });
  //     return;
  //   }
  //   if (Commons.isValidEmail(controller.emailTextField.value.text)) {
  //     String res = await controller.pleaseLoginUser();
  //     if (res == "emailNotVerified") {
  //       try {
  //         Commons.hideProgressDialog();
  //         Get.to(
  //           const OTPVerificationScreen(),
  //           arguments: {"email": Constants.emailToVerify, "fromWhere": "login"},
  //           transition: Transition.rightToLeft, // Left-to-right animation
  //           duration: const Duration(
  //               milliseconds: 500), // Optional: animation duration
  //         );
  //       } catch (e) {
  //         e.printError();
  //       }
  //     } else if (res == "done") {
  //       try {
  //         Commons.hideProgressDialog();
  //         if (Constants.fromWhere == "JobPostCompletedScreen") {
  //           Get.to(
  //             const JobPostCompletedScreen(),
  //             transition: Transition.rightToLeft, // Left-to-right animation
  //             duration: const Duration(
  //                 milliseconds: 500), // Optional: animation duration
  //           );
  //         } else {
  //           Get.to(
  //             const SelectServiceScreen(),
  //             transition: Transition.rightToLeft, // Left-to-right animation
  //             duration: const Duration(
  //                 milliseconds: 500), // Optional: animation duration
  //           );
  //         }
  //       } catch (e) {
  //         e.printError();
  //       }
  //     } else {
  //       try {
  //         Commons.hideProgressDialog();
  //         dialogDesc2 = res;
  //         Get.defaultDialog(
  //           titleStyle: null,
  //           title: "",
  //           content: Column(
  //             children: <Widget>[
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 0.0),
  //                 child: Align(
  //                     alignment: Alignment.topCenter,
  //                     child: Image.asset(
  //                       "lib/assets/images/signuperrorimage.png",
  //                       fit: BoxFit.contain,
  //                       height: 136.92,
  //                       width: 123.72,
  //                     )),
  //               ),
  //               HeadingText(text: dialogHeadingText, centerAlign: true),
  //               Headingdescription(
  //                   text: dialogDesc1, centerAlign: true, size: 15.0),
  //               Headingdescription(
  //                   text: dialogDesc2, centerAlign: true, size: 15.0),
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 18.0),
  //                 child: ElevatedButton(
  //                     style: ButtonStyle(
  //                         backgroundColor: WidgetStatePropertyAll(
  //                             Color(MyColors.themeRedColor)),
  //                         shape: WidgetStatePropertyAll(RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(12)))),
  //                     onPressed: () {
  //                       Get.back();
  //                     },
  //                     child: Padding(
  //                       padding: const EdgeInsets.only(left: 50.0, right: 50.0),
  //                       child: Container(
  //                         child: Center(
  //                             child: Text(
  //                           Strings.tryAgainText,
  //                           style: TextStyle(color: Colors.white),
  //                         )),
  //                       ),
  //                     )),
  //               ),
  //               SizedBox(height: 16.0)
  //             ],
  //           ),
  //         );
  //       } catch (e) {
  //         e.printError();
  //       }
  //     }
  //   } else {
  //     Commons.hideProgressDialog();
  //   }
  // }
}
