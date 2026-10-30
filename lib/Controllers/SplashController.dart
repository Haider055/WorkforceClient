import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Others/NotificationNavigationService.dart';
import 'package:workforceclientapp/Others/Strings.dart';
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
      // if (Platform.isAndroid) {
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        NotificationService.showNotification(
            message.notification!.title ??
                Strings.newNotificationText(Get.context!),
            message.notification!.body ??
                Strings.newNotificationText(Get.context!),
            data: message.data);
      }
      // }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      NotificationNavigationService.handleNotificationTap(message.data);
    });
  }

  Future<void> _loadSavedValue() async {
    // EULA must be accepted before anything else, and only ever shown once.
    _prefs = await SharedPreferences.getInstance();
    String lang = _prefs.getString('language') ?? "de";
    Get.updateLocale(Locale(lang));

    bool eulaAccepted = _prefs.getBool('eula_accepted') ?? false;
    if (!eulaAccepted) {
      Get.offAllNamed(AppLinks.eula_screen);
      return;
    }
    bool isSuspended = _prefs.getBool('isSuspended') ?? false;
    if (isSuspended) {
      Get.offAllNamed(AppLinks.account_suspended_screen);
      return;
    }

    String value = "";
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
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
