import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:workforceclientapp/Models/Chat.dart';
import 'package:workforceclientapp/Models/Pagination.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/Strings.dart';

class ReviewScreenController extends GetxController {
  RxString review = "".obs;
  RxInt ratingValue = 0.obs;
  RxInt jobPostingId = 0.obs;
  RxInt tradesmenId = 0.obs;
  final data = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    jobPostingId.value = data['jobPostingId'];
    tradesmenId.value = data['tradesmenId'];
  }

  Future<bool> pleaseSubmitReview(BuildContext context, String review,
      int rating, int jobPostingId, int tradesmenId) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/reviews'),
        headers: await Commons.manageRequestHeader(),
        body: jsonEncode(<String, dynamic>{
          'job_posting_id': jobPostingId,
          'reviewee_id': tradesmenId,
          'rating': rating,
          'comment': review
        }),
      );

      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          if (jsonData.keys.contains('data')) {
            if (jsonData['data']['message'] ==
                "Review submitted successfully") {
              Fluttertoast.showToast(msg: jsonData['data']['message']);
              return true;
            }
            return false;
          } else {
            Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
            return false;
          }
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
