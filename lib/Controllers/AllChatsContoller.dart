import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Models/Chat.dart';
import 'package:workforceclientapp/Models/ChatsList.dart';
import 'package:workforceclientapp/Models/Pagination.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/Strings.dart';

class AllChatsContoller extends GetxController {
  ChatsList? chatsList;
  RxList<Chat> list = <Chat>[].obs;
  RxBool isLoading = false.obs;
  RxInt totalChats = 0.obs;
  RxBool isLoadingMore = false.obs;
  late SharedPreferences _prefs;
  RxBool isLoggedIn = false.obs;

  @override
  void onInit() async {
    super.onInit();
    print("init");
    await checkIsLoggedIn();
  }

  void refreshData() async {
    try {
      print("refresh called");
      isLoading.value = true;
      list = <Chat>[].obs;
      list.clear();
      totalChats.value = 0;
      checkIsLoggedIn();
    } catch (e) {
      throw Exception(e);
    }
  }

  void getChats(int page) async {
    try {
      chatsList = await pleaseGetAllChats(Get.context!, page);
      if (chatsList != null) {
        list.addAll(chatsList!.list);
        totalChats.value = chatsList!.pagination!.total ?? 0;
        isLoading.value = false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void updateChatObject(int id, int index) async {
    try {
      final chat = await pleaseGetChat(Get.context!, id);
      if (chat != null && index >= 0 && index < list.length) {
        list.elementAt(index).jobStatus = chat.jobStatus;
        print("Updated jobStatus: ${chat.jobStatus}");
      } else {
        print("go");
      }
    } catch (e) {
      print("Error in updateChatObject: $e");
    } finally {
      Commons.hideProgressDialog();
    }
  }

  Future<void> checkIsLoggedIn() async {
    _prefs = await SharedPreferences.getInstance();
    isLoggedIn.value =
        (_prefs.getString("isLogin") ?? "loggedOut") == "loggedOut"
            ? false
            : true;
    if (isLoggedIn.value) {
      getChats(1);
    } else {
      isLoading.value = false;
    }
  }

  Future<ChatsList?> pleaseGetAllChats(BuildContext context, int page) async {
    try {
      List<Chat> list = [];
      ChatsList? chatsList;

      Pagination pagination = Pagination();
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/chats?page=$page'),
        headers: await Commons.manageRequestHeader(),
      );

      Map<String, dynamic> jsonData = jsonDecode(response.body);
      print(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          if (jsonData.keys.contains('data')) {
            List<dynamic> dataList = jsonData['data'];
            for (var item in dataList) {
              if (item != null && item is Map<String, dynamic>) {
                list.add(Chat.fromJson(item));
              }
            }
            if (jsonData.keys.contains('pagination')) {
              pagination = Pagination.fromJson(jsonData['pagination']);
            }
            chatsList = ChatsList(list: list, pagination: pagination);
            return chatsList;
          } else {
            Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
            return chatsList;
          }
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
          return chatsList;
        }
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
        return chatsList;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Chat?> pleaseGetChat(BuildContext context, int id) async {
    try {
      Chat? chat;

      Pagination pagination = Pagination();
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/chats/$id'),
        headers: await Commons.manageRequestHeader(),
      );

      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          if (jsonData.keys.contains('data')) {
            Map<String, dynamic> dataObj = jsonData['data'];
            if (dataObj.keys.contains('chat')) {
              if (jsonData['chat'] != null) {
                chat = Chat.fromJson(jsonData['chat']);
              }
            }
            return chat;
          } else {
            Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
            return chat;
          }
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
          return chat;
        }
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
        return chat;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
