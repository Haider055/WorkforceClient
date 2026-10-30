import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/Strings.dart';

class LegalDetailController extends GetxController {
  final data = Get.arguments;

  RxBool isLoading = true.obs;
  RxBool hasError = false.obs;
  RxString title = "".obs;
  RxString content = "".obs;
  String _url = "";

  @override
  void onInit() {
    super.onInit();
    if (data != null) {
      title.value = data['title'] ?? "";
      final String slug = data['slug'] ?? "";
      // Prefer the full URL the list API returns; fall back to the slug.
      _url = data['url'] ?? "${Constants.baseUrl}/legal/$slug";
    }
    loadDocument();
  }

  Future<void> loadDocument() async {
    if (_url.isEmpty) {
      hasError.value = true;
      isLoading.value = false;
      return;
    }

    isLoading.value = true;
    hasError.value = false;

    try {
      final lang = await Commons.getPrefLanguageValue();

      // Only language headers, so the login token is never sent to this host.
      final response = await http.get(
        Uri.parse(_url),
        headers: {
          'Accept-Language': lang,
          'Accept': '*',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // bodyBytes + utf8 keeps German umlauts correct.
        content.value = utf8.decode(response.bodyBytes);
        hasError.value = content.value.trim().isEmpty;
      } else {
        hasError.value = true;
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      }
    } on TimeoutException {
      hasError.value = true;
      Commons.hideProgressDialog();
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
    } catch (e) {
      debugPrint('loadDocument error: $e');
      hasError.value = true;
      Commons.hideProgressDialog();
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
    } finally {
      isLoading.value = false;
    }
  }
}
