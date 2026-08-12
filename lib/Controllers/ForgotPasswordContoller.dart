import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/widgets/HeadingText.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class ForgotPasswordContoller extends GetxController {
  final emailTextField = TextEditingController(text: "").obs;
  RxString emailAddressErrorText = "".obs;

  @override
  void onInit() {
    super.onInit();
    emailTextField.value.text = "";
  }

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

  void pleaseShowDialog(String msg) {
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
          Headingdescription(text: msg, centerAlign: true, size: 15.0),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
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
  }
}
