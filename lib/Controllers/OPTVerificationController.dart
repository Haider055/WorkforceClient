import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Controllers/LoginContoller.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/Strings.dart';

class OTPVerificationController extends GetxController {
  late SharedPreferences _prefs;

  RxString email = "".obs;
  RxString preAuthToken = "".obs;
  RxString password = "".obs;
  RxString pinCode = "".obs;
  RxString fromWhere = "".obs;
  final data = Get.arguments;
  final LoginContoller loginContoller = Get.put(LoginContoller());
  RxString middleText = "".obs;
  RxInt middleTextCode = 0xff000000.obs;
  RxInt outlineBorderColor = 0xFFC8C5C5.obs;
  RxInt completeBorderColor = 0xff00D712.obs;
  RxInt verifyButtonColor = 0xffDDDDDD.obs;
  int tokenRetry = 0;

  RxInt remainingSeconds = 300.obs; // 5 minutes = 300 seconds
  Timer? _countdownTimer;
  RxBool canResend = false.obs;

  late final SmsRetriever smsRetriever;
  final TextEditingController pinController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final editTextField1 = TextEditingController().obs;
  final editTextField2 = TextEditingController().obs;
  final editTextField3 = TextEditingController().obs;
  final editTextField4 = TextEditingController().obs;
  final editTextField5 = TextEditingController().obs;
  final editTextField6 = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    email.value = data['email'].toString();
    fromWhere.value = data['fromWhere'].toString();
    if (data['pre_auth_token'] != null) {
      preAuthToken.value = data['pre_auth_token'].toString();
    }
    if (data['password'] != null) {
      password.value = data['password'].toString();
    }
    if (data['email'] != null) {
      email.value = data['email'].toString();
    }
    startTimer();

    if (kIsWeb) {
      BrowserContextMenu.disableContextMenu();
    }
  }

  void startTimer() {
    canResend.value = false;
    remainingSeconds.value = 300;
    _countdownTimer?.cancel(); // cancel any existing timer first
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  String get formattedTime {
    final minutes = (remainingSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    super.onClose();
  }

  @override
  void dispose() {
    if (kIsWeb) {
      BrowserContextMenu.enableContextMenu();
    }
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<String> pleaseRegisterUser(String name, String email, String password,
      String confirmpassword, String phone, BuildContext context) async {
    try {
      final response = await http
          .post(
            Uri.parse('${Constants.baseUrl}/register'),
            headers: await Commons.manageRequestHeader(),
            body: jsonEncode(<String, String>{
              'name': name,
              'email': email,
              'phone': phone,
              'password': password,
              'password_confirmation': confirmpassword,
              'user_type': 'user',
            }),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
        return "failed";
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
      return "failed";
    } catch (e) {
      throw Exception(e);
    }
    return "failed";
  }

  Future<bool> sendOtpAgain(String email, BuildContext context) async {
    try {
      final response = await http
          .post(
            Uri.parse('${Constants.baseUrl}/send-otp'),
            headers: await Commons.manageRequestHeader(),
            body: jsonEncode(<String, String>{"email": email}),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        // If the server did return a 200 CREATED response,
        // then parse the JSON.
        if (jsonData['success']) {
          Fluttertoast.showToast(msg: Strings.otpSentText(Get.context!));
          print("object");
          return true;
          // return directLoginUser(context);
        } else {
          Fluttertoast.showToast(
              msg: Strings.otpFailedToSentText(Get.context!));
          print("object1");
          return false;
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser();
        return false;
      } else {
        Fluttertoast.showToast(msg: Strings.otpFailedToSentText(Get.context!));
        print("object2");
        return false;
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.otpFailedToSentText(Get.context!));
      return false;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> pleaseVerifyOTP(
      String otp, String email, BuildContext context) async {
    try {
      final response = await http
          .post(
            Uri.parse('${Constants.baseUrl}/verify-otp'),
            headers: await Commons.manageRequestHeader(),
            body: jsonEncode(<String, String>{
              "email": email,
              "otp": otp,
              "type": "register"
            }),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        // If the server did return a 200 CREATED response,
        // then parse the JSON.
        if (jsonData['success']) {
          String msg = jsonData['message'];
          Fluttertoast.showToast(msg: msg);
          // return directLoginUser(context);
          return "success";
        } else {
          String msg = jsonData['message'];
          return msg;
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser();
        return '';
      } else {
        // If the server did not return a 200 CREATED response,
        // then throw an exception.
        String msg = jsonData['message'];
        return msg;
      }
    } on TimeoutException {
      throw Exception('Request timed out');
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> verify2FA(
      String token, String otp, BuildContext context) async {
    try {
      final response = await http
          .post(
            Uri.parse('${Constants.baseUrl}/2fa/verify'),
            headers: await Commons.manageRequestHeader(),
            body: jsonEncode(<String, String>{
              'otp': otp,
              'pre_auth_token': preAuthToken.value.toString(),
            }),
          )
          .timeout(const Duration(seconds: 5));
      Commons.hideProgressDialog();

      Map<String, dynamic> jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
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
              if (dataObj['user'] != null) {
                if (dataObj['user']['role'] != null) {
                  if (dataObj['user']['role'] == "tradeperson") {
                    Fluttertoast.showToast(msg: "Only Users allowed to login");
                    return "otherUser";
                  } else {
                    await saveUserInfo(dataObj['user']);
                    fCMSaveToken();
                    Fluttertoast.showToast(msg: msg);
                    // TextInput.finishAutofillContext(shouldSave: true);
                    return "done";
                  }
                }
              } else {
                // Fluttertoast.showToast(msg: Strings.somethingWentWrongText);
                return Strings.somethingWentWrong(Get.context!);
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
        // If the server did not return a 200 CREATED response,
        // then throw an exception.
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
        return "failed";
      }
    } on TimeoutException {
      Commons.hideProgressDialog();
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
      return "failed";
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

  Future<void> saveUserInfo(Map<String, dynamic> userObj) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('isLogin', "loggedIn");
    await _prefs.setInt('id', userObj['id'] ?? -1);
    await _prefs.setString('name', userObj['name'] ?? "");
    await _prefs.setString('email', userObj['email'] ?? "");
    await _prefs.setString('password', password.value.toString() ?? "");
    await _prefs.setString('phone', userObj['phone'] ?? "");
    await _prefs.setString('profile_img', userObj['profile_img'] ?? "");
    await _prefs.setBool(
        'two_factor_enabled', userObj['two_factor_enabled'] ?? false);
  }
}
