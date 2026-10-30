import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:workforceclientapp/Models/LegalGuide.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/Strings.dart';

class LegalGuidesController extends GetxController {
  RxBool isLoading = true.obs;
  RxBool hasError = false.obs;
  RxList<LegalGuide> guides = <LegalGuide>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadGuides();
  }

  Future<void> loadGuides() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final response = await http
          .get(
            Uri.parse('${Constants.baseUrl}/legal'), // confirm this path
            headers: await Commons.manageRequestHeader(),
          )
          .timeout(const Duration(seconds: 5));

      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData['success'] == true) {
        final data = jsonData['data'];
        final List<dynamic> list = data != null ? (data['guides'] ?? []) : [];

        guides.value = list
            .whereType<Map<String, dynamic>>()
            .map((item) => LegalGuide.fromJson(item))
            .toList();
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser(true);
        hasError.value = true;
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
        hasError.value = true;
      }
    } on TimeoutException {
      Commons.hideProgressDialog();
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      hasError.value = true;
    } catch (e) {
      debugPrint('loadGuides error: $e');
      Commons.hideProgressDialog();
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
