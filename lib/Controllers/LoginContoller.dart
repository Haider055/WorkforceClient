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

  Future<String> pleaseLoginUser() async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/login'),
        headers: await Commons.manageRequestHeader(),
        body: jsonEncode(<String, String>{
          'email': emailTextField.value.text.toString(),
          'password': passwordTextField.value.text.toString(),
        }),
      );

      print(response.body);
      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // If the server did return a 200 CREATED response,
        // then parse the JSON.
        _prefs = await SharedPreferences.getInstance();
        String msg = jsonData['message'];
        if (jsonData['success']) {
          if (jsonData.keys.contains('data')) {
            Map<String, dynamic> dataObj = jsonData['data'];
            if (dataObj.keys.contains('token')) {
              String tokenString = dataObj['token'];
              await _prefs.setString('token', tokenString);
            }
            if (dataObj.keys.contains('user')) {
              if (dataObj['user']['role'] != null) {
                if (dataObj['user']['role'] == "tradeperson") {
                  Fluttertoast.showToast(msg: "Only Users allowed to login");
                  // Get.to(const SelectServiceScreen());
                  return "otherUser";
                } else {
                  await saveUserInfo(dataObj['user']);
                  await fCMSaveToken();
                  Fluttertoast.showToast(msg: msg);
                  return "done";
                }
              }
            } else {
              // Fluttertoast.showToast(msg: Strings.somethingWentWrongText);
              return Strings.somethingWentWrong(Get.context!);
            }
            return Strings.somethingWentWrong(Get.context!);
          } else {
            // Fluttertoast.showToast(msg: Strings.somethingWentWrongText);
            return Strings.somethingWentWrong(Get.context!);
          }
        } else {
          // Fluttertoast.showToast(msg: Strings.somethingWentWrongText);
          return Strings.somethingWentWrong(Get.context!);
        }
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
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> fCMSaveToken() async {
    try {
      final notificationSettings =
          await FirebaseMessaging.instance.requestPermission(provisional: true);

      late final String? token;
      late final String? deviceId;

      if (Platform.isAndroid) {
        token = await FirebaseMessaging.instance.getToken();
        deviceId = await getDeviceId();
        if (token != null) {
          print("token: $token");
          print("deviceId: $deviceId");
        } else {
          Fluttertoast.showToast(
              msg: Strings.notificationSetupError(Get.context!));
          return "";
        }
      } else if (Platform.isIOS) {
        final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) {
          // APNS token is available, make FCM plugin API requests...
          token = await FirebaseMessaging.instance.getToken();
          deviceId = await getDeviceId();
          if (token != null) {
            print("token: $token");
            print("deviceId: $deviceId");
          } else {
            Fluttertoast.showToast(
                msg: Strings.notificationSetupError(Get.context!));
            return "";
          }
        } else {
          Fluttertoast.showToast(
              msg: Strings.notificationSetupError(Get.context!));
          return "";
        }
      }

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/fcm-token'),
        headers: await Commons.manageRequestHeader(),
        body: jsonEncode(<String, String>{
          "token": token.toString(),
          "device_type": "android",
          "device_id": deviceId.toString()
        }),
      );
      print("object");
      print(response.body);

      // Map<String, dynamic> jsonData = jsonDecode(response.body);

      // if (response.statusCode == 200) {
      //   return "";
      // } else {
      //   Fluttertoast.showToast(
      //       msg: Strings.notificationSetupError(Get.context!));
      //   return "";
      // }
      return "";
    } catch (e) {
      throw Exception(e);
    }
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
      emailAddressErrorText.value = "Email cannot be empty!";
      return;
    }
    if (passwordTextField.value.text.isEmpty) {
      passwordErrorText.value = "Password cannot be empty!";
      return;
    }
    if (Commons.isValidEmail(emailTextField.value.text)) {
      Commons.showProgressDialog(Get.context!);
      String res = await pleaseLoginUser();
      if (res == "emailNotVerified") {
        try {
          Commons.hideProgressDialog();
          Get.offAllNamed(
            AppLinks.otp_verification_screen,
            arguments: {"email": Constants.emailToVerify, "fromWhere": "login"},
          );
        } catch (e) {
          e.printError();
        }
      } else if (res == "done") {
        try {
          Commons.hideProgressDialog();
          if (Constants.fromWhere == "JobPostCompletedScreen") {
            Get.offAllNamed(AppLinks.job_post_completed_screen);
          } else {
            Get.offAllNamed(AppLinks.select_service_screen);
          }
        } catch (e) {
          e.printError();
        }
      } else if (res == "otherUser") {
        Commons.hideProgressDialog();
      } else {
        try {
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
    await _prefs.setInt('id', userObj['id'] ?? -1);
    await _prefs.setString('name', userObj['name'] ?? "");
    await _prefs.setString('email', userObj['email'] ?? "");
    await _prefs.setString(
        'password', passwordTextField.value.text.toString() ?? "");
    await _prefs.setString('phone', userObj['phone'] ?? "");
    await _prefs.setString('profile_img', userObj['profile_img'] ?? "");
  }
}
