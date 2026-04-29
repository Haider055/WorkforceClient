import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:fluttertoast/fluttertoast.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';

class CreateNewPasswordController extends GetxController {
  late SharedPreferences _prefs;
  String prviousPassword = "";

  final passwordTextField = TextEditingController(text: "").obs;
  final confirmPasswordTextField = TextEditingController(text: "").obs;
  RxString email = "".obs;
  final data = Get.arguments;
  RxString confirmPassErrorText = "".obs;
  RxString passErrorText = "".obs;
  RxDouble passwordStrength = 0.0.obs;
  RxString passwordStrengthText = "".obs;
  RxBool showPasswordRules = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize the text fields with empty strings
    passwordTextField.value.text = "";
    confirmPasswordTextField.value.text = "";
    if (data != null) {
      prviousPassword = data['password'] ?? "";
      email.value = data['email'] ?? "";
    }
  }

  Future<void> pleaseResetPassword(String email) async {
    try {
      Commons.showProgressDialog(Get.context!);
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/reset-password'),
        headers: await Commons.manageRequestHeader(),
        body: jsonEncode(<String, String>{
          'email': email,
          'password': passwordTextField.value.text.toString(),
          'password_confirmation':
              confirmPasswordTextField.value.text.toString(),
        }),
      );

      Map<String, dynamic> jsonData = jsonDecode(response.body);
      Commons.hideProgressDialog();

      if (response.statusCode == 200) {
        // If the server did return a 200 CREATED response,
        // then parse the JSON.
        String msg = jsonData['message'];
        Fluttertoast.showToast(msg: msg);
        Get.toNamed(
          AppLinks.password_updated_screen,
        );
      } else {
        String msg = jsonData['message'];
        Fluttertoast.showToast(msg: msg);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> pleaseUpdatePassword(String currentPassword) async {
    try {
      Commons.showProgressDialog(Get.context!);
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/update-password'),
        headers: await Commons.manageRequestHeader(),
        body: jsonEncode(<String, String>{
          'current_password': currentPassword,
          'password': passwordTextField.value.text.toString(),
          'password_confirmation':
              confirmPasswordTextField.value.text.toString(),
        }),
      );

      Map<String, dynamic> jsonData = jsonDecode(response.body);
      Commons.hideProgressDialog();

      if (response.statusCode == 200) {
        // If the server did return a 200 CREATED response,
        // then parse the JSON.
        String msg = jsonData['message'];
        Fluttertoast.showToast(msg: msg);
        updatePassword();
        passwordTextField.value.text = "";
        confirmPasswordTextField.value.text = "";
        return true;
      } else {
        String msg = jsonData['message'];
        Fluttertoast.showToast(msg: msg);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> updatePassword() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('password', passwordTextField.value.text ?? "");
  }

  Widget passwordRule(String text, bool isValid) {
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
