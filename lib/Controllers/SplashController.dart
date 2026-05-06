import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/notification_service.dart';

class SplashController extends GetxController {
  late SharedPreferences _prefs;
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () {
      _loadSavedValue();
    });

    // to listen notifications when the app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message received");

      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        NotificationService.showNotification(
          message.notification!.title ?? "No Title",
          message.notification!.body ?? "No Body",
        );
      }
    });
  }

  Future<void> _loadSavedValue() async {
    String value = "";
    _prefs = await SharedPreferences.getInstance();
    value = _prefs.getString("isLogin") ?? "loggedOut";
    if (value == "loggedIn") {
      Get.offAllNamed(
        AppLinks.select_service_screen,
      );
    } else {
      String language = _prefs.getString("language") ?? "no language selected";
      String onBoardValue = _prefs.getString("onBoardDone") ?? "no";
      if (language == "no language selected") {
        Get.offAllNamed(
          AppLinks.select_language_screen,
        );
      } else if (onBoardValue == "no") {
        Get.offAllNamed(
          AppLinks.onboard_screen,
        );
      } else {
        Get.offAllNamed(
          AppLinks.select_service_screen,
        );
      }
    }
    _prefs = await SharedPreferences.getInstance();
    String lang = _prefs.getString('language') ?? "en";
    Get.updateLocale(Locale(lang));

    // Get.to(
    //   const PostedOrderDetailScreen(),
    //   transition: Transition.rightToLeft, // Left-to-right animation
    //   duration:
    //       const Duration(milliseconds: 500), // Optional: animation duration
    // );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
