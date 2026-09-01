import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/HeadingText.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class LoginContoller extends GetxController {
  final emailTextField = TextEditingController().obs;
  final passwordTextField = TextEditingController().obs;
  late SharedPreferences _prefs;
  RxString emailAddressErrorText = "".obs;
  RxString passwordErrorText = "".obs;
  int tokenRetry = 0;
  String preAuthToken = "";

  Future<String> pleaseLoginUser() async {
    try {
      final response = await http
          .post(
            Uri.parse('${Constants.baseUrl}/login'),
            headers: await Commons.manageRequestHeader(),
            body: jsonEncode(<String, String>{
              'email': emailTextField.value.text.toString(),
              'password': passwordTextField.value.text.toString(),
            }),
          )
          .timeout(const Duration(seconds: 5));

      print(response.body);
      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _prefs = await SharedPreferences.getInstance();
        String msg = jsonData['message'];
        if (jsonData['success']) {
          if (jsonData.keys.contains('data')) {
            Map<String, dynamic> dataObj = jsonData['data'];
            if (dataObj.keys.contains('requires_2fa')) {
              if (dataObj['requires_2fa'] == true) {
                if (dataObj['pre_auth_token'] != null) {
                  preAuthToken = dataObj['pre_auth_token'];
                  Commons.hideProgressDialog();
                  return "pre_auth";
                }
              }
            }

            if (dataObj.keys.contains('token')) {
              String tokenString = dataObj['token'];
              await _prefs.setString('token', tokenString);
            }
            if (dataObj.keys.contains('user')) {
              if (dataObj['user'] != null) {
                if (dataObj['user']['role'] != null) {
                  if (dataObj['user']['role'] == "tradeperson") {
                    Fluttertoast.showToast(msg: "Only Users allowed to login");
                    return "otherUser";
                  } else {
                    await saveUserInfo(dataObj['user']);
                    fCMSaveToken();
                    Fluttertoast.showToast(msg: msg);
                    return "done";
                  }
                }
              } else {
                return Strings.somethingWentWrong(Get.context!);
              }
            } else {
              return Strings.somethingWentWrong(Get.context!);
            }
            return Strings.somethingWentWrong(Get.context!);
          } else {
            return Strings.somethingWentWrong(Get.context!);
          }
        } else {
          return Strings.somethingWentWrong(Get.context!);
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser(true);
        return '';
      } else {
        if (jsonData.keys.contains('errors')) {
          Map<String, dynamic> errorObj = jsonData['errors'];
          if (errorObj.keys.contains('email_verified')) {
            if (!errorObj['email_verified']) {
              Fluttertoast.showToast(
                  msg: Strings.pleaseVerifyYourEmail(Get.context!));
              Constants.emailToVerify = emailTextField.value.text.toString();
              return "emailNotVerified";
            }
          }
        }
        String msg = jsonData['message'];
        Fluttertoast.showToast(msg: msg);
        return msg;
      }
    } on TimeoutException {
      throw Exception('Request timed out');
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> fCMSaveToken() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt >= 33) {
          await FirebaseMessaging.instance.requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            sound: true,
          );
        }
      } else {
        await FirebaseMessaging.instance.requestPermission(
          provisional: false,
          sound: true,
          alert: true,
          badge: true,
        );
      }

      getTokenAndUpdate();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> getTokenAndUpdate() async {
    try {
      String? token = "";
      String? deviceId = "";

      try {
        token = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        print(e.toString());
        return "";
      }
      try {
        deviceId = await getDeviceId();
      } catch (e) {
        print(e.toString());
        return "";
      }
      print("token: $token");
      print("deviceId: $deviceId");

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/fcm-token'),
        headers: await Commons.manageRequestHeader(),
        body: jsonEncode(<String, String>{
          "token": token.toString(),
          "device_type": Platform.isAndroid ? "ANDROID" : "IOS",
          "device_id": deviceId.toString()
        }),
      );
      print("object");
      print(response.body);

      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("Token updated on server successfully");
        _prefs = await SharedPreferences.getInstance();
        await _prefs.setString('fcm_token', token!);
        await _prefs.setString('device_id', deviceId.toString());

        return "";
      } else {
        Fluttertoast.showToast(
            msg: Strings.notificationSetupError(Get.context!));
        return "";
      }
    } catch (e) {
      print(e.toString());
    }
    return "";
  }

  Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Android ID (may not be stable)
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // iOS unique device ID
    }
    return null;
  }

  Future<void> pleaseValidateData() async {
    if (emailTextField.value.text.isEmpty) {
      emailAddressErrorText.value =
          Strings.emailCannotBeEmptyText(Get.context!);
      return;
    }
    if (passwordTextField.value.text.isEmpty) {
      passwordErrorText.value = Strings.passwordCannotBeEmptyText(Get.context!);
      return;
    }
    if (Commons.isValidEmail(emailTextField.value.text)) {
      Commons.showProgressDialog(Get.context!);
      String res = await pleaseLoginUser();
      Commons.hideProgressDialog();
      if (res == "emailNotVerified") {
        try {
          Get.toNamed(
            AppLinks.otp_verification_screen,
            arguments: {"email": Constants.emailToVerify, "fromWhere": "login"},
          );
        } catch (e) {
          e.printError();
        }
      } else if (res == "done") {
        try {
          if (Constants.fromWhere == "JobPostCompletedScreen") {
            Get.offAllNamed(AppLinks.job_post_completed_screen);
          } else {
            Get.offAllNamed(AppLinks.select_service_screen);
          }
        } catch (e) {
          e.printError();
        }
      } else if (res == "otherUser") {
      } else if (res == "pre_auth") {
        try {
          Get.toNamed(AppLinks.otp_verification_screen, arguments: {
            "password": passwordTextField.value.text.toString(),
            "fromWhere": "login",
            "email": emailTextField.value.text.toString(),
            "pre_auth_token": preAuthToken
          });
        } catch (e) {
          e.printError();
        }
      } else {
        try {
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
                  padding:
                      const EdgeInsets.only(top: 18.0, left: 12.0, right: 12.0),
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
        } catch (e) {
          e.printError();
        }
      }
    } else {
      Commons.hideProgressDialog();
      emailAddressErrorText.value = Strings.pleaseEnterValidEmail(Get.context!);
    }
  }

  Future<void> saveUserInfo(Map<String, dynamic> userObj) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('isLogin', "loggedIn");
    await _prefs.setBool('isSuspended', false);
    await _prefs.setInt('id', userObj['id'] ?? -1);
    await _prefs.setString('name', userObj['name'] ?? "");
    await _prefs.setString('email', userObj['email'] ?? "");
    await _prefs.setString(
        'password', passwordTextField.value.text.toString() ?? "");
    await _prefs.setString('phone', userObj['phone'] ?? "");
    await _prefs.setString('profile_img', userObj['profile_img'] ?? "");
    await _prefs.setBool(
        'two_factor_enabled', userObj['two_factor_enabled'] ?? false);
  }
}
