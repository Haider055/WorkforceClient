import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:workforceclientapp/Controllers/OPTVerificationController.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
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
      width: 47.w,
      height: 50.h,
      textStyle: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w600,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0.r),
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
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: EdgeInsets.only(top: 44.0.h, left: 12.0.w),
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
                child: Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 25.0.w),
                            child: Text(
                              controller.preAuthToken.value.isNotEmpty
                                  ? "2FA Verification"
                                  : Strings.otpVerification(context),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 28.0.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 25.0.w, top: 6.0.h),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Headingdescription(
                              text: Strings.otpVerificationScreenText(context),
                              centerAlign: false,
                              size: 15.0.sp,
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 25.0.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Form(
                                  key: controller.formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Directionality(
                                        // Specify direction if desired
                                        textDirection: TextDirection.ltr,
                                        child: Pinput(
                                          length: 6,
                                          // You can pass your own SmsRetriever implementation based on any package
                                          // in this example we are using the SmartAuth
                                          // smsRetriever: smsRetriever,
                                          controller: controller.pinController,
                                          focusNode: controller.focusNode,
                                          defaultPinTheme: defaultPinTheme,
                                          separatorBuilder: (index) =>
                                              SizedBox(width: 8.w),
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
                                            controller.verifyButtonColor.value =
                                                MyColors.themeRedColor.obs();
                                            controller.pinCode.value =
                                                pin.toString();
                                            debugPrint('onCompleted: $pin');
                                          },
                                          onChanged: (value) {
                                            controller.middleText.value =
                                                Strings.enterCode(context)
                                                    .obs();
                                            controller.verifyButtonColor.value =
                                                0xffDDDDDD.obs();
                                            debugPrint('onChanged: $value');
                                          },
                                          cursor: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 9.0.h),
                                                width: 22.0.w,
                                                height: 1.0.h,
                                                color: Color(controller
                                                    .completeBorderColor.value),
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
                                                            8.r),
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
                                                  BorderRadius.circular(15.r),
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
                          padding: EdgeInsets.only(top: 55.0.h),
                          child: Text(controller.middleText.value,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(controller.middleTextCode.value),
                                  fontSize: 16.0.sp,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins')),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 50.0.h),
                          child: Obx(() {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Headingdescription(
                                    text: Strings.didNotReceiveCode(context),
                                    centerAlign: false,
                                    size: 16.0.sp),
                                SizedBox(width: 4.0.w),
                                controller.canResend.value
                                    ? RedClickableText(
                                        text: Strings.resend(context),
                                        size: 16.0.sp,
                                        callback: () async {
                                          var res =
                                              await controller.sendOtpAgain(
                                                  controller.email.value,
                                                  context);
                                          if (res) {
                                            controller
                                                .startTimer(); // restart countdown after resend
                                          }
                                        },
                                      )
                                    : Text(
                                        controller.formattedTime,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0.sp,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                              ],
                            );
                          }),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 25.0.h, left: 8.0.w, right: 8.0.w),
                          child: FullWidthButton(
                            text: Strings.verify(context),
                            color: controller.verifyButtonColor.value,
                            onPressed: () async {
                              if (controller.middleText.value ==
                                  Strings.pleaseVerify(context)) {
                                if (controller.fromWhere.value == "login" &&
                                    controller.preAuthToken.value.isNotEmpty) {
                                  print("object1");
                                  Commons.showProgressDialog(context);
                                  String res = await controller.verify2FA(
                                      controller.preAuthToken.value,
                                      controller.pinCode.value,
                                      context);
                                  if (res == 'done') {
                                    Get.offAllNamed(
                                        AppLinks.select_service_screen);
                                  }

                                  return;
                                } else {
                                  print("object2");
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
                                        Get.toNamed(
                                            AppLinks.job_post_completed_screen);
                                      } else {}
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
                                          msg: Strings.youCanNowLoginText(
                                              Get.context!));
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
                  height: 136.0.h,
                  width: 123.0.w,
                )),
          ),
          HeadingText(
              text: Strings.failedText(Get.context!), centerAlign: true),
          Headingdescription(
              text: Strings.somethingWentWrong(Get.context!),
              centerAlign: true,
              size: 15.0.sp),
          Headingdescription(
              text: Strings.wrongPin(Get.context!),
              centerAlign: true,
              size: 15.0.sp),
          Padding(
            padding: EdgeInsets.only(top: 18.0.h),
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
                  padding: EdgeInsets.only(left: 50.0.w, right: 50.0.w),
                  child: Container(
                    child: Center(
                        child: Text(
                      Strings.tryAgain(Get.context!),
                      style: const TextStyle(color: Colors.white),
                    )),
                  ),
                )),
          ),
          SizedBox(height: 16.0.h)
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
