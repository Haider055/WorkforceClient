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

class Lang {
  final String name;
  final String code;
  const Lang(this.name, this.code);
}

class ChangeLanguageController extends GetxController {
  List<Lang> languages = [
    Lang(Strings.englishText(Get.context!), "en"),
    Lang(Strings.germanText(Get.context!), "de"),
    Lang(Strings.turkishText(Get.context!), "tr"),
    Lang(Strings.portugueseText(Get.context!), "pt"),
  ];

  @override
  void onInit() {
    super.onInit();
    updateLanguages();
    getSelecedLang();
  }

  void getSelecedLang() async {
    _prefs = await SharedPreferences.getInstance();
    selectedLang.value = _prefs.getString("language") ?? "en";
  }

  RxString selectedLang = 'en'.obs;
  late SharedPreferences _prefs;

  Future<bool> pleaseChangeLanguage(String lang) async {
    try {
      final response = await http
          .post(
            Uri.parse('${Constants.baseUrl}/locale'),
            headers: await Commons.manageRequestHeader(),
            body: jsonEncode(<String, dynamic>{'language': lang}),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = jsonDecode(response.body);
      //print(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          return true;
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
          return false;
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser(true);
        return false;
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
        return false;
      }
    } on TimeoutException {
      Commons.hideProgressDialog();
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      return false;
    } catch (e) {
      Commons.hideProgressDialog();
      throw Exception(e);
    }
  }

  void setLanguage(String lang) async {
    try {
      Commons.showProgressDialog(Get.context!);
      var res = await pleaseChangeLanguage(lang);
      if (res) {
        selectedLang.value = lang;
        await _prefs.setString("language", lang);
        Get.updateLocale(Locale(lang));
        Commons.hideProgressDialog();
        onInit();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void updateLanguages() {
    languages = [
      Lang(Strings.englishText(Get.context!), "en"),
      Lang(Strings.germanText(Get.context!), "de"),
      Lang(Strings.turkishText(Get.context!), "tr"),
      Lang(Strings.portugueseText(Get.context!), "pt"),
    ];
  }
}
