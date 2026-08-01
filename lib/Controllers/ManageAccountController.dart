import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/Strings.dart';

class ManageAccountController extends GetxController {
  RxString pass = "".obs;
  late SharedPreferences _prefs;
  final passwordTextField = TextEditingController().obs;

  RxBool isTwoFAEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTwoFAStatus();
  }

  Future<void> _loadTwoFAStatus() async {
    _prefs = await SharedPreferences.getInstance();
    isTwoFAEnabled.value = _prefs.getBool('two_factor_enabled') ?? false;
    pass.value = _prefs.getString('password') ?? "";
  }

  Future<bool> pleaseChange2FAStatus(bool val) async {
    String url = '';
    if (val) {
      url = '${Constants.baseUrl}/2fa/enable';
    } else {
      url = '${Constants.baseUrl}/2fa/disable';
    }
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: await Commons.manageRequestHeader(),
            body: jsonEncode(<String, dynamic>{'password': pass.value}),
          )
          .timeout(const Duration(seconds: 5));
      Commons.hideProgressDialog();

      Map<String, dynamic> jsonData = jsonDecode(response.body);
      print(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          _prefs.setBool('two_factor_enabled', val);
          return true;
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
          return false;
        }
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
        return false;
      }
    } on TimeoutException {
      Commons.hideProgressDialog();
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      return false;
    } catch (e) {
      throw Exception(e);
    }
  }
}
