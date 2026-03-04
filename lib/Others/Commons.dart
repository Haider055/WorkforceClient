import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Others/CupertinoProgressDialog.dart';

class Commons {
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  static Future<String> getPrefLanguageValue() async {
    late SharedPreferences prefs;
    String value = "";
    prefs = await SharedPreferences.getInstance();
    value = prefs.getString("language")!;

    return value;
  }

  static Future<String> getUserToken() async {
    late SharedPreferences prefs;
    String value = "";
    prefs = await SharedPreferences.getInstance();
    value = prefs.getString("token") ?? "";

    return value;
  }

  static Future<Map<String, String>> manageRequestHeader() async {
    String lang = await getPrefLanguageValue();
    String token = await getUserToken();
    Map<String, String> request = <String, String>{
      'Authorization': 'Bearer $token',
      'Accept-Language': lang,
      'Content-Type': 'application/json',
    };

    return request;
  }

  // static void showProgressDialog(BuildContext context) {
  //   Get.dialog(
  //     WillPopScope(
  //       onWillPop: () async => false,
  //       child: AlertDialog(
  //         backgroundColor: Color(MyColors.whiteColor),
  //         content: SizedBox(
  //           height: MediaQuery.of(context).size.height / 10,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               CircularProgressIndicator(color: Color(MyColors.themeRedColor)),
  //               SizedBox(
  //                 height: 4,
  //               ),
  //               Text("Please wait..")
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //     barrierDismissible: false,
  //   );
  // }

  static void showProgressDialog(BuildContext context) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: const CupertinoProgressDialog(msg: 'Please Wait'),
      ),
      barrierDismissible: false,
    );
  }

  static void hideProgressDialog() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  // static Widget showLottiePlayer(BuildContext context) {
  //   return const LottiePlayer(
  //     networkUrl: 'https://assets5.lottiefiles.com/packages/lf20_i9mtrven.json',
  //     width: 200,
  //     height: 200,
  //   );
  // }
}
