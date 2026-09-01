import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';

class SignUpContoller extends GetxController {
  late SharedPreferences _prefs;

  RxString dialogIconsUrl = "lib/assets/images/signuperrorimage.png"
      .obs; // lib/assets/images/signuperrorimage.png
  int dialogButtonColor = 0xff39B54A; // 0xFF8073 for error
  RxString emailAddressErrorText = "".obs;
  RxString nameErrorText = "".obs;
  RxString phoneErrorText = "".obs;
  RxString passErrorText = "".obs;
  RxString confirmPassErrorText = "".obs;
  RxDouble passwordStrength = 0.0.obs;
  RxString passwordStrengthText = "".obs;
  RxBool showPasswordRules = false.obs;

  final nameTextField = TextEditingController().obs;
  final emailTextField = TextEditingController().obs;
  final phoneTextField = TextEditingController().obs;
  final passwordTextField = TextEditingController().obs;
  final confirmPasswordTextField = TextEditingController().obs;

  Future<String> pleaseRegisterUser() async {
    try {
      String lang = await Commons.getPrefLanguageValue();
      final response = await http
          .post(
            Uri.parse('${Constants.baseUrl}/register'),
            headers: <String, String>{
              'Accept-Language': lang,
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, String>{
              'name': nameTextField.value.text.toString(),
              'email': emailTextField.value.text.toString(),
              'phone': phoneTextField.value.text.toString(),
              'password': passwordTextField.value.text.toString(),
              'password_confirmation':
                  confirmPasswordTextField.value.text.toString(),
              'user_type': 'user',
            }),
          )
          .timeout(const Duration(seconds: 5));

      print(response.body);
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      String message = jsonData['message'];

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          Fluttertoast.showToast(msg: message);
          Constants.signupEmail = emailTextField.value.text;
          Constants.signupPassword = passwordTextField.value.text;
          Commons.hideProgressDialog();
          Get.toNamed(
            AppLinks.otp_verification_screen,
            arguments: {
              "email": emailTextField.value.text.toString(),
              "fromWhere": "signup"
            },
          );
          return "";
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser(true);
        return '';
      } else {
        Map<String, dynamic> jsonDataError = jsonData['errors'];
        if (jsonDataError.keys.contains('email')) {
          String msg = jsonDataError['email'];
          Fluttertoast.showToast(msg: msg);
          return msg;
        } else if (jsonDataError.keys.contains("phone")) {
          String msg = jsonDataError['phone'];
          Fluttertoast.showToast(msg: msg);
          return msg;
        } else {}
        return "";
      }
      return "";
    } on TimeoutException {
      Commons.hideProgressDialog();
      throw Exception('Request timed out');
    } catch (e) {
      throw Exception(e);
    }
  }

  void checkPasswordStrength(String password) {
    double strength = 0;
    if (password.length >= 12) strength += 0.2;
    if (RegExp(r'[a-z]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[!@#\$&*~]').hasMatch(password)) strength += 0.2;

    passwordStrength.value = strength;
    if (strength < 0.4) {
      passwordStrengthText.value = Strings.weakText(Get.context!);
    } else if (strength < 0.8) {
      passwordStrengthText.value = Strings.moderateText(Get.context!);
    } else if (strength < 1.0) {
      passwordStrengthText.value = Strings.goodText(Get.context!);
    } else {
      passwordStrengthText.value = Strings.strongText(Get.context!);
      showPasswordRules.value = false;
    }
  }
}
