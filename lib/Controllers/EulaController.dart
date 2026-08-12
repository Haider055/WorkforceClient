import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Others/routes.dart';

class EulaController extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> agreeToEula() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('eula_accepted', true);
      isLoading.value = false;
      Get.offAllNamed(AppLinks.select_language_screen);
    } catch (e) {
      isLoading.value = false;
      throw Exception(e);
    }
  }

  void cancelEula() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }
}
