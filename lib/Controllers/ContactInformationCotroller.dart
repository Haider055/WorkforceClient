import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/Strings.dart';

class ContactInformationCotroller extends GetxController {
  final nameTextField = TextEditingController().obs;
  final phoneTextField = TextEditingController().obs;
  late SharedPreferences _prefs;

  Future<String> pleaseSendOTP(String email) async {
    try {
      final response = await http
          .post(
            Uri.parse('${Constants.baseUrl}/send-otp'),
            headers: await Commons.manageRequestHeader(),
            body: jsonEncode(<String, String>{
              'email': email,
            }),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        String msg = jsonData['message'];
        Fluttertoast.showToast(msg: msg);
        return "success";
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser();
        return '';
      } else {
        String msg = jsonData['message'];
        return msg;
      }
    } on TimeoutException {
      throw Exception('Request timed out');
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> pleaseUpdateNameAndPhone() async {
    try {
      final response = await http
          .post(
            Uri.parse('${Constants.baseUrl}/basic'),
            headers: await Commons.manageRequestHeader(),
            body: jsonEncode(<String, String>{
              'name': nameTextField.value.text,
              'phone': phoneTextField.value.text,
            }),
          )
          .timeout(const Duration(seconds: 5));
      Commons.hideProgressDialog();

      Map<String, dynamic> jsonData = json.decode(response.body);
      print(response.body);

      if (response.statusCode == 200) {
        String msg = jsonData['message'];
        Fluttertoast.showToast(msg: msg);
        updateUserInfo();
        return "success";
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser();
        return '';
      } else {
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

  Future<void> updateUserInfo() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('name', nameTextField.value.text);
    await _prefs.setString('phone', phoneTextField.value.text);
  }
}
