import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/Strings.dart';

class SupportCentreController extends GetxController {
  RxBool isLoading = true.obs;
  RxString supportAddress = ''.obs;
  RxString supportPhone = ''.obs;
  RxString supportWhatsApp = ''.obs;
  RxString supportEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getSupportCentreInfo();
  }

  Future<void> getSupportCentreInfo() async {
    try {
      isLoading.value = true;

      final response = await http
          .get(
            Uri.parse('${Constants.baseUrl}/settings/contact-info'),
            headers: await Commons.manageRequestHeader(),
          )
          .timeout(const Duration(seconds: 5));

      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonData.containsKey('data') && jsonData['data'] is List) {
          final List<dynamic> dataList = jsonData['data'];

          for (var item in dataList) {
            if (item is Map<String, dynamic>) {
              final String key = item['key'] ?? '';
              final String value = item['value'] ?? '';

              switch (key) {
                case 'contact_address':
                  supportAddress.value = value;
                  break;
                case 'contact_phone':
                  supportPhone.value = value;
                  break;
                case 'contact_whatsapp':
                  supportWhatsApp.value = value;
                  break;
                case 'contact_email_info':
                  supportEmail.value = value;
                  break;
              }
            }
          }
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
        }
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
    } catch (e) {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      debugPrint('getSupportCentreInfo error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
