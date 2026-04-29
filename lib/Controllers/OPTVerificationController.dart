import 'dart:convert';

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
  RxString pinCode = "".obs;
  RxString fromWhere = "".obs;
  final data = Get.arguments;
  final LoginContoller loginContoller = Get.put(LoginContoller());
  RxString middleText = "".obs;
  RxInt middleTextCode = 0xff000000.obs;
  RxInt outlineBorderColor = 0xFFC8C5C5.obs;
  RxInt completeBorderColor = 0xff00D712.obs;
  RxInt verifyButtonColor = 0xffDDDDDD.obs;

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

    if (kIsWeb) {
      BrowserContextMenu.disableContextMenu();
    }
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
      final response = await http.post(
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
      );

      Map<String, dynamic> jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        // If the server did return a 200 CREATED response,
        // then parse the JSON.

        // if (jsonData['message'] == "Fee Already Paid") {
        //   Get.snackbar("Fee Already Paid", "", colorText: Colors.white);
        //   return "Fee Already Paid";
        // } else {
        //   Get.snackbar("Fee Submitted Successfully", "",
        //       colorText: Colors.white);

        //   return "Fee Submitted Successfully";
        // }
      } else {
        // If the server did not return a 200 CREATED response,
        // then throw an exception.
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
        return "failed";
      }

      // Future<Student> createAlbum(String title) async {
      // }
    } catch (e) {
      throw Exception(e);
    }
    return "failed";
  }

  Future<String> pleaseVerifyOTP(
      String otp, String email, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/verify-otp'),
        headers: await Commons.manageRequestHeader(),
        body: jsonEncode(
            <String, String>{"email": email, "otp": otp, "type": "register"}),
      );

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
      } else {
        // If the server did not return a 200 CREATED response,
        // then throw an exception.
        String msg = jsonData['message'];
        return msg;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> directLoginUser(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/login'),
        headers: await Commons.manageRequestHeader(),
        body: jsonEncode(<String, String>{
          'email': Constants.signupEmail,
          'password': Constants.signupPassword,
        }),
      );

      Map<String, dynamic> jsonData = jsonDecode(response.body);
      print(response.body);

      if (response.statusCode == 200) {
        // If the server did return a 200 CREATED response,
        // then parse the JSON.
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String msg = jsonData['message'];
        if (jsonData['success']) {
          if (jsonData.keys.contains('data')) {
            Map<String, dynamic> dataObj = jsonData['data'];
            if (dataObj.keys.contains('token')) {
              String tokenString = dataObj['token']; // Convert to JSON string
              await prefs.setString('token', tokenString);
            }
            if (dataObj.keys.contains('user')) {
              _prefs = await SharedPreferences.getInstance();
              String jsonString =
                  jsonEncode(dataObj['user']); // Convert to JSON string
              await prefs.setString('UserInfo', jsonString);
              await prefs.setString('isLogin', "loggedIn");
              Fluttertoast.showToast(msg: msg);
              // Get.to(const SelectServiceScreen());
              Constants.signupEmail = "";
              Constants.signupPassword = "";
              return "done";
            } else {
              // Fluttertoast.showToast(msg: Strings.somethingWentWrongText);
              return Strings.somethingWentWrong(Get.context!);
            }
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
                  msg: Strings.pleaseVerifyYourEmail(context));
              Constants.emailToVerify = Constants.signupEmail;
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
    return "";
  }
}
