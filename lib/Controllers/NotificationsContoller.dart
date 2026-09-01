import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:workforceclientapp/Models/NotificationList.dart';
import 'package:workforceclientapp/Models/NotificationModel.dart';
import 'package:workforceclientapp/Models/NotificationPreference.dart';
import 'package:workforceclientapp/Models/Pagination2.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/Strings.dart';

class NotificationsContoller extends GetxController {
  RxList<NotificationPreference> list = <NotificationPreference>[].obs;
  RxBool isLoading = true.obs;
  NotificationList? notificationList;
  RxString status = "".obs;
  RxBool isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    getPreferencesOptions();
    // requestPermission();
  }

  Future<void> requestPermission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> getPreferencesOptions() async {
    list.value = await getAllNotificationOptions(Get.context!);
    isLoading.value = false;
  }

  Future<List<NotificationPreference>> getAllNotificationOptions(
      BuildContext context) async {
    try {
      List<NotificationPreference> list = [];

      final response = await http
          .get(
            Uri.parse('${Constants.baseUrl}/notification-preferences'),
            headers: await Commons.manageRequestHeader(),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          if (jsonData.keys.contains('data')) {
            List<dynamic> dataList = jsonData['data'];
            for (var item in dataList) {
              if (item != null && item is Map<String, dynamic>) {
                list.add(NotificationPreference.fromJson(item));
              }
            }
            return list;
          } else {
            Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
            return list;
          }
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
          return list;
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser(true);
        return list;
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
        return list;
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
      return list;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> pleaseUpdatePref(
      BuildContext context, NotificationPreference pref) async {
    try {
      final response = await http
          .post(
            Uri.parse('${Constants.baseUrl}/notification-preferences/update'),
            headers: await Commons.manageRequestHeader(),
            body: jsonEncode(<String, dynamic>{
              'id': pref.id,
              'push_enabled': pref.pushEnabled.value,
              'email_enabled': pref.emailEnabled.value,
              'type': pref.type
            }),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          if (jsonData['message'] == "") {
            return true;
          }
          return false;
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
          return false;
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser(true);
        return false;
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
        return false;
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
      return false;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<NotificationList?> getAllNotificationList(
      BuildContext context, String cursor) async {
    try {
      NotificationList? notificationsList;
      List<NotificationModel> list = [];

      Pagination2 pagination = Pagination2();
      String url = "";
      if (cursor.isEmpty) {
        url = "${Constants.baseUrl}/notifications";
      } else {
        url = "${Constants.baseUrl}/notifications?cursor=$cursor";
      }

      final response = await http
          .get(
            Uri.parse(url),
            headers: await Commons.manageRequestHeader(),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success'] == true) {
          if (jsonData.keys.contains('data')) {
            List<dynamic> dataList = jsonData['data'];
            for (var item in dataList) {
              list.add(NotificationModel.fromJson(item));
            }
            if (jsonData.keys.contains('pagination')) {
              pagination = Pagination2.fromJson(jsonData['pagination']);
            }
            notificationsList = NotificationList(
                notificationsList: list, pagination: pagination);
          }
          return notificationsList;
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
          return notificationsList;
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser(true);
        return null;
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
        return notificationsList;
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> pleaseMarkAllAsRead(BuildContext context) async {
    try {
      final response = await http
          .post(
            Uri.parse('${Constants.baseUrl}/notifications/mark-all-as-seen'),
            headers: await Commons.manageRequestHeader(),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          Fluttertoast.showToast(
              msg: Strings.allNotificationsMarkedAsReadText(Get.context!));
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
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      return false;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> pleaseMarkAsRead(BuildContext context, String id) async {
    try {
      final response = await http
          .post(
            Uri.parse('${Constants.baseUrl}/notifications/mark-as-seen/$id'),
            headers: await Commons.manageRequestHeader(),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          return true;
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
          return false;
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser(true);
        return false;
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
        return false;
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
      return false;
    } catch (e) {
      throw Exception(e);
    }
  }
}
