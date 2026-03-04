import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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

  Future<Message?> sendMessage(
      BuildContext context, String message, int chatId) async {
    try {
      Message? messageObj;
      final response =
          await http.post(Uri.parse('${Constants.baseUrl}/chats/send-message'),
              headers: await Commons.manageRequestHeader(),
              body: jsonEncode({
                'message': message,
                'chat_id': chatId,
              }));

      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          if (jsonData['message'] == "Message sent successfully") {
            if (jsonData.keys.contains('data')) {
              messageObj = Message.fromJson(jsonData['data']['message']);
              Fluttertoast.showToast(msg: "Sent");
              messageTextField.value.text = "";
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
      } else {
        Fluttertoast.showToast(msg: Strings.messageFailedToSend(context));
        return messageObj;
      }
    } catch (e) {
      throw Exception(e);
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
      final response = await http.get(
        Uri.parse(url),
        headers: await Commons.manageRequestHeader(),
      );

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
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
        return chatObj;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Chat?> pleaseGetChatObject(int chatId, BuildContext context) async {
    try {
      Chat? chat;

      // Pagination pagination = Pagination();
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/chats/$chatId'),
        headers: await Commons.manageRequestHeader(),
      );

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
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
        return chat;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
