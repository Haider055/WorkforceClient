import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pinput.dart';
import 'package:workforceclientapp/Controllers/AllChatsContoller.dart';
import 'package:workforceclientapp/Models/Chat.dart';
import 'package:workforceclientapp/Models/ChatObj.dart';
import 'package:workforceclientapp/Models/ChatsList.dart';
import 'package:workforceclientapp/Models/Message.dart';
import 'package:workforceclientapp/Models/Pagination.dart';
import 'package:workforceclientapp/Models/Pagination2.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/Strings.dart';

class ConversationContoller extends GetxController {
  final messageTextField = TextEditingController().obs;
  final RxBool enable = true.obs;

  Future<ChatsList?> pleaseGetAllChats(BuildContext context, int page) async {
    try {
      List<Chat> list = [];
      ChatsList? chatsList;

      Pagination pagination = Pagination();
      final response = await http
          .get(
            Uri.parse('${Constants.baseUrl}/chats?page=$page'),
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
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(msg: Strings.accountBlockedMessage(context));
        Commons.logoutUser(true);
        return null;
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
        return chatsList;
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Message?> sendMessage(
      BuildContext context, String message, int chatId) async {
    try {
      Message? messageObj;
      messageTextField.value.text = "";
      final response = await http
          .post(Uri.parse('${Constants.baseUrl}/chats/send-message'),
              headers: await Commons.manageRequestHeader(),
              body: jsonEncode({
                'message': message,
                'chat_id': chatId,
              }))
          .timeout(const Duration(seconds: 5));

      print(response.statusCode);
      print(response.body);

      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          if (jsonData['message'] == "Message sent successfully") {
            if (jsonData.keys.contains('data')) {
              messageObj = Message.fromJson(jsonData['data']['message']);
              return messageObj;
            }
            Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
            return messageObj;
          } else {
            Fluttertoast.showToast(msg: Strings.messageFailedToSend(context));
            return messageObj;
          }
        } else {
          Fluttertoast.showToast(msg: Strings.messageFailedToSend(context));
          return messageObj;
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(msg: Strings.accountBlockedMessage(context));
        Commons.logoutUser(true);
        return null;
      } else if (response.statusCode == 400) {
        Fluttertoast.showToast(msg: Strings.blockedbyUser(context));
        enable.value = false;
        Get.find<AllChatsContoller>().refreshData();
      } else {
        Fluttertoast.showToast(msg: Strings.messageFailedToSend(context));
        return messageObj;
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.messageFailedToSend(context));
      return null;
    } catch (e) {
      throw Exception(e);
    }
    return null;
  }

  Future<bool> pleaseSubmitReport({
    required BuildContext context,
    required String reportableType,
    required int reportableId,
    required String reason,
    String? details,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('${Constants.baseUrl}/reports'),
            headers: await Commons.manageRequestHeader(),
            body: jsonEncode(<String, dynamic>{
              'reportable_type': reportableType,
              'reportable_id': reportableId,
              'reason': reason,
              if (details != null && details.isNotEmpty) 'details': details,
            }),
          )
          .timeout(const Duration(seconds: 5));
      Commons.hideProgressDialog();

      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonData['success'] == true) {
          Fluttertoast.showToast(
              msg: jsonData['message'] ?? Strings.reportSubmittedText(context));
          return true;
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
          return false;
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(msg: Strings.accountBlockedMessage(context));
        Commons.logoutUser(true);
        return false;
      } else {
        String msg = jsonData['message'] ?? Strings.somethingWentWrong(context);
        Fluttertoast.showToast(msg: msg);
        return false;
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
      debugPrint('pleaseSubmitReport error: $e');
      return false;
    }
  }

  Future<ChatObj?> pleaseGetChat(
      BuildContext context, int chatId, String cursor) async {
    try {
      List<Message> list = [];
      Pagination2 pagination = Pagination2();
      ChatObj? chatObj;
      String url = "";
      if (cursor.isEmpty) {
        url = '${Constants.baseUrl}/chats/$chatId/messages';
      } else {
        url = '${Constants.baseUrl}/chats/$chatId/messages?cursor=$cursor';
      }

// Pagination pagination = Pagination();
      final response = await http
          .get(
            Uri.parse(url),
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
                list.add(Message.fromJson(item));
              }
            }
            if (jsonData.keys.contains('pagination')) {
              pagination = Pagination2.fromJson(jsonData['pagination']);
            }
            chatObj = ChatObj(list: list, pagination: pagination);
            return chatObj;
          } else {
            Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
            return chatObj;
          }
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
          return chatObj;
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(msg: Strings.accountBlockedMessage(context));
        Commons.logoutUser(true);
        return null;
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
        return chatObj;
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Chat?> pleaseGetChatObject(int chatId, BuildContext context) async {
    try {
      Chat? chat;

// Pagination pagination = Pagination();
      final response = await http
          .get(
            Uri.parse('${Constants.baseUrl}/chats/$chatId'),
            headers: await Commons.manageRequestHeader(),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          if (jsonData.keys.contains('data')) {
            Map<String, dynamic> dataObj = jsonData['data'];
            if (dataObj.keys.contains('chat')) {
              if (dataObj['chat'] != null) {
                chat = Chat.fromJson(dataObj['chat']);
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
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(msg: Strings.accountBlockedMessage(context));
        Commons.logoutUser(true);
        return null;
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
        return chat;
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> pleaseMarkAllasRead(BuildContext context, int chatId) async {
    try {
      print("333333");
      final response = await http
          .post(
            Uri.parse('${Constants.baseUrl}/chats/$chatId/read'),
            headers: await Commons.manageRequestHeader(),
          )
          .timeout(const Duration(seconds: 5));
      Commons.hideProgressDialog();

      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          return;
        } else {
          return;
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(msg: Strings.accountBlockedMessage(context));
        Commons.logoutUser(true);
        return;
      } else {
        return;
      }
    } on TimeoutException {
      Commons.hideProgressDialog();
      return;
    } catch (e) {
      throw Exception(e);
    }
  }
}
