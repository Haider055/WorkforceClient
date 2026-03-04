import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
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
      final response = await http.post(
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
      );

      Map<String, dynamic> jsonData = jsonDecode(response.body);
      String message = jsonData['message'];
      // print(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          if (message == "User registered successfully") {
            Fluttertoast.showToast(msg: "User registered successfully");
            Constants.signupEmail = emailTextField.value.text;
            Constants.signupPassword = passwordTextField.value.text;
            Commons.hideProgressDialog();
            Get.offAllNamed(
              AppLinks.otp_verification_screen,
              arguments: {
                "email": emailTextField.value.text.toString(),
                "fromWhere": "signup"
              },
            );
            return "";
          } else {}
        }
      } else {
        if (message == "Validation error") {
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
      }
      return "";
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
      passwordStrengthText.value = "Weak";
    } else if (strength < 0.8) {
      passwordStrengthText.value = "Moderate";
    } else if (strength < 1.0) {
      passwordStrengthText.value = "Good";
    } else {
      passwordStrengthText.value = "Strong";
      showPasswordRules.value = false;
    }
  }
}
