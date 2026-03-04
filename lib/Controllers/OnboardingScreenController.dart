import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Others/routes.dart';

class OnboardingScreenController extends GetxController {
  late SharedPreferences _prefs;
  final RxInt currentIndex = 0.obs;
  final PageController pageController = PageController();

  void goToDashboard() async {
    try {
      SharedPreferences prefs;
      prefs = await SharedPreferences.getInstance();
      await prefs.setString("onBoardDone", "yes");

      Get.offAllNamed(
        AppLinks.select_service_screen,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  void nextPage() async {
    if (currentIndex < 2) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      goToDashboard();
    }
  }

  void previousPage() {
    if (currentIndex > 0) {
      pageController.previousPage(
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
