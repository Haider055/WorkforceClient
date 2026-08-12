import 'dart:async';
import 'dart:io';

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
import 'package:workforceclientapp/views/screens/Authentications/PasswordUpdatedScreen.dart';

class ProfileController extends GetxController {
  late SharedPreferences _prefs;

  final passwordTextField = TextEditingController().obs;
  final confirmPasswordTextField = TextEditingController().obs;

  Future<void> pleaseResetPassword(String email, BuildContext context) async {
    try {
      final response = await http
          .post(
            Uri.parse('${Constants.baseUrl}/reset-password'),
            headers: await Commons.manageRequestHeader(),
            body: jsonEncode(<String, String>{
              'email': email,
              'password': passwordTextField.value.text.toString(),
              'password_confirmation':
                  confirmPasswordTextField.value.text.toString(),
            }),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = jsonDecode(response.body);
      print(response.body);

      if (response.statusCode == 200) {
        _prefs = await SharedPreferences.getInstance();
        String msg = jsonData['message'];

        Fluttertoast.showToast(msg: msg);
        Get.to(
          const PasswordUpdatedScreen(),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 500),
        );
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser();
      } else {
        String msg = jsonData['message'];
        Fluttertoast.showToast(msg: msg);
      }
    } on TimeoutException {
      throw Exception('Request timed out');
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> pleaseDeleteAccount(BuildContext context) async {
    try {
      final response = await http
          .delete(
            Uri.parse('${Constants.baseUrl}/delete-account'),
            headers: await Commons.manageRequestHeader(),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = jsonDecode(response.body);
      print(response.body);
      Commons.hideProgressDialog();

      if (response.statusCode == 200) {
        _prefs = await SharedPreferences.getInstance();
        String msg = jsonData['message'];

        Fluttertoast.showToast(msg: msg);
        return true;
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser();
        return false;
      } else {
        String msg = jsonData['message'];
        Fluttertoast.showToast(msg: msg);
        return false;
      }
    } on TimeoutException {
      Commons.hideProgressDialog();
      throw Exception('Request timed out');
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> pleaseUpdateProfileImage(
      File image, BuildContext context) async {
    try {
      var url = Uri.parse('${Constants.baseUrl}/profile-image');

      var request = http.MultipartRequest("POST", url);

      request.headers.addAll({
        'Accept-Language': await Commons.getPrefLanguageValue(),
        'Authorization': 'Bearer ${await Commons.getUserToken()}',
      });

      var stream = http.ByteStream(image.openRead());
      var length = await image.length();

      var multipartFile = http.MultipartFile(
        'image', // Make sure this matches the API field name
        stream,
        length,
        filename: image.path,
      );
      request.files.add(multipartFile);

      var response = await request.send().timeout(const Duration(seconds: 5));

      var responseData = await response.stream.bytesToString();
      Map<String, dynamic> jsonData = jsonDecode(responseData);

      if (response.statusCode == 200) {
        _prefs = await SharedPreferences.getInstance();

        if (jsonData['success']) {
          String msg = jsonData['message'];
          if (jsonData.keys.contains("data")) {
            Map<String, dynamic> dataObj = jsonData['data'];
            if (dataObj.keys.contains('profile_img')) {
              if (dataObj['profile_img'] != null) {
                await _prefs.setString(
                    'profile_img', dataObj['profile_img'] ?? "");
                Fluttertoast.showToast(
                    msg: Strings.profileImageUpdated(context));
                return true;
              }
            }
          }
          return false;
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
          return false;
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser();
        return false;
      } else {
        String msg = jsonData['message'];
        Fluttertoast.showToast(msg: msg);
        return false;
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      return false;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> pleaseLogoutAccount(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String email = prefs.getString('email') ?? '';

      final response = await http
          .post(
            Uri.parse('${Constants.baseUrl}/logout'),
            headers: await Commons.manageRequestHeader(),
            body: jsonEncode(<String, String>{'email': email}),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = jsonDecode(response.body);
      Commons.hideProgressDialog();

      if (response.statusCode == 200 && jsonData['success'] == true) {
        return true;
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser();
        return false;
      } else {
        return false;
      }
    } on TimeoutException {
      Commons.hideProgressDialog();
      throw Exception('Request timed out');
    } catch (e) {
      throw Exception(e);
    }
  }

  void logoutUser() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('isLogin', "loggedOut");
    Get.offAllNamed(AppLinks.select_service_screen);
  }
}
