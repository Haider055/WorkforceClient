import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Models/NotificationList.dart';
import 'package:workforceclientapp/Models/NotificationModel.dart';
import 'package:workforceclientapp/Models/Pagination2.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/Strings.dart';

class NotificationScreenContoller extends GetxController {
  RxBool isLoading = true.obs;
  RxList<NotificationModel> notiList = <NotificationModel>[].obs;
  NotificationList? notificationList;
  RxString status = "".obs;
  RxBool isLoadingMore = false.obs;
  RxString isLoggedin = "loggedOut".obs;
  late SharedPreferences _prefs;

  @override
  void onInit() {
    super.onInit();
    checkIsLoggedIn();
  }

  void refreshData() async {
    try {
      print("refresh");
      isLoading.value = true;
      notiList.clear();
      notiList.value = <NotificationModel>[].obs;
      checkIsLoggedIn();
    } catch (e) {
      throw Exception(e);
    }
  }

  void checkIsLoggedIn() async {
    // print(widget.isLoggedin);
    _prefs = await SharedPreferences.getInstance();
    isLoggedin.value = _prefs.getString("isLogin") ?? "loggedOut";

    if (isLoggedin.value == "loggedOut") {
      isLoading.value = false;
    } else {
      getNotificationList("");
    }
  }

  void getNotificationList(String cursor) async {
    try {
      // postedOrders!.postedJobsList.clear();
      print("called");
      notificationList = await getAllNotificationList(Get.context!, cursor);
      if (notificationList != null) {
        if (notificationList!.notificationsList != null) {
          if (!isLoadingMore.value) {
            notiList.clear();
          }
          notiList.addAll(notificationList!.notificationsList!);
          print("lenght");
          print(notiList.length);
          // update count
          Constants.unreadNotificationsCount.value = 0;
          for (var i = 0;
              i < notificationList!.notificationsList!.length;
              i++) {
            if (!notificationList!.notificationsList![i].isRead.value) {
              Constants.unreadNotificationsCount.value++;
            }
          }
          //***
          if (notificationList!.pagination != null) {}
          isLoadingMore.value = false;
          isLoading.value = false;
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<NotificationList?> getAllNotificationList(
      BuildContext context, String cursor) async {
    try {
      List<NotificationModel> list = [];

      Pagination2 pagination = Pagination2();
      String url = "";
      if (cursor.isEmpty) {
        url = "${Constants.baseUrl}/notifications";
      } else {
        url = "${Constants.baseUrl}/notifications?cursor=$cursor";
      }

      final response = await http.get(
        Uri.parse(url),
        headers: await Commons.manageRequestHeader(),
      );

      Map<String, dynamic> jsonData = jsonDecode(response.body);
      print("body");
      print(response.body);

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
            notificationList = NotificationList(
                notificationsList: list, pagination: pagination);
          }
          return notificationList;
        } else {
          Fluttertoast.showToast(msg: "Something went wrong");
          return notificationList;
        }
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
        return notificationList;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> pleaseMarkAllAsRead(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/notifications/mark-all-as-seen'),
        headers: await Commons.manageRequestHeader(),
      );

      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          if (jsonData['message'] == "All notifications marked as read") {
            Fluttertoast.showToast(msg: "All notifications marked as read");
            Constants.unreadNotificationsCount.value = 0;
            for (var i = 0; i < notiList.length; i++) {
              notiList[i].isRead.value = true;
            }
            return true;
          }
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
          return false;
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
          return false;
        }
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> pleaseMarkAsRead(BuildContext context, String id) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/notifications/mark-as-seen/$id'),
        headers: await Commons.manageRequestHeader(),
      );

      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          Fluttertoast.showToast(msg: "Notifications marked as read");
          Constants.unreadNotificationsCount.value--;
          return true;
          // if (jsonData['message'] == "All notifications marked as read") {
          //   Fluttertoast.showToast(msg: "All notifications marked as read");
          //   return true;
          // }
          // Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
          // return false;
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
          return false;
        }
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
